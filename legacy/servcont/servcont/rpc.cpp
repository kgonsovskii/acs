#include "pch.h"
#include <tss/rpc.hpp>
#include <ctype.h> // ::toupper()
#include <memory>
#include <tss/file.hpp>
#include <boost/format.hpp>
#ifdef	LINUX
#include <netinet/tcp.h>
#endif

using namespace std;
using namespace boost;

namespace tss { namespace rpc {

namespace detail {

void throwProtoViolation(int no)
{
	throw runtime_error(str(format("RPC proto violation %d.") %no));
}
}

static char *cpyParam(char *out, const char * const in, const size_t size, const bool isStatic)
{
	if (!size)
		out = NULL;
	else if (!isStatic)
	{
		out = new char[size];
		copy(in, in + size, out);
	} else
		out = const_cast<char *>(in);
	return out;
}

Param::Param(const void *value, char type_, size_t size_, bool isStatic_)
	: type(type_), size(size_), isStatic(isStatic_), _value(cpyParam(_value, static_cast<const char *>(value), size_, isStatic_))
{
}

Param::Param(const Param& rhs)
	: type(rhs.type), size(rhs.size), isStatic(rhs.isStatic), _value(cpyParam(_value, rhs.value(), rhs.size, rhs.isStatic))
{
}

size_t Param::paramSizeByType(char type)
{
	switch (type)
	{
		case paramTypeInteger: return 4;
		case paramTypeBoolean: return 1;
		case paramTypeFloat: return 8;
		case paramTypeDateTime: return 8;
		case paramTypeUid: return 16;
		default: throw logic_error("Invalid param type.");
	}
}

void Param::_assert(size_t size_) const
{
	if (size < size_)
		throw runtime_error("Bad param typecast.");
}

size_t Params::streamSize() const
{
	size_t ret = 1;//count
	for (const_iterator it = begin(); it != end(); ++it)
	{
		ret += (1//type
			+ 1 //nameLength
			+ it->first.size()//name
			+ it->second->size);//data
		if (it->second->type == paramTypeString || it->second->type == paramTypeFile)
			ret += 4;//dataSize
	}
	return ret;
}

void Params::add(const string& name, const void *value, char type, size_t size, bool isStatic)
{
	insert(name, new Param(value, type, size, isStatic));
}

string Params::_key2str(const std::string& key) const
{
	return str(format("Param '%s'") %key);
}

/*
Client::Client(Events& events, const string& host, unsigned short port, size_t minBufSize_):
	minBufSize(minBufSize_),
	socket(Socket::TCP),
	_events(events),
	_packId(0),
	_execCond(false),
	_waitSem(),
	_rxThread(NULL),
	_handle(uuid::create()),
	_osync(),
	_execSync(),
	_obuf(),
	_blockRest(0),
	_dataRest(0),
	_currentOutProcName(),
	_currentInParams(NULL),
	_currentRemExecProcResult(false),
	_sync(),
	_ready(false),
	_timeout(0),
	_executing(false),
	_aborted(false)
	//_waitThread(new _WaitThImpl(*this))
{
	socket.connect(ip::host2addr(host.c_str()), htons(port));
	socket.NagleAlgo(false);

	_rxThread = new Thread(new _RxThImpl(*this));

	_obuf.reserve(minBufSize);

	TSS_SCOPED_THREAD_LOCK(_osync);
	_packStart(detail::packTypeConnect, _handle.size(), _nextPackId());
	_blockStart(_packId, _handle.size());
	_obuf.add(_handle.begin(), 16);
	_packEnd(_packId, 'C');

	{
		TSS_SCOPED_THREAD_LOCK(_sync);
		_ready = true;
	}
}
*/

/*
#ifdef LINUX
Client::Client(Events& events, const char *filename, size_t minBufSize_) :
	_events(events),
	_packId(0),
	_socket(Socket::TCP),
	_execCond(false),
	_waitThread(new _WaitThImpl(*this)),
	_rxThread(NULL),
	_handle(uuid::create()),
	_ready(false),
	minBufSize(minBufSize_),
	_executing(false),
{
	_socket.connect(filename);

	_rxThread = new Thread(new _RxThImpl(*this));

	_obuf.reserve(minBufSize);

	TSS_SCOPED_THREAD_LOCK(_osync);
	_packStart(detail::packTypeConnect, _handle.size(), _nextPackId());
	_blockStart(_packId, _handle.size());
	_obuf.add(_handle.begin(), 16);
	_packEnd(_packId, 'C');

	{
		TSS_SCOPED_THREAD_LOCK(_sync);
		_ready = true;
	}
}
#endif
*/

Client::Client(Events& events, size_t minBufSize_):
	events(events),
	minBufSize(minBufSize_),
	_packId(0),
	//_execCond(false),
	//_waitSem(),
	//_rxThread(NULL),
	_handle(uuid::gen()),
	//_osync(),
	//_execSync(),
	//_obuf(),
	_blockRest(0),
	_dataRest(0),
	//_currentOutProcName(),
	_currentInParams(NULL),
	_currentRemExecProcResult(false),
	//_sync(),
	//_ready(false),
	_timeout(0),
	//_executing(false),
	_isopen(false)
{
	_obuf.reserve(minBufSize);
}

Client::~Client()
{
#ifndef NDEBUG
	trace("rpc::~Client()");
	TSS_SCOPED_THREAD_LOCK(_sync);
	if (this->_socket)
	{
		printf("~Client socket: %u\n", _socket->handle());
	}
	assert(!_isopen);
#endif
}

bool Client::ready() const
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	return _ready;
}

bool Client::isOpen() const
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	return _isopen;
}

