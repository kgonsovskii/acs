#ifndef TSS_SERVCONT_HPP_INCLUDED
#define TSS_SERVCONT_HPP_INCLUDED

#pragma once

#include <tss/config.hpp>
#include <cassert>
#include <cstdlib>
#include <algorithm>
#include <utility>
#include <vector>
#include <string>
#include <boost/format.hpp>
#include <boost/scoped_array.hpp>
#include <boost/scoped_ptr.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/function.hpp>
#include <boost/bind.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/optional.hpp>
#include "sys.hpp"
#include "time.hpp"
#include "map.hpp"
#include "serialport.hpp"
#include "sock.hpp"
#include "sync.hpp"
#include "thread.hpp"
#include "timer.hpp"
#ifdef TSS_DAVINCI
extern "C"
{
#include <drv_i2c.h>
}
#endif


namespace tss { namespace servcont {

class Error: public std::runtime_error
{
public:
	Error(const char *className_, const std::string& msg): std::runtime_error(msg), className(className_) {}
	~Error() throw() {} //g++: overriding virtual std::runtime_error::~runtime_error() throw ()
	const std::string className;
};//Error

class ClientError: public Error
{
public:
	ClientError(const char *className, const std::string& msg): Error(className, msg) {}
};//ClientError

#define	TSS_SERVCONT_THROW_CLIENT_ERROR_REQUEST(msg)	throw servcont::ClientError("Request", msg)
#define	TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER(msg)	throw servcont::ClientError("Parameter", msg)
#define	TSS_SERVCONT_PROG_VER(major, minor)	(major << 8 | minor)

boost::uint64_t keyToInt(const char* key);

class Channel;
class Controller;

struct Timestamp
{
	enum { size = 6 };
	Timestamp()
	{
		const struct tm * const now = os::localtime();
		data[0] = now->tm_year - 100;
		data[1] = now->tm_mon + 1;
		data[2] = now->tm_mday;
		data[3] = now->tm_hour;
		data[4] = now->tm_min;
		data[5] = now->tm_sec;
	}
	explicit Timestamp(const char *p)
	{
		if (p)
			memcpy(data, p, sizeof(data));
	}
	Timestamp(char y, char m, char d, char h, char n, char s)
	{
		data[0] = y;
		data[1] = m;
		data[2] = d;
		data[3] = h;
		data[4] = n;
		data[5] = s;
	}
	char year()		const throw()	{ return data[0]; }
	char month()	const throw()	{ return data[1]; }
	char day()		const throw()	{ return data[2]; }
	char hour()		const throw()	{ return data[3]; }
	char minute()	const throw()	{ return data[4]; }
	char second()	const throw()	{ return data[5]; }

	void year(char v)	throw()	{ data[0] = v; }
	void month(char v)	throw()	{ data[1] = v; }
	void day(char v)	throw()	{ data[2] = v; }
	void hour(char v)	throw()	{ data[3] = v; }
	void minute(char v)	throw()	{ data[4] = v; }
	void second(char v)	throw()	{ data[5] = v; }

	const char *c_array() const throw() { return data; }
	char data[size];
};

class Controllers: public PtrMap<char, Controller>
{
public:
	Controllers(Channel& channel_): channel(channel_) {}
	Controller& add(char);
	void remove(char);
	Channel& channel;
protected:
	std::string _key2str(const char&) const;
};//Controllers

class Channel
{
friend class Controller;
public:
	class Error: public servcont::Error
	{
	public:
		Error(const Channel&, const char *, const char *);
	};//Error

	struct Events
	{
		virtual ~Events() {}
		virtual void onControllerEvent(const Channel&, const char *) throw() = 0;
		virtual void onError(const Channel&, const std::exception&) throw() = 0;
		virtual void onControllerError(const Channel&, const Controller&, const std::exception&) throw() = 0;
		virtual void onChangeState(const Channel&, bool) throw() = 0;
		virtual void onPollSpeed(const Channel&, int) throw() = 0;
		virtual void onControllerState(const Channel&, const Controller&, char) throw() = 0;
		virtual void onControllersChanged(const Channel&) throw() = 0;
		virtual void onWriteAllKeysAsync(const Controller&, const std::string&) throw() = 0;
	};//Events
	Channel(Events&, unsigned short, unsigned short, unsigned short);
	virtual ~Channel();
	std::vector<char> findControllers();
	void activate();
	bool active() const;
	void deactivate();
	bool ready() const;
	std::pair<bool, bool> activeAndReady() const;
	virtual const std::string& id() const throw() = 0;
	virtual const std::string& connInfo() const throw() = 0;
	//bool anyPollable() const;
	unsigned int pollSpeed() const throw() { return _speedOld; }
	Events& events;
	Controllers controllers;
	const unsigned short responseTimeout;
	const unsigned short aliveTimeout;
	const unsigned short deadTimeout;
	//int counter;
protected:
	struct _ThImpl: Thread::Impl
	{
		_ThImpl(Channel& host_): host(host_) {}
		~_ThImpl() { trace("Channel::~_ThImpl()"); }
		void operator() () throw();
		Channel& host;
	};//_ThImpl

