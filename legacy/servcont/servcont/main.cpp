#include "pch.h"
#include <tss/config.hpp>
#include <cstdlib>
#include <string>
#include <list>
#include <queue>
#include <algorithm>
#include <boost/scoped_ptr.hpp>
#include <boost/scoped_array.hpp>
#include <boost/format.hpp>
#include <tss/sys.hpp>
#include <tss/app.hpp>
#include <tss/sync.hpp>
#include <tss/filename.hpp>
#include <tss/file.hpp>
#include <tss/rpc.hpp>
#include <tss/servcont.hpp>
#include <tss/sqlite.hpp>
//#include <tss/assertnoiostream.hpp>

using namespace std;
using namespace boost;
using namespace tss;

struct SendableEvent;

struct ChannelEvents: servcont::Channel::Events
{
	~ChannelEvents() { /*trace("~ChannelEvents()");*/ }
	void onControllerEvent(const servcont::Channel&, const char *) throw();
	void onError(const servcont::Channel&, const std::exception&) throw();
	void onControllerError(const servcont::Channel&, const servcont::Controller&, const std::exception&) throw();
	void onChangeState(const servcont::Channel&, bool) throw();
	void onPollSpeed(const servcont::Channel&, int) throw();
	void onControllerState(const servcont::Channel&, const servcont::Controller&, char) throw();
	void onControllersChanged(const servcont::Channel&) throw();
	void onWriteAllKeysAsync(const servcont::Controller&, const std::string&) throw();
};//ChannelEvents

class Channels: public PtrMap<string, servcont::Channel>
{
public:
	~Channels();
	servcont::SerialChannel& add(unsigned short, unsigned short, unsigned short, const string&, unsigned int);
	servcont::IPChannel& add(unsigned short, unsigned short, unsigned short, const string&, unsigned short);
#ifdef TSS_DAVINCI
	servcont::DVRS422Channel& add(unsigned short, unsigned short, unsigned short, unsigned short);
#endif
protected:
	std::string _key2str(const string&) const;
	ChannelEvents _events;
};//Channels

struct ClientEvents: rpc::Client::Events
{
	~ClientEvents() { /*trace("~ClientEvents()");*/ }
	void onConnect(rpc::Client&) throw();
	void onDisconnect(rpc::Client&) throw();
	bool onProc(rpc::Client&, const rpc::Proc&, rpc::Params&) throw();
	void onExec(rpc::Client&, bool, const rpc::Params&, const string&) throw();
};//ClientEvents

class Client: public rpc::Client
{
public:
	Client(ClientEvents& events, const string& connInfo_)
		: rpc::Client(events, 256), connInfo(connInfo_)
	{ trace("Client()"); }
	~Client() { trace("~Client()"); }
	const string connInfo;
protected:
};

class Clients: public list<boost::shared_ptr<Client> >
{
public:
	typedef list<boost::shared_ptr<Client> > Base;
	Clients(): _mainClient(NULL) {}
	~Clients();
	size_t count() const;
	void add(SOCKET, const string&);
	bool exec(const SendableEvent&, bool, bool) const;
	void disconnect();
	bool isMainClient(const rpc::Client&) const throw();
	void mainClient(const Client&);
	void onDisconnect(const Client&);
protected:
	thread::Synchronizer _sync;
	ClientEvents _events;
	const Client *_mainClient;
};//Clients

class Event
{
public:
	enum Type {etNone, etController, etChannelError, etControllerError, etChannelState,
		etChannelPollSpeed, etControllerState, etChannelsChanged, etControllersChanged, etClientsChanged, etQueueFull, etWriteAllKeysAsync
	};
	explicit Event(Type type_): type(type_) {}
	Event(Type type_, const char *timestamp_): timestamp(timestamp_), type(type_) {}
	virtual ~Event() { /*trace("~Event()");*/ }
	const servcont::Timestamp timestamp;
	const Type type;
protected:
};//Event

class QueueFullEvent: public Event
{
public:
	QueueFullEvent(): Event(etQueueFull) {}
};

class ClientsChangedEvent: public Event
{
public:
	ClientsChangedEvent(): Event(etClientsChanged) {}
};

class ChannelsChangedEvent: public Event
{
public:
	ChannelsChangedEvent(): Event(etChannelsChanged) {}
};//ChannelsChanged

class ChannelEvent: public Event
{
public:
	ChannelEvent(Type type, const string& ch_): Event(type), ch(ch_) {}
	ChannelEvent(Type type, const string& ch_, const char *timestamp_): Event(type, timestamp_), ch(ch_) {}
	const string ch;
};//ChannelEvent

class ControllersChangedEvent: public ChannelEvent
{
public:
	ControllersChangedEvent(const string& ch): ChannelEvent(etControllersChanged, ch) {}
};

class WriteAllKeysAsyncEvent : public ChannelEvent
{
public:
	WriteAllKeysAsyncEvent(const string& ch, char addr, const std::string& err):
		ChannelEvent(etWriteAllKeysAsync, ch),
		addr(addr), err(err)
	{
	}
	const char addr;
	const std::string err;
};

class ControllerEvent: public ChannelEvent
{
public:
	enum Kind {ekNone, ekKey, ekButton, ekDoorOpen, ekDoorClose, ek220v, ekCase, ekTimer, ekAutoTimeout, ekRestart, ekStart, ekStaticSensor};
	enum {size = 16};//without CS
	ControllerEvent(const string& ch, const char *evt):
		ChannelEvent(etController, ch), used(false), _ct(NULL)
	{
		memcpy(_data, evt, sizeof(_data));
		_ict();
	}
	ControllerEvent(const string& ch, const char *evt, const char *timestamp):
		ChannelEvent(etController, ch, timestamp), used(false), _ct(NULL)
	{
		memcpy(_data, evt, sizeof(_data));
		_ict();
	}
	~ControllerEvent() { /*trace("~ControllerEvent()");*/ }
	Kind kind() const throw();
	const char *data() const throw() { return _data; }
	char addr() const throw() { return _data[0]; }
	unsigned short No() const throw() { return (_data[9] << 8 | _data[8]); }
	bool isAuto() const throw() { return 0 != (_data[12] & 128); }
	bool isLast() const throw() { return (!(_data[1] & 128)); }
	bool hasYear() const throw() { return 0 != (_data[11] & 128); }
	bool hasDate() const throw() { return (_data[10] != 0 || _data[11] != 0); }
	const servcont::Timestamp& controllerTimestamp() const throw() { return _ct; }
	bool used;
protected:
	void _ict();
	char _data[size];
	servcont::Timestamp _ct;
};//ControllerEvent

class EventQueue
{
public:
	EventQueue(): _busy(false), _limit(UINT_MAX), _sender(new _SenderThreadImpl(*this)) {}
	~EventQueue();
	size_t size() const throw();
	void push(boost::shared_ptr<Event> evt);
	const SendableEvent *front(bool&, bool&);
	void pop(bool);
	void save() throw();
	void load();
	void stop() throw();
	void limit(size_t);
	void signal();
	void busy(bool);
protected:
	typedef queue<boost::shared_ptr<Event> > _Cont;
	struct _SenderThreadImpl: public Thread::Impl
	{
		_SenderThreadImpl(EventQueue& cue_): cue(cue_), terminated(false) {} 
		~_SenderThreadImpl() { trace("~_SenderThreadImpl()\n"); }
		void operator() () throw();
		EventQueue& cue;
		volatile bool terminated;
	};
	thread::Synchronizer _sync;
	bool _busy;
	size_t _limit;
	_Cont _cont;
	Semaphore _sem;
	Thread _sender;
};//EventQueue

class CoEvtLog
{
public:
	struct ScopedOpen
	{
		ScopedOpen(CoEvtLog& o_): o(o_), oldOpen(o._isOpen())
		{
			if (!oldOpen)
				o._open();
		}
		~ScopedOpen()
		{
			if (!oldOpen)
				o._close();
		}
		CoEvtLog& o;
		const bool oldOpen;
	};

	CoEvtLog(): _db(NULL), _log(false) {}
	void open(bool);
	void close() throw();
	void add(const ControllerEvent&);
	int send(const char *, const char *, int, int);
	void clear();
	bool isLog() const throw() { return _log; }
protected:
	void _open();
	void _close();
	bool _isOpen() const throw() { return _db != NULL; }
	thread::Synchronizer _sync;
	SQLite *_db;
	volatile bool _log;
};

class Servcont: public Application
{
public:
	enum Task {cleanupClients, stopEventCue};

	Servcont(int, char **);
	~Servcont() { trace("~Servcont()"); }

	void run();
	void shutdown() throw();
	string rootDir() const;
	//string logDir() const;
	string dataDir() const;
	void doTask(const Task);

