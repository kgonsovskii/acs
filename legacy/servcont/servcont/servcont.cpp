#include "pch.h"
#include <tss/servcont.hpp>

#ifdef	LINUX
#include <netinet/tcp.h>
#endif
#include "tss/servcont.hpp"

#include <cstdio>
#include <set>
#include <map>
#include <algorithm>
#include <iomanip>
#include <tss/ip.hpp>

namespace std
{
	class exception;
}

using namespace std;
using namespace boost;

namespace tss { namespace servcont {

	/*static std::string hexlify(const char* first, const char* last)
	{
		std::ostringstream os;
		os.unsetf(std::ios::dec);
		os.setf(std::ios::hex);
		os.setf(std::ios::uppercase);
		while (first != last)
		{
			os << std::setfill('0') << std::setw(2) << (int)(unsigned char)*first;
			++first;
		}
		return os.str();
	}*/

/*static void dump(const char *p, int n)
{
	printf("size: %d-->\n", n);
	for (int i = 0; i < n; ++i)
	{
		printf("%.2X ", (int)(unsigned char)p[i]);
	}
	printf(\n"<--\n\n");
}*/

static void chkRange(int min, int max, int val, const char *name)
{
	if (val < min || val > max)
		TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER(str(format("%s out of range %d..%d.") %name %min %max));
}

static bool isKey(const char *s) throw()
{
	return !(255 == s[0] && 255 == s[1] && 255 == s[2] && 255 == s[3] && 255 == s[4] && 255 == s[5]);
}

static bool isDallas(const char *s) throw()
{
	return ('D' == s[0] && 'A' == s[1] && 'L' == s[2] && 'L' == s[3] && 'A' == s[4] && 'S' == s[5]);
}

static bool isAlarm(const char *s) throw()
{
	return ('A' == s[0] && 'L' == s[1] && 'A' == s[2] && 'R' == s[3] && 'M' == s[4]);
}

boost::uint64_t keyToInt(const char* key)
{
	boost::uint64_t v = key[0] << 40 | key[1] << 32 | key[2] << 24 | key[3] << 16 | key[4] << 8 | key[5];
	return v;
}

static std::string keyToStr(const char* key)
{
	std::string s;
	char buf[4];
	for (int i = 0; i < 6; ++i)
	{
		sprintf_s(buf, sizeof(buf), "%.2X", key[i]);
		s += buf;
	}
	return s;
}

static void decodeKeyAttr(const char *key, char& ports, char& persCat, bool& suppressDoorEvent, bool& openEvenComplex, bool& isSilent)
{
	ports = key[0];
	persCat = (key[1] & 15) + 1;
	suppressDoorEvent = ((key[1] & (1 << 5)) != 0);
	openEvenComplex = ((key[1] & (1 << 6)) != 0);
	isSilent = ((key[1] & (1 << 7)) != 0);
}

static void unpackKey(char *out, const char *key)
{
	Controller::reverseCopyKey(out, key);
	char ports;
	bool suppressDoorEvent, openEvenComplex, isSilent;	
	decodeKeyAttr(key + 6, ports, out[14], suppressDoorEvent, openEvenComplex, isSilent);
	expandMask(out + 6, ports);
	out[15] = suppressDoorEvent;
	out[16] = openEvenComplex;
	out[17] = isSilent;
}

static char chipCheckCount(char flags)
{
	switch ((flags >> 3) & 7)
	{
	case 0: return 3;
	case 1: return 8;
	case 2: return 4;
	case 3: return 12;
	case 4: return 5;
	case 5: return 16;
	case 6: return 6;
	case 7: return 20;
	default: return 0;
	}
}

static void unpackChip(char *out, const char *chip)
{
	Controller::reverseCopyKey(out, chip);
	out[6] = !(chip[6] & (1 << 7));
	out[7] = chip[6] & (1 << 6);
	out[8] = chipCheckCount(chip[6]);
	out[9] = (chip[6] & 7) + 1;
	//out[10] = chip[7] & 63; old
}

//static void packChip(char *out, const char *chip)
//{
//	Controller::reverseCopyKey(out, chip);
//	out += 6;
//	chip += 6;
//	char checkCount = chip[2];
//	switch (checkCount) {
//		case 3:
//			checkCount = 0;
//			break;
//		case 4:
//			checkCount = 2;
//			break;
//		case 5:
//			checkCount = 4;
//			break;
//		case 6:
//			//checkCount = 6;
//			break;
//		case 8:
//			checkCount = 1;
//			break;
//		case 12:
//			checkCount = 3;
//			break;
//		case 16:
//			checkCount = 5;
//			break;
//		case 20:
//			checkCount = 7;
//			break;
//		default:
//			TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER("Check count out of range.");
//	}
//
//	char port = chip[3];
//	chkRange(1, 8, port, "Port");
//	--port;
//
//	*out = ((!*chip) << 7) | //active
//		(chip[1] << 6) | //opneEvenComplex
//		(checkCount << 3) |
//		port;
//	/*++out;
//
//	const char bitCount = chip[4];
//	//old doc chkRange(9, 56, bitCount, "Bit count");
//	chkRange(10, 57, bitCount, "Bit count"); // new doc
//	*out = bitCount;*/
//}

static void packKey(char *out, const char *key)
{
	Controller::reverseCopyKey(out, key);
	char ports = 0;
	for (short i = 0; i != 8; ++i)
		ports |= (key[i + 6] != 0) << i;
	out[6] = ports;
	char persCat = key[14];
	chkRange(1, 16, persCat, "Personnel category");
	--persCat;
	const char suppressDoorEvent = key[15] != 0;
	const char openEvenComplex = key[16] != 0;
	const char isSilent = key[17] != 0;
	out[7] = persCat | (suppressDoorEvent << 5) | (openEvenComplex << 6) | (isSilent << 7);
}


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

struct TTSpecialDay
{
	explicit TTSpecialDay(const char *data): year(data[0]), month(data[1]), day(data[2]), type((8 == data[3])? 0: data[3])
	{
		chkRange(1, 12, month, "Month");
		chkRange(1, 31, day, "Day");
		chkRange(1, 8, data[3], "DayType");
	}
	const char year;
	const char month;
	const char day;
	const char type;
	operator unsigned int () const throw() { return ((year << 24) | month << 16 | day << 8 | type); }
};

static void makeSD(char *image, const char * const buf, const char count)
{
	set<TTSpecialDay> items;
	for (char i = 0; count != i; ++i)
	{
		if (!items.insert(TTSpecialDay(&buf[4 * i])).second)
			TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER("Special day duplicate");
	}
	image[0] = count;

	short i = 0;
	for (set<TTSpecialDay>::const_iterator it = items.begin(); items.end() != it; ++it)
	{
		const int off = 4 + (4 * i);
		++i;
		image[off]     = bin2bcd(it->day);
		image[off + 1] = bin2bcd(it->month);
		image[off + 2] = bin2bcd(it->year);
		image[off + 3] = bin2bcd(it->type);
	}
}

struct TTItem
{
	typedef map<unsigned short, unsigned short> Intervals;
	Intervals intervals;
};

static void makeTT(char *image, const char * const buf, const int count)
{
	typedef map<char, TTItem> Items;
	Items items;

	for (int itemIdx = 0; count != itemIdx; ++itemIdx)
	{
		const int itemOff = 6 * itemIdx;
		chkRange(1, 8, buf[itemOff], "DayType");
		chkRange(0, 24, buf[itemOff + 1], "Hour");
		chkRange(0, 59, buf[itemOff + 2], "Minute");
		chkRange(0, 24, buf[itemOff + 3], "Hour");
		chkRange(0, 59, buf[itemOff + 4], "Minute");
		chkRange(1, 16, buf[itemOff + 5], "Personnel category");
		const char dayType = (8 == buf[itemOff])? 0: buf[itemOff];
		const unsigned short from = buf[itemOff + 1] << 8 | buf[itemOff + 2];
		const unsigned short to   = buf[itemOff + 3] << 8 | buf[itemOff + 4];
		if (from >= to)
			TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER("Interval's begin >= end.");
		Items::iterator it = items.find(dayType);
		if (items.end() == it)
		{
			TTItem item;
			item.intervals.insert(make_pair(from, 0));
			item.intervals.insert(make_pair(to, 0));
			items.insert(pair<char, TTItem>(dayType, item));
		} else
		{
			it->second.intervals.insert(make_pair(from, 0));
			it->second.intervals.insert(make_pair(to, 0));
		}
	}

	for (int itemIdx = 0; count != itemIdx; ++itemIdx)
	{
		const int itemOff = 6 * itemIdx;
		const char dayType = (8 == buf[itemOff])? 0: buf[itemOff];
		Items::iterator dayIt = items.find(dayType);
		if (items.end() != dayIt)
		{
			const unsigned short from = buf[itemOff + 1] << 8 | buf[itemOff + 2];
			TTItem::Intervals::iterator fromIt = dayIt->second.intervals.find(from);
			if (dayIt->second.intervals.end() != fromIt) {
				const unsigned short to = buf[itemOff + 3] << 8 | buf[itemOff + 4];
				const char persCat = buf[itemOff + 5] - 1;
				fromIt->second |= 1 << persCat;
				TTItem::Intervals::iterator toIt = dayIt->second.intervals.find(to);
				--toIt;
				while (toIt != fromIt)
				{
					toIt->second |= 1 << persCat;
					--toIt;
				}
			}
		}
	}

	for (char dayTypeIdx = 0; 8 != dayTypeIdx; ++dayTypeIdx)
	{
		int drsOff = 320 + (64 * dayTypeIdx);
		const int kdsOff = 832 + (64 * dayTypeIdx);
		Items::iterator itemIt = items.find(dayTypeIdx);
		if (items.end() != itemIt)
		{
			itemIt->second.intervals.insert(make_pair(0, 0));
			itemIt->second.intervals.insert(make_pair(24 << 8, 0));
			if (itemIt->second.intervals.size() > 32)
				TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER("Too many intervals");
			vector<unsigned int> kdsMasks(16, 0);
			TTItem::Intervals::const_iterator intervalIt = itemIt->second.intervals.begin();
			for (short intervalIdx = 0; 32 != intervalIdx; ++intervalIdx)
			{
				if (itemIt->second.intervals.end() != intervalIt)
				{
					image[drsOff] = bin2bcd(intervalIt->first & 0xFF);
					image[drsOff + 1] = bin2bcd(intervalIt->first >> 8);
					for (short persCatIdx=0; persCatIdx != 16; ++persCatIdx)
					{
						if (intervalIt->second & (1 << persCatIdx))
							kdsMasks[persCatIdx] |= 1 << intervalIdx;
					}
					drsOff += 2;
					++intervalIt;
				}
			}
			for (short persCatIdx=0; persCatIdx != 16; ++persCatIdx)
				memcpy(&image[kdsOff + (4 * persCatIdx)], &kdsMasks[persCatIdx], 4);
		}
	}
}

void Controller::writeTimetable(const char *specialDays, size_t specialDaysSize, const char *items, size_t itemsSize) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (0x9C != _getProgId())
		_throwFeature();