void Client::_sendProc(const Proc& proc, bool noAck) const
{
	try
	{
		TSS_SCOPED_THREAD_LOCK(_osync);
		if (noAck)
		{
			_packId = 0xffff;
			_packStart(detail::packTypePost, proc.streamSize(), _packId);
		} else
			_packStart(detail::packTypeQuery, proc.streamSize(), _nextPackId());
		_startBlock(_packId);
		_sendByte(proc.name.size());
		_send(proc.name);
		_sendParams(proc.params);
		_packEnd(_packId, 'C');
	} catch (...)
	{
		_executing = false;
		throw;
	}
}

void Client::exec(const Proc& proc, Params& params, unsigned int timeout) const
{
	if (!ready())
		throw runtime_error("RPC not ready.");
	TSS_SCOPED_THREAD_LOCK(_execSync);
	assert(!_executing);
	_executing = true;
	_currentInParams = &params;
	_currentRemExecProcResult = false;
	_sendProc(proc, false);
	const bool r = _execCond->wait(timeout);
	_executing = false;
	_currentInParams = NULL;
	if (!_currentRemExecProcResult || !r)
		throw runtime_error(_execErrMsg(!_currentRemExecProcResult && !_ready, !r, timeout));
}

void Client::execNoAck(const Proc& proc) const
{
	if (!ready())
		throw runtime_error("RPC not ready.");
	_sendProc(proc, true);
}

void Client::execNoWait(const Proc& proc, unsigned int timeout) const
{
	if (!ready())
		throw runtime_error("RPC not ready.");
	TSS_SCOPED_THREAD_LOCK(_execSync);
	assert(!_executing);
	_executing = true;
	_currentInParams = new Params;
	_currentRemExecProcResult = false;
	_sendProc(proc, false);
	_currentOutProcName = proc.name;
	_timeout = timeout;
	_waitSem->set();
}

void Client::_sendFile(const char *name, streamsize size) const
{
	// TODO: make as in sendProc
	const streamsize maxBlockSize(4096);
	streamsize done = 0, rest, curSize;
	ifstream fs;
	char buf[maxBlockSize];
	openFile(name, ios::in|ios::binary, fs);
	while (done != size)
	{
		rest = static_cast<streamsize>(size - done);
		if (rest > maxBlockSize)
			curSize = maxBlockSize;
		else
			curSize = rest;
		fs.read(buf, curSize);
		done += curSize;
		_send(buf, curSize);
	}
}

void Client::_packStart(char type, size_t size, unsigned short id) const
{
	_dataRest = size;

	_obuf.add(detail::packPrefix, sizeof(detail::packPrefix));
	_obuf.add(type);
	_obuf.add(id);
}

void Client::_packEnd(unsigned short id, char end) const
{
	_blockStart(id, 0);
	_obuf.add(end);
	_flush();
}

void Client::_blockStart(unsigned short packId, size_t size) const
{
	_blockRest = detail::maxBlockSize;
	_obuf.add(packId);
	_obuf.add(static_cast<unsigned short>(size));
}