	thread::Synchronizer sync;
	Channels channels;
	EventQueue eventCue;
	Clients clients;
	CoEvtLog coEvtLog;
protected:
	struct _ThImpl: Thread::Impl
	{
		~_ThImpl() { trace("Servcont::~_ThImpl()"); }
		void operator ()() throw();
	};
	thread::Synchronizer _taskSync;
	Semaphore _sem;
	Thread *_thread;
	bool _cleanupClients, _stopEventCue;

} static * volatile app;


int main(int argc, char *argv[])
{
//#ifdef _SECURE_SCL
//	printf("_SECURE_SCL: %d\n", _SECURE_SCL);
//#endif
//#ifdef MSWINDOWS
//	::SetProcessAffinityMask(::GetCurrentProcess(), 1);
//#endif

	struct X
	{
		~X() { app->shutdown(); }
		void run() { app->run(); }
	};

	int ret = EXIT_FAILURE;
	try
	{
		app = &Application::init<Servcont>(argc, argv);
		X x;
		x.run();
		ret = EXIT_SUCCESS;
	} catch (const std::exception& e)
	{
		handleException(e);
	} catch (...)
	{
		log("Unexpected exception.");
	}
	return ret;
}

static bool a_equal_B(char a, const char b) throw()
{
	return (::toupper(a) == b);
}

static bool equal(const string& a, const char * const b) throw()
{
	return ((a.size() == strlen(b)) && std::equal(a.begin(), a.end(), b, &a_equal_B));
}

Channels::~Channels()
{
	trace("~Channels()");
}

servcont::SerialChannel& Channels::add(unsigned short responseTimeout, unsigned short aliveTimeout, unsigned short deadTimeout, const string& devStr, unsigned int speed)
{
	servcont::SerialChannel *ch = new servcont::SerialChannel(_events, responseTimeout, aliveTimeout, deadTimeout, devStr, speed);
	insert(ch->id(), ch);
	return *ch;
}

servcont::IPChannel& Channels::add(unsigned short responseTimeout, unsigned short aliveTimeout, unsigned short deadTimeout, const string& host, unsigned short port)
{
	servcont::IPChannel *ch = new servcont::IPChannel(_events, responseTimeout, aliveTimeout, deadTimeout, host, port);
	insert(ch->id(), ch);
	return *ch;
}

#ifdef TSS_DAVINCI
servcont::DVRS422Channel& Channels::add(unsigned short responseTimeout, unsigned short aliveTimeout, unsigned short deadTimeout, unsigned short speed)
{
	servcont::DVRS422Channel *ch = new servcont::DVRS422Channel(_events, responseTimeout, aliveTimeout, deadTimeout, speed);
	insert(ch->id(), ch);
	return *ch;
}
#endif

string Channels::_key2str(const std::string& key) const
{
	return str(format("Channel<%s>") %key);
}

static servcont::Controller& co(const rpc::Proc& proc)
{
	return app->channels[proc.params["CHANNEL"].asString()].controllers[*proc.params["ADDR"].value()];
}


//#define TSS_SERVCONT_LOG_RELAYONS

static void controllRelay(const rpc::Proc& proc, bool isOn)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	if (isOn)
	{
#ifdef TSS_SERVCONT_LOG_RELAYONS
		const int port = proc.params["PORT"].asInt();
		const int interval = proc.params["INTERVAL"].asInt();
		const char * const fmt = "relay: %d interval: %d - %s";
		try
		{
			co(proc).relayOn(port, interval, proc.params["SUPPRESSDOOREVENT"].asBool());
			log(boost::str(boost::format(fmt) %port %interval %"ok"));
		}
		catch (...)
		{
			log(boost::str(boost::format(fmt) %port %interval %"failed"));
			throw;
		}
#else
		co(proc).relayOn(proc.params["PORT"].asInt(), proc.params["INTERVAL"].asInt(), proc.params["SUPPRESSDOOREVENT"].asBool());
#endif
	}
	else
		co(proc).relayOff(proc.params["PORT"].asInt());
}

//static void chkChTimeout(unsigned int val)
//{
//	chkRange(0, 0xFFFF, val, "Timeout");
//}

static void aditChannels(const rpc::Proc& proc, bool isAdd)
{
	{
		TSS_SCOPED_THREAD_LOCK(app->sync);
		if (isAdd)
		{
			//chkChTimeout(proc.params["RESPONSETIMEOUT"].asInt());
			//chkChTimeout(proc.params["ALIVETIMEOUT"].asInt());
			//chkChTimeout(proc.params["DEADTIMEOUT"].asInt());
			if (proc.params["ISIP"].asBool())
			{
				app->channels.add(
					proc.params["RESPONSETIMEOUT"].asInt(),
					proc.params["ALIVETIMEOUT"].asInt(),
					proc.params["DEADTIMEOUT"].asInt(),
					proc.params["HOST"].asString(),
					static_cast<unsigned short>(proc.params["PORT"].asInt())
				);
			} else
			{
				app->channels.add(
					proc.params["RESPONSETIMEOUT"].asInt(),
					proc.params["ALIVETIMEOUT"].asInt(),	
					proc.params["DEADTIMEOUT"].asInt(),
					proc.params["PORT"].asString(),
					static_cast<unsigned int>(proc.params["SPEED"].asInt())
				);
			}
		} else
		{
			servcont::Channel& ch = app->channels[proc.params["ID"].asString()];
			if (ch.active())
				TSS_SERVCONT_THROW_CLIENT_ERROR_REQUEST("Channel is active");
			app->channels.erase(ch.id());
		}
	}
	app->eventCue.push(boost::shared_ptr<ChannelsChangedEvent>(new ChannelsChangedEvent));
}

#ifdef TSS_DAVINCI
static void addDvRs422Channel(const rpc::Proc& proc)
{
	{
		TSS_SCOPED_THREAD_LOCK(app->sync);
		app->channels.add(
			proc.params["RESPONSETIMEOUT"].asInt(),
			proc.params["ALIVETIMEOUT"].asInt(),
			proc.params["DEADTIMEOUT"].asInt(),
			static_cast<unsigned int>(proc.params["SPEED"].asInt())
			);
	}
	app->eventCue.push(boost::shared_ptr<ChannelsChangedEvent>(new ChannelsChangedEvent));
}
#endif


static void controllChannel(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	if (proc.params["ACTIVE"].asBool())
		app->channels[proc.params["ID"].asString()].activate();
	else
		app->channels[proc.params["ID"].asString()].deactivate();
}

static void editControllers(const rpc::Proc& proc, bool isAdd)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	servcont::Channel& ch = app->channels[proc.params["CHANNEL"].asString()];
	if (ch.active())
		TSS_SERVCONT_THROW_CLIENT_ERROR_REQUEST("Channel is active");
	if (isAdd)
		ch.controllers.add(proc.params["ADDR"].asInt());
	else
		ch.controllers.remove(proc.params["ADDR"].asInt());
}

static void findControllers(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	servcont::Channel& ch = app->channels[proc.params["CHANNEL"].asString()];
	std::vector<char> addrs = ch.findControllers();
	params.add("COUNT", static_cast<int>(addrs.size()));
	params.add("ADDRS", &addrs[0], addrs.size());
}

static void pollOn(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	co(proc).pollOn(
		proc.params["ISAUTO"].asBool(),
		proc.params["ISRELIABLE"].asBool());
}

static void pollOff(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	co(proc).pollOff(proc.params["FORCEAUTO"].asBool());
}

static void switchToAuto(bool doTheBest, bool closeChannel, bool clearChannels)
{
	bool channelsChanged = false;
	{
		TSS_SCOPED_THREAD_LOCK(app->sync);
		for (Channels::const_iterator chIt = app->channels.begin(); chIt != app->channels.end(); ++chIt)
		{
			servcont::Channel& ch = *chIt->second;
			for (servcont::Controllers::const_iterator coIt = ch.controllers.begin(); coIt != ch.controllers.end(); ++coIt)
			{
				servcont::Controller& co = *coIt->second;
				try
				{
					co.pollOff(true);
				} catch (const std::exception& e)
				{
					if (doTheBest)
						handleException(e);
					else
						throw;
				}
			}
			if (closeChannel)
				ch.deactivate();
		}
		if (clearChannels)
		{
			if (!app->channels.empty())
			{
				app->channels.clear();
				channelsChanged = true;
			}
		}
	}
	if (channelsChanged)
		app->eventCue.push(boost::shared_ptr<ChannelsChangedEvent>(new ChannelsChangedEvent));
}

static void timer(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	co(proc).timer(proc.params["INTERVAL"].asInt());
}

static void generateTimerEvents(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	co(proc).generateTimerEvents(proc.params["COUNT"].asInt());
}

static void writeKey(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	const rpc::Param& param = proc.params["KEY"];
	if (18 != param.size)
		TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER("Invalid key length");
	co(proc).writeKey(param.value());
}

static void eraseKey(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	co(proc).eraseKey(
		proc.params["KEY"].value());
}

static void eraseAllKeys(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	co(proc).eraseAllKeys();
}