	_RAMInfo rami(*this);

	const short imageSize = rami.TTblockCount() * rami.blockSizeBytes();
	if (imageSize < 1344)
		_throwFeature();

	scoped_array<char> image(new char[imageSize]);
	memset(&image[0], 0, imageSize);
	image[28] = 'T'; image[29] = 'I'; image[30] = 'M'; image[31] = 'E';
	image[32] = 16;
	image[33] = 8;
	image[34] = 4;
	packShort(64, &image[36]);
	packShort(320, &image[38]);
	packShort(832, &image[40]);

	makeSD(&image[64], specialDays, static_cast<char>(specialDaysSize / 4));

	makeTT(&image[0], items, static_cast<int>(itemsSize / 6));

	int off = rami.TTfirstBlock() * rami.blockSizeBytes();
	const short buffersPerImage = imageSize / rami.obufSizeBytes();
	const char bufSize = static_cast<char>(rami.ibufSizeBytes());
	scoped_array<char> buf(new char[bufSize + 6 + 1]);

	_MemGuard kjhasdf(*this, mtRAM, 0);

	short i = 0;
	for (short bufIdx = 0; buffersPerImage != bufIdx; ++bufIdx)
	{
		memcpy(&buf[6], &image[bufSize * bufIdx], bufSize);
		_writeMem(0, off, &buf[0], bufSize);
		off += bufSize;

		if (_polling && !_autonomic)
		{
			if (i / 10)
			{
				i = 0;
				_readEvt2(false);
			}
			++i;
		}
	}
}

void Controller::restartProg() const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	const char cmd[] = {0x16, 0x23, addr};
	channel._write(cmd, sizeof(cmd));
}

