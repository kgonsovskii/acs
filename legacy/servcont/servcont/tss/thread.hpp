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
#include <boost/scoped_ptr.hpp>

namespace tss {

class Thread: boost::noncopyable
{
public:
	struct Impl
	{
		virtual ~Impl() {}
		virtual void operator() () throw() = 0;
	};//Impl

	Thread(Impl *pimpl): _pimpl(pimpl)
	{
#ifdef LINUX
		os::pthread_create(&_id, NULL, &_thread_func, _pimpl.get());
#endif
#ifdef MSWINDOWS
		_handle = os::_beginthreadex(NULL, 0, &_thread_func, _pimpl.get(), 0, &_id);
#endif
	}

	~Thread()
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
	pthread_t id() const { return _id; }
#endif
#ifdef MSWINDOWS
	unsigned id() const { return _id; }
	HANDLE handle() const { return _handle; }
#endif

	Impl *pimpl() throw() { return _pimpl.get(); }

	template <class T>
	T *pimpl() throw() { return static_cast<T *>(_pimpl.get()); }

private:
	boost::scoped_ptr<Impl> _pimpl;
#ifdef LINUX
	pthread_t _id;
	static void *_thread_func(void *obj)
#endif
#ifdef MSWINDOWS
	unsigned  _id;
	HANDLE _handle;
	static unsigned WINAPI _thread_func(void *obj)
#endif
	{
		(*static_cast<Impl *>(obj))();
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