static void eraseAllEvents(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	co(proc).eraseAllEvents();
}

static void keyExist(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	char ports, persCat;
	bool suppressDoorEvent; bool openEvenComplex; bool isSilent;
	bool r = co(proc).keyExist(
		proc.params["KEY"].value(),
		ports,
		persCat,
		suppressDoorEvent,
		openEvenComplex,
		isSilent);
	params.add("RESULT", r);
	if (r)
	{
		char buf[12];
		expandMask(buf, ports);
		buf[8] = persCat;
		buf[9] = suppressDoorEvent;
		buf[10] = openEvenComplex;
		buf[11] = isSilent;
		params.add("KEYATTR", buf, sizeof(buf));
	}
}

static void readAllKeys(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	vector<char> v;
	const int r = co(proc).readAllKeys(v);
	params.add("COUNT", r);
	if (0 != r)
		params.add("KEYS", &v[0], v.size());
}

static void readAllChips(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	vector<char> v;
	const int r = co(proc).readAllChips(v);
	params.add("COUNT", r);
	if (0 != r)
		params.add("CHIPS", &v[0], v.size());
}

static void writeAllChips(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	const rpc::Param& chips = proc.params["CHIPS"];
	co(proc).writeAllChips(chips.value(), static_cast<int>(chips.size / 10));
}

static void controlChip(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	const rpc::Param& chip = proc.params["CHIP"];
	if (chip.size != 6)
		TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER("Chip must be 6 bytes long.");
	co(proc).controlChip(chip.value(), proc.params["ACTIVE"].asBool());
}

static void eraseAllChips(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	co(proc).eraseAllChips();
}

static void chipInfo(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	int idx = proc.params["IDX"].asInt();
	char buf[20];
	size_t n = co(proc).chipInfo(idx, buf);
	params.add("RESULT", buf, n);
}


static void mainClient(const Client& client, const rpc::Proc& proc)
{
	app->clients.mainClient(client);
	app->eventCue.limit(proc.params["QUEUELIMIT"].asInt());
	if (proc.params["LOGCONTROLLEREVENTS"].asBool())
		app->coEvtLog.open(true);
}

static void writeAllKeys(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	const rpc::Param& keys = proc.params["KEYS"];
	co(proc).writeAllKeys(keys.value(), static_cast<int>(keys.size / 18));
}

static void writeAllKeysAsync(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	const rpc::Param& keys = proc.params["KEYS"];
	co(proc).writeAllKeysAsync(keys.value(), static_cast<int>(keys.size / 18));
}

static void progId(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	int r = co(proc).progId();
	params.add("RESULT", r);
}

static void progVer(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	int r = static_cast<unsigned short>(co(proc).progVer());
	params.add("RESULT", r);
}

static void serNum(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	params.add("RESULT", co(proc).serNum());
}

static void eventsInfo(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	int capacity, count;
	co(proc).eventsInfo(capacity, count);
	params.add("CAPACITY", capacity);
	params.add("COUNT", count);
}

static void keysInfo(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	int capacity, count;
	co(proc).keysInfo(capacity, count);
	params.add("CAPACITY", capacity);
	params.add("COUNT", count);
}

static void portsInfo(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	char buf[8];
	co(proc).portsInfo(buf);
	params.add("RESULT", buf, sizeof(buf));
}

static void readClock(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	char timestamp[6];
	co(proc).readClock(timestamp);
	params.add("RESULT", timestamp, sizeof(timestamp));
}

static void writeClockDate(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	co(proc).writeClockDate(proc.params["VALUE"].value());
}

static void writeClockTime(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	co(proc).writeClockTime(proc.params["VALUE"].value());
}

static void readTimetable(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	vector<char> v;
	const int off = co(proc).readTimetable(v);
	const char *p;
	if (off)
		p = &v[0];
	else
		p = NULL;
	params.add("SPECIALDAYS", p, off, false);
	if (off < static_cast<int>(v.size()))
		p = &v[off];
	else
		p = NULL;
	params.add("ITEMS", p, v.size() - off);
}

static void writeTimetable(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);

	const rpc::Param& specialDays = proc.params["SPECIALDAYS"];
	const rpc::Param& items = proc.params["ITEMS"];
	co(proc).writeTimetable(specialDays.value(), specialDays.size,  items.value(), items.size);
}

static void eraseTimetable(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	co(proc).eraseTimetable();
}

static void restartProg(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	co(proc).restartProg();
}

static void readKeypad(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	char buf[16];
	co(proc).readKeypad(buf);
	params.add("DATA", buf, sizeof(buf));

}

static void channelList(rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	const int size = 55;
	const int count  = static_cast<int>(app->channels.size());
	const size_t total = count * size;
	scoped_array<char> buf(new char[total]);
	int i = 0;
	for (Channels::const_iterator it = app->channels.begin(); it != app->channels.end(); ++it)
	{
		const servcont::Channel& ch = *it->second.get();
		size_t off = i * size;
		std::pair<bool, bool> activeAndReady = ch.activeAndReady();
		buf[off] = activeAndReady.first; ++off; //IsActive
		buf[off] = activeAndReady.second; ++off; //IsReady
		if (typeid(*it->second) == typeid(servcont::IPChannel))
		{
			const servcont::IPChannel& ipch = static_cast<const servcont::IPChannel&>(ch);
			buf[off] = true; ++off; //IsIP
			strcpy(&buf[off], ipch.host.c_str()); off += 32; //PortOrHost
			packInt(ipch.port, &buf[off]); off += 4; //SpeedOrPort
		}
		else if (typeid(*it->second) == typeid(servcont::SerialChannel))
		{
			const servcont::SerialChannel& sch = static_cast<const servcont::SerialChannel&>(ch);
			buf[off] = false; ++off; //IsIP
			strcpy(&buf[off], sch.devStr.c_str()); off += 32; //PortOrHost
			packInt(sch.speed, &buf[off]); off += 4; //SpeedOrPort
		}
#ifdef TSS_DAVINCI
		else
		{
			const servcont::DVRS422Channel& sch = static_cast<const servcont::DVRS422Channel&>(ch);
			buf[off] = false; ++off; //IsIP
			strcpy(&buf[off], sch.id().c_str()); off += 32; //PortOrHost
			packInt(sch.speed, &buf[off]); off += 4; //SpeedOrPort
		}
#endif
		packInt(ch.responseTimeout, &buf[off]); off += 4; //ResponseTimeout
		packInt(ch.aliveTimeout, &buf[off]); off += 4; //AliveTimeout
		packInt(ch.aliveTimeout, &buf[off]); off += 4; //DeadTimeout
		packInt(ch.pollSpeed(), &buf[off]);
		++i;
	}
	params.add("COUNT", count);
	params.add("ITEMS", &buf[0], total);
}

static void controllerList(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	const int size = 2;
	const int count  = static_cast<int>(app->channels.size());
	servcont::Channel& ch = app->channels[proc.params["CHANNEL"].asString()];
	const size_t total = count * size * ch.controllers.size();
	scoped_array<char> buf(new char[total]);
	int i = 0;
	for (servcont::Controllers::const_iterator it = ch.controllers.begin(); it != ch.controllers.end(); ++it)
	{
		const servcont::Controller& co = *it->second;
		const size_t off = i * size;
		buf[off] = co.addr;
		buf[off + 1] = co.state();
		++i;
	}
	params.add("COUNT", count);
	params.add("ITEMS", &buf[0], total);
}

static void clientList(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	const int size = 22;
	const int count  = static_cast<int>(app->clients.count());
	const size_t total = count * size;
	scoped_array<char> buf(new char[total]);
	int i = 0;
	for (Clients::const_iterator it = app->clients.begin(); it != app->clients.end(); ++it)
	{
		const Client& cli = *it->get();
		size_t off = i * size;
		copy(cli.handle().begin(), cli.handle().end(), &buf[off]); off += 16; //Id
		struct sockaddr_in name;
		cli.socket().getName(&name);
		packInt(name.sin_addr.s_addr, &buf[off]); off += 4; //Addr
		packShort(name.sin_port, &buf[off]); //Port
		++i;
	}
	params.add("COUNT", count);
	params.add("ITEMS", &buf[0], total);
}

#ifdef UCLINUX
static void setHostClock(const rpc::Proc& proc)
{
	const char *p = proc.params["VALUE"].value();
	system(str(format("date %u.%u.%u-%u:%u:%u") %((int)p[0] + 2000) %(int)p[1] %(int)p[2] %(int)p[3] %(int)p[4] %(int)p[5]).c_str());
}
#endif

static void writeKeypad(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	co(proc).writeKeypad(proc.params["DATA"].value());
}

#if	0
static servcont::Channel& addCh()
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	return app->channels.add(&app->channelEvents, 400, "\\\\.\\COM1", static_cast<unsigned int>(19200));
	//return app->channels.add(&app->channelEvents, 200, "192.168.0.39", static_cast<unsigned short>(5086));
}