void Controller::readSetup(char *data) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	_RAMInfo rami(*this);
	scoped_array<char> buf(new char[rami.obufSizeBytes() + 7]);
	const int cnt = 256 / rami.obufSizeBytes();
	_setMemMode(mtEEPROM, 0, moRead, cnt);
	for (int i=0; i != cnt; ++i)
	{
		const int off = rami.obufSizeBytes() * i;
		_readMem(0, off, &buf[0], rami.obufSizeBytes() + 6);
		memcpy(&data[off], &buf[5], rami.obufSizeBytes());
	}
	if (data[255] != crc8(data, 255))
		_throwCheckSum();
}

void Controller::writeSetup(const char *p) const
{
	char data[256];
	memcpy(data, p, 255);
	data[255] = crc8(data, 255);
	Channel::ExtCmdScopedLock scopedLock(channel);
	_RAMInfo rami(*this);
	scoped_array<char> buf(new char[rami.ibufSizeBytes() + 7]);
	const int cnt = 256 / rami.ibufSizeBytes();
	_setMemMode(mtEEPROM, 0, moWrite, cnt);
	for (int i=0; i != cnt; ++i)
	{
		const int off = rami.ibufSizeBytes() * i;
		memcpy(&buf[6], &data[off], rami.ibufSizeBytes());
		_writeMem(0, off, &buf[0], static_cast<char>(rami.ibufSizeBytes()));
	}
}

char Controller::_readRPD(char off) const
{
	const char cmd[] = {0x16, 0x63, addr, off};
	channel._write(cmd, sizeof(cmd));
	char ret;
	const int r = channel._read(&ret, 1);
	_chkInput(r);
	return ret;
}

/*void Controller::_writeRPD(char) const
{
	//<SYN><A3h><adr><LoAD><HiAD><Val>
	const char cmd[] = {0x16, 0xA3, addr, off};
	channel._write(cmd, sizeof(cmd));
	_chkInput();
	char ret;
	channel._read(&ret, 1);
	return ret;
}*/

int Controller::_varVal(const char *data, int idx) const
{
	int ret;
	switch (data[0])
	{
		case 2:
			ret = data[idx] | (data[1 + idx] << 8);
			break;
		case 3:
			ret = data[idx] | (data[1 + idx] << 8) | (data[2 + idx] << 16);
			break;
		default:
			_throwUnexpectedResponse();
	}
	return ret;
}

int Controller::readAllChips(vector<char>& chips) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	int off = _readRPD(0x4E) * 256;
	char buf[6 + 8];
	_readMem(off, buf, sizeof(buf));
	const int count = tss::servcont::isAlarm(&buf[5])? buf[12]: 0;
	if (!count)
		return 0;
	chips.resize(8 + count * 11);
	expandMask(&chips[0], buf[10]);
	for (int i=0; i != count; ++i)
	{
		off += 8;
		_readMem(off, buf, sizeof(buf));
		unpackChip(&chips[8 + 10 * i], &buf[5]);
	}
	return count;
}

class TSSServcontChip
{
public:
	enum { size = 8, uniqueFactorMin = 9, uniqueBitsMax = 48 };

	boost::uint64_t bitsVal(int count) const
	{
		boost::uint64_t v = ((boost::uint64_t)_b[5] << 40) | ((boost::uint64_t)_b[4] << 32) | (_b[3] << 24) | (_b[2] << 16) | (_b[1] << 8) | _b[0];
		boost::uint64_t m = 0;
		for (int i=0; i < count; ++i)
			m |= 1ull << i;
		v = v & m;
		return v;
	}

