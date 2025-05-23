#ifndef TSS_SYS_HPP_INCLUDED
#define TSS_SYS_HPP_INCLUDED

#pragma once

#include "config.hpp"
#include <stdio.h>
#ifdef LINUX
#include <cerrno>
#include <sched.h>
#include <sys/time.h> //gettimeofday
#include <signal.h>
#endif
#ifdef MSWINDOWS
#include <windows.h>
#endif
#include <climits>
#include <stdexcept>
#include <string>
#include <boost/noncopyable.hpp>

namespace tss {

#ifndef INFINITE
#	define INFINITE 0xffffffff
#endif

void log(const char * const) throw();
static inline void log(const std::string& s) throw() { log(s.c_str()); }
void handleException(const std::exception&, const char * const = NULL, const char * const = NULL) throw();

class Abort: public std::runtime_error
{
public:
	Abort(): std::runtime_error("Abort") {}
};

class FatalError: public std::runtime_error
{
public:
	FatalError(const std::string& msg): std::runtime_error(msg) {}
};

#ifdef NDEBUG
#define trace(s)     ((void)0)
#else
static inline void trace(const char *s) throw() { log(s); }
#endif

template <typename T>
static inline bool even(const T x)
{
	return (0 == (x % 2));
}

template <typename T>
static inline bool odd(const T x)
{
	return (0 != (x % 2));
}

template <typename OutT, typename MaskT>
static inline void expandMask(OutT * const out, const MaskT mask)
{
	const unsigned short bitCount = sizeof(MaskT) * CHAR_BIT;
	for (unsigned short i=0; i != bitCount; ++i)
		out[i] = (mask & (1 << i)) != 0;
}

static inline void hexdump(const char * const buf, const size_t size, char * const out)
{
	size_t x = 0;
	for (size_t i=0; i != size; ++i) {
		sprintf(&out[x], "%.2X ", buf[i]);
		x += 3;
	}
	out[x - 1] = 0;
}

static inline char bcd2bin(const char val) throw()
{
	return ( (val & 0x0f) + 10 * ((val & 0xf0) >> 4) );
}

static inline char bin2bcd(const char val) throw()
{
	const char x = val / 10;
	return ( (x << 4) + (val - (x * 10)) );
}

static inline char *packShort(const unsigned short x, char * const buf, const bool isBigEndian = false) throw()
{
	if (isBigEndian)
	{
		buf[0] = static_cast<char>(x >> 8);
		buf[1] = static_cast<char>(x);
	} else
	{
		buf[0] = static_cast<char>(x);
		buf[1] = static_cast<char>(x >> 8);
	}
	return buf;
}

static inline short unpackShort(const char * const buf, const bool isBigEndian = false) throw()
{
	return isBigEndian? (buf[1] | buf[0] << 8): (buf[1] << 8 | buf[0]);
}

static inline char *packInt(const unsigned int x, char * const buf) throw()
{
	buf[0] = static_cast<char>(x);
	buf[1] = static_cast<char>(x >> 8);
	buf[2] = static_cast<char>(x >> 16);
	buf[3] = static_cast<char>(x >> 24);
	return buf;
}

static inline int unpackInt(const char * const buf) throw()
{
	return ( (buf[3] << 24) | buf[2] << 16 | buf[1] << 8 | buf[0] );
}

std::string errMsg(const char * const msg, const int ec);

static inline std::string errMsg(const std::string& msg, const int ec)
{
	return errMsg(msg.c_str(), ec);
}

namespace os {

static inline int errNo() throw()
{
#ifdef LINUX
	return errno;
#endif
#ifdef MSWINDOWS
	return ::GetLastError();
#endif
}

std::string errDesc(int ec);
static inline std::string errDesc()
{
	return os::errDesc(os::errNo());
}

template <class T>
static inline void throwException()
{
	throw T(errDesc(errNo()));
}

static inline void fatalError()
{
	throwException<FatalError>();
}

}//namespace os

static inline unsigned int timeDiff(const unsigned int in, unsigned int * const out = NULL)
{
#ifdef LINUX
	struct timeval tv;
	::gettimeofday(&tv, NULL);
	const unsigned int now = (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
#endif
#ifdef MSWINDOWS
	const DWORD now = ::GetTickCount();
#endif
	const unsigned int diff = now - in;
	if (out)
		*out = now;
	return diff;
}

namespace thread {

static inline void sleep(const unsigned int x) throw()
{
#ifdef LINUX
	if (x != INFINITE) {
		struct timespec t;
		t.tv_sec = x / 1000;
		t.tv_nsec = (x % 1000) * 1000000;
		::nanosleep(&t, NULL);
	} else
		::sleep(INFINITE);
#endif
#ifdef MSWINDOWS
	::Sleep(x);
#endif
}

static inline void yield() throw()
{
#ifdef LINUX
	::sched_yield();
#endif
#ifdef MSWINDOWS
	::Sleep(0);
#endif
}

static inline unsigned int id()
{
#ifdef LINUX
	return ::pthread_self();
#endif
#ifdef MSWINDOWS
	return ::GetCurrentThreadId();
#endif
}

}//namespace thread

namespace process {

#ifdef LINUX
	typedef pid_t ID;
#else
	typedef DWORD ID;
#endif

static inline ID id() throw()
{
#ifdef LINUX
	return ::pthread_self();
#else
	return ::GetCurrentProcessId();
#endif
}

static inline bool exists(ID pid)
{
#ifdef LINUX
	return (::kill(pid, 0) == 0);
#endif
}

//ID find(const char *);

// TODO: looks bad.
static inline bool kill(ID pid
#ifdef LINUX
		, int sig
#endif
		)
{
	return
#ifdef LINUX
	::kill(pid, sig) == 0;
#else
	::GenerateConsoleCtrlEvent(CTRL_BREAK_EVENT, pid) != FALSE;
#endif
}

}//namespace process

namespace Delphi { namespace TDateTime {

enum { epochDiff = 25569, secsPerDay = 86400 };

static inline double to(const time_t val)
{
	return static_cast<double>(val) / secsPerDay + epochDiff;
}

static inline time_t from(const double val)
{
	return static_cast<time_t>((static_cast<double>(val) - epochDiff) * secsPerDay);
}

}//namespace Delphi
}//namespace TDateTime

}//namespace tss

#endif