void Client::_send(const char *data, size_t size) const
{
	const char *p(data);
	size_t x;
	while (size)
	{
		if (size > _blockRest)
			x = _blockRest;
		else
			x = size;
		if (_obuf.size() + x >= 1024)
		{
			_flush();
			socket().write(p, static_cast<int>(x));
		} else
			_obuf.add(p, x);
		p += x;
		size -= x;
		_blockRest -= x;
		_dataRest -= x;
		if (!_blockRest && size)
			_startBlock(_packId);
	}			
}

void Client::_sendParams(const Params& params) const
{
	_sendByte(params.size());
	for (Params::const_iterator it = params.begin(); it != params.end(); ++it)
	{
		_sendByte(it->second->type);
		_sendByte(it->first.size());
		_send(it->first);
		if (it->second->type == paramTypeString || it->second->type == paramTypeFile)
			_sendDWord(it->second->size);
		if (it->second->type != paramTypeFile)
			_send(it->second->value(), it->second->size);
		else
			_sendFile(it->second->value(), static_cast<streamsize>(it->second->size));
	}
}

void Client::_params2class(detail::Buffer<char>& buf, const int off, Params& params)
{
	const int count = buf[off];
	char type, nameLen;
	string name;
	const char *val;
	size_t size, done = 0;
	for (int i=0; i != count; ++i)
	{
		type = buf[off + done + 1];
		nameLen = buf[off + done + 2];
		name.assign(&buf[off + done + 3], &buf[off + done + 3 + nameLen]);
		if (type == paramTypeString || type == paramTypeFile)
		{
			size = unpackInt(&buf[off + done + 3 + nameLen]);
			done += 4;
		} else
			size = Param::paramSizeByType(type);
		if (size)
			val = &buf[off + done + 3 + nameLen];
		else
			val = NULL;
		transform(name.begin(), name.end(), name.begin(), &::toupper);
		params.add(name, val, type, size, false);
		done += 1 + 1 + nameLen + size;
	}
}

unsigned short Client::_nextPackId() const
{
	if (_packId >= detail::maxId)
		_packId = 0;
	return ++_packId;
}

void Client::_flush() const
{
	assert(_obuf.size() > 0);
	socket().write(&_obuf[0], static_cast<int>(_obuf.size()));
	_obuf.clear();
}

void Client::_startBlock(unsigned short packId) const
{
	if (_dataRest < detail::maxBlockSize)
		_blockStart(packId, _dataRest);
	else
		_blockStart(packId, detail::maxBlockSize);
}

string Client::_execErrMsg(bool aborted, bool timedout, unsigned int timeout) const
{
	string ret;
	if (aborted)
	{
		format f("Remote procedure '%s' aborted.");
		f %_currentOutProcName;
		ret = f.str();
	} else if (timedout)
	{
		format f("Remote procedure '%s' failed; timeout > %u.");
		f %_currentOutProcName %timeout;
		ret = f.str();
	} else if (!_currentRemExecProcResult)
	{
		try
		{
			const Param& p1 = (*_currentInParams)["EXCEPTIONCLASS"];
			const Param& p2 = (*_currentInParams)["MESSAGE"];
			format f("Remote procedure '%s' failed; class: '%s', message: '%s'.");
			f %_currentOutProcName %string(p1.value(), p1.size) %string(p2.value(), p2.size);
			ret = f.str();
		} catch (std::exception& e)
		{
			ret = e.what();
		}
	}
	return ret;
}

void Client::open(SOCKET handle, bool un)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	if (!_isopen)
	{
		_ready = false;
		_executing = false;
		_waitSem = new Semaphore;
		_execCond = new Condition(false);
		_socket = new Socket(handle);
		if (!un)
			_socket->NagleAlgo(false);
		_socket->keepAlive(6);
		_waitThread = new Thread(new _WaitThImpl(*this));
		_connected = false;
		_rxThread = new Thread(new _RxThImpl(*this));
		_isopen = true;
	}
}

void Client::open(SOCKET handle, const uuid& id, unsigned short packId)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	if (!_isopen)
	{
		_handle = id;
		_ready = false;
		_executing = false;
		_waitSem = new Semaphore;
		_execCond = new Condition(false);
		_socket = new Socket(handle);
		_socket->NagleAlgo(false);
		_waitThread = new Thread(new _WaitThImpl(*this));
		_connected = true;
		_rxThread = new Thread(new _RxThImpl(*this));
		_isopen = true;
		_ready = true;

		TSS_SCOPED_THREAD_LOCK(_osync);
		Params params;
		_packId = packId;
		_packStart(detail::packTypeAnswer, params.streamSize() +
			1//result
			, packId);
		_startBlock(packId);
		_sendByte('T');
		_sendParams(params);
		_packEnd(packId, 'C');
	}
}

