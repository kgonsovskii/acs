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




Controller::Controller(Channel &ch_, char addr_):
	channel(ch_),
	addr(addr_),
	_polling(false),
	_progId(0),
	_progVer(0),
	_progVerCnt(0),
	_aliveTimer(ch_.aliveTimeout, *this),
	_deadTimer(ch_.deadTimeout, *this),
	_recoverState(_recoverNone),
	_state(_stateStateless),
	_stateTimer(*this)
{
	trace("Controller()");
}

Controller::~Controller()
{
	trace("~Controller()");
}

void Controller::_processEvt(const char *buf)
{
	if (buf[16] != cs8(buf, 16))
		_throwCheckSum();
	if (buf[0] != addr)
		_throwUnexpectedResponse();
	if (buf[12] & 64 && _getProgId() == 0x9C)
		throw Error(*this, "Error", "Erroneous event");
	_setState(_autonomic? _stateAutonomicPolling: _stateComplex);
	channel.events.onControllerEvent(channel, buf);
}

void Controller::_readEvt()
{
	const char cmd[] = {0x16, _autonomic? 0x3B: 0x2B, addr};
	char buf[17];
	channel._write(cmd, sizeof(cmd));
	channel._lastEvtCo = addr;
	int read = 0;
	bool isEvent = false;
	while (true)
	{
		const int r = channel._read(&buf[read], sizeof(buf) - read);
		_chkInput(r);
		read += r;
		if (read == sizeof(buf))
		{
			_processEvt(buf);
			isEvent = true;
			break;
		} else if (read == 3 && buf[0] == addr && buf[1] == 0)
		{
			if (buf[2] == addr) // No events?
				break;
			else
			if (buf[2] == static_cast<char>(~addr)) // Busy?
				//_throwBusy();
				break; // 2014-03-27 silent busy.
		} else if (read == 4 && buf[1] == addr && buf[2] == 0 && buf[3] == addr) // No events? äëÿ 201 ñ ïðîøèâêîé 85h.
			break;
	}
	channel._lastEvtCo = 0;
	++channel._speedCounter;
	if (!isEvent)
		_setState(_autonomic? _stateAutonomicPolling: _stateComplex);
}

void Controller::_readEvt2(bool isAuto) const
{
	const char cmd[] = {0x16, isAuto? 0x3A: 0x2A, addr};
	char buf[17];
	channel._write(cmd, sizeof(cmd));
	int read = 0;
	while (true)
	{
		const int r = channel._read(&buf[read], sizeof(buf) - read);
		if (r == 0)
			break;
		read += r;
		if (read == sizeof(buf))
			break;
		else if (read == 3 && buf[0] == addr && buf[1] == 0)
		{
			if (buf[2] == addr) // No events?
				break;
			else 
			if (buf[2] == static_cast<char>(~addr)) // Busy?
				break;
		} else if (read == 4 && buf[1] == addr && buf[2] == 0 && buf[3] == addr) // No events? äëÿ 201 ñ ïðîøèâêîé 85h.
			break;
	}
}

int Controller::_readPack(char *buf, int size, bool chkOp) const
{
	int read = 0, len = 0;
	while (true) {
		const int r = channel._read(&buf[read], size - read);
		_chkInput(r);
		read += r;
		if (!len)
			len = _chkPack(buf, read, chkOp);
		if (len && (read - 3) >= len)
			return len;
		if (size == read)
			_throwUnexpectedResponse();
	}
}

int Controller::_chkPack(const char *buf, int size, bool chkOp) const
{
	int len = 0;

	// _Command?
	if (size > 3) {
		if (buf[0] != addr)
			_throwUnexpectedResponse();
		len = buf[1] - 1;//packLength
		if ( (size - 3) >= len ) {
			const int x = len + 2;
			if (cs8(buf, x) != buf[x])
				_throwCheckSum();
			// ïðè íåäîïóñòèìîì ïàðàìåòðå òèïà îïåðàöèè, ëèáî â ñëó÷àå íåâåðíîé äëèíû ïàêåòà?
			if (chkOp && len == 1) {
				switch (buf[2]) {
					case 0xFE:
						throw Error(*this, "Error", "Invalid pack length");
					case 0xFF:
						throw Error(*this, "Error", "Illegal operation");
				}
			}
		}
	} else if (size > 2 && buf[0] == addr && buf[1] == 0 && buf[2] == static_cast<char>(~addr)) // Busy?
		_throwBusy();
	else if (size > 1 && buf[0] == 0x16 && buf[1] == 0x15) // NAK â ñëó÷àå íåñîâïàäåíèÿ êîíòðîëüíîé ñóììû?
		_throwCheckSum();

	return len;
}

char Controller::cs8(const char *buf, int size)
{
	char ret = buf[0];
	for (int i=1; i != size; ++i)
		ret += buf[i];
	return ret;
}

