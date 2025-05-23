#ifndef TSS_SERIALPORT_HPP_INCLUDED
#define TSS_SERIALPORT_HPP_INCLUDED

#pragma once

#include "config.hpp"
#include <tss/os.hpp>
#ifdef LINUX
#include <tss/nix/termios.hpp>
#endif
#include <tss/sys.hpp>
#include <string>

namespace tss
{

class SerialPort: public os::Handle
{
public:
	enum BaudRate
	{
#ifdef LINUX
		br1200 = B1200,
		br2400 = B2400,
		br4800 = B4800,
		br9600 = B9600,
		br19200 = B19200,
		br38400 = B38400,
		br57600 = B57600,
		br115200 = B115200
#else
		br1200 = CBR_1200,
		br2400 = CBR_2400,
		br4800 = CBR_4800,
		br9600 = CBR_9600,
		br19200 = CBR_19200,
		br38400 = CBR_38400,
		br57600 = CBR_57600,
		br115200 = CBR_115200
#endif
	};
	enum ControlSignal
	{
		DTR, RTS
	};
	SerialPort(const std::string&);
	void setup(BaudRate
#ifdef MSWINDOWS
		, DWORD, DWORD
#endif
		);
#ifdef LINUX
	bool waitInput(unsigned int) const;
#endif
#ifdef MSWINDOWS
	void readTimeout(DWORD);
#endif
	int read(char *, int) const;
	int write(const char *, int) const;
	void controlSignal(ControlSignal, bool);
	static unsigned int value(BaudRate);
	static BaudRate baudRate(unsigned int);
	static HANDLE createHandle(const std::string&);
protected:
};

}//namespace tss

#endif