	//class _CoCmd
	//{
	//public:
	//	enum Cmd {ccNone, ccRelayOn, ccRelayOff};
	//	_CoCmd(char addr_);
	//	const struct tm *timestamp() const throw() { return &_timestamp; }
	//	const char addr;
	//private:
	//	struct tm _timestamp;
	//};//_CoCmd

	struct _SpeedTimer: public Timer::Item
	{
		_SpeedTimer(Channel& ch_): Timer::Item(2, false), ch(ch_) {}
		void onTimer() throw();
		Channel& ch;
	};


	struct ExtCmdScopedLock
	{
		explicit ExtCmdScopedLock(const Channel& ch): channel(ch)
		{
			channel._extCmd = true;
			channel._sync.lock();
		}

		~ExtCmdScopedLock()
		{
			channel._extCmd = false;
			channel._sync.unlock();
		}

		const Channel& channel;
	};

	virtual void _init() = 0;
	virtual void _fini() = 0;
	virtual int _read(char *, int) const = 0;
	virtual void _write(const char *, int) = 0;
	void _flushInput();
	bool _active() const { return (NULL !=_thread); }
	void _initSpeed() throw();
	void _work();
	bool _processController(Controller&);
	//void _chkActive() const { if (!_active()) throw std::runtime_error("Channel not active"); }
	void _chkReady() const { if (!_ready) throw std::runtime_error("Channel not ready"); }
	void _setReady(bool val);
	void _throwReading(const char *msg) const { throw Error(*this, "Reading", msg); }
	void _throwWriting(const char *msg) const { throw Error(*this, "Writing", msg); }
	void _chkAndSetAliveTimer(Controller&);

	volatile mutable bool _extCmd;
	thread::Synchronizer _sync;
	bool _ready;
	volatile bool _deactivating;
	bool _error;

	_SpeedTimer _speedTimer;

	Thread *_thread;

	char _lastEvtCo;

	unsigned int _speedOld;
	unsigned int _speedCounter;
	unsigned int _speedClock;

	Timer _timer;
	Trigger<thread::Synchronizer> _fireSpeedEvent;
	bool _speedZeroFired;

	boost::scoped_ptr<Thread> _writeAllKeysTh;
};//Channel;


class Controller
{
friend class Channel;
public:
	class Error: public servcont::Error
	{
	public:
		Error(const Controller& co, const char *className, const std::string& msg);
	};//Error

	Controller(Channel&, char);
	~Controller();
	std::string name() const throw();
	char state() const;
	void pollOn(bool, bool);
	void pollOff(bool);
	//void forceAuto();
	char progId() const;
	short progVer() const;
	bool isAlarm() const;
	int serNum() const;
	void eventsInfo(int&, int&) const;
	void keysInfo(int&, int&) const;
	void portsInfo(char *) const;
	void relayOn(int, int, bool) const;
	void relayOff(int) const;
	void timer(int) const;
	void generateTimerEvents(int) const;
	void writeKey(const char *) const;
	void eraseKey(const char *) const;
	void eraseAllKeys() const;
	void eraseAllEvents() const;
	bool keyExist(const char *, char&, char&, bool&, bool&, bool&) const;
	int readAllKeys(std::vector<char>&) const;
	void writeAllKeys(const char *, int) const;
	void writeAllKeysAsync(const char *, int) const;
	void readClock(char *) const;
	void writeClockDate(const char *) const;
	void writeClockTime(const char *) const;
	int readTimetable(std::vector<char>&) const;
	void eraseTimetable() const;
	void writeTimetable(const char *, size_t, const char *, size_t) const;
	void restartProg() const;
	void readKeypad(char *) const;
	void writeKeypad(const char *) const;
	void readSetup(char *) const;
	void writeSetup(const char *) const;
	int readAllChips(std::vector<char>&) const;
	void writeAllChips(const char *, int) const;
	void controlChip(const char *, bool) const;
	void eraseAllChips() const;
	int chipInfo(int, char*) const;
	bool isChipActivated(boost::uint64_t v) const;