char Controller::crc8(const char *data, int size)
{
	static const char tbl[] = {
		0x00, 0x5E, 0xBC, 0xE2, 0x61, 0x3F, 0xDD, 0x83, 0xC2, 0x9C, 0x7E, 0x20, 0xA3, 0xFD, 0x1F, 0x41,
		0x9D, 0xC3, 0x21, 0x7F, 0xFC, 0xA2, 0x40, 0x1E, 0x5F, 0x01, 0xE3, 0xBD, 0x3E, 0x60, 0x82, 0xDC,
		0x23, 0x7D, 0x9F, 0xC1, 0x42, 0x1C, 0xFE, 0xA0, 0xE1, 0xBF, 0x5D, 0x03, 0x80, 0xDE, 0x3C, 0x62,
		0xBE, 0xE0, 0x02, 0x5C, 0xDF, 0x81, 0x63, 0x3D, 0x7C, 0x22, 0xC0, 0x9E, 0x1D, 0x43, 0xA1, 0xFF,
		0x46, 0x18, 0xFA, 0xA4, 0x27, 0x79, 0x9B, 0xC5, 0x84, 0xDA, 0x38, 0x66, 0xE5, 0xBB, 0x59, 0x07,
		0xDB, 0x85, 0x67, 0x39, 0xBA, 0xE4, 0x06, 0x58, 0x19, 0x47, 0xA5, 0xFB, 0x78, 0x26, 0xC4, 0x9A,
		0x65, 0x3B, 0xD9, 0x87, 0x04, 0x5A, 0xB8, 0xE6, 0xA7, 0xF9, 0x1B, 0x45, 0xC6, 0x98, 0x7A, 0x24,
		0xF8, 0xA6, 0x44, 0x1A, 0x99, 0xC7, 0x25, 0x7B, 0x3A, 0x64, 0x86, 0xD8, 0x5B, 0x05, 0xE7, 0xB9,
		0x8C, 0xD2, 0x30, 0x6E, 0xED, 0xB3, 0x51, 0x0F, 0x4E, 0x10, 0xF2, 0xAC, 0x2F, 0x71, 0x93, 0xCD,
		0x11, 0x4F, 0xAD, 0xF3, 0x70, 0x2E, 0xCC, 0x92, 0xD3, 0x8D, 0x6F, 0x31, 0xB2, 0xEC, 0x0E, 0x50,
		0xAF, 0xF1, 0x13, 0x4D, 0xCE, 0x90, 0x72, 0x2C, 0x6D, 0x33, 0xD1, 0x8F, 0x0C, 0x52, 0xB0, 0xEE,
		0x32, 0x6C, 0x8E, 0xD0, 0x53, 0x0D, 0xEF, 0xB1, 0xF0, 0xAE, 0x4C, 0x12, 0x91, 0xCF, 0x2D, 0x73,
		0xCA, 0x94, 0x76, 0x28, 0xAB, 0xF5, 0x17, 0x49, 0x08, 0x56, 0xB4, 0xEA, 0x69, 0x37, 0xD5, 0x8B,
		0x57, 0x09, 0xEB, 0xB5, 0x36, 0x68, 0x8A, 0xD4, 0x95, 0xCB, 0x29, 0x77, 0xF4, 0xAA, 0x48, 0x16,
		0xE9, 0xB7, 0x55, 0x0B, 0x88, 0xD6, 0x34, 0x6A, 0x2B, 0x75, 0x97, 0xC9, 0x4A, 0x14, 0xF6, 0xA8,
		0x74, 0x2A, 0xC8, 0x96, 0x15, 0x4B, 0xA9, 0xF7, 0xB6, 0xE8, 0x0A, 0x54, 0xD7, 0x89, 0x6B, 0x35
	};
	char ret = 0;
	for (int i=0; i != size; ++i)
		ret = tbl[ret ^ data[i]];
	return ret;
}

const char *Controller::reverseCopyKey(char *out, const char *key)
{
	out[0] = key[5];
	out[1] = key[4];
	out[2] = key[3];
	out[3] = key[2];
	out[4] = key[1];
	out[5] = key[0];
	return out;
}

void Controller::pollOn(bool isAuto, bool isReliable)
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	_polling = true;
	channel._timer.active(_deadTimer, false);
	channel._timer.active(_aliveTimer, false);
	_recoverState = _recoverNone;
	_autonomic = isAuto;
}

void Controller::pollOff(bool forceAuto)
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	_polling = false;
	channel._timer.active(_deadTimer, false);
	channel._timer.active(_aliveTimer, false);
	_recoverState = _recoverNone;
	if (forceAuto && channel._ready)
	{
		_readEvt2(true);
		_setState(_stateStateless);
	} else
		channel._timer.active(_stateTimer, true);
}