	void setKey(const boost::uint8_t *v)
	{
		Controller::reverseCopyKey((char *)_b, (const char *)v);
	}

	void setFlags(boost::uint8_t v)
	{
		_b[6] = v;
	}

	void setUniqueFactor(boost::uint8_t v)
	{
		_b[7] = v;
	}

	const boost::uint8_t *data() const { return _b; }
private:
	boost::uint8_t _b[size];
};

class TSSServcontChips
{
public:
	TSSServcontChips(int count): _c(count) {}
	const boost::uint8_t *get(int idx) const { return _c[idx].data(); }
	void set(int idx, const boost::uint8_t *v)
	{
		_c[idx].setKey(v);
		v += 6;
		boost::uint8_t checkCount = v[2];
		switch (checkCount)
		{
		case 3:
			checkCount = 0;
			break;
		case 4:
			checkCount = 2;
			break;
		case 5:
			checkCount = 4;
			break;
		case 6:
			//checkCount = 6;
			break;
		case 8:
			checkCount = 1;
			break;
		case 12:
			checkCount = 3;
			break;
		case 16:
			checkCount = 5;
			break;
		case 20:
			checkCount = 7;
			break;
		default:
			TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER("Check count out of range.");
		}

		boost::uint8_t port = v[3];
		chkRange(1, 8, port, "Port");
		--port;

		boost::uint8_t flags = ((!*v) << 7) | //active
			(v[1] << 6) | //opneEvenComplex
			(checkCount << 3) |
			port;

		_c[idx].setFlags(flags);
	}

	void makeUnique()
	{
		for (std::size_t i = 0; i < _c.size(); ++i)
			_c[i].setUniqueFactor(_uniqueFactor(i));
	}

private:
	bool _find(const std::size_t idx, const int bits) const
	{
		const boost::uint64_t a = _c[idx].bitsVal(bits);
		bool found = false;
		for (std::size_t i = 0; !found && i < _c.size(); ++i)
		{
			if (idx != i)
			{
				const boost::uint64_t b = _c[i].bitsVal(bits);
				found = (a == b);
			}
		}
		return found;
	}

	boost::uint8_t _uniqueFactor(const std::size_t idx) const
	{
		int bits = 4;//1!!!
		bool found;
		for (;;)
		{
			found = _find(idx, bits);
			if (found)
			{
				++bits;
				if (bits > TSSServcontChip::uniqueBitsMax)
					TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER("Unique factor violation, these chips can't be written together.");
			}
			else
				break;
		}
		return bits + TSSServcontChip::uniqueFactorMin;
	}

	std::vector<TSSServcontChip> _c;
};

void Controller::writeAllChips(const char *data, int count) const
{
	chkRange(1, 127, count, "Chip count");
	TSSServcontChips chips(count);
	for (int i=0; i != count; ++i)
		chips.set(i, (const boost::uint8_t *)&data[8 + i * 10]);
	chips.makeUnique();

	Channel::ExtCmdScopedLock scopedLock(channel);
	int off = _readRPD(0x4E) * 256;
	char buf[6 + TSSServcontChip::size + 1];
	memcpy(&buf[6], "ALARM", 5);
	buf[11] = data[0] | (data[1] << 1) | (data[2] << 2) | (data[3] << 3) | (data[4] << 4) | (data[5] << 5) | (data[6] << 6) | (data[7] << 7);
	buf[12] = 0;
	buf[13] = count;
	_writeMem(off, buf, 8);
	for (int i=0; i != count; ++i)
	{
		off += 8;
		memcpy(&buf[6], chips.get(i), TSSServcontChip::size);
		_writeMem(off, buf, TSSServcontChip::size);
	}
}

void Controller::controlChip(const char *chip, bool activate) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	char rchip[6];
	reverseCopyKey(rchip, chip);
	int off = _readRPD(0x4E) * 256;
	char buf[6 + 8 + 1];
	_readMem(off, buf, sizeof(buf) - 1);
	const int count = tss::servcont::isAlarm(&buf[5])? buf[12]: 0;
	if (!count)
		TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER(str(format("Chip '%s' not found.") % keyToStr(chip)));
	for (int i=0; i != count; ++i)
	{
		off += 8;
		_readMem(off, buf, sizeof(buf) - 1);
		if (memcmp(&buf[5], rchip, 6) == 0)
		{
			memmove(&buf[6], &buf[5], 8);
			if (activate)
				buf[6 + 6] &= ~(1 << 7);
			else
				buf[6 + 6] |= (1 << 7);
			_writeMem(off + 6, &buf[6], 1);

			boost::uint64_t key = keyToInt(chip);
			if (activate)
				_chipsActivated.insert(key);
			else
				_chipsActivated.erase(key);

			return;
		}
	}
	TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER(str(format("Chip '%s' not found.") %chip));
}

void Controller::eraseAllChips() const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	int off = _readRPD(0x4E) * 256;
	char buf[6 + 8 + 1];
	memset(&buf[6], 0, 8);
	_writeMem(off, buf, sizeof(buf));
}