static servcont::Controller& addCo(servcont::Channel& ch, char addr)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	return ch.controllers.add(addr);
}

static void activateCh(servcont::Channel& ch)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	ch.activate();
}

static void realayOn(servcont::Controller& co)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	co.relayOn(1, 1, false);
}

static void eeprom(servcont::Controller& co)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);

#if 0
	char data[256];

	co.readSetup(data);
	servcont::dump(data, 256, false);

	co.writeSetup(data);
	trace("\n***\n");

	co.readSetup(data);
	servcont::dump(data, 256, false);
#endif

#if 0
	co._setMemMode(servcont::Controller::mtEEPROM, 0, servcont::Controller::moRead);
	co._readMem(0, 0, buf, 128 + 6);
	memcpy(data, &buf[5], 128);

	co._readMem(0, 128, buf, 128 + 6);
	memcpy(&data[128], &buf[5], 128);

	servcont::dump(data, 256, false);

	printf("%d ==? %d\n", (int)data[255], (int)servcont::Controller::crc8(data, 255));
#endif

#if 0
	data[0xF0] = 0xFF;
	data[255] = servcont::Controller::crc8(data, 255);
	co._setMemMode(servcont::Controller::mtEEPROM, 0, servcont::Controller::moWrite);
	memcpy(&buf[6], data, 128);
	co._writeMem(0, 0, buf, 128);

	memcpy(&buf[6], &data[128], 128);
	co._writeMem(0, 128, buf, 128);

	co._setMemMode(servcont::Controller::mtEEPROM, 0, servcont::Controller::moOff);
#endif
}

static void test()
{
	try {
		servcont::Channel& ch = addCh();
		servcont::Controller& co = addCo(ch, 82);
		activateCh(ch);
		thread::sleep(100);
		alarm(co);

		printf("\nend_of_the_test.\n");
		thread::sleep(INFINITE);
	} catch (const std::exception& e) {
		fprintf(stderr, "%s\n", e.what());
		fflush(stderr);
	}
}
#endif //<--- debug & test

void Servcont::run()
{
	eventCue.load();

	TCPServer server("0.0.0.0", 4000);

	_thread = new Thread(new _ThImpl);

	while (!app->terminated())
	{
		if (server.waitInput(330))
		{
			struct sockaddr_in sockName;
			const SOCKET handle = server.accept(&sockName);
			clients.add(handle, Socket::name2str(&sockName));
		}
	}
}

void Servcont::shutdown() throw()
{
	switchToAuto(true, true, true);
	coEvtLog.close();
	clients.disconnect();
	eventCue.stop();
	eventCue.save();
	delete _thread;
}

/*std::string Servcont::logDir() const
{
	string s = rootDir();
	s += "log";
	s += pathSeparator;
	return s;
}*/

std::string Servcont::dataDir() const
{
	string s = rootDir();
	s += "data";
	s += pathSeparator;
	return s;
}

std::string Servcont::rootDir() const
{
	string s = extractFilePath(argv[0]) + "..";
	s += pathSeparator;
	return s;
}

Servcont::Servcont(int argc_, char **argv_):
	// version
	Application("TSS Servcont", 1 << 8 | 35, argc_, argv_), _thread(NULL), _cleanupClients(false), _stopEventCue(false)
{
}

void Servcont::doTask(const Task task)
{
	TSS_SCOPED_THREAD_LOCK(_taskSync);
	if (task == cleanupClients)
		_cleanupClients = true;
	else if (task == stopEventCue)
		_stopEventCue = true;
	_sem.set();
}

void ClientEvents::onDisconnect(rpc::Client& sender) throw()
{
	log(str(format("Client<%s> %s.") %static_cast<const Client&>(sender).connInfo %"closed"));
	app->clients.onDisconnect(static_cast<const Client&>(sender));
}

void Clients::add(SOCKET handle, const string& connInfo)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	boost::shared_ptr<Client> client(new Client(_events, connInfo));
	client->open(handle);
	push_back(client);
}

/*void Clients::remove(const rpc::Client *client)
{
	TSS_SCOPED_THREAD_LOCK(sync);
	for (Container::iterator it = cont.begin(); it != cont.end(); ++it)
	{
		if (it->get() == client) {
			cont.erase(it);
			break;
		}
	}
}*/

/*bool Clients::anyConnected() const
{
	TSS_SCOPED_THREAD_LOCK(sync);
	for (Container::const_iterator it = cont.begin(); it != cont.end(); ++it)
	{
		if ((*it)->ready())
			return true;
	}
	return false;
}*/

void Clients::disconnect()
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	for (iterator it = begin(); it != end(); ++it)
	{
		(*it)->disconnect(true);
	}
	if (empty())
		app->doTask(Servcont::cleanupClients);
}

size_t Clients::count() const
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	return size();
}

static string exceptionClass(const std::exception& e)
{
	// TODO: классифицировать остальные исключения!
	string s;
	if ( typeid(servcont::Controller::Error) == typeid(e) )
		s = string("Controller") + "." + static_cast<const servcont::Error&>(e).className;
	else
	if ( typeid(servcont::Channel::Error) == typeid(e) )
		s = string("Channel") + "." + static_cast<const servcont::Error&>(e).className;
	else
	if ( typeid(servcont::ClientError) == typeid(e) )
		s = string("Client") + "." + static_cast<const servcont::Error&>(e).className;
	else
		s = "Exception";
	return s;
}

static void coEvtLogSend(const rpc::Proc& proc, rpc::Params& params)
{
	const int count = app->coEvtLog.send(
		proc.params["BEG"].value(),
		proc.params["END"].value(),
		proc.params["LIMIT"].asInt(),
		proc.params["OFFSET"].asInt());
	params.add("COUNT", count);
}

static void coEvtLogClear(const rpc::Proc& proc)
{
	app->coEvtLog.clear();
}

static void readSetup(const rpc::Proc& proc, rpc::Params& params)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	char buf[256];
	co(proc).readSetup(buf);
	params.add("DATA", (const char *)buf, (size_t)255);
}

static void writeSetup(const rpc::Proc& proc)
{
	TSS_SCOPED_THREAD_LOCK(app->sync);
	if (proc.params["DATA"].size != 255)
		TSS_SERVCONT_THROW_CLIENT_ERROR_REQUEST("Invalid setup len, must be 255");
	co(proc).writeSetup(proc.params["DATA"].value());
}

static void ensureMainClient(const rpc::Client& client)
{
	if (!app->clients.isMainClient(client))
		TSS_SERVCONT_THROW_CLIENT_ERROR_REQUEST("Not main client");
}