	Channel& channel;
	const char addr;

	static char cs8(const char *, int);
	static char crc8(const char *, int);
	//static void decodeKeyAttr(const char *, char&, char&, bool&, bool&, bool&);
	static const char *reverseCopyKey(char *out, const char *key);
protected:
	enum _MemType {mtNone, mtRAM, mtEEPROM};
	enum _MemOp {moNone, moOff, moRead, moWrite};

	struct _AliveTimer: public Timer::Item
	{
		_AliveTimer(unsigned short timeout, Controller& co_): Timer::Item(timeout, true), co(co_) {}
		void onTimer() throw();
		Controller& co;
	};

	struct _DeadTimer: public Timer::Item
	{
		_DeadTimer(unsigned short timeout, Controller& co_): Timer::Item(timeout, true), co(co_) {}
		void onTimer() throw();
		Controller& co;
	};

	struct _StateTimer: public Timer::Item
	{
		_StateTimer(Controller& co_): Timer::Item(3, true), co(co_) {}
		void onTimer() throw();
		Controller& co;
	};

	class _Command
	{
	public:
		_Command(const Controller& co_, char op_, char osize_, char isize_)
			: co(co_), op(op_), osize(osize_), isize(isize_), _buf(new char[std::max<size_t>(osize, isize) + 7]) {}
		int exec(bool = true);
		char& operator [](char index) throw() { return _buf[6 + index]; }
		const Controller& co;
		const char op;
		const char osize;
		const char isize;
	protected:
		boost::scoped_array<char> _buf;
	};//_Command

	class _MemGuard
	{
	public:
		_MemGuard(const Controller& co_, _MemType mem_, char bank): co(co_), mem(mem_), _bank(bank) { _turnOn(bank); }
		~_MemGuard() { _turnOff(); }
		char bank() const throw() { return _bank; }
		void switchBankIf(char bank);
		const Controller& co;
		const _MemType mem;
	protected:
		void _turnOn(char bank) { co._setMemMode(mem, bank, moWrite); _bank = bank; }
		void _turnOff() { co._setMemMode(mem, _bank, moOff); }
		char _bank;
	};//_MemGuard

	class _RAMInfo
	{
	public:
		explicit _RAMInfo(const Controller&);
		char type() const throw() { return buf[2]; }
		char blockSizePages() const throw() { return buf[3]; }
		short blockSizeBytes() const throw() { return (buf[3] * 256); }
		short blockCount() const throw() { return (buf[4]? buf[4]: 256); }
		short ibufSizeBytes() const throw() { return (buf[11]? buf[11]: 256); }
		short obufSizeBytes() const throw() { return (buf[12]? buf[12]: 256); }
		char KBfirstBlock() const throw() { return buf[13]; }
		char TTfirstBlock() const throw() { return buf[15]; }
		char TTblockCount() const throw() { return buf[16]; }
	protected:
		char buf[18];
	};//_RAMInfo

	class _KBInfo
	{
	public:
		explicit _KBInfo(const Controller&);
		char valueSize() const throw() { return buf[2]; }
		int capacity() const throw() { return co._varVal(&buf[2], 1); }
		int count() const throw() { return co._varVal(&buf[2], 1 + valueSize()); }
		//char blocks() const throw() { return co._varVal(&buf[2], 1 + valueSize() * 2); }// TODO: chk ver (since 0.5). throw it?
		const Controller& co;
	protected:
		char buf[11];
	};//_KBInfo

	class _TTInfo
	{
	public:
		explicit _TTInfo(const Controller& co);
		bool valid() const throw() { return _valid; }
		char firstBlock() const throw() { return buf[2]; }
		char blockCount() const throw() { return buf[3]; }
		char version() const throw() { return buf[5]; }
		char persCatCount() const throw() { return buf[6]; }
		char dayTypeCount() const throw() { return buf[7]; }
		char TPiP_size() const throw() { return buf[8]; }
		char intervalCount() const throw() { return (buf[9] * CHAR_BIT); }
		char dayType() const throw() { return buf[10]; }
		char currentInterval() const throw() { return buf[11]; }
	protected:
		bool _valid;
		char buf[15];
	};//_TTInfo