int Controller::chipInfo(int idx, char* result) const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	if (_getProgVer() < TSS_SERVCONT_PROG_VER(1, 86))
		_throwFeature();
	_Command cmd(*this, 0xC8, 2, 14);
	cmd[0] = 0xC8;
	cmd[1] = idx;
	const int len = cmd.exec();
	if (len == 2)
	{
		if (cmd[0] == 0xC8 && cmd[1] == 0)
			TSS_SERVCONT_THROW_CLIENT_ERROR_PARAMETER(str(format("Chip # %d not found.") % idx));
		else
			_throwUnexpectedResponse();
	}
	int i = 0;
	if (len >= 12)
	{
		if (!(cmd[0] == 0xC8 && cmd[1] == idx))
			_throwUnexpectedResponse();
		result[i++] = cmd[1];//Idx
		result[i++] = cmd[2] + 1;//Chan(Port)
		result[i++] = cmd[3];//FC
		memcpy(&result[i], &cmd[4], 6);//SN
		i += 6;
	}
	if (len == 14)
	{
		result[i++] = 1;//full;
		int flags = cmd[10];
		result[i++] = flags & 3;//канал
		result[i++] = (flags & 4) != 0;//чип отрапортован как пропавший
		result[i++] = (flags & 8) != 0;//чип в очереди на передачу события
		result[i++] = (flags & 16) != 0;//чип выявлен при анализе состава шлейфа
		result[i++] = (flags & 32) != 0;//включать реле при отрыве чипа в АВТОНОМЕ
		result[i++] = (flags & 64) != 0;//включать реле при отрыве чипа в КОМПЛЕКСЕ
		result[i++] = (flags & 128) != 0;//отслеживание чипа включено
		result[i++] = cmd[11];//Bits
		result[i++] = cmd[12];//AbsntLimit
		result[i] = cmd[13];//AbsntMax
	}
	else if (len == 12)
	{
		result[i++] = 0;//!full;
		result[i++] = !(cmd[10] & (1 << 7));
		result[i++] = cmd[10] & (1 << 6);
		result[i++] = chipCheckCount(cmd[10]);
		result[i++] = (cmd[10] & 7) + 1;
		result[i] = cmd[11];//Bits
	}
	else
		_throwUnexpectedResponse();
	return i;
}

bool Controller::isChipActivated(boost::uint64_t v) const
{
	std::set<boost::uint64_t>::const_iterator it = _chipsActivated.find(v);
	bool res = it != _chipsActivated.end();
	return res;
}

bool Controller::_getIsAlarm() const
{
	if (!_isAlarm)
	{
		int off = _readRPD(0x4E) * 256;
		char buf[6 + 8];
		_readMem(off, buf, sizeof(buf));
		_isAlarm = tss::servcont::isAlarm(&buf[5]);
	}
	return *_isAlarm;
}


string Controller::name() const throw()
{
	return str(format("Channel<%s>" + string(".") + "Controller<%d>") %channel.connInfo() %static_cast<int>(addr));
}

void Controller::_setState(char val)
{
	if (_state != val)
	{
		_state = val;
		if (val == _stateAutonomicPolling || val == _stateComplex)
			channel._timer.active(_stateTimer, false);
		channel.events.onControllerState(channel, *this, val);
	}
}

char Controller::state() const
{
	Channel::ExtCmdScopedLock scopedLock(channel);
	return _state;
}

Controller& Controllers::add(char addr)
{
	Controller *co = new Controller(channel, addr);
	insert(addr, co);
	channel.events.onControllersChanged(channel);
	return *co;
}

void Controllers::remove(char addr)
{

	erase(addr);
	channel.events.onControllersChanged(channel);
}

string Controllers::_key2str(const char& key) const
{
	return str(format("Controller<%d>") %static_cast<int>(key));
}

Channel::Channel(Events& events_, unsigned short responseTimeout_, unsigned short aliveTimeout_, unsigned short deadTimeout_):
	events(events_),
	controllers(*this),
	responseTimeout(responseTimeout_),
	aliveTimeout(aliveTimeout_),
	deadTimeout(deadTimeout_),
	_extCmd(false),
	_sync(),
	_ready(false),
	_deactivating(false),
	_error(false),
	_speedTimer(*this),
	_thread(NULL),
	_lastEvtCo(0),
	_speedOld(0),
	_speedCounter(0),
	_speedClock(0),
	_timer(),
	_fireSpeedEvent(_sync),
	_speedZeroFired(false),
	_writeAllKeysTh()
{
	trace("Channel()");
}

Channel::~Channel()
{
	trace("~Channel()");
}

std::vector<char> Channel::findControllers()
{
	ExtCmdScopedLock scopedLock(*this);
	_chkReady();
	_flushInput();
	std::vector<char> result;
	char buf[17];
	for (char addr = 0; addr < 0xFF; ++addr)
	{
		const char cmd[] = { 0x16, 0x3A, addr };
		_write(cmd, sizeof(cmd));
		int read = 0;
		while (true)
		{
			const int r = _read(&buf[read], sizeof(buf) - read);
			if (r == 0)
				break;
			read += r;
			if (read == sizeof(buf))
			{
				result.push_back(addr);
				break;
			}
			else if (read == 3 && buf[0] == addr && buf[1] == 0)
			{
				if (buf[2] == addr) // No events?
				{
					result.push_back(addr);
					break;
				}
				else
				{
					if (buf[2] == static_cast<char>(~addr)) // Busy?
					{
						result.push_back(addr);
						break;
					}
				}
			}
			else if (read == 4 && buf[1] == addr && buf[2] == 0 && buf[3] == addr) // No events? äëÿ 201 ñ ïðîøèâêîé 85h.
			{
				result.push_back(addr);
				break;
			}
		}
	}
	return result;
}

