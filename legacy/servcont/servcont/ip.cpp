#include "pch.h"
#include <tss/ip.hpp>
#ifdef LINUX
#include <cstring>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
#endif
#include <boost/format.hpp>

using namespace std;
using namespace boost;

namespace tss { namespace ip {

string errDesc(int ec)
{
#ifdef LINUX
	return str(format("sock ec: %d, desc: '%s'") %ec %strerror(ec));
#endif
#ifdef MSWINDOWS
	return str(format("sock ec: %d") %ec);
#endif
}

string errMsg(int ec, const string& msg)
{
	return str(format("%s; %s.") %msg %errDesc(ec));
}

string errMsg(const string& msg)
{
	return str(format("%s; %s.") %msg %errDesc(errNo()));
}

bool isDottedAddr(string s)
{
	s.push_back('.');
	int len = 0, dotCount = 0, valCount = 0;
	char buf[4];
	for (string::const_iterator it = s.begin(); it != s.end(); ++it) {
		if (isdigit(*it)) {
			if (len < 3)
				buf[len++] = *it;
			else
				return false;
		} else if (*it == '.') {
			if (++dotCount > 4)
				return false;
			if (len) {
				buf[len] = '\0';
				if (atoi(buf) > 255)
					return false;
				if (++valCount > 4)
					return false;
				len = 0;
			}
		} else
			return false;
	}
	return (valCount == 4 && dotCount == 4);
}

string hostName()
{
	char buf[256];
	ip::check(gethostname(buf, 255), "Can't get host name");
	string ret(buf);
	return ret;
}

struct in_addr resolveHost(const char *s, IPAddrVector *v)
{
	struct hostent *he = gethostbyname(s);
	if (!he)
#ifdef LINUX
	{
		int ec = h_errno;
		throw ip::Exception(ec, str(format("Can't resolve host '%s'; h_errno: %d, desc: '%s'.") %s %ec %hstrerror(ec)));
	}
#endif
#ifdef MSWINDOWS
		ip::throwException(str(format("Can't resolve host '%s'") %s));
#endif
	struct in_addr ret = *reinterpret_cast<struct in_addr *>(he->h_addr_list[0]);
	if (v) {
		v->push_back(ret);
		int i=1;
		while (he->h_addr_list[i])
			v->push_back(*reinterpret_cast<struct in_addr *>(he->h_addr_list[i++]));
	}
	return ret;
}

unsigned int host2addr(const char *s)
{
	unsigned int ret;
	if (isDottedAddr(s))
		ret = inet_addr(s);
	else {
		ret = atoi(s);
		if (ret)
			ret = htonl(ret);
		else
			ret = resolveHost(s, NULL).s_addr;
	}
	return ret;
}

const char *addr2dns(unsigned int ip)
{
	char *r = inet_ntoa(*reinterpret_cast<struct in_addr *>(&ip));
	if (r == NULL)
		throw std::runtime_error("Can't convert IP address to dotted string.");
	return r;
}

}}