char Controller::_getProgId() const
{
	if (!_progId)
	{
		const char cmd[] = {0x16, 0x20, addr};
		channel._write(cmd, sizeof(cmd));
		const int r = channel._read(&_progId, 1);
		_chkInput(r);
	}
	return _progId;
}

short Controller::_getProgVer() const
{
	if (_progVer == 0 && _progVerCnt < 3)
	{
		char buf[5];
		try
		{
			if (_4c(0x10, buf, sizeof(buf), true) != 2)
				_throwUnexpectedResponse();
			_progVer = unpackShort(&buf[2]);
		}
		catch (...)
		{
			if (_getProgId() == 0x9C)
				throw;
			++_progVerCnt;
		}
	}
	return _progVer;
}

int Controller::_getSerNum() const
{
	char buf[7];
	if (_4c(0x20, buf, sizeof(buf), true) != 4)
		_throwUnexpectedResponse();
	return unpackInt(&buf[2]);
}

int Controller::_4c(const char op, char *buf, int size, bool chkOp) const
{
	buf[0] = 0x16;
	buf[1] = 0x6C;
	buf[2] = addr;
	buf[3] = op;
	channel._write(buf, 4);
	return _readPack(buf, size, chkOp);
}

void Controller::_setMemMode(_MemType mem, char bank, _MemOp op, char numOps) const
{
	chkRange(0, 15, numOps, "Memory operation count");

	char buf[6];
	buf[0] = 0x16;
	buf[1] = 0xA4;
	buf[2] = addr;

	char x = 0;
	switch (mem) {
	case mtRAM:
		x = 1;
		break;
	case mtEEPROM:
		x = 3;
		break;
	default:
		TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER("Unknown memmory type");
	}
	x <<= 4;

	switch (op) {
	case moOff:
		break;
	case moRead:
		break;
	case moWrite:
		x |= 128;
		break;
	default:
		TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER("Unknown memory operation");
	}
	buf[3] = (numOps & 15) | x;
	buf[4] = bank;
	buf[5] = cs8(&buf[3], 2);

	//printf("mem_mode> size: %d \n", sizeof(buf));
	//for (int iii = 0; iii < sizeof(buf); ++iii)
	//{
	//	int b = (int)(unsigned char)buf[iii];
	//	printf("%X ", b);
	//}
	//printf("\n\n");

	channel._write(buf, sizeof(buf));
	int packLen = _readPack(buf, sizeof(buf), true);
	if (packLen != 3)
		_throwUnexpectedResponse();
	if (buf[2] & 8)
		_throwSetMem("writing access denied");
	if (buf[2] & 4)
		_throwSetMem("invalid bank");
	if (buf[2] & 2)
		_throwSetMem("unsupported address space");
	if (buf[2] & 1)
		_throwSetMem("unknown address space");

	//printf("mem_mode< size: %d \n", sizeof(buf));
	//for (int iii = 0; iii < (packLen+3); ++iii)
	//{
	//	int b = (int)(unsigned char)buf[iii];
	//	printf("%X ", b);
	//}
	//printf("\n\n");
}

void Controller::_readMem(char bank, int off, char *buf, short size) const
{
	const char cmd[] = {
		0x16,
		0xB0 | bank,
		addr,
		off,
		off >> 8,
		size - 6};
	channel._write(cmd, sizeof(cmd));
	int read = 0;
	while (true) {
		const int r = channel._read(&buf[read], size - read);
		_chkInput(r);
		read += r;
		if (read > 1 && buf[0] == 0x16) {
			switch (buf[1]) {
			case 4:
				throw Error(*this, "Error", "Can't read memory");
			case 0x18:
				_throwBusy();
			}
			if (read > 4) {
				if ( !(buf[1] == 0x80/*RAM*/ || buf[1] == 0x83/*EEPROM*/) || buf[2] != cmd[3] || buf[3] != cmd[4] || buf[4] != cmd[5] )
					_throwUnexpectedResponse();
				if (read == size) {
					if (buf[size - 1] != cs8(&buf[5], size - 6))
						_throwCheckSum();
					break;
				}
			}
		}
	}
	//static int rdccc = 0;
	//printf("rd> no: %d; size: %d \n", rdccc++, size);
	//for (int iii = 0; iii < size; ++iii)
	//{
	//	int b = (int)(unsigned char)buf[iii];
	//	printf("%X ", b);
	//}
	//printf("\n\n");
}