void Channel::_flushInput()
{
	char buf[17];
	int read = 0;
	while (true)
	{
		const int r = _read(&buf[read], sizeof(buf) - read);
		if (!r)
			break;
		read += r;
		if (read == sizeof(buf))
		{
			if (_lastEvtCo)
			{
				Controller *co = controllers.find(_lastEvtCo);
				if (co)
					co->_processEvt(buf);
			}
			break;
		}
	};
	_error = false;
}

void Channel::_setReady(bool val)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	_ready = val;
}

bool Channel::active() const
{
	Channel::ExtCmdScopedLock scopedLock(*this);
	return _active();
}

std::pair<bool, bool> Channel::activeAndReady() const
{
	Channel::ExtCmdScopedLock scopedLock(*this);
	std::pair<bool, bool> res(_active(), _ready);
	return res;
}

bool Channel::_processController(Controller& co)
{
	TSS_SCOPED_THREAD_LOCK(_sync);

	const bool ret = co._polling;
	if (ret)
	{
		co._readEvt();

		if (co._recoverState == Controller::_recoverAlive)
		{
			_timer.active(co._aliveTimer, false);
			co._recoverState = Controller::_recoverNone;
		}
	}

	return ret;
}

void Channel::activate()
{
	Channel::ExtCmdScopedLock scopedLock(*this);
	if (!_active())
	{
		_deactivating = false;
		_timer.add(_speedTimer);
		for (Controllers::const_iterator it = controllers.begin(); it != controllers.end(); ++it)
		{
			_timer.add(it->second->_stateTimer);
			_timer.add(it->second->_aliveTimer);
			_timer.add(it->second->_deadTimer);
		}
		_timer.start();
		_thread = new Thread(new _ThImpl(*this));
	}
}

bool Channel::ready() const
{
	Channel::ExtCmdScopedLock scopedLock(*this);
	return _ready;
}

void Channel::_initSpeed() throw()
{
	_speedOld = 0;
	_speedClock = 0;
	_speedCounter = 0;
	timeDiff(0, &_speedClock);
};

static bool cmpAndSet(const thread::Synchronizer& sync, string& s1, const string& s2)
{
	TSS_SCOPED_THREAD_LOCK(sync);
	const bool ret = s1 != s2;
	if (ret)
		s1 = s2;
	return ret;
}

void Channel::_work()
{
	struct X
	{
		X(Channel& ch_): ch(ch_) {}
		~X()
		{
			ch._fini();
			ch.events.onChangeState(ch, false);
		}
		Channel& ch;
	} jhsdasf(*this);

	try
	{
		_init();
		events.onChangeState(*this, true);
	} catch (const std::exception& e)
	{
		if ( typeid(e) == typeid(FatalError) )
			handleException(e);
		else
			throw Error(*this, "Activation", e.what());
	}

	_initSpeed();
	_timer.active(_speedTimer, true);

	while (!_deactivating)
	{
		bool anyProcessed = false;

		for (Controllers::const_iterator it = controllers.begin(); it != controllers.end(); ++it)
		{
			Controller& co = *it->second;
			try
			{
				if (!anyProcessed)
					anyProcessed = _processController(co);
				else
					_processController(co);
				thread::yield();
			} catch (const std::exception& e)
			{
				if (typeid(e) != typeid(Controller::Error))
					throw;
				anyProcessed = true;//trick
				trace(e.what());
				if (cmpAndSet(_sync, co._lastErrMsg, e.what()))
				{
					handleException(e);
					events.onControllerError(*this, co, e);
				}
				_timer.active(co._stateTimer, true);
				_chkAndSetAliveTimer(co);
			}

			while (_extCmd)
			{
				thread::sleep(10);
			}
		}

		if (anyProcessed)
		{
			if (_fireSpeedEvent.toggle())
			{
				_speedZeroFired = false;
				const unsigned int diff = timeDiff(_speedClock, &_speedClock) + 1;//to prevent from division by zero.
				const unsigned int x = _speedCounter * 1000 / diff;
				_speedCounter = 0;
				if ( (::abs(static_cast<int>(_speedOld - x)) / 5) )
				{
					_speedOld = x;
					events.onPollSpeed(*this, x);
				}
			}
			
			while (_extCmd)
			{
				thread::sleep(10);
			}

		} else
		{
			if (!_speedZeroFired)
			{
				_speedZeroFired = true;
				_speedOld = 0;
				events.onPollSpeed(*this, 0);
			}
			thread::sleep(100);			
		}
	}

	_timer.active(_speedTimer, false);
	for (Controllers::const_iterator it = controllers.begin(); it != controllers.end(); ++it)
	{
		Controller& co = *it->second;
		try
		{
			_timer.active(co._deadTimer, false);
			_timer.active(co._aliveTimer, false);
			_timer.active(co._stateTimer, false);
			co._readEvt2(true);
			co._setState(Controller::_stateStateless);
		} catch (...)
		{
		}
	}
	_speedOld = 0;
	events.onPollSpeed(*this, 0);
}

void Channel::deactivate()
{
	if (active())
	{
		_deactivating = true;
		_timer.stop();
		_timer.remove(_speedTimer);
		for (Controllers::const_iterator it = controllers.begin(); it != controllers.end(); ++it)
		{
			_timer.remove(it->second->_stateTimer);
			_timer.remove(it->second->_aliveTimer);
			_timer.remove(it->second->_deadTimer);
		}
	} 
	delete _thread;
	_thread = NULL;
}