bool ClientEvents::onProc(rpc::Client& sender, const rpc::Proc& proc, rpc::Params& params) throw()
{
	static const char * const RELAYON = "RELAYON";
	static const char * const RELAYOFF = "RELAYOFF";
	static const char * const ADDCHANNEL = "ADDCHANNEL";
#ifdef TSS_DAVINCI
	static const char * const ADDDVRS422CHANNEL = "ADDDVRS422CHANNEL";
#endif
	static const char * const REMOVECHANNEL = "REMOVECHANNEL";
	static const char * const CONTROLLCHANNEL = "CONTROLLCHANNEL";
	static const char * const ADDCONTROLLER = "ADDCONTROLLER";
	static const char * const REMOVECONTROLLER = "REMOVECONTROLLER";
	static const char * const POLLON = "POLLON";
	static const char * const POLLOFF = "POLLOFF";
	static const char * const TIMER = "TIMER";
	static const char * const GENERATETIMEREVENTS = "GENERATETIMEREVENTS";
	static const char * const WRITEKEY = "WRITEKEY";
	static const char * const ERASEKEY = "ERASEKEY";
	static const char * const ERASEALLKEYS = "ERASEALLKEYS";
	static const char * const ERASEALLEVENTS = "ERASEALLEVENTS";
	static const char * const KEYEXIST = "KEYEXIST";
	static const char * const READALLKEYS = "READALLKEYS";
	static const char * const WRITEALLKEYS = "WRITEALLKEYS";
	static const char * const WRITEALLKEYSASYNC = "WRITEALLKEYSASYNC";
	static const char * const PROGID = "PROGID";
	static const char * const PROGVER = "PROGVER";
	static const char * const SERNUM = "SERNUM";
	static const char * const EVENTSINFO = "EVENTSINFO";
	static const char * const KEYSINFO = "KEYSINFO";
	static const char * const PORTSINFO = "PORTSINFO";
	static const char * const READCLOCK = "READCLOCK";
	static const char * const WRITECLOCKDATE = "WRITECLOCKDATE";
	static const char * const WRITECLOCKTIME = "WRITECLOCKTIME";
	static const char * const READTIMETABLE = "READTIMETABLE";
	static const char * const WRITETIMETABLE = "WRITETIMETABLE";
	static const char * const ERASETIMETABLE = "ERASETIMETABLE";
	static const char * const RESTARTPROG = "RESTARTPROG";
	static const char * const WRITEKEYPAD = "WRITEKEYPAD";
	static const char * const READKEYPAD = "READKEYPAD";
	static const char * const CHANNELLIST = "CHANNELLIST";
	static const char * const CONTROLLERLIST = "CONTROLLERLIST";
	static const char * const CLIENTLIST = "CLIENTLIST";
	static const char * const SWITCHTOAUTO = "SWITCHTOAUTO";
	static const char * const READALLCHIPS = "READALLCHIPS";
	static const char * const WRITEALLCHIPS = "WRITEALLCHIPS";
	static const char * const CONTROLCHIP = "CONTROLCHIP";
	static const char * const ERASEALLCHIPS = "ERASEALLCHIPS";
	static const char * const CHIPINFO = "CHIPINFO";
	static const char * const MAINCLIENT = "MAINCLIENT";
	static const char * const COEVTLOGSEND = "COEVTLOGSEND";
	static const char * const COEVTLOGCLEAR = "COEVTLOGCLEAR";
	static const char * const READSETUP = "READSETUP";
	static const char * const WRITESETUP = "WRITESETUP";
	static const char * const FINDCONTROLLERS = "FINDCONTROLLERS";
#ifdef UCLINUX
	static const char * const SETHOSTCLOCK = "SETHOSTCLOCK";
#endif
	bool ret;
	try
	{
		//{
		//	std::string s;
		//	s = proc.name + " -- start.";
		//	log(s.c_str());
		//}

		if (equal(proc.name, RELAYON))
		{
			ensureMainClient(sender);
			controllRelay(proc, true);
		} else if (equal(proc.name, RELAYOFF))
		{
			ensureMainClient(sender);
			controllRelay(proc, false);
		} else if (equal(proc.name, ADDCHANNEL))
		{
			ensureMainClient(sender);
			aditChannels(proc, true);
#ifdef TSS_DAVINCI
		} else if (equal(proc.name, ADDDVRS422CHANNEL))
		{
			ensureMainClient(sender);
			addDvRs422Channel(proc);
#endif
		} else if (equal(proc.name, REMOVECHANNEL))
		{
			ensureMainClient(sender);
			aditChannels(proc, false);
		} else if (equal(proc.name, CONTROLLCHANNEL))
		{
			ensureMainClient(sender);
			controllChannel(proc);
		} else if (equal(proc.name, ADDCONTROLLER))
		{
			ensureMainClient(sender);
			editControllers(proc, true);
		} else if (equal(proc.name, REMOVECONTROLLER))
		{
			ensureMainClient(sender);
			editControllers(proc, false);
		} else if (equal(proc.name, POLLON))
		{
			ensureMainClient(sender);
			pollOn(proc);
		} else if (equal(proc.name, POLLOFF))
		{
			ensureMainClient(sender);
			pollOff(proc);
		} else if (equal(proc.name, TIMER))
		{
			ensureMainClient(sender);
			timer(proc);
		} else if (equal(proc.name, GENERATETIMEREVENTS))
		{
			ensureMainClient(sender);
			generateTimerEvents(proc);
		} else if (equal(proc.name, WRITEKEY))
		{
			ensureMainClient(sender);
			writeKey(proc);
		} else if (equal(proc.name, ERASEKEY))
		{
			ensureMainClient(sender);
			eraseKey(proc);
		} else if (equal(proc.name, ERASEALLKEYS))
		{
			ensureMainClient(sender);
			eraseAllKeys(proc);
		} else if (equal(proc.name, ERASEALLEVENTS))
		{
			ensureMainClient(sender);
			eraseAllEvents(proc);
		} else if (equal(proc.name, KEYEXIST))
			keyExist(proc, params);
		else if (equal(proc.name, READALLKEYS))
			readAllKeys(proc, params);
		else if (equal(proc.name, WRITEALLKEYS))
		{
			ensureMainClient(sender);
			writeAllKeys(proc);
		} else if (equal(proc.name, WRITEALLKEYSASYNC))
		{
			ensureMainClient(sender);
			writeAllKeysAsync(proc);
		}
		else if (equal(proc.name, PROGID))
			progId(proc, params);
		else if (equal(proc.name, PROGVER))
			progVer(proc, params);
		else if (equal(proc.name, SERNUM))
			serNum(proc, params);
		else if (equal(proc.name, EVENTSINFO))
			eventsInfo(proc, params);
		else if (equal(proc.name, KEYSINFO))
			keysInfo(proc, params);
		else if (equal(proc.name, PORTSINFO))
			portsInfo(proc, params);
		else if (equal(proc.name, READCLOCK))
			readClock(proc, params);
		else if (equal(proc.name, WRITECLOCKDATE))
		{
			ensureMainClient(sender);
			writeClockDate(proc);
		} else if (equal(proc.name, WRITECLOCKTIME))
		{
			ensureMainClient(sender);
			writeClockTime(proc);
		} else if (equal(proc.name, READTIMETABLE))
			readTimetable(proc, params);
		else if (equal(proc.name, WRITETIMETABLE))
		{
			ensureMainClient(sender);
			writeTimetable(proc);
		} else if (equal(proc.name, ERASETIMETABLE))
		{
			ensureMainClient(sender);
			eraseTimetable(proc);
		} else if (equal(proc.name, RESTARTPROG))
		{
			ensureMainClient(sender);
			restartProg(proc);
		} else if (equal(proc.name, WRITEKEYPAD))
		{
			ensureMainClient(sender);
			writeKeypad(proc);
		} else if (equal(proc.name, READKEYPAD))
		{
			ensureMainClient(sender);
			readKeypad(proc, params);
		} else if (equal(proc.name, CHANNELLIST))
			 channelList(params);
		else if (equal(proc.name, CONTROLLERLIST))
			controllerList(proc, params);
		else if (equal(proc.name, CLIENTLIST))
			clientList(proc, params);
		else if (equal(proc.name, SWITCHTOAUTO))
		{
			ensureMainClient(sender);
			switchToAuto(false, false, false);
		} else if (equal(proc.name, READALLCHIPS))
			readAllChips(proc, params);
		else if (equal(proc.name, WRITEALLCHIPS))
		{
			ensureMainClient(sender);
			writeAllChips(proc);
		} else if (equal(proc.name, CONTROLCHIP))
		{
			ensureMainClient(sender);
			controlChip(proc);
		} else if (equal(proc.name, ERASEALLCHIPS))
		{
			ensureMainClient(sender);
			eraseAllChips(proc);
		} else if (equal(proc.name, CHIPINFO))
		{
			ensureMainClient(sender);
			chipInfo(proc, params);
		} else if (equal(proc.name, MAINCLIENT))
			mainClient(static_cast<const Client&>(sender), proc);
		else if (equal(proc.name, COEVTLOGSEND))
		{
			ensureMainClient(sender);
			coEvtLogSend(proc, params);
		} else if (equal(proc.name, COEVTLOGCLEAR))
		{
			ensureMainClient(sender);
			coEvtLogClear(proc);
		} else if (equal(proc.name, READSETUP))
		{
			ensureMainClient(sender);
			readSetup(proc, params);
		} else if (equal(proc.name, WRITESETUP))
		{
			ensureMainClient(sender);
			writeSetup(proc);
		} else if (equal(proc.name, FINDCONTROLLERS))
		{
			ensureMainClient(sender);
			findControllers(proc, params);
		}
#ifdef UCLINUX
		else if (equal(proc.name, SETHOSTCLOCK))
		{
			ensureMainClient(sender);
			setHostClock(proc);
		}
#endif
		else
			TSS_SERVCONT_THROW_CLIENT_ERROR_REQUEST("Unknown procedure");
		ret = true;

		//{
		//	std::string s;
		//	s = proc.name + " -- finish.";
		//	log(s.c_str());
		//}

	} catch (const std::exception& e)
	{
		trace(e.what());
		ret = false;
		params.add("EXCEPTIONCLASS", exceptionClass(e));
		params.add("MESSAGE", str(format("Procedure '%s' failed; %s") %proc.name %e.what()));

		//{
		//	std::string s;
		//	s = proc.name + " -- finish with error.";
		//	log(s.c_str());
		//}

	}
	return ret;
}

void ClientEvents::onConnect(rpc::Client& sender) throw()
{
	log(str(format("Client<%s> %s.") %static_cast<const Client&>(sender).connInfo %"connected"));
	app->eventCue.push(boost::shared_ptr<ClientsChangedEvent>(new ClientsChangedEvent));
}

void ClientEvents::onExec(rpc::Client& sender, bool result, const rpc::Params& params, const string& errMsg) throw()
{
	if (result)
		app->eventCue.pop(true);
	else
	{
		log(errMsg);
		sender.disconnect(true);
	}
}