short Controller::_readMem(int off, char *buf, short size) const
{
	size -= 6;
	chkRange(1, 256, size, "Size");
	buf[0] = 0x16;
	buf[1] = 0xA0;
	buf[2] = addr;
	buf[3] = off;
	buf[4] = off >> 8;
	buf[5] = (size == 256)? 0: size;
	channel._write(buf, 6);

	size += 6;
	int read = 0;
	short len = 0;
	while (true) {
		const int r = channel._read(&buf[read], size - read);
		_chkInput(r);
		read += r;
		if (read >= 5) {
			if (buf[0] != 0x16 || buf[1] != 0x80 || buf[2] != static_cast<char>(off) || buf[3] != static_cast<char>(off >> 8))
				_throwUnexpectedResponse();
			len = buf[4];
			if ((read - 6) == len) {
				if (buf[size - 1] != cs8(&buf[5], len))
					_throwCheckSum();
				break;
			}
		}
		if (size == read)
			_throwUnexpectedResponse();
	}
	return len;
}

void Controller::_writeMem(char bank, int off, char *buf, char size) const
{
	buf[0] = 0x16;
	buf[1] = 0xF0 | bank;
	buf[2] = addr;
	buf[3] = off;
	buf[4] = off >> 8;
	buf[5] = size;
	buf[size + 6] = cs8(&buf[6], size);
	size += 7;

	//static int wrccc = 0;
	//printf("wr> no: %d; size: %d \n", wrccc++, size);
	//for (int iii = 0; iii < size; ++iii)
	//{
	//	int b = (int)(unsigned char)buf[iii];
	//	printf("%X ", b);
	//}
	//printf("\n\n");

	channel._write(buf, size);
	int read = 0;
	do {
		const int r = channel._read(&buf[read], size - read);
		_chkInput(r);
		read += r;
		if (read > 1) {
			if (0x16 != buf[0])
				_throwUnexpectedResponse();
			switch (buf[1]) {
			case 4:
				_throwWriteMem("invalid mode");
			case 6:
				break;
			case 0x15:
				_throwWriteMem("Invalid checksum");
			case 0x18:
				_throwWriteMem("busy");
			case 0x1B:
				_throwWriteMem("invalid mode or offset");
			default:
				_throwUnexpectedResponse();
			}
		}
	} while (read < 2);

	//printf("write_mem< size: %d \n", sizeof(buf));
	//for (int iii = 0; iii < read; ++iii)
	//{
	//	int b = (int)(unsigned char)buf[iii];
	//	printf("%X ", b);
	//}
	//printf("\n\n");
}

void Controller::_writeMem(int off , char *buf, char size) const
{
	buf[0] = 0x16;
	buf[1] = 0xE0;
	buf[2] = addr;
	buf[3] = off;
	buf[4] = off >> 8;
	buf[5] = size;
	buf[size + 6] = cs8(&buf[6], size);
	size += 7;
	channel._write(buf, size);

	/*std::string s = "> " + hexlify(buf, buf + size);
	log(s);*/

	int read = 0;
	do {
		const int r = channel._read(&buf[read], size - read);
		_chkInput(r);
		read += r;
	} while (read < 2);
	if (!(buf[0] == 0x16 && buf[1] == 0x06))
		_throwUnexpectedResponse();
}

char Controller::progId() const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	return _getProgId();
}

short Controller::progVer() const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0 == _getProgVer())
		_throwFeature();
	return _progVer;
}

bool Controller::isAlarm() const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	return _getIsAlarm();
}

int Controller::serNum() const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0 == _getProgVer())
		_throwFeature();
	const int ret = _getSerNum();
	return ret;
}

void Controller::_eventsInfo(int& capacity, int& count) const
{
	char buf[10];
	const int respLen = _4c(1, buf, sizeof(buf), true);
	if (!((2 == buf[2] && 5 == respLen) || (3 == buf[2] && 7 == respLen)))
		_throwUnexpectedResponse();
	capacity = _varVal(&buf[2], 1);
	count = _varVal(&buf[2], 1 + buf[2]);
}

void Controller::_eventsInfo201(int& capacity, int& count) const
{
	capacity = _readRPD(0x53) + _readRPD(0x54) * 256;
	count = _readRPD(0x34) + _readRPD(0x35) * 256;
}

void Controller::eventsInfo(int& capacity, int& count) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0 == _getProgVer())
		_eventsInfo201(capacity, count);
	else
		_eventsInfo(capacity, count);
}

void Controller::_keysInfo(int& capacity, int& count) const
{
	_KBInfo kbi(*this);
	capacity = kbi.capacity();
	count = kbi.count();
}

void Controller::_keysInfo201(int& capacity, int& count) const
{
	const int offBeg = _readRPD(0x4E) * 256;
	const short pageCount = _readRPD(0x4F);
	capacity = pageCount * 31;
	char buf[6 + 8];
	count = 0;
	for (short pageIdx = 0; pageIdx != pageCount; ++pageIdx) {
		_readMem(offBeg + (pageIdx * 256), buf, sizeof(buf));
		if (isDallas(&buf[5]))
			count += buf[12];
		else
			break;
	}
}

void Controller::keysInfo(int& capacity, int& count) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0 == _getProgVer())
		_keysInfo201(capacity, count);
	else
		_keysInfo(capacity, count);
}