void Channel::_chkAndSetAliveTimer(Controller& co)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	if (co._recoverState == Controller::_recoverNone)
	{
		_timer.active(co._aliveTimer, true);
		co._recoverState = Controller::_recoverAlive;
	}
}

//bool Channel::anyPollable() const
//{
//	TSS_SCOPED_THREAD_LOCK(_sync);
//	for (Controllers::Container::const_iterator it = controllers.cont().begin(); it != controllers.cont().end(); ++it)
//	{
//		if (it->second->_polling)
//			return true;
//	}
//	return false;
//}

void Channel::_ThImpl::operator ()() throw()
{
	string lastErrMsg;
	while (!host._deactivating)
	{
		try
		{
			host._work();
		} catch (const std::exception& e)
		{
			if (lastErrMsg != e.what())
			{
				format f("Channel<%s>");
				f %host.connInfo();
				handleException(e, f.str().c_str());
				lastErrMsg = e.what();
				host.events.onError(host, e);
			}
			if (!host._deactivating)
				thread::sleep(1000);
		}
	}
}

SerialChannel::SerialChannel(Events& events, unsigned short responseTimeout, unsigned short aliveTimeout, unsigned short deadTimeout, const string& devStr_, unsigned int speed_):
	Channel(events, responseTimeout, aliveTimeout, deadTimeout), devStr(devStr_), speed(speed_), _comm(NULL)
{
	format f("%s@%u");
	f %devStr_ %speed_;
	_connInfo = f.str();
}

SerialChannel::~SerialChannel()
{
}

void SerialChannel::_init()
{
	_comm = new SerialPort(devStr);
	_comm->setup(SerialPort::baudRate(speed)
#ifdef MSWINDOWS
		, 512, 512
#endif
		);	
#ifdef MSWINDOWS
	_comm->readTimeout(responseTimeout);
#endif
	_comm->controlSignal(SerialPort::DTR, false);
	_comm->controlSignal(SerialPort::RTS, true);
	_setReady(true);
}

void SerialChannel::_fini()
{
	_setReady(false);
	delete _comm; _comm = NULL;
}

int SerialChannel::_read(char *buf, int size) const
{
	assert(size > 0);
	int r;
	try {
#ifdef LINUX
		if (!_comm->waitInput(responseTimeout))
			return 0;
#endif
		r = _comm->read(buf, size);
	} catch (const std::exception& e) {
		if ( typeid(e) != typeid(FatalError) )
			_throwReading(e.what());
		else
			throw;
	}
	return r;
}

void SerialChannel::_write(const char *buf, int size)
{
	assert(size > 0);
	_chkReady();
	try
	{
		if (_error)
			_flushInput();
		_comm->write(buf, size);
	} catch (const std::exception& e)
	{
		if ( typeid(e) != typeid(FatalError) )
			_throwWriting(e.what());
		else
			throw;
	}
}

IPChannel::IPChannel(Events& events, unsigned short responseTimeout, unsigned short aliveTimeout, unsigned short deadTimeout, const string& host_, unsigned short port_):
	Channel(events, responseTimeout, aliveTimeout, deadTimeout), host(host_), port(port_), _comm(NULL)
{
	format f("%s:%u");
	f %host_ %port_;
	_id = f.str();
}

IPChannel::~IPChannel()
{
}

void IPChannel::_init()
{
	_comm = new Socket(Socket::TCP);
	_comm->connect(ip::host2addr(host.c_str()), htons(port), 2000);
	_comm->NagleAlgo(false);
	_setReady(true);
}

void IPChannel::_fini()
{
	_setReady(false);
	delete _comm; _comm = NULL;
}

int IPChannel::_read(char *buf, int size) const
{
	assert(size > 0);
	int r;
	try
	{
		if (!_comm->waitInput(responseTimeout))
			return 0;
		r = _comm->read(buf, size);
		//if (r == 0)
		//	throw runtime_error("Remote side has shut down the connection.");
	} catch (const std::exception& e)
	{
		if ( typeid(e) != typeid(FatalError) )
			_throwReading(e.what());
		else
			throw;
	}
	return r;
}

void IPChannel::_write(const char *buf, int size)
{
	assert(size > 0);
	_chkReady();
	try
	{
		if (_error)
			_flushInput();
		_comm->write(buf, size);
	} catch (const std::exception& e)
	{
		if ( typeid(e) != typeid(FatalError) )
			_throwWriting(e.what());
		else
			throw;
	}
}

void Controller::_MemGuard::switchBankIf(char bank)
{
	if (_bank != bank)
	{
		_turnOff();
		_turnOn(bank);
	}
}

int Controller::_Command::exec(bool chkOp /*= true*/)
{
	_buf[0] = 0x16;
	_buf[1] = 0xE4;
	_buf[2] = co.addr;
	_buf[3] = op;
	_buf[4] = 0;
	_buf[5] = osize;
	_buf[osize + 7 - 1] = cs8(&_buf[6], osize);
	co.channel._write(&_buf[0], osize + 7);
	return co._readPack(&_buf[4], isize + 3, chkOp);
}


Controller::_RAMInfo::_RAMInfo(const Controller& co)
{
	buf[0] = 0x16;
	buf[1] = 0x2D;
	buf[2] = co.addr;
	co.channel._write(buf, 3);
	const int packLen = co._readPack(buf, sizeof(buf), true);
	if (packLen != 15)
		co._throwUnexpectedResponse();
}