void Client::open(const std::string& host, unsigned short port)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	if (!_isopen)
	{
		_ready = false;
		_executing = false;
		_waitSem = new Semaphore;
		_execCond = new Condition(false);
		_socket = new Socket(Socket::TCP);
		_socket->connect(ip::host2addr(host.c_str()), htons(port));
		_socket->NagleAlgo(false);
		_waitThread = new Thread(new _WaitThImpl(*this));
		_connected = false;
		_rxThread = new Thread(new _RxThImpl(*this));
		_isopen = true;

		{
			TSS_SCOPED_THREAD_LOCK(_osync);
			_packStart(detail::packTypeConnect, uuid::size(), _nextPackId());
			_blockStart(_packId, uuid::size());
			_obuf.add(_handle.begin(), uuid::size());
			_packEnd(_packId, 'C');
		}
		_ready = true;
	}
}

#ifdef LINUX
void Client::open(const char *filename)
{
	{
	TSS_SCOPED_THREAD_LOCK(_sync);
	if (!_isopen)
	{
		_ready = false;
		_executing = false;
		_waitSem = new Semaphore;
		_execCond = new Condition(false);
		_socket = new Socket(Socket::TCP, true);
		_socket->connect(filename);
		_waitThread = new Thread(new _WaitThImpl(*this));
		_connected = false;
		_rxThread = new Thread(new _RxThImpl(*this));
		_isopen = true;
	} else
		return;
	}

	{
		TSS_SCOPED_THREAD_LOCK(_osync);
		_packStart(detail::packTypeConnect, uuid::size(), _nextPackId());
		_blockStart(_packId, uuid::size());
		_obuf.add(_handle.begin(), uuid::size());
		_packEnd(_packId, 'C');
	}
	_ready = true;
}
#endif

void Client::close()
{
	{
		TSS_SCOPED_THREAD_LOCK(_sync);
		if (_isopen)
		{
			_ready = false;
			_isopen = false;
			if (_socket)
			{
				_waitSem->set();
				_execCond->set();
				_socket->shutdown(SHUT_RDWR);
				delete _socket; _socket = NULL;
			}
		} else
			return;
	}
	delete _rxThread;
	delete _waitThread;
	delete _waitSem;
	delete _execCond;
}

void Client::disconnect(bool isShutdown)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	_ready = false;
	if (_socket)
	{
		_waitSem->set();
		_execCond->set();
		if (isShutdown)
			_socket->shutdown(SHUT_RDWR);
		delete _socket; _socket = NULL;
	}
}

const Socket& Client::socket() const
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	if (!_socket)
		throw Abort();
	return *_socket;
}

unsigned short Client::packId() const
{
	return _rxThread->pimpl<_RxThImpl>()->packId;
}

void Client::_RxThImpl::operator()() throw()
{
	if (client._connected)
		client.events.onConnect(client);
	try
	{
		while (true)
		{
			receivePackHdr();
			receiveBlocks();
			receivePackFtr();
			processData();
		}
	}
	catch (const std::exception& e)
	{
		handleException(e);
	} 
	{
		TSS_SCOPED_THREAD_LOCK(client._sync);
		client._ready = false;
		if (client._socket)
		{
			client._waitSem->set();
			client._execCond->set();
			delete client._socket; client._socket = NULL;
		}
	}
	if (client._connected)
		client.events.onDisconnect(client);
}

void Client::_RxThImpl::receive(char *buf, size_t size)
{
	size_t done = 0;
	while (done != size)
		done += client.socket().read(&buf[done], static_cast<int>(size - done));
}

void Client::_RxThImpl::receivePackHdr()
{
	char buf[8];
	receive(buf, sizeof(buf));
	if (0 != memcmp(detail::packPrefix, buf, sizeof(buf)))
		detail::throwProtoViolation(2);

	packType = receiveByte();
	switch (packType)
	{
		case detail::packTypeConnect:
			break;
		case detail::packTypeQuery:
			break;
		case detail::packTypeAnswer:
			break;
		case detail::packTypePost:
			break;
		default:
			detail::throwProtoViolation(3);
	}

	packId = receiveWord();
	if (packId == 0)
		detail::throwProtoViolation(4);
}