/*
static void trace_raw_event(const char *rawEvt)
{
	ostringstream os;
	os.unsetf(ios_base::dec);
	os.setf(ios_base::hex);
	for (int i=0; i< 17; ++i)
		os << setfill('0') << setw(2) << (int)rawEvt[i] << ' ';
	trace(os.str().c_str());
}

static void trace_event(int e)
{
	switch (e & 7) {
	case 0:
		trace("no event.");
		break;
	case 1:
		trace("obschee sobitie");
		break;
	case 2:
		trace("rasshirennoe sobitie");
		break;
	case 4:
		trace("RTE");
		break;
	case 5:
		trace("RTEA");
		break;
	case 6:
		trace("KEY");
		break;
	case 7:
		trace("KEYA");
		break;
	default:
		if ((e & 15) == 3)
			trace("DATA");
		else
		if ((e & 15) == 11)
			trace("CLOSE");
		break;
	}
}
*/


struct ChannelStateEvent: ChannelEvent
{
	ChannelStateEvent(const string& ch, bool ready_): ChannelEvent(etChannelState, ch), ready(ready_) {}
	const bool ready;
};

struct ChannelPollSpeedEvent: ChannelEvent
{
	ChannelPollSpeedEvent(const string& ch, int val_): ChannelEvent(etChannelPollSpeed, ch), val(val_) {}
	const int val;
};

struct SendableEvent
{
	SendableEvent(const char *name): proc(name) { /*trace("SendableEvent()");*/ }
	virtual ~SendableEvent() { /*trace("~SendableEvent()");*/ }
	void exec(const Client& client, bool noAck) const
	{
		if (noAck)
			client.execNoAck(proc);
		else
		{
			app->eventCue.busy(true);
			client.execNoWait(proc, 10000);
		}
	}
	rpc::Proc proc;
	static SendableEvent *create(const Event&);
};


struct ChannelErrorEvent: ChannelEvent
{
	ChannelErrorEvent(Type type, const string& ch, const string& cls_, const char *msg_): ChannelEvent(type, ch), cls(cls_), msg(msg_) {}
	ChannelErrorEvent(const string& ch, const string& cls_, const char *msg_): ChannelEvent(etChannelError, ch), cls(cls_), msg(msg_) {}
	const string cls;
	const string msg;
};

struct ControllerErrorEvent: ChannelErrorEvent
{
	ControllerErrorEvent(const string& ch, const string& cls, const char *msg, char co_)
		: ChannelErrorEvent(etControllerError, ch, cls, msg), co(co_) {}
	const char co;
};

struct ControllerStateEvent: ChannelEvent
{
	ControllerStateEvent(const string& ch, char co_, char state_): ChannelEvent(etControllerState, ch), co(co_), state(state_) {}
	const char co;
	char state;
};

struct TimestampedSendableEvent: SendableEvent
{
	TimestampedSendableEvent(const char *name, const Event& evt): SendableEvent(name)
	{
		proc.params.add("TIME", evt.timestamp.c_array(), static_cast<size_t>(servcont::Timestamp::size));
	}
};

struct ChannelSendableEvent: TimestampedSendableEvent
{
	ChannelSendableEvent(const char *name, const ChannelEvent& evt): TimestampedSendableEvent(name, evt)
	{
			proc.params.add("CHANNEL", evt.ch);
	}
};

struct ChannelStateSendableEvent: ChannelSendableEvent
{
	ChannelStateSendableEvent(const ChannelStateEvent& evt): ChannelSendableEvent("ChannelState", evt)
	{
		proc.params.add("ISREADY", evt.ready);
	}
};

struct ChannelPollSpeedSendableEvent: ChannelSendableEvent
{
	ChannelPollSpeedSendableEvent(const ChannelPollSpeedEvent& evt): ChannelSendableEvent("ChannelPollSpeed", evt)
	{
		proc.params.add("VALUE", evt.val);
	}
};

struct ChannelErrorSendableEvent: ChannelSendableEvent
{
	ChannelErrorSendableEvent(const char *name, const ChannelErrorEvent& evt): ChannelSendableEvent(name, evt)
	{
		proc.params.add("CLASS", evt.cls);
		proc.params.add("MESSAGE", evt.msg);
	}
};

struct ControllerErrorSendableEvent: ChannelErrorSendableEvent
{
	ControllerErrorSendableEvent(const ControllerErrorEvent& evt): ChannelErrorSendableEvent("ControllerError", evt)
	{
		proc.params.add("ADDR", evt.co);
	}
};

struct ControllerStateSendableEvent: ChannelSendableEvent
{
	ControllerStateSendableEvent(const ControllerStateEvent& evt): ChannelSendableEvent("ControllerState", evt)
	{
		proc.params.add("ADDR", evt.co);
		proc.params.add("STATE", evt.state);
	}
};

struct ControllerSendableEvent: SendableEvent
{
	ControllerSendableEvent(const char *name, const ControllerEvent& evt): SendableEvent(name)
	{
		proc.params.add("CHANNEL", evt.ch);

		memcpy(data, evt.timestamp.c_array(), servcont::Timestamp::size);
		data[6] = evt.addr();
		packShort(evt.No(), &data[7]);
		data[9] = evt.isAuto();
		memcpy(&data[10], evt.controllerTimestamp().c_array(), servcont::Timestamp::size);
		data[16] = evt.isLast();
	}
	static ControllerSendableEvent *create(const ControllerEvent&);
	char data[30];
};//ControllerSendableEvent

struct ControllerPortSendableEvent: ControllerSendableEvent
{
	ControllerPortSendableEvent(const char *name, const ControllerEvent& evt): ControllerSendableEvent(name, evt)
	{
		data[17] = (evt.data()[1] >> 4 & 7) + 1; //Port
	}
};//ControllerPortSendableEvent

struct ControllerPortKeySendableEvent: ControllerPortSendableEvent
{
	ControllerPortKeySendableEvent(const ControllerEvent& evt): ControllerPortSendableEvent("ControllerKey", evt)
	{
		servcont::Controller::reverseCopyKey(&data[19], &evt.data()[2]);

		if (evt.isAuto())
		{
			data[18] = (evt.data()[1] & 15) == 7; //isOpen
			data[25] = (evt.data()[12] & 31) == 16; //IsTimeRestrict -  1: допуск по временным ограничениям есть;
			data[26] = !((evt.data()[12] & 15) == 8); //IsTimeRestrictDone - 0: была попытка применить временные ограничения;
			data[27] = !((evt.data()[12] & 7) == 4); //IsAccessGranted - 0: доступ по этому каналу разрешен;
			data[28] = !((evt.data()[12] & 3) == 2); //IsKeyFound - 0: ключ в БК найден;
			data[29] = !(evt.data()[12] & 1); //IsKeySearchDone - 0: был произведен поиск в базе ключей;
		}

		proc.params.add("DATA", data, 30, false);
	}
};//ControllerPortKeySendableEvent

struct ControllerPortButtonSendableEvent: ControllerPortSendableEvent
{
	ControllerPortButtonSendableEvent(const ControllerEvent& evt): ControllerPortSendableEvent("ControllerButton", evt)
	{
		data[18] = (evt.data()[1] & 15) == 5; //isOpen

		proc.params.add("DATA", data, 19, false);
	}
};//ControllerPortButtonSendableEvent

struct ControllerPortDoorOpenSendableEvent: ControllerPortSendableEvent
{
	ControllerPortDoorOpenSendableEvent(const ControllerEvent& evt): ControllerPortSendableEvent("ControllerDoorOpen", evt)
	{
		proc.params.add("DATA", data, 18, false);
	}
};//ControllerPortDoorOpenSendableEvent

struct ControllerPortDoorCloseSendableEvent: ControllerPortSendableEvent
{
	ControllerPortDoorCloseSendableEvent(const ControllerEvent& evt): ControllerPortSendableEvent("ControllerDoorClose", evt)
	{
		proc.params.add("DATA", data, 18, false);
	}
};//ControllerPortDoorCloseSendableEvent

struct Controller220VSendableEvent: ControllerSendableEvent
{
	Controller220VSendableEvent(const ControllerEvent& evt): ControllerSendableEvent("Controller220V", evt)
	{
		proc.params.add("DATA", data, 17, false);
	}
};//Controller220VSendableEvent

struct ControllerCaseSendableEvent: ControllerSendableEvent
{
	ControllerCaseSendableEvent(const ControllerEvent& evt): ControllerSendableEvent("ControllerCase", evt)
	{
		proc.params.add("DATA", data, 17, false);
	}
};//ControllerCaseSendableEvent

struct ControllerTimerSendableEvent: ControllerSendableEvent
{
	ControllerTimerSendableEvent(const ControllerEvent& evt): ControllerSendableEvent("ControllerTimer", evt)
	{
		proc.params.add("DATA", data, 17, false);
	}
};//ControllerTimerSendableEvent

