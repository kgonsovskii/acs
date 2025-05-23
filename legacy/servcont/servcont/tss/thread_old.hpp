#ifndef TSS_THREAD_HPP_INCLUDED
#define TSS_THREAD_HPP_INCLUDED

#pragma once

#include "config.hpp"
#ifdef LINUX
#include "nix/pthread.hpp"
#endif
#ifdef MSWINDOWS
#include "win/windows.hpp"
#include "win/process.hpp"
#endif
#include <boost/noncopyable.hpp>

namespace tss {

class Thread: boost::noncopyable
{
public:
	void start()
	{
#ifdef LINUX
		os::pthread_create(&_id, NULL, &_thread_func, this);
#endif
#ifdef MSWINDOWS
		_handle = os::_beginthreadex(NULL, 0, &_thread_func, this, 0, &_id);
#endif
	}

	void join() const
	{
#ifdef LINUX
		os::pthread_join(id(), NULL);
#endif
#ifdef MSWINDOWS
		os::WaitForSingleObject(handle(), INFINITE);
		os::CloseHandle(_handle);
#endif
	}

#ifdef LINUX
	pthread_t id() const throw() { return _id; }
#endif
#ifdef MSWINDOWS
	unsigned id() const throw() { return _id; }
	HANDLE handle() const throw() { return _handle; }
#endif

protected:
	virtual void _run() throw() = 0;
private:
#ifdef LINUX
	pthread_t _id;
	static void *_thread_func(void *obj)
#endif
#ifdef MSWINDOWS
	unsigned  _id;
	HANDLE _handle;
	static unsigned WINAPI _thread_func(void *self)
#endif
	{
		static_cast<Thread *>(self)->_run();
#ifdef LINUX
		return NULL;
#endif
#ifdef MSWINDOWS
		_endthreadex(0);
		return 0;
#endif
	}
};//Thread

}//namespace tss

#endif