void Client::_RxThImpl::receiveBlocks()
{
	ibuf.capacity(client.minBufSize);
	ibuf.clear();

	while (true)
	{
		const unsigned short blockPackId = receiveWord();
		if (blockPackId == 0 || blockPackId != packId)
			detail::throwProtoViolation(5);

		const unsigned short blockLen = receiveWord();
		if (blockLen == 0)
			break;

		receiveBlock(blockLen);
	}
}

void Client::_RxThImpl::processAnswer()
{
	switch (ibuf[0])
	{
	case 'F':
		client._currentRemExecProcResult = false;
		break;
	case 'T':
		client._currentRemExecProcResult = true;
		break;
	default:
		detail::throwProtoViolation(6);
	}

	// TODO: заменить на более точный и надежный вариант. обрабатывать rollback.
	if (client._executing)
	{
		if (client._currentInParams)
		{
			client._currentInParams->clear();
			_params2class(ibuf, 1, *client._currentInParams);
			client._execCond->set();
		}
	}
}

void Client::_RxThImpl::processQuery()
{
	const int procNameLen = ibuf[0];
	const string procName(&ibuf[1], &ibuf[1 + procNameLen]);
	Proc proc(procName);
	_params2class(ibuf, 1 + procNameLen, proc.params);
	Params params;
	const bool execRes = client.events.onProc(client, proc, params);

	TSS_SCOPED_THREAD_LOCK(client._osync);
	client._packId = packId;
	client._packStart(detail::packTypeAnswer, params.streamSize() +
		1//result
		, packId);
	client._startBlock(packId);
	if (execRes)
		client._sendByte('T');
	else
		client._sendByte('F');
	client._sendParams(params);
	client._packEnd(packId, 'C');
}

void Client::_RxThImpl::processPost()
{
	const int procNameLen = ibuf[0];
	const string procName(&ibuf[1], &ibuf[1 + procNameLen]);
	Proc proc(procName);
	_params2class(ibuf, 1 + procNameLen, proc.params);
	Params params;
	client.events.onProc(client, proc, params);
}

void Client::_RxThImpl::processConnect()
{
	if (ibuf.size() != uuid::size())
		detail::throwProtoViolation(7);
	if (client._connected)
	{
		if (client._handle != uuid(ibuf.data))
			detail::throwProtoViolation(8);
	}
	client._handle = uuid(ibuf.data);
	client._connected = true;
	{
		TSS_SCOPED_THREAD_LOCK(client._sync);
		client._ready = true;
	}
	client.events.onConnect(client);
}

char Client::_RxThImpl::receiveByte()
{
	char ch;
	client.socket().read(&ch, 1);
	return ch;
}

unsigned short Client::_RxThImpl::receiveWord()
{
	unsigned short ret;
	receive(reinterpret_cast<char *>(&ret), 2);
	return ret;
}

void Client::_RxThImpl::receiveBlock(unsigned short size)
{
	const size_t oldSize = ibuf.size();
	ibuf.resize(oldSize + size);
	receive(&ibuf[oldSize], size);
}

void Client::_RxThImpl::processData()
{
	switch (packType)
	{
	case detail::packTypeConnect:
		processConnect();
		break;
	case detail::packTypeQuery:
		processQuery();
		break;
	case detail::packTypeAnswer:
		processAnswer();
		break;
	case detail::packTypePost:
		processPost();
		break;
	}
}

void Client::_RxThImpl::receivePackFtr()
{
	const char packEnd = receiveByte();
	switch (packEnd)
	{
	case 'C':
		break;
	case 'R':
		break;
	default:
		detail::throwProtoViolation(1);
	}
}

void Client::_WaitThImpl::operator()() throw()
{
	while (true)
	{
		client._waitSem->wait();
		if (!client._ready)
			break;
		TSS_SCOPED_THREAD_LOCK(client._execSync);
		const bool r = client._execCond->wait(client._timeout);
		client._executing = false;
		client.events.onExec(client, r && client._currentRemExecProcResult, *client._currentInParams, client._execErrMsg(!client._currentRemExecProcResult && !client._ready, !r, client._timeout));
		delete client._currentInParams; client._currentInParams = NULL;
	}
	delete client._currentInParams;
}

}}