void Controller::portsInfo(char *ports) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (_getProgVer() < 11)
		_throwFeature();

	char buf[4];
	const int respLen = _4c(0x40, buf, sizeof(buf), false);
	if (1 != respLen)
		_throwUnexpectedResponse();

	expandMask(ports, buf[2]);
}

void Controller::relayOn(int port, int interval, bool suppressDoorEvent) const
{
	chkRange(1, 8, port, "Port");
	chkRange(0, 31, interval, "Interval");
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (_getProgVer() >= 33) {
		_Command cmd(*this, 0x11, 3, 2);
		cmd[0] = addr;
		//cmd[1] = suppressDoorEvent? (port - 1) | 128 : (port - 1);
		cmd[1] = suppressDoorEvent? (port - 1) | 192 : (port - 1) | 64;
		cmd[2] = interval * 4;
		cmd.exec();
	} else {
		const char cmd[] = {0x16, suppressDoorEvent? 0x6A: 0x69, addr, (interval << 3) | (port - 1)};
		channel._write(cmd, sizeof(cmd));
		channel._write(cmd, sizeof(cmd)); // and one more time
	}
}

void Controller::relayOff(int port) const
{
	chkRange(1, 8, port, "Port");
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (_getProgVer() >= 33)
	{
		_Command cmd(*this, 0x10, 2, 1);
		cmd[0] = addr;
		cmd[1] = 1 << (port - 1);
		cmd.exec();
	} else {
		const char cmd[] = {0x16, 0x6B, addr, 1 << (port - 1)};
		channel._write(cmd, sizeof(cmd));
		channel._write(cmd, sizeof(cmd)); // and one more time
	}
}

void Controller::timer(int interval) const
{
	chkRange(0, 255, interval, "Interval");
	Channel::ExtCmdScopedLock scopedLock(channel);
	const char cmd[] = {0x16, 0x6D, addr, interval};
	channel._write(cmd, sizeof(cmd));
}

void Controller::generateTimerEvents(int count) const
{
	chkRange(1, 0xFFFF, count, "Count");
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (_getProgVer() < 270)//v1.14
		_throwFeature();
	char buf[6];
	buf[0] = 0x16;
	buf[1] = 0xAF;
	buf[2] = addr;
	packShort(count, &buf[3]);
	buf[sizeof(buf) - 1] = cs8(buf, sizeof(buf) - 1);
	channel._write(buf, sizeof(buf));
	const int r = channel._read(buf, 1);
	_chkInput(r);
}

void Controller::_writeKey201(const char *key) const
{
	const int offBeg = _readRPD(0x4E) * 256;
	const short pageCount = _readRPD(0x4F);
	bool noSpace = true;
	char buf[6 + 16 + 1];
	for (short pageIdx = 0; pageIdx != pageCount; ++pageIdx)
	{
		_readMem(offBeg + (pageIdx * 256), buf, sizeof(buf) - 1);
		if (isDallas(&buf[5]))
		{
			const char numKeys = buf[12];
			if (numKeys < 31) {
				noSpace = false;
				packKey(&buf[6], key);
				_writeMem(offBeg + (pageIdx * 256) + (numKeys * 8) + 8, buf, 8);
				buf[6] = numKeys + 1;
				_writeMem(offBeg + (pageIdx * 256) + 7, buf, 1);
				break;
			}
		} else
		{
			noSpace = false;
			memcpy(&buf[6], "DALLAS", 6);
			buf[12] = 0;
			buf[13] = 1;
			packKey(&buf[14], key);
			_writeMem(offBeg + (pageIdx * 256), buf, 16);
			break;
		}
	}
	if (noSpace)
		throw Error(*this, "Error", "No space");
}

void Controller::_writeKey(const char *key) const
{
	_eraseKey(key);
	_Command cmd(*this, 1, 8, 1);
	packKey(&cmd[0], key);
	cmd.exec();
}

void Controller::writeKey(const char *key) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0 == _getProgVer())
		_writeKey201(key);
	else
		_writeKey(key);
}

void Controller::_eraseKey(const char *key) const
{
	_Command cmd(*this, 0, 6, 1);
	reverseCopyKey(&cmd[0], key);
	cmd.exec();
}

void Controller::eraseKey(const char *key) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0 == _getProgVer())
		_throwFeature();
	_eraseKey(key);
}

void Controller::_eraseAllKeys() const
{
	_Command cmd(*this, 0x81, 6, 1);
	cmd[0] = 0x81;
	cmd[1] = addr;
	packInt(_getSerNum(), &cmd[2]);
	cmd.exec();
}

void Controller::_eraseAllKeys201() const
{
	const int offBeg = _readRPD(0x4E) * 256;
	const short pageCount = _readRPD(0x4F);
	char buf[6 + 8 + 1];
	memset(&buf[6], 0, 8);
	for (short pageIdx = 0; pageIdx != pageCount; ++pageIdx) {
		_writeMem(offBeg + (pageIdx * 256), buf, 8);
	}
}

