#ifndef TSS_IP_HPP_INCLUDED
#define TSS_IP_HPP_INCLUDED

#pragma once

#include "config.hpp"
#ifdef LINUX
#include <cerrno>
#include <netinet/in.h>
#endif
#ifdef MSWINDOWS
#include <winsock2.h>
#endif
#include <stdexcept>
#include <vector>
#include <string>

namespace tss { namespace ip {

typedef std::vector<struct in_addr> IPAddrVector;

class Exception: public std::runtime_error {
public:
	Exception(int errNo_, const std::string& msg): std::runtime_error(msg), errNo(errNo_) {}
	const int errNo;
};

static inline int errNo() throw()
{
#ifdef LINUX
	return errno;
#else
	return WSAGetLastError();
#endif
}

static inline void errNo(int val) throw()
{
#ifdef LINUX
	errno = val;
#else
	WSASetLastError(val);
#endif
}

std::string errDesc(int);
std::string errMsg(int, const std::string&);
std::string errMsg(const std::string&);
static inline void throwException(const std::string& msg) { const int ec = ip::errNo(); throw ip::Exception(ec, ip::errMsg(ec, msg)); }
static inline void check(int r, const std::string& errMsg)
{
	if (-1 == r)
		ip::throwException(errMsg);
}
bool isDottedAddr(std::string);
std::string hostName();
struct in_addr resolveHost(const char *, IPAddrVector *v = NULL);
unsigned int host2addr(const char *);
const char *addr2dns(unsigned int);

}}

#endif
