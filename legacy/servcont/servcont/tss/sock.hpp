#ifndef TSS_SOCK_HPP_INCLUDED
#define TSS_SOCK_HPP_INCLUDED

#pragma once

#include "config.hpp"
#ifdef LINUX
#include <netinet/tcp.h>
#endif
#include <boost/noncopyable.hpp>
#include <string>

#ifdef LINUX
#include <sys/socket.h>
#include <netinet/in.h>
#	define	SOCKET			int
#	define	INVALID_SOCKET	-1
#	define	SOCKET_ERROR	-1
#	define	closesocket(s)	(::close(s))
#endif
#ifdef MSWINDOWS
#include <winsock2.h>
#	define	socklen_t		int
#	ifndef ECONNABORTED
#		define	ECONNABORTED	WSAECONNABORTED
#	endif
#	ifndef ETIMEDOUT
#		define	ETIMEDOUT		WSAETIMEDOUT
#	endif
#	ifndef EINPROGRESS
#		define	EINPROGRESS		WSAEWOULDBLOCK
#	endif
#	define	SHUT_RDWR		SD_BOTH
#	ifndef EINTR
#		define	EINTR			WSAEINTR
#	endif
#endif

namespace tss {

class Socket: public boost::noncopyable
{
public:
	enum Proto {TCP, UDP};
	explicit Socket(SOCKET handle) throw(): _handle(handle) {}
#ifdef LINUX
	Socket(Proto proto, bool = false);
#else
	explicit Socket(Proto proto);
#endif
	~Socket();
	operator SOCKET() const throw() { return _handle; }
	void bind(u_long, u_short);
	void connect(u_long, u_short);
	void connect(u_long, u_short, unsigned int);
	int write(const char *, int, int = 0) const;
	int write(const char *, int, const struct sockaddr_in *, int = 0) const;
	bool waitInput(unsigned int) const;
	int read(char *, int, int = 0) const;
	int read(char *, int, struct sockaddr_in *, int = 0) const;
#ifdef LINUX
	void bind(const char *);
	void connect(const char *);
	SOCKET accept() const;
	int write(const struct msghdr *, int = 0) const;
	int read(struct msghdr *, int = 0) const;
#endif
	void listen(int = SOMAXCONN);
	SOCKET accept(struct sockaddr_in *) const;
	void keepAlive(unsigned short);
	void NagleAlgo(bool);
	void getOpt(int, int, char *, socklen_t *) const;
	int getOpt(int, int) const;
	void setOpt(int, int, const char *, socklen_t);
	void setOpt(int level, int name, int value) { setOpt(level, name, reinterpret_cast<char *>(&value), sizeof(int)); }
	SOCKET handle() const throw() { return _handle; }
	void reuseAddr(bool yes) { setOpt(SOL_SOCKET, SO_REUSEADDR, yes); }
	void getName(struct sockaddr_in *name) const { return getName(_handle, name); }
	void shutdown(int);
	static void getName(SOCKET, struct sockaddr_in *);
	static std::string name2str(const struct sockaddr_in *);
	static struct sockaddr *initSockAddr(struct sockaddr_in *, u_long, u_short) throw();
	static int select(SOCKET, fd_set *, fd_set *, fd_set *, unsigned int);
private:
	SOCKET _handle;
};

class TCPServer: public Socket
{
public:
	TCPServer(const char *, unsigned short);
};

}//namespace tss

#endif
