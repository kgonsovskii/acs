#ifndef TSS_RPC_HPP_INCLUDED
#define TSS_RPC_HPP_INCLUDED

#pragma once

#include "config.hpp"
#ifdef LINUX
#include <cstring>
#endif
#include <stdexcept>
#include <list>
#include <fstream>
#include <boost/noncopyable.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/format.hpp>
#include "map.hpp"
#include "sync.hpp"
#include "thread.hpp"
#include "uuid.hpp"
#include "ip.hpp"
#include "sock.hpp"

namespace tss { namespace rpc {

enum
{
	paramTypeInteger,
	paramTypeBoolean,
	paramTypeFloat,
	paramTypeDateTime,
	paramTypeUid,
	paramTypeString,
	paramTypeFile
};

namespace detail {

void throwProtoViolation(int);

template <typename T>
class Buffer: private boost::noncopyable
{
public:
	typedef T *Iterator;

	Buffer(): data(NULL), _capacity(0), _size(0) {}
	~Buffer() throw()
	{
		std::free(data);
	}

	T *add(const void *p, size_t size)
	{
		const size_t oldSize = _size;
		resize(_size + size);
		memcpy(&data[oldSize], p, size);
		return data;
	}

	T *add(char byte)
	{
		const size_t oldSize = _size;
		resize(_size + sizeof(byte));
		data[oldSize] = byte;
		return data;
	}

	T *add(unsigned short word)
	{
		const size_t oldSize = _size;
		resize(_size + sizeof(word));
		data[oldSize] = word & 0xff;
		data[oldSize + 1] = word >> 8;
		return data;
	}

	Iterator begin() throw()
	{
		return data;
	}

	Iterator end() throw()
	{
		return (data + _size);
	}

	void reserve(size_t size)
	{
		if (_capacity < size)
			capacity(size);
	}

	void capacity(size_t size)
	{
		if (_capacity != size) {
			data = static_cast<T *>(std::realloc(data, size * sizeof(T)));
			_capacity = size;
			if (size < _size)
				_size = size;
		}
	}

	size_t capacity() const throw()
	{
		return _capacity;
	}

	void resize(size_t size)
	{
		reserve(size);
		_size = size;
	}

	size_t size() const throw()
	{
		return _size;
	}

	void clear() throw()
	{
		resize(0);
	}

	T *operator &() throw()
	{
		return data;
	}

	T& operator [](size_t idx)
	{
		if (!(idx < _size))
			throwProtoViolation(9);
		return data[idx];
	}

	T& operator *() throw()
	{
		assert(_size > 0);
		return *data;
	}

	T *data;
private:
	size_t _capacity;
	size_t _size;
};//Buffer

static const char packPrefix[]				=	{'r', 'p', 'c', '_', 'S', 'o', 'c', 'k'};
static const unsigned short maxId			=	0xffff - 1;
static const unsigned short maxBlockSize	=	0xffff;

enum
{
	packTypeConnect = 1,
	packTypeQuery,
	packTypeAnswer,
	packTypePost
};

}//namespace detail

class Param
{
public:
	Param(const void *, char, size_t, bool = false);
	Param(const Param&);
	~Param() { if (!isStatic) delete [] _value; }
	const char *value() const throw() { return _value; }
	operator const char *() const throw() { return _value; }

	int asInt() const
	{
		_assert(paramSizeByType(paramTypeInteger));
		return unpackInt(_value);
	}

	bool asBool() const
	{
		_assert(paramSizeByType(paramTypeBoolean));
		return (*_value != 0);
	}

	std::string asString() const
	{
		std::string ret(_value, size);
		return ret;
	}

	uuid asUid() const
	{
		_assert(paramSizeByType(paramTypeUid));
		return uuid(_value);
	}

	const char type;
	const size_t size;
	const bool isStatic;

	static size_t paramSizeByType(char);
protected:
	void _assert(size_t) const;
	char *_value;
};//Param

class Params: public PtrMap<std::string, Param>
{
public:
	size_t streamSize() const;

	void add(const std::string&, const void *, char, size_t, bool);

	void add(const std::string& name, const char *value, size_t size, bool isStatic = false)
	{
		add(name, value, paramTypeString, size, isStatic);
	}

	void add(const std::string& name, const char *value, bool isStatic = false)
	{
		add(name, value, paramTypeString, strlen(value), isStatic);
	}

	void add(const std::string& name, int value, bool isStatic = false)
	{
		add(name, reinterpret_cast<char *>(&value), paramTypeInteger, Param::paramSizeByType(paramTypeInteger), isStatic);
	}

	void add(const std::string& name, const std::string& value, bool isStatic = false)
	{
		add(name, value.c_str(), paramTypeString, value.size(), isStatic);
	}