void Controller::eraseAllKeys() const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0 == _getProgVer())
		_eraseAllKeys201();
	else
		_eraseAllKeys();
}

void Controller::eraseAllEvents() const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0 == _getProgVer())
		_throwFeature();
	_Command cmd(*this, 0x80, 6, 1);
	cmd[0] = 0x80;
	cmd[1] = addr;
	packInt(_getSerNum(), &cmd[2]);
	cmd.exec();
}

bool Controller::keyExist(const char *key, char& ports, char& persCat, bool& suppressDoorEvent, bool& openEvenComplex, bool& isSilent) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0 == _getProgVer())
		_throwFeature();
	_Command cmd(*this, 2, 6, 8);
	reverseCopyKey(&cmd[0], key);
	const int len = cmd.exec();
	const bool ret = (len == 8 && cmd[0] == key[5] && cmd[1] == key[4] && cmd[2] == key[3] && cmd[3] == key[2] && cmd[4] == key[1] && cmd[5] == key[0]);
	if (ret)
		decodeKeyAttr(&cmd[6], ports, persCat, suppressDoorEvent, openEvenComplex, isSilent);
	return ret;
}

void Controller::readKeypad(char *out) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0 == _getProgVer())
		_throwFeature();
	_Command cmd(*this, 0x21, 1, 10);
	cmd[0] = addr;
	cmd.exec();
	memset(out, 0, 16);
	if (0x43 == cmd[0])
	{
		for (int i=0; i != 8; ++i)
		{
			if (cmd[1] & (1 << i))
			{
				char *p = &out[i * 2];
				const char x = cmd[2 + i];
				*p = x >> 4;
				*(++p) = x & 15;
			}
		}
	}
}

void Controller::writeKeypad(const char *data) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0 == _getProgVer())
		_throwFeature();
	_Command cmd(*this, 0x20, 8, 10);
	for (int i=0; i != 8; ++i)
	{
		const char count = data[i * 2];
		chkRange(0, 12, count, "Key count");
		const char timeout = data[i * 2 + 1];
		chkRange(0, 15, timeout, "Timeout");
		cmd[i] = (count << 4) | timeout;
	}
	cmd.exec();
}

int Controller::_readAllKeys201(vector<char>& keys) const
{
	const int offBeg = _readRPD(0x4E) * 256;
	const short pageCount = _readRPD(0x4F);
	char buf[6 + 8];
	int count = 0;
	keys.resize(0);
	for (short pageIdx = 0; pageIdx != pageCount; ++pageIdx)
	{
		short numKeys;
		for (short keyIdx = 0; keyIdx != 32; ++keyIdx)
		{
			_readMem(offBeg + (pageIdx * 256) + (keyIdx * 8), buf, sizeof(buf));
			if (keyIdx == 0)
			{
				if (isDallas(&buf[5]))
					numKeys = buf[12];
				else
					return count;
			} else
			{
				keys.resize(keys.size() + 18);
				unpackKey(&keys[keys.size() - 18], &buf[5]);
				if (keyIdx == numKeys)
					break;
			}
		}
		 count += numKeys;
	}
	return count;
}

#define	MEM_BANK(off)	(off / 65536)

int Controller::_readAllKeys(vector<char>& keys) const
{
	_KBInfo kbi(*this);
	if (0 == kbi.count())
		return 0;

	_RAMInfo rami(*this);

	keys.resize(0);
	keys.reserve(kbi.count() * 18);

	const short keysPerBuffer = rami.obufSizeBytes() / 8;
	const short buffersPerBlock = rami.blockSizeBytes() / rami.obufSizeBytes();
	scoped_array<char> buf(new char[rami.obufSizeBytes() + 6]);
	int count = 0;

	int off = rami.KBfirstBlock() * rami.blockSizeBytes();
	const int offEnd = rami.blockCount() * rami.blockSizeBytes() + off;

	const char bank = MEM_BANK(off);
	//TODO: switch bank
	_setMemMode(mtRAM, bank, moRead);

	while (off < offEnd)
	{
		short numKeys;
		short done = 0;
		for (short i = 0; i < buffersPerBlock; ++i)
		{
			short start;
			_readMem(bank, off, &buf[0], rami.obufSizeBytes() + 6);
			if (0 == i)
			{
				if (isDallas(&buf[5]))
					numKeys = buf[12];
				else
					numKeys = 0;
				if (0 == numKeys) {
					off += rami.blockSizeBytes();
					break;
				}
				start = 1;
			} else
				start = 0;
			for (short j = start; j < keysPerBuffer; ++j)
			{
				const char * const curKey = &buf[5 + j * 8];
				if (isKey(curKey))
				{
					keys.resize(keys.size() + 18);
					unpackKey(&keys[keys.size() - 18], curKey);
					++count;
					if (count == kbi.count())
						return count;
					++done;
					if (done == numKeys)
						break;
				}
			}
			off += rami.obufSizeBytes();
		}
	}
	return count;
}