struct ControllerAutoTimeoutSendableEvent: ControllerSendableEvent
{
	ControllerAutoTimeoutSendableEvent(const ControllerEvent& evt): ControllerSendableEvent("ControllerAutoTimeout", evt)
	{
		proc.params.add("DATA", data, 17, false);
	}
};//ControllerAutoTimeoutSendableEvent

struct ControllerRestartSendableEvent: ControllerSendableEvent
{
	ControllerRestartSendableEvent(const ControllerEvent& evt): ControllerSendableEvent("ControllerRestart", evt)
	{
		proc.params.add("DATA", data, 17, false);
	}
};//ControllerRestartSendableEvent

struct ControllerStartSendableEvent: ControllerSendableEvent
{
	ControllerStartSendableEvent(const ControllerEvent& evt): ControllerSendableEvent("ControllerStart", evt)
	{
		proc.params.add("DATA", data, 17, false);
	}
};//ControllerStartSendableEvent

struct ControllerStaticSensorSendableEvent: ControllerSendableEvent
{
	ControllerStaticSensorSendableEvent(const ControllerEvent& evt): ControllerSendableEvent("ControllerStaticSensor", evt)
	{
		data[17] = evt.data()[3];
		proc.params.add("DATA", data, 18, false);
	}
};//ControllerStaticSensorSendableEvent

struct WriteAllKeysAsyncSendableEvent : ChannelSendableEvent
{
	WriteAllKeysAsyncSendableEvent(const WriteAllKeysAsyncEvent& evt) : ChannelSendableEvent("WriteAllKeysAsync", evt)
	{
		proc.params.add("ADDR", evt.addr);
		proc.params.add("ERROR", evt.err);
	}
};

ControllerSendableEvent *ControllerSendableEvent::create(const ControllerEvent &evt)
{
	switch (evt.kind())
	{
		case ControllerEvent::ekKey: return (new ControllerPortKeySendableEvent(evt));
		case ControllerEvent::ekButton: return (new ControllerPortButtonSendableEvent(evt));
		case ControllerEvent::ekDoorOpen: return (new ControllerPortDoorOpenSendableEvent(evt));
		case ControllerEvent::ekDoorClose: return (new ControllerPortDoorCloseSendableEvent(evt));
		case ControllerEvent::ek220v: return (new Controller220VSendableEvent(evt));
		case ControllerEvent::ekCase: return (new ControllerCaseSendableEvent(evt));
		case ControllerEvent::ekTimer: return (new ControllerTimerSendableEvent(evt));
		case ControllerEvent::ekAutoTimeout: return (new ControllerAutoTimeoutSendableEvent(evt));
		case ControllerEvent::ekRestart: return (new ControllerRestartSendableEvent(evt));
		case ControllerEvent::ekStart: return (new ControllerStartSendableEvent(evt));
		case ControllerEvent::ekStaticSensor: return (new ControllerStaticSensorSendableEvent(evt));
		default: TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER("Unknown controller event");
	}
}

ControllerEvent::Kind ControllerEvent::kind() const throw()
{
	const char x = _data[1] & 7;
	if (x == 6 || x == 7)
		return ekKey;
	else
	if (x == 4 || x == 5)
		return ekButton;
	else
	if (3 == (_data[1] & 15))
		return ekDoorOpen;
	else
	if (11 == (_data[1] & 15))
		return ekDoorClose;
	else
	if (1 == x)
	{
		switch (_data[1] >> 4 & 7)
		{
			case 0: return ek220v;
			case 1: return ekCase;
			case 2: return ekTimer;
			case 3: return ekAutoTimeout;
			case 6: return ekRestart;
			case 7: return ekStart;
			default: return ekNone;
		}
	} else
	if (2 == x)
		return ekStaticSensor;
	else
		return ekNone;
}

void ControllerEvent::_ict()
{
	if (hasYear())
	{
		unsigned short x = unpackShort(&_data[10]);
		_ct.year(x >> 9 & 63);
		_ct.month(x >> 5 & 15);
		_ct.day(x & 31);
	} else
	{
		//_ct.year(timestamp.year());
		_ct.year(0);

		if (hasDate())
		{
			_ct.month(bcd2bin(_data[11]));
			_ct.day(bcd2bin(_data[10]));
		} else
		{
			//_ct.month(timestamp.month());
			//_ct.day(timestamp.day());
			_ct.month(1);
			_ct.day(1);
		}
	}
	_ct.hour(bcd2bin(_data[15]));
	_ct.minute(bcd2bin(_data[14]));
	_ct.second(bcd2bin(_data[13]));
}

const SendableEvent * EventQueue::front(bool& forAll, bool& coEvt)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	const SendableEvent *ret;
	if (!_cont.empty())
	{
		Event& evt = *_cont.front();
		ret = SendableEvent::create(evt);
		if (evt.type == Event::etController)
		{
			coEvt = true;
			ControllerEvent& ce = static_cast<ControllerEvent&>(evt);
			forAll = !ce.used;
			ce.used = true;
		} else
		{
			forAll = true;
			coEvt = false;
		}
	} else
		ret = NULL;
	return ret;
}

size_t EventQueue::size() const throw()
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	return _cont.size();
}

void EventQueue::push(boost::shared_ptr<Event> evt)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	_cont.push(evt);
	if (1 == _cont.size())
		_sem.set();
	else if (_cont.size() == _limit)
	{
		_cont.push(boost::shared_ptr<QueueFullEvent>(new QueueFullEvent));
		app->doTask(Servcont::stopEventCue);
	}
}

static boost::shared_ptr<SQLite> coevtcue()
{
	const string path = app->dataDir();
	createPath(path);
	const string filename = path + "coevtcue.db";
	boost::shared_ptr<SQLite> db(new SQLite(filename.c_str()));
	db->exclusive();
	db->exec("CREATE TABLE IF NOT EXISTS coevtcue(ch,t2,evt)");
	return db;
}

void EventQueue::save() throw()
{
	try
	{
		TSS_SCOPED_THREAD_LOCK(_sync);
		if (!_cont.size())
			return;
		boost::shared_ptr<SQLite> db(coevtcue());
		while (_cont.size())
		{
			const Event& evt = *_cont.front();
			if (evt.type == Event::etController)
			{
				const ControllerEvent& ce = static_cast<const ControllerEvent&>(evt);
				SQLite::Stmt stmt(*db, "INSERT INTO coevtcue VALUES(?,?,?)");
				stmt.bind(1, ce.ch.data(), static_cast<int>(ce.ch.size()));
				stmt.bind(2, ce.timestamp.c_array(), servcont::Timestamp::size);
				stmt.bind(3, ce.data(), ControllerEvent::size);
				stmt.step();
			}
			_cont.pop();
		}
	} catch (const std::exception& e)
	{
		handleException(e);
	}
}

void EventQueue::load()
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	boost::shared_ptr<SQLite> db(coevtcue());
	SQLite::Stmt stmt(*db, "SELECT * FROM coevtcue");
	while (stmt.step() == SQLITE_ROW)
	{
		boost::shared_ptr<ControllerEvent> evt(new ControllerEvent(stmt.columnBlob(0), stmt.columnBlob(2)));
		evt->used = true;
		_cont.push(evt);
	}
	db->dropTable("coevtcue");
	db->vacuum();
}

void EventQueue::pop(bool isSet)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	//assert(!_cont.empty());
	// TODO: why? происходит при завершении сервконта (CTRL+C).
	if (!_cont.empty())
		_cont.pop();
	if (isSet)
	{
		_busy = false;
		if (!_cont.empty())
			_sem.set();
	}
}

EventQueue::~EventQueue()
{
	trace("~EventQueue()");
}

void EventQueue::signal()
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	if (!_busy)
		_sem.set();
}

void EventQueue::stop() throw()
{
	_sender.pimpl<_SenderThreadImpl>()->terminated = true;
	_sem.set();
}

void EventQueue::limit(size_t val)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	_limit = val;
}

void EventQueue::busy(bool val)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	_busy = val;
}

void EventQueue::_SenderThreadImpl::operator ()() throw()
{
	while (true)
	{
		cue._sem.wait();
		if (terminated)
			break;
		while (true)
		{
			bool forAll, coEvt;
			const SendableEvent *p = cue.front(forAll, coEvt);
			if (p)
			{
				scoped_ptr<const SendableEvent> evt(p);
				if (app->clients.exec(*evt, forAll, !coEvt))
					cue.pop(false);
				else
					break;
			} else
				break;
		}
	}
}

void ChannelEvents::onControllerEvent(const servcont::Channel& ch, const char *rawEvt) throw()
{
	//trace_raw_event(rawEvt);
	//trace_event(rawEvt[1]);
	boost::shared_ptr<ControllerEvent> ce(new ControllerEvent(ch.id(), rawEvt));

#if 0
	if (ce->kind() == ControllerEvent::ekKey)
	{
		try
		{
			tss::servcont::Controller& c = app->channels[ch.id()].controllers[ce->addr()];
			if (c.isAlarm())
			{
				const char* rchip = &ce->data()[2];
				char chip[6];
				servcont::Controller::reverseCopyKey(chip, rchip);
				boost::uint64_t key = tss::servcont::keyToInt(chip);
				if (c.isChipActivated(key))
					c.controlChip(chip, false);
				else
				{
					thread::sleep(1);
					return;
				}
			}
		}
		catch (...) {}
	}
#endif

	app->eventCue.push(ce);
	if (app->coEvtLog.isLog())
		app->coEvtLog.add(*ce);
}

