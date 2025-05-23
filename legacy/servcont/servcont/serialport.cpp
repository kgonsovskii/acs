#include "pch.h"
#include <tss/serialport.hpp>
#ifdef LINUX
#include <sys/time.h>
#include <tss/nix/sys/select.hpp>
#include <tss/nix/ioctl.hpp>
#include <tss/nix/fcntl.hpp>
#endif
#include <stdexcept>
#include <boost/format.hpp>
#include <tss/sys.hpp>

using namespace std;
using namespace boost;

namespace tss
{

HANDLE SerialPort::createHandle(const string& devStr)
{
#ifdef LINUX
	const HANDLE ret = ::open(devStr.c_str(), O_RDWR|O_NOCTTY|O_NDELAY);
#else
	const HANDLE ret = ::CreateFile(devStr.c_str(),
		GENERIC_READ|GENERIC_WRITE,
		0,
		NULL,
		OPEN_EXISTING,
		0,
		NULL);
#endif
	if (ret == INVALID_HANDLE_VALUE)
	{
		const int ec = os::errNo();
		string s;
		switch (ec)
		{
		case 2:
			s = str(format("Serial port '%s' doesn't exist") %devStr);
			s = errMsg(s, ec);
			break;
#ifdef MSWINDOWS
		case 5:
			s = str(format("Serial port '%s' already open") %devStr);
			s = errMsg(s, ec);
			break;
#endif
		default:
			s = str(format("Can't open serial port '%s'") %devStr);
			s = errMsg(s, ec);
		}
		throw runtime_error(s);
	}
	return ret;
}


SerialPort::SerialPort(const string& devStr): os::Handle(createHandle(devStr))
{
#ifdef LINUX
	os::fcntl(handle, F_SETFL, 0);
#endif
}


void SerialPort::setup(BaudRate speed
#ifdef MSWINDOWS
					   , DWORD dwInQueue, DWORD dwOutQueue
#endif
					   )
{
#ifdef LINUX
	struct termios options;

	os::tcgetattr(handle, &options);

	cfmakeraw(&options);

	os::cfsetispeed(&options, speed);
	os::cfsetospeed(&options, speed);

	options.c_cflag |= (CLOCAL|CREAD);

	// 1 stop bit
	options.c_cflag &= ~CSTOPB;

	// disable HW
	options.c_cflag &= ~CRTSCTS;
	
// !!! parity, def=even;
//options.c_cflag |= PARENB;
//options.c_cflag &= ~PARODD;

	// ignore parity errors & chk.
	options.c_iflag &= ~INPCK;
	options.c_iflag |= IGNPAR;

	// timeouts
	options.c_cc[VTIME] = 0;
	options.c_cc[VMIN] = 0;

	// apply all the settings
	os::tcsetattr(handle, TCSANOW, &options);

#else
	os::SetupComm(handle, dwInQueue, dwOutQueue);

	DCB dcb = {0};
	dcb.DCBlength = sizeof(dcb);
	dcb.BaudRate = speed;
	dcb.ByteSize = 8;
	dcb.fBinary = TRUE;
	os::SetCommState(handle, &dcb);
#endif
}


#ifdef LINUX
bool SerialPort::waitInput(unsigned int timeout) const
{
	fd_set rfds;
	FD_ZERO(&rfds);
	FD_SET(handle, &rfds);
	int r;
	if (timeout != INFINITE) {
		struct timeval tv = {timeout / 1000, (timeout % 1000) * 1000};
		r = os::select(handle + 1, &rfds, NULL, NULL, &tv);
	} else
		r = os::select(handle + 1, &rfds, NULL, NULL, NULL);
	if (r == 0)
		return false;
	else
		return true;
}
#endif


int SerialPort::read(char *buf, int size) const
{
#ifdef LINUX
	return os::read(handle, buf, size);
#else
	DWORD ret;
	if (!::ReadFile(handle, buf, size, &ret, NULL))
		//os::fatalError();
		os::throwException<runtime_error>();
	return ret;
#endif
}


int SerialPort::write(const char *buf, int size) const
{
#ifdef LINUX
	return os::write(handle, buf, size);
#else
	DWORD ret;
	if (!::WriteFile(handle, buf, size, &ret, NULL))
		os::fatalError();
	return ret;
#endif
}


void SerialPort::controlSignal(ControlSignal cs, bool isSet)
{
#ifdef LINUX
	int status;
	os::ioctl(handle, TIOCMGET, (int)&status);
	switch (cs) {
		case DTR:
			isSet? status |= TIOCM_DTR: status &= ~TIOCM_DTR; 
			break;
		case RTS:
			isSet? status |= TIOCM_RTS: status &= ~TIOCM_RTS; 
			break;
	}
	//status &= ~TIOCM_DTR; ???
	os::ioctl(handle, TIOCMSET, (int)&status);
#endif
#ifdef MSWINDOWS
	DWORD x;
	switch (cs) {
		case DTR:
			x = isSet? SETDTR: CLRDTR;
			break;
		case RTS:
			x = isSet? SETRTS: CLRRTS;
			break;
	}
	os::EscapeCommFunction(handle, x);
#endif
}


unsigned int SerialPort::value(BaudRate speed)
{
	switch (speed)
	{
	case br1200:
		return 1200;
	case br2400:
		return 2400;
	case br4800:
		return 4800;
	case br9600:
		return 9600;
	case br19200:
		return 19200;
	case br38400:
		return 38400;
	case br57600:
		return 57600;
	case br115200:
		return 115200;
	default:
		throw logic_error("Unsupported baudrate.");
	}
}


SerialPort::BaudRate SerialPort::baudRate(unsigned int speed)
{
	switch (speed)
	{
	case 1200:
		return br1200;
	case 2400:
		return br2400;
	case 4800:
		return br4800;
	case 9600:
		return br9600;
	case 19200:
		return br19200;
	case 38400:
		return br38400;
	case 57600:
		return br57600;
	case 115200:
		return br115200;
	default:
		throw logic_error("Unsupported baudrate.");
	}
}


#ifdef MSWINDOWS
void SerialPort::readTimeout(DWORD timeout)
{
	COMMTIMEOUTS ct = {MAXDWORD, MAXDWORD, timeout, MAXDWORD, MAXDWORD};
	os::SetCommTimeouts(handle, &ct);
}


#endif
}