int Controller::readAllKeys(vector<char>& keys) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0 == _getProgVer())
		return _readAllKeys201(keys);
	else
		return _readAllKeys(keys);
}


void Controller::_writeAllKeys(const char *keys, int count) const
{
	/* 2.7 times slower than raw mem method.
	_KBInfo kbi(*this);
	chkRange(1, kbi.capacity(), count, "Key count");

	_eraseAllKeys();

	_Command cmd(*this, 3, 8, 1);
	for (int i=0; i < count; ++i)
	{
		packKey(&cmd[0], &keys[i * 18]);
		cmd.exec();
	}
	*/


	/* raw mem */
	_KBInfo kbi(*this);

	chkRange(1, kbi.capacity(), count, "Key count");

	_RAMInfo rami(*this);
	const short keysPerBuffer = rami.ibufSizeBytes() / 8;
	const short buffersPerBlock = rami.blockSizeBytes() / rami.obufSizeBytes();
	const short keysPerBlock = keysPerBuffer * buffersPerBlock - 1;
	short x;
	x = count / keysPerBlock;
	if (count % keysPerBlock)
		++x;
	const short blocks = x;
	scoped_array<char> buf(new char[rami.ibufSizeBytes() + 6 + 1]);

	_eraseAllKeys();

	int off = rami.KBfirstBlock() * rami.blockSizeBytes();
	_MemGuard mg(*this, mtRAM, MEM_BANK(off));
	int done = 0;
	int rest = count;
	for (short block = 0; block != blocks; ++block)
	{
		for (short buffer = 0; buffer != buffersPerBlock; ++buffer)
		{
			if (0 == buffer)
			{
				memcpy(&buf[6], "DALLAS", 6);
				buf[6 + 6] = 0;
				if (rest > keysPerBlock)
					buf[6 + 7] = static_cast<char>(keysPerBlock);
				else
					buf[6 + 7] = rest;
			}
			for (short key = 0; key != keysPerBuffer; ++key)
			{
				if (buffer != 0 || key != 0) {
					if (rest)
					{
						packKey(&buf[6 + key * 8], &keys[done * 18]);
						++done;
						--rest;
					} else
						memset(&buf[6 + key * 8], 0xFF, 8);
				}
			}
			mg.switchBankIf(MEM_BANK(off));
			_writeMem(mg.bank(), off, &buf[0], static_cast<char>(rami.ibufSizeBytes()));
			off += rami.ibufSizeBytes();
		}
		if (_polling && !_autonomic)
			_readEvt2(false);
	}
}

void Controller::_writeAllKeys201(const char *keys, int count) const
{
	const int offBeg = _readRPD(0x4E) * 256;
	const short pageCount = _readRPD(0x4F);
	chkRange(1, pageCount * 256, count, "Key count");
	int done = 0;
	char buf[6 + 248 + 1];
	char c = 0;
	for (short pageIdx = 0; pageIdx != pageCount; ++pageIdx) {
		const char numKeys = ((count - done) > 31)? 31: (count - done);
		if (count != done) {
			for (int keyIdx = 1; keyIdx != 32 && count != done; ++keyIdx, ++done)
			{
				packKey(&buf[6 + (keyIdx - 1) * 8], &keys[done * 18]);
			}
			_writeMem(offBeg + (pageIdx * 256) + 8, buf, numKeys * 8);
			memcpy(&buf[6], "DALLAS", 6);
			buf[6 + 6] = 0;
			buf[6 + 7] = numKeys;
			_writeMem(offBeg + (pageIdx * 256), buf, 8);
		} else
		{
			memset(&buf[6], 0, 8);
			_writeMem(offBeg + (pageIdx * 256), buf, 8);
		}

		if (_polling && !_autonomic && ++c / 4)
		{
			c = 0;
			_readEvt2(false);
		}
	}
}

void Controller::writeAllKeys(const char *keys, int count) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0 == _getProgVer())
		_writeAllKeys201(keys, count);
	else
		_writeAllKeys(keys, count);
}

void Controller::writeAllKeysAsync(const char *keys, int count) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	channel._writeAllKeysTh.reset(new Thread(new WriteAllKeysThImpl(*this, keys, count)));
}