	struct _TTImage
	{
		struct TPiP_Item
		{
			explicit TPiP_Item(const char *data_): data(data_) {}
			char day() const throw() { return bcd2bin(data[0]); }
			char month() const throw() { return bcd2bin(data[1]); }
			char year() const throw() { return bcd2bin(data[2]); }
			char dayType() const throw() { const char x = bcd2bin(data[3]); return (x? x: 8); }
			const char * const data;
		};//TPiP_Item
		struct DRS_Item
		{
			explicit DRS_Item(const char *data_): data(data_) {}
			char hour() const throw() { return bcd2bin(data[1]); }
			char minute() const throw() { return bcd2bin(data[0]); }
			const char * const data;
		};//DRS_Item
		explicit _TTImage(const char *data_): data(data_) {}
		short TPiP_offset() const throw() { return unpackShort(&data[0x24]); }
		short DRS_offset() const throw() { return unpackShort(&data[0x26]); }
		short KDS_offset() const throw() { return unpackShort(&data[0x28]); }
		char TPiP_itemCount() const throw() { return data[TPiP_offset()]; }
		const char *TPiP_item(short idx) const throw() { return &data[TPiP_offset() + 4 + (4 * idx)]; }
		const char *DRS_item(short idx) const throw() { return &data[DRS_offset() + (2 * idx)]; }
		int KDS_item(int off) const throw() { return unpackInt(&data[off]); }
		const char * const data;
	};//_TTImage

	struct WriteAllKeysThImpl : Thread::Impl
	{
		WriteAllKeysThImpl(const Controller& co, const char *keys, int count);
		~WriteAllKeysThImpl();
		void operator() () throw();
		const Controller& co;
		std::vector<char> keys;
		const bool is_201;
	};

	void _chkInput(int r) const
	{
		if (r == 0)
			throw Error(*this, "Timeout", boost::str(boost::format("No response in %u msec") %channel.responseTimeout));
	}

	void _throwFeature() const
	{
		throw Error(*this, "Feature", "Unsupported feature");
	}

	void _throwUnexpectedResponse() const
	{
		throw Error(*this, "Protocol", "Unexpected response");
	}

	void _throwCheckSum() const
	{
		throw Error(*this, "Error", "Invalid checksum");
	}

	void _throwBusy() const
	{
		throw Error(*this, "Error", "Busy");
	}

	void _throwSetMem(const char *detail) const
	{
		throw Error(*this, "Error", boost::str(boost::format("Can't set memory mode, %s") %detail));
	}

	void _throwWriteMem(const char *detail) const
	{
		throw Error(*this, "Error", boost::str(boost::format("Can't write memory, %s") %detail));
	}

	void _readEvt();
	void _readEvt2(bool) const;
	void _processEvt(const char *);

	/* int _readPack(char *buf - äîñòàòî÷íîãî ðàçìåðà, int size - ïîëíûé ðàçìåð äëÿ ÷òåíèÿ) const */
	int _readPack(char *, int, bool) const;

	int _chkPack(const char *, int, bool) const;

	/* int _4c(const char op - êîä îïåðàöèè, char *buf - äîñòàòî÷íîãî ðàçìåðà, int size - ïîëíûé ðàçìåð äëÿ ÷òåíèÿ) const */
	int _4c(const char, char *, int, bool) const;

	int _varVal(const char *, int) const;
	char _getProgId() const;
	short _getProgVer() const;
	bool _getIsAlarm() const;
	int _getSerNum() const;
	char _readRPD(char) const;
	//void _writeRPD(char) const;
	void _setMemMode(_MemType, char, _MemOp, char = 0) const;
	void _readMem(char, int, char *, short) const;

	/* short _readMem(int off, char *buf - ðàçìåðîì: size + 6 è íà÷àëîì äàííûõ: buf[5], short size - âñåãî áóôåðà) const */
	short _readMem(int, char *, short) const;

	/* void _writeMem(char bank, int off, char *buf - ðàçìåðîì: size + 7 è íà÷àëîì äàííûõ: buf[6], char size - ðàçìåð äàííûõ) const */
	void _writeMem(char, int, char *, char) const;

	void _writeMem(int, char *, char) const;

	void _eraseKey(const char *) const;
	void _eraseKey201(const char *) const;
	void _eraseAllKeys() const;
	void _eraseAllKeys201() const;
	int _readAllKeys(std::vector<char>&) const;
	int _readAllKeys201(std::vector<char>&) const;
	void _writeKey(const char *) const;
	void _writeKey201(const char *) const;
	void _writeAllKeys(const char *, int) const;
	void _writeAllKeys201(const char *, int) const;
	void _keysInfo(int&, int&) const;
	void _keysInfo201(int&, int&) const;
	void _eventsInfo(int&, int&) const;
	void _eventsInfo201(int&, int&) const;

	void _setState(char);

