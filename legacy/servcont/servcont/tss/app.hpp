#ifndef TSS_APP_HPP_INCLUDED
#define TSS_APP_HPP_INCLUDED

#pragma once

#include "config.hpp"
#ifdef MSWINDOWS
#ifndef TSS_NO_WINSOCK
#include <winsock2.h>
#endif
#endif
#include <csignal>
#ifndef NDEBUG
#include <cstdio>
#endif
#include <boost/noncopyable.hpp>
#include <boost/format.hpp>
#include "sys.hpp" // log(), FatalError

#ifdef MSWINDOWS
#ifndef TSS_NO_WINSOCK
#pragma comment(lib, "ws2_32.lib")
#endif
#endif

namespace tss {

class Application: private boost::noncopyable
{
protected:
	Application(const char *name_, unsigned short version_, int argc_, char **argv_)
		:name(name_), version(version_), argc(argc_), argv(argv_)
	{
#ifdef MSWINDOWS
#ifndef TSS_NO_WINSOCK
		WSADATA data;
		const int r = WSAStartup(WINSOCK_VERSION, &data);
		if (r != 0)
			throw FatalError(boost::str(boost::format("WinSock2 Error. Code: %d.") %r));
#endif
#endif

		signal(SIGINT, &_signalHandler);
#ifdef LINUX
		signal(SIGPIPE, SIG_IGN);
#endif
		signal(SIGTERM, &_signalHandler);
#ifdef MSWINDOWS
		signal(SIGBREAK, &_signalHandler);

		if( SetConsoleCtrlHandler( (PHANDLER_ROUTINE) CtrlHandler, TRUE ) )
		{
			trace("The Control Handler is installed");
		}
#endif
		log(boost::str(boost::format("%s v%u.%u %s.") %name %(version >> 8) %(version & 0xFF) %"start").c_str());
	}

	~Application()
	{
		log(boost::str(boost::format("%s v%u.%u %s.") %name %(version >> 8) %(version & 0xFF) %"stop").c_str());
#ifdef MSWINDOWS
#ifndef TSS_NO_WINSOCK
		WSACleanup();
#endif
#endif
	}

	static void _signalHandler(int signal)
	{
		_terminated = 1;
#ifndef NDEBUG
		printf("signal: %d\n", signal);
#endif
	}

#ifdef MSWINDOWS
	static BOOL CtrlHandler( DWORD fdwCtrlType )
	{
		switch( fdwCtrlType )
		{
			// Handle the CTRL-C signal.
		case CTRL_C_EVENT:
			trace( "Ctrl-C event" );
			return FALSE;

			// CTRL-CLOSE: confirm that the user wants to exit.
		case CTRL_CLOSE_EVENT:
			trace( "Ctrl-Close event" );
			return FALSE;

			// Pass other signals to the next handler.
		case CTRL_BREAK_EVENT:
			trace( "Ctrl-Break event" );
			return FALSE;

		case CTRL_LOGOFF_EVENT:
			trace( "Ctrl-Logoff event" );
			return TRUE;

		case CTRL_SHUTDOWN_EVENT:
			trace( "Ctrl-Shutdown event" );
			return TRUE;

		default:
			return FALSE;
		}
	}
#endif

	static volatile sig_atomic_t _terminated;

public:

	template <class T>
	static T& init(int argc_, char **argv_)
	{
		static T ret(argc_, argv_);
		return ret;
	}

	bool terminated() const throw() { return _terminated != 0; }

	const char * const name;
	const unsigned short version;
	const int argc;
	const char * const * const argv;
};

volatile sig_atomic_t Application::_terminated = 0;

}

#endif