Controller::_KBInfo::_KBInfo(const Controller& co_) : co(co_)
{
	const int packLen = co._4c(0x08, buf, 11, true);
	if (!((packLen == 6 && buf[2] == 2) || (packLen == 8 && buf[2] == 3)))
		co._throwUnexpectedResponse();
}


Controller::_TTInfo::_TTInfo(const Controller& co)
{
	const int packLen = co._4c(0x80, buf, 13, true);
	switch (packLen)
	{
		case 2:
			_valid = false;
			break;
		case 3:
			_valid = false;
			break;
		case 10:
			_valid = true;
			break;
		default:
			co._throwUnexpectedResponse();
			break;
	}
}

Controller::Error::Error(const Controller& co, const char *className, const string& msg)
	: servcont::Error(className, str(format("%s: %s") %co.name() %msg))
{
	co._progId = 0;
	co._progVer = 0;
	co.channel._error = true;
}


//Channel::_CoCmd::_CoCmd(char addr_) : addr(addr_)
//{
//	const struct tm *now = os::localtime();
//	memcpy(&_timestamp, now, sizeof(_timestamp));
//}

Channel::Error::Error(const Channel& ch, const char *className, const char *msg)
	: servcont::Error(className, str(format(string("Channel<%s>") + ": %s") %ch.connInfo() %msg))
{
}

void Channel::_SpeedTimer::onTimer() throw()
{
	ch._fireSpeedEvent.set(true);
}

void Controller::_AliveTimer::onTimer() throw()
{
	TSS_SCOPED_THREAD_LOCK(co.channel._sync);
	trace("AliveTimer::onTimer()");
	co._polling = false;
	co.channel._timer.active(co._deadTimer, true);
	co._recoverState = _recoverDead;
}


void Controller::_DeadTimer::onTimer() throw()
{
	TSS_SCOPED_THREAD_LOCK(co.channel._sync);
	trace("DeadTimer::onTimer()");
	co._lastErrMsg.clear();
	co._polling = true;
	co._recoverState = _recoverNone;
}


void Controller::_StateTimer::onTimer() throw()
{
	TSS_SCOPED_THREAD_LOCK(co.channel._sync);
	trace("StateTimer::onTimer()");
	co._setState(_stateStateless);
}

#ifdef TSS_DAVINCI

const char DVRS422Channel::i2cOutAvailReg = 0x17;
const char DVRS422Channel::i2cInAvailReg = 0x10;
const char DVRS422Channel::i2cOutReg = 0x10;
const char DVRS422Channel::i2cInReg = 0x11;
const std::string DVRS422Channel::_id = "DVRS422";


DVRS422Channel::DVRS422Channel(Events& events, unsigned short responseTimeout, unsigned short aliveTimeout, unsigned short deadTimeout, unsigned int speed_):
	Channel(events, responseTimeout, aliveTimeout, deadTimeout), speed(speed_)
{
	
}

DVRS422Channel::~DVRS422Channel()
{
	
}

const std::string& DVRS422Channel::id() const throw() { return _id; }
const std::string& DVRS422Channel::connInfo() const throw() { return _id; }

void DVRS422Channel::_init()
{
	_i2c.open(0xE0);
}

void DVRS422Channel::_fini()
{
	_i2c.close();
}

int DVRS422Channel::_read(char *buf, int size) const
{
	const int r = _waitInAvail();
	if (r)
	{
		BOOST_ASSERT(r <= size);
		_i2c.read(i2cInReg, buf, r);
	}
	return r;
}

void DVRS422Channel::_write(const char *buf, int size)
{
	_i2c.write(i2cOutReg, buf, size);
}

int DVRS422Channel::_inAvail() const
{
	char v;
	_i2c.read(i2cInAvailReg, &v, 1);
	return v;
}

int DVRS422Channel::_waitInAvail() const
{
	int r;
	unsigned short duration = 7;
	bool expired = false;
	thread::sleep(7);
	do
	{
		r = _inAvail();
		if (!r)
		{
			thread::sleep(1);
			duration += 1;
			expired = duration > responseTimeout;
			//printf("DVRS422Channel::_waitInAvail(): duration: %d; expired: %d\n", (int)duration, (int)expired);
		}
	} while (!r && !expired);
	return r;
}

#endif // #ifdef TSS_DAVINCI

Controller::WriteAllKeysThImpl::WriteAllKeysThImpl(const Controller& co, const char *keys, int count) :
	co(co), is_201(0 == co._getProgVer())
{
	trace("Channel::WriteAllKeysThImpl()");
	this->keys.resize(count * 18);
	std::memcpy(this->keys.data(), keys, this->keys.size());
}

Controller::WriteAllKeysThImpl::~WriteAllKeysThImpl()
{
	trace("Channel::~WriteAllKeysThImpl()");
}

void Controller::WriteAllKeysThImpl::operator()() throw()
{
	Channel::ExtCmdScopedLock scopedLock(co.channel);
	std::string err;
	try
	{
		if (is_201)
			co._writeAllKeys201(keys.data(), keys.size() / 18);
		else
			co._writeAllKeys(keys.data(), keys.size() / 18);
	}
	catch (const std::exception& e)
	{
		err = e.what();
	}
	catch (...)
	{
		err = "unknown error";
	}
	co.channel.events.onWriteAllKeysAsync(co, err);
}

}}//namespace tss { namespace servcont