	bool _polling;
	bool _autonomic;
	//bool _reliable;
	mutable char _progId;
	mutable short _progVer;
	mutable int _progVerCnt;
	mutable boost::optional<bool> _isAlarm;
	mutable std::set<boost::uint64_t> _chipsActivated;

	std::string _lastErrMsg;

	_AliveTimer _aliveTimer;
	_DeadTimer _deadTimer;

	enum {_recoverNone, _recoverAlive, _recoverDead};
	char _recoverState;

	enum {_stateStateless=1, _stateAutonomicPolling, _stateComplex};
	char _state;
	_StateTimer _stateTimer;
};//Controller

class SerialChannel: public Channel
{
public:
	SerialChannel(Events&, unsigned short, unsigned short, unsigned short, const std::string&, unsigned int);
	~SerialChannel();
	const std::string& id() const throw() { return devStr; }
	const std::string& connInfo() const throw() { return _connInfo; }
	const std::string devStr;
	const unsigned int speed;
protected:
	void _init();
	void _fini();
	int _read(char *, int) const;
	void _write(const char *, int);
	SerialPort *_comm;
	std::string _connInfo;
};//SerialChannel

class IPChannel: public Channel
{
public:
	IPChannel(Events&, unsigned short, unsigned short, unsigned short, const std::string&, unsigned short);
	~IPChannel();
	const std::string& id() const throw() { return _id; }
	const std::string& connInfo() const throw() { return _id; }
	const std::string host;
	const unsigned short port;
protected:
	void _init();
	void _fini();
	int _read(char *, int) const;
	void _write(const char *, int);
	Socket *_comm;
	std::string _id;
};//IPChannel


#ifdef TSS_DAVINCI

//const char avrI2cAddr = 0xE0;

class I2CBase: private boost::noncopyable
{
public:
	explicit I2CBase(const char addr)
	{
		_chk( DRV_i2cOpen(&_hndl, addr) );
	}
	~I2CBase()
	{
		_chk( DRV_i2cClose(&_hndl) );
	}
	void write(const char reg, const void * const buf, const char size)
	{
		_chk( DRV_i2cWrite(&_hndl, reg, static_cast<const Uint8 *>(buf), size) );
	}
	void read(const char reg, void * const buf, const char size)
	{
		_chk( DRV_i2cRead(&_hndl, reg, static_cast<Uint8 *>(buf), size) );
	}
private:
	void static _chk(const int r)
	{
		if (r != 0)
		{
			//const boost::system::system_error e(errno, boost::system::system_category());
			//boost::throw_exception(e);
		}
	}
	DRV_I2cHndl _hndl;
};//class I2CBase


class I2C: private boost::noncopyable
{
public:
	void open(const char addr)
	{
		BOOST_ASSERT(!isOpen());
		_i2c.reset(new I2CBase(addr));
	}
	void close()
	{
		_i2c.reset();
	}
	bool isOpen() const { return !!_i2c.get(); }
	void write(const char reg, const void * const buf, const char size)
	{
		BOOST_ASSERT(isOpen());
		_i2c->write(reg, buf, size);
	}
	void write(const char reg, const unsigned short v)
	{
		BOOST_ASSERT(isOpen());
		const char buf[] = { v & 0xFF, v >> 8 };
		_i2c->write(reg, buf, 2);
	}
	void read(const char reg, void * const buf, const char size)
	{
		BOOST_ASSERT(isOpen());
		_i2c->read(reg, buf, size);
	}
	boost::uint16_t read(const char reg)
	{
		BOOST_ASSERT(isOpen());
		char buf[2];
		_i2c->read(reg, buf, 2);
		return buf[0] << 8 | buf[1];
	}	
protected:
private:
	std::auto_ptr<I2CBase> _i2c;
};//class I2C

class DVRS422Channel: public Channel
{
public:
	DVRS422Channel(Events&, unsigned short, unsigned short, unsigned short, unsigned int);
	~DVRS422Channel();
	const unsigned int speed;
	const std::string& id() const throw();
	const std::string& connInfo() const throw();
	static const char i2cOutAvailReg;
	static const char i2cInAvailReg;
	static const char i2cOutReg;
	static const char i2cInReg;
private:
	void _init();
	void _fini();
	int _read(char *, int) const;
	void _write(const char *, int);
	//int _outAvail();
	int _inAvail() const;
	int _waitInAvail() const;
	mutable I2C _i2c;
	static const std::string _id;
};//class DVRS422Channel

#endif // #ifdef TSS_DAVINCI

}}//namespace tss { namespace servcont

#endif
