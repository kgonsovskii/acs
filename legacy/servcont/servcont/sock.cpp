#include "pch.h"
#include <tss/sock.hpp>

#include <tss/sys.hpp>
#include <tss/ip.hpp>
#ifdef LINUX
#include <sys/un.h>
#include <tss/nix/fcntl.hpp>
//#include <sys/select.h>
#endif
#ifdef MSWINDOWS
#include <MSTcpIP.h>
#endif
#include <memory.h>
#include <boost/format.hpp>

using namespace std;
using namespace boost;

namespace tss {

static void chkAborted(const int e)
{
	if (e == ECONNABORTED || e == EINTR)
		throw Abort();
}

Socket::Socket(Proto proto
#ifdef LINUX
			   , bool isLocal
#endif
			   )
{
	switch (proto) {
	case TCP:
#ifdef LINUX		
		_handle = ::socket(isLocal? PF_LOCAL: PF_INET, SOCK_STREAM, isLocal? 0: IPPROTO_TCP);
#else
		_handle = ::socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
#endif
		break;
	case UDP:
#ifdef LINUX
		_handle = ::socket(isLocal? PF_LOCAL: PF_INET, SOCK_DGRAM, isLocal? 0: IPPROTO_UDP);
#else
		_handle = ::socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
#endif
		break;
	default:
		assert(!"Unsupported socket protocol");
	}
	if (INVALID_SOCKET == _handle)
		throw FatalError(ip::errMsg("socket()"));
}

Socket::~Socket()
{
	trace("~Socket()");
	if (SOCKET_ERROR == closesocket(_handle))
		throw FatalError(ip::errMsg("closesocket()"));
}

void Socket::bind(u_long addr, u_short port)
{
	struct sockaddr_in name;
	const struct sockaddr *pname = initSockAddr(&name, addr, port);
	ip::check(::bind(_handle, pname, sizeof(struct sockaddr_in)), str(format("Socket can't bind to '%s'") %name2str(&name)));
}

void Socket::connect(u_long addr, u_short port)
{
	struct sockaddr_in name;
	const struct sockaddr *pname = initSockAddr(&name, addr, port);
	ip::check(::connect(_handle, pname, sizeof(struct sockaddr_in)), str(format("Socket can't connect to %s") %name2str(&name)));
}

void Socket::connect(u_long addr, u_short port, unsigned int timeout)
{
#ifdef LINUX
	os::fcntl(_handle, F_SETFL, O_NONBLOCK | os::fcntl(_handle, F_GETFL, 0));
#endif
#ifdef MSWINDOWS
	u_long nonblock;
	nonblock = ~0;
	if (-1 == ::ioctlsocket(_handle, FIONBIO, &nonblock))
		throw FatalError(ip::errMsg("ioctlsocket()"));
#endif

	struct sockaddr_in name;
	const struct sockaddr *pname = initSockAddr(&name, addr, port);
	if (SOCKET_ERROR == ::connect(_handle, pname, sizeof(struct sockaddr_in)))
	{
#ifdef LINUX
		if (EINPROGRESS != ip::errNo())
#endif
#ifdef MSWINDOWS
		if (WSAEWOULDBLOCK != ip::errNo())
#endif
			ip::throwException(str(format("Socket can't connect to %s") %name2str(&name)));

		fd_set fds;
		FD_ZERO(&fds);
		FD_SET(_handle, &fds);
		int r = select(_handle + 1, NULL, &fds, NULL, timeout);
		if (0 == r)
			throw ip::Exception(ETIMEDOUT, ip::errMsg(ETIMEDOUT, str(format("Socket can't connect to %s") %name2str(&name))));
	}
#ifdef LINUX
	os::fcntl(_handle, F_SETFL, ~O_NONBLOCK & os::fcntl(_handle, F_GETFL, 0));
#endif
#ifdef MSWINDOWS
	nonblock = 0;
	if (SOCKET_ERROR == ::ioctlsocket(_handle, FIONBIO, &nonblock))
		throw FatalError(ip::errMsg("ioctlsocket()"));
#endif
}

void Socket::getOpt(int level, int name, char *value, socklen_t *size) const
{
	ip::check(getsockopt(_handle, level, name, value, size), "getsockopt()");
}

int Socket::getOpt(int level, int name) const
{
	int value;
	socklen_t len = sizeof(int);
	getOpt(level, name, reinterpret_cast<char *>(&value), &len);
	return value;
}

void Socket::setOpt(int level, int name, const char *value, socklen_t size)
{
	ip::check(setsockopt(_handle, level, name, value, size), "setsockopt()");
}

void Socket::getName(SOCKET _handle, struct sockaddr_in *name)
{
	socklen_t len = sizeof(struct sockaddr_in);
	ip::check(getsockname(_handle, reinterpret_cast<struct sockaddr *>(name), &len), "getsockname()");
}

string Socket::name2str(const struct sockaddr_in *name)
{
	format f("%s:%u");
	f %ip::addr2dns(name->sin_addr.s_addr) %htons(name->sin_port);
	return f.str();
}

struct sockaddr *Socket::initSockAddr(struct sockaddr_in *name, u_long addr, u_short port) throw()
{
	memset(name, 0, sizeof(struct sockaddr_in));
	name->sin_family = AF_INET;
	name->sin_addr.s_addr = addr;
	name->sin_port = port;
	return reinterpret_cast<struct sockaddr *>(name);
}

int Socket::write(const char *buf, int size, int flags) const
{
	const int r = ::send(_handle, buf, size, flags);
	if (SOCKET_ERROR == r)
	{
		chkAborted(ip::errNo());
		ip::throwException("Socket can't send");
	}
	return r;
}

int Socket::write(const char *buf, int size, const struct sockaddr_in* to, int flags) const
{
	const int r = ::sendto(_handle, buf, size, flags, reinterpret_cast<const struct sockaddr *>(to), sizeof(struct sockaddr_in));
	if (SOCKET_ERROR == r)
	{
		chkAborted(ip::errNo());
		ip::throwException("Socket can't send");
	}
	return r;
}

#ifdef LINUX
void Socket::bind(const char *filename)
{
	struct sockaddr_un name;
	name.sun_family = AF_LOCAL;
	strcpy(name.sun_path, filename);
	const struct sockaddr *pname = reinterpret_cast<const struct sockaddr *>(&name);
	ip::check(::bind(_handle, pname, SUN_LEN(&name)), str(format("Socket can't bind to '%s'") %filename));
}

void Socket::connect(const char *filename)
{
	struct sockaddr_un name;
	name.sun_family = AF_LOCAL;
	strcpy(name.sun_path, filename);
	const struct sockaddr *pname = reinterpret_cast<const struct sockaddr *>(&name);
	ip::check(::connect(_handle, pname, SUN_LEN(&name)), str(format("Socket can't connect to %s") %filename));
}

SOCKET Socket::accept() const
{
	socklen_t len = 0;
	const SOCKET s = ::accept(_handle, NULL, &len);
	if (INVALID_SOCKET == s)
		throw FatalError(ip::errMsg("accept()"));
	return s;
}

int Socket::write(const struct msghdr *msg, int flags /*= 0*/) const
{
	const int r = ::sendmsg(_handle, msg, flags);
	if (SOCKET_ERROR == r)
	{
		chkAborted(ip::errNo());
		ip::throwException("Socket can't send");
	}
	return r;
}

int Socket::read(struct msghdr *msg, int flags /*= 0*/) const
{
	const int r = ::recvmsg(_handle, msg, flags);
	if (SOCKET_ERROR == r)
	{
		chkAborted(ip::errNo());
		ip::throwException("Socket can't receive");
	} else if (0 == r)
		throw Abort();
	return r;
}
#endif

bool Socket::waitInput(unsigned int timeout) const
{
	fd_set rfds;
	FD_ZERO(&rfds);
	FD_SET(_handle, &rfds);
	const int r = select(_handle + 1, &rfds, NULL, NULL, timeout);
	return (r > 0);
}

int Socket::read(char *buf, int size, int flags) const
{
	const int r = ::recv(_handle, buf, size, flags);
	if (SOCKET_ERROR == r)
	{
		chkAborted(ip::errNo());
		ip::throwException("Socket can't receive");
	} else if (0 == r)
		throw Abort();
	return r;
}

int Socket::read(char *buf, int size, struct sockaddr_in *from, int flags) const
{
	socklen_t len = sizeof(struct sockaddr_in);
	const int r = ::recvfrom(_handle, buf, size, flags, reinterpret_cast<struct sockaddr *>(from), &len);
	if (SOCKET_ERROR == r)
	{
		chkAborted(ip::errNo());
		ip::throwException("Socket can't receive");
	} else if (0 == r)
		throw Abort();
	return r;
}

void Socket::keepAlive(unsigned short seconds)
{
#ifdef LINUX
	setOpt(SOL_TCP, TCP_KEEPIDLE, seconds? seconds: 7200);
	setOpt(SOL_TCP, TCP_KEEPINTVL, seconds? 1: 75);
	setOpt(SOL_SOCKET, SO_KEEPALIVE, seconds? 1: 9);
#endif
#ifdef MSWINDOWS
	struct tcp_keepalive ka;
	ka.onoff = seconds != 0;
	if (seconds)
	{
		ka.keepalivetime = seconds * 1000;
		ka.keepaliveinterval = 1000;
	}
	DWORD done;
	if (SOCKET_ERROR == WSAIoctl(_handle, SIO_KEEPALIVE_VALS, &ka, sizeof(ka), NULL, 0, &done, NULL, NULL))
		throw FatalError(ip::errMsg("WSAIoctl()"));
#endif
}

void Socket::listen(int backlog)
{
	ip::check(::listen(_handle, backlog), "listen()");
}

SOCKET Socket::accept(struct sockaddr_in *name) const
{
	socklen_t len = sizeof(struct sockaddr_in);
	SOCKET s = ::accept(_handle, reinterpret_cast<struct sockaddr *>(name), &len);
	if (INVALID_SOCKET == s)
		throw FatalError(ip::errMsg("accept()"));
	return s;
}

void Socket::NagleAlgo(bool isOn)
{
	const int val = isOn? 0: 1;
	setOpt(IPPROTO_TCP, TCP_NODELAY, val);
}

int Socket::select(SOCKET nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, unsigned int timeout)
{
	struct timeval tv = {timeout / 1000, (timeout % 1000) * 1000};
	const int r = ::select(static_cast<int>(nfds), readfds, writefds, exceptfds, &tv);
	if (-1 == r)
	{
		chkAborted(ip::errNo());
		throw FatalError(ip::errMsg("select()"));
	}
	return r;
}

void Socket::shutdown(int how)
{
	if (SOCKET_ERROR == ::shutdown(_handle, how))
		throw FatalError(ip::errMsg("shutdown()"));
}

TCPServer::TCPServer(const char *host, unsigned short port): Socket(Socket::TCP)
{
	reuseAddr(true);
	bind(ip::host2addr(host), htons(port));
	listen();
}

}