void ChannelEvents::onError(const servcont::Channel& ch, const std::exception& e) throw()
{
	app->eventCue.push(boost::shared_ptr<ChannelErrorEvent>(new ChannelErrorEvent(ch.id(), exceptionClass(e), e.what())));
}

void ChannelEvents::onControllerError(const servcont::Channel& ch, const servcont::Controller& co, const std::exception& e) throw()
{
	app->eventCue.push(boost::shared_ptr<ControllerErrorEvent>(new ControllerErrorEvent(ch.id(), exceptionClass(e), e.what(), co.addr)));
}

void ChannelEvents::onChangeState(const servcont::Channel& ch, bool ready) throw()
{
	app->eventCue.push(boost::shared_ptr<ChannelStateEvent>(new ChannelStateEvent(ch.id(), ready)));
}

void ChannelEvents::onPollSpeed(const servcont::Channel& ch, int val) throw()
{
	app->eventCue.push(boost::shared_ptr<ChannelPollSpeedEvent>(new ChannelPollSpeedEvent(ch.id(), val)));
}

void ChannelEvents::onControllerState(const servcont::Channel& ch, const servcont::Controller& co, char state) throw()
{
	app->eventCue.push(boost::shared_ptr<ControllerStateEvent>(new ControllerStateEvent(ch.id(), co.addr, state)));
}

void ChannelEvents::onControllersChanged(const servcont::Channel& ch) throw()
{
	app->eventCue.push(boost::shared_ptr<ControllersChangedEvent>(new ControllersChangedEvent(ch.id())));
}

void ChannelEvents::onWriteAllKeysAsync(const servcont::Controller& co, const std::string& err) throw()
{
	app->eventCue.push(boost::shared_ptr<WriteAllKeysAsyncEvent>(new WriteAllKeysAsyncEvent(co.channel.id(), co.addr, err)));
}

void CoEvtLog::open(bool log)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	if (!_isOpen())
		_open();
	_log = log;
}

void CoEvtLog::_open()
{
	const string path = app->dataDir();
	createPath(path);
	const string filename = path + "coevtlog.db";
	_db = new SQLite(filename.c_str());
	_db->exclusive();
	_db->exec("CREATE TABLE IF NOT EXISTS coevtlog(ch,t1,t2,addr,evt)");
}

void CoEvtLog::close() throw()
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	try
	{
		if (_isOpen())
			_close();
	} catch (const std::exception& e)
	{
		handleException(e);
	}
}

void CoEvtLog::_close()
{
	delete _db;
	_db = NULL;
}

void CoEvtLog::add(const ControllerEvent& evt)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	assert(_isOpen());
	SQLite::Stmt stmt(*_db, "INSERT INTO coevtlog VALUES(?,?,?,?,?)");
	stmt.bind(1, evt.ch.data(), static_cast<int>(evt.ch.size()));
	stmt.bind(2, evt.controllerTimestamp().c_array(), servcont::Timestamp::size);
	stmt.bind(3, evt.timestamp.c_array(), servcont::Timestamp::size);
	const char addr = evt.addr();
	stmt.bind(4, &addr, 1);
	stmt.bind(5, evt.data(), ControllerEvent::size);
	stmt.step();
}

int CoEvtLog::send(const char *beg, const char *end, int limit, int offset)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	if (app->channels.size())
		TSS_SERVCONT_THROW_CLIENT_ERROR_REQUEST("Channels not empty");
	ScopedOpen x(*this);
	SQLite::Stmt stmt(*_db, str(format("SELECT * FROM coevtlog WHERE t1>=? AND t1<=? LIMIT %d OFFSET %d") %limit %offset).c_str());
	stmt.bind(1, beg, 6);
	stmt.bind(2, end, 6);
	int count = 0;
	while (stmt.step() == SQLITE_ROW)
	{
		boost::shared_ptr<ControllerEvent> evt(new ControllerEvent(stmt.columnBlob(0), stmt.columnBlob(4), stmt.columnBlob(2)));
		app->eventCue.push(evt);
		++count;
	}
	return count;
}

void CoEvtLog::clear()
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	if (app->channels.size())
		TSS_SERVCONT_THROW_CLIENT_ERROR_REQUEST("Channels not empty");
	ScopedOpen x(*this);
	_db->dropTable("coevtlog");
	_db->vacuum();
}

SendableEvent *SendableEvent::create(const Event& evt)
{
	switch (evt.type)
	{
	case Event::etController:
		return ControllerSendableEvent::create(static_cast<const ControllerEvent&>(evt));
	case Event::etChannelError:
		return new ChannelErrorSendableEvent("ChannelError", static_cast<const ChannelErrorEvent&>(evt));
	case Event::etControllerError:
		return new ControllerErrorSendableEvent(static_cast<const ControllerErrorEvent&>(evt));
	case Event::etChannelState:
		return new ChannelStateSendableEvent(static_cast<const ChannelStateEvent&>(evt));
	case Event::etChannelPollSpeed:
		return new ChannelPollSpeedSendableEvent(static_cast<const ChannelPollSpeedEvent&>(evt));
	case Event::etControllerState:
		return new ControllerStateSendableEvent(static_cast<const ControllerStateEvent&>(evt));
	case Event::etChannelsChanged:
		return new TimestampedSendableEvent("ChannelsChanged", evt);
	case Event::etControllersChanged:
		return new ChannelSendableEvent("ControllersChanged", static_cast<const ChannelEvent&>(evt));
	case Event::etClientsChanged:
		return new TimestampedSendableEvent("ClientsChanged", evt);
	case Event::etQueueFull:
		return new TimestampedSendableEvent("QueueFull", evt);
	case Event::etWriteAllKeysAsync:
		return new WriteAllKeysAsyncSendableEvent(static_cast<const WriteAllKeysAsyncEvent&>(evt));
	default:
		assert(!"Unknown evt type");
		return NULL;
	};
}

bool Clients::exec(const SendableEvent& evt, bool forAll, bool noAck) const
{
	TSS_SCOPED_THREAD_LOCK(_sync);

	bool ret = noAck;
	
	if (_mainClient)
	{
		try
		{
			evt.exec(*_mainClient, noAck);
		} catch(const std::exception& e)
		{
			ret = false;
			handleException(e);
		}
	}
	
	if (forAll)
	{
		for (const_iterator it = begin(); it != end(); ++it)
		{
			try
			{
				const Client& cli = *(*it);
				if (&cli != _mainClient && cli.ready())
				{
					evt.exec(cli, true);
				}
			} catch (const std::exception& e)
			{
				handleException(e);
			}
		}
	}

	return ret;
}

void Clients::mainClient( const Client& client )
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	if (_mainClient)
	{
		if (!std::equal(client.handle().begin(), client.handle().end(), _mainClient->handle().begin()))
			TSS_SERVCONT_THROW_CLIENT_ERROR_REQUEST("Main client already exists");
	}
	if (_mainClient != &client)
	{
		_mainClient = &client;
		app->eventCue.busy(false);
		app->eventCue.signal();
	}
}

void Clients::onDisconnect( const Client& client )
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	if (_mainClient == &client)
	{
		_mainClient = NULL;
		switchToAuto(true, true, true);
	}
	app->doTask(Servcont::cleanupClients);
	if (size() > 1)
		app->eventCue.push(boost::shared_ptr<ClientsChangedEvent>(new ClientsChangedEvent));
}

bool Clients::isMainClient(const rpc::Client& testee) const throw()
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	return static_cast<const rpc::Client *>(_mainClient) == &testee;
}

Clients::~Clients()
{
	trace("~Clients()");
}

void Servcont::_ThImpl::operator()() throw()
{
	while (true)
	{
		app->_sem.wait();
		bool cleanupClients, stopEventCue;
		{
			TSS_SCOPED_THREAD_LOCK(app->_taskSync);
			stopEventCue = app->_stopEventCue;
			app->_stopEventCue = false;
			cleanupClients = app->_cleanupClients;
			app->_cleanupClients = false;
		}

		if (stopEventCue)
			switchToAuto(true, false, false);

		if (cleanupClients)
		{
			app->_cleanupClients = false;
			Clients::iterator it = app->clients.begin();
			while (it != app->clients.end())
			{
				if (!(*it)->ready())
				{
					(*it)->close();
					app->clients.erase(it);
					it = app->clients.begin();
				} else
					++it;
			}
		}
		if (app->terminated() && app->clients.empty())
			break;
	}
}