int Controller::readTimetable(vector<char>& timetable) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0x9C != _getProgId() || _getProgVer() < 5)
		_throwFeature();

	_TTInfo tti(*this);
	if (!tti.valid())
		return 0;
	if (0 == tti.blockCount())
		return 0;

	_RAMInfo rami(*this);

	timetable.resize(0);

	const short buffersPerBlock = rami.blockSizeBytes() / rami.obufSizeBytes();
	scoped_array<char> buf(new char[rami.obufSizeBytes() + 6]);
	int off;
	off = tti.firstBlock() * rami.blockSizeBytes();

	scoped_array<char> ttBuf(new char[rami.blockSizeBytes() * tti.blockCount()]);
	_TTImage tt(&ttBuf[0]);
	int ttSize = 0;
	const int offEnd = rami.blockCount() * rami.blockSizeBytes() + off;

	_setMemMode(mtRAM, 0, moRead);

	for (char blockIdx = 0; off < offEnd && blockIdx < tti.blockCount(); ++blockIdx)
	{
		for (short i = 0; i < buffersPerBlock; ++i)
		{
			_readMem(0, off, &buf[0], rami.obufSizeBytes() + 6);
			if (0 == blockIdx && 0 == i)
			{
				if (!('T' == buf[33] && 'I' == buf[34] && 'M' == buf[35] && 'E' == buf[36]))
					return 0;
			}
			memcpy(&ttBuf[ttSize], &buf[5], rami.obufSizeBytes());
			off += rami.obufSizeBytes();
			ttSize += rami.obufSizeBytes();
		}

		if (_polling && !_autonomic)
			_readEvt2(false);
	}

	for (char i=0; i < tt.TPiP_itemCount(); ++i)
	{
		_TTImage::TPiP_Item item(tt.TPiP_item(i));
		timetable.push_back(item.year());
		timetable.push_back(item.month());
		timetable.push_back(item.day());
		timetable.push_back(item.dayType());
	}

	const int ret = static_cast<int>(timetable.size());

	const char BPD_size = tti.intervalCount() / 8;
	off = tt.KDS_offset();
	for (short dayTypeIdx = 0; dayTypeIdx < tti.dayTypeCount(); ++dayTypeIdx)
	{
		for (short persCatIdx = 0; persCatIdx < tti.persCatCount(); ++persCatIdx)
		{
			int x = tt.KDS_item(off);
			short intervalIdx = dayTypeIdx * tti.intervalCount();
			for (short i = 0; i < tti.intervalCount(); ++i)
			{
				if (x & (1 << i))
				{
					_TTImage::DRS_Item from(tt.DRS_item(intervalIdx));
					_TTImage::DRS_Item to(tt.DRS_item(intervalIdx + 1));
					timetable.push_back(dayTypeIdx? dayTypeIdx: 8);
					timetable.push_back(from.hour());
					timetable.push_back(from.minute());
					timetable.push_back(to.hour());
					timetable.push_back(to.minute());
					timetable.push_back(persCatIdx + 1);
				}
				++intervalIdx;
			}
			off += BPD_size;
		}
	}

	return ret;
}

void Controller::readClock(char *timestamp) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);

	if (0 == _getProgVer())
		_throwFeature();

	char buf[10];
	buf[0] = 0x16;
	buf[1] = 0x6E;
	buf[2] = addr;
	buf[3] = 0x7F;
	channel._write(buf, 4);
	if (_readPack(buf, sizeof(buf), true) != 7)
		_throwUnexpectedResponse();
	if (buf[2] & 0x80)
		throw Error(*this, "Error", "Erroneous clock");
	timestamp[5] = bcd2bin(buf[2]);
	timestamp[4] = bcd2bin(buf[3]);
	timestamp[3] = bcd2bin(buf[4]);
	timestamp[2] = bcd2bin(buf[6]);
	timestamp[1] = bcd2bin(buf[7]);
	timestamp[0] = bcd2bin(buf[8]);
}

void Controller::writeClockDate(const char *date) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0 == _getProgVer())
		_throwFeature();
	chkRange(1, 12, date[1], "Month");
	chkRange(1, 31, date[2], "Day");
	const char cmd[] = {0x16, 0xA9, addr, bin2bcd(date[2]), bin2bcd(date[1]), bin2bcd(date[0])};
	channel._write(cmd, sizeof(cmd));
}

void Controller::writeClockTime(const char *time) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	chkRange(0, 23, time[0], "Hour");
	chkRange(0, 59, time[1], "Minute");
	chkRange(0, 59, time[2], "Second");
	const char cmd[] = {0x16, 0xA8, addr, bin2bcd(time[2]), bin2bcd(time[1]), bin2bcd(time[0])};
	channel._write(cmd, sizeof(cmd));
}

void Controller::eraseTimetable() const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0x9C != _getProgId())
		_throwFeature();

	_RAMInfo rami(*this);

	_setMemMode(mtRAM, 0, moWrite, 1);
	char buf[6 + 4 + 1];
	buf[6] = 'X';
	buf[7] = 'X';
	buf[8] = 'X';
	buf[9] = 'X';
	_writeMem(0, rami.TTfirstBlock() * rami.blockSizeBytes() + 28, buf, 4);
}