	void add(const std::string& name, bool value, bool isStatic = false)
	{
		add(name, reinterpret_cast<char *>(&value), paramTypeBoolean, Param::paramSizeByType(paramTypeBoolean), isStatic);
	}

	void add(const std::string& name, const uuid& id, bool isStatic = false)
	{
		add(name, id.begin(), rpc::paramTypeUid, uuid::size(), isStatic);
	}
protected:
	std::string _key2str(const std::string&) const;
};//Params

struct Proc
{
	explicit Proc(const std::string& name_): name(name_) {}
	size_t streamSize() const
	{
		return (1//nameLength
			+ name.size()//name
			+ params.streamSize());//params
	}

	const std::string name;
	Params params;
};//Proc

class Client
{
public:
	struct Events
	{
		virtual ~Events() {}
		virtual void onConnect(Client&) throw() = 0;
		virtual void onDisconnect(Client&) throw() = 0;
		virtual bool onProc(Client&, const Proc&, Params&) throw() = 0;
		virtual void onExec(Client&, bool, const Params&, const std::string&) throw() = 0;
	};
	//Client(Events&, const std::string&, unsigned short, size_t);
/*
#ifdef LINUX
	Client(Events&, const char *, size_t);
#endif
*/
	Client(Events&, size_t);

	~Client();
	void open(SOCKET, bool = false);
	void open(SOCKET, const uuid&, unsigned short);
	void open(const std::string&, unsigned short);
#ifdef LINUX
	void open(const char *);
#endif
	void close();
	void disconnect(bool);
	bool ready() const;
	bool isOpen() const;
	const uuid& handle() const { return _handle; }
	void exec(const Proc&, Params&, unsigned int) const;
	void execNoAck(const Proc&) const;
	void execNoWait(const Proc&, unsigned int) const;
	const Socket& socket() const;
	unsigned short packId() const;
	Events& events;
	const size_t minBufSize;
protected:
	struct _RxThImpl: Thread::Impl
	{
		_RxThImpl(Client& client_): client(client_), packType(0), packId(0) { ibuf.reserve(client.minBufSize); }
		~_RxThImpl() { trace("~Client::_RxThImpl()"); }
		void operator() () throw();
		void receive(char *, size_t);
		char receiveByte();
		unsigned short receiveWord();
		void receivePackHdr();
		void receiveBlocks();
		void receiveBlock(unsigned short size);
		void processData();
		void processAnswer();
		void processQuery();
		void processPost();
		void processConnect();
		void receivePackFtr();

		Client& client;
		//bool connected;
		detail::Buffer<char> ibuf;
		char packType;
		unsigned short packId;
	};//_RxThImpl

	struct _WaitThImpl: Thread::Impl
	{
		_WaitThImpl(Client& client_): client(client_) {}
		~_WaitThImpl() { trace("Client::~_WaitThImpl()"); }
		void operator() () throw();
		Client& client;
	};//_WaitThImpl

	unsigned short _nextPackId() const;
	void _sendProc(const Proc&, bool) const;
	void _flush() const;
	void _startBlock(unsigned short packId) const;
	void _send(const char *, size_t) const;
	void _send(const std::string& data) const { _send(data.c_str(), data.size()); }
	void _sendByte(char data) const { _send(&data, 1); }
	void _sendByte(size_t data) const { _send(reinterpret_cast<const char *>(&data), 1); }
	void _sendDWord(size_t data) const { _send(reinterpret_cast<const char *>(&data), 4); }
	void _sendFile(const char *, std::streamsize) const;
	void _packStart(char, size_t, unsigned short) const;
	void _packEnd(unsigned short, char) const;
	void _blockStart(unsigned short, size_t) const;
	void _sendParams(const Params&) const;
	std::string _execErrMsg(bool, bool, unsigned int) const;

	Socket *_socket;
	mutable unsigned short _packId;
	Semaphore *_waitSem;
	Condition *_execCond;
	Thread *_rxThread;
	uuid _handle;
	thread::Synchronizer _osync;
	thread::Synchronizer _execSync;
	mutable detail::Buffer<char> _obuf;
	mutable size_t _blockRest;
	mutable size_t _dataRest;
	mutable std::string _currentOutProcName;
	mutable Params *_currentInParams;
	mutable bool _currentRemExecProcResult;
	thread::Synchronizer _sync;
	volatile bool _ready;
	mutable unsigned int _timeout;
	volatile mutable bool _executing;
	volatile bool _isopen;
	Thread *_waitThread;
	volatile bool _connected;

	static void _params2class(detail::Buffer<char>&, const int, Params&);
};//Client

}}

#endif
