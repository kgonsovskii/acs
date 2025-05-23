#ifndef TSS_SYNC_HPP_INCLUDED
#define TSS_SYNC_HPP_INCLUDED

#pragma once

#include "config.hpp"
#include "sys.hpp"
#ifdef LINUX
#include <cassert>
#include "nix/semaphore.hpp"
#include "nix/pthread.hpp"
#endif
#ifdef MSWINDOWS
#include "win/windows.hpp"
#endif
#include <boost/noncopyable.hpp>

namespace tss {

template <class T>
	struct Synchronizable: T
{};

template <class T>
struct ScopedLock
{
	ScopedLock(const T& sync_): sync(sync_)
	{
		sync.lock();
	}

	~ScopedLock()
	{
		sync.unlock();
	}

	const T& sync;
};

template <class Sync, class T>
struct LockPtr: private boost::noncopyable
{
	LockPtr(const Sync& sync_, T *p_): sync(sync_), p(p_)
	{
		sync.lock();
	}

	~LockPtr()
	{
		sync.unlock();
	}

	T *operator ->() const throw()
	{
		return p;
	}

	T& operator *() const throw()
	{
		return *p;
	}

	const Sync& sync;
	T * const p;
};//LockPtr

template <class Sync, typename T>
class Atomic
{
public:
	Atomic(const Sync& sync_, T val): sync(sync_), _val(val) {}
	void set(T val)
	{
		ScopedLock<Sync> asdfas(sync);
		_val = val;
	}
	T get() const
	{
		ScopedLock<Sync> qnfxc(sync);
		return _val;
	}
	T operator= (T rhs) { set(rhs); return rhs; }
	T operator! () const { return !get(); }
	T operator== (T rhs) const { return (get() == rhs); }
	T operator!= (T rhs) const { return (get() != rhs); }
	operator T() const { return get(); }
	const Sync& sync;
protected:
	T _val;
};//Atomic

template <class Sync>
class Trigger: public Atomic<Sync, bool>
{
public:
	typedef Atomic<Sync, bool> Base;
	Trigger(const Sync& sync_): Base(sync_, false) {}
	bool toggle()
	{
		const ScopedLock<Sync> anfxc(Base::sync);
		const bool ret = Base::_val;
		if (ret)
		{
			Base::_val = false;
		}
		return ret;
	}
};//Trigger

#ifdef LINUX

class MutexBase: private boost::noncopyable
{
public:
	~MutexBase()
	{
		os::pthread_mutex_destroy(&_obj);
	}

	pthread_mutex_t *handle() const throw() { return &_obj; }

	void lock() const
	{
		os::pthread_mutex_lock(&_obj);
	}

	void unlock() const
	{
		os::pthread_mutex_unlock(&_obj);
	}

protected:
	void _createHandle(pthread_mutexattr_t *attr)
	{
		os::pthread_mutex_init(&_obj, attr);
	}

private:
	mutable pthread_mutex_t _obj;

};//MutexBase

class Mutex: public MutexBase
{
public:
	Mutex()
	{
		_createHandle(NULL);
	}
};//Mutex

class MutexAttr
{
public:
	MutexAttr()
	{
		os::pthread_mutexattr_init(&_obj);
	}
	~MutexAttr()
	{
		os::pthread_mutexattr_destroy(&_obj);
	}
	pthread_mutexattr_t *handle() const throw()
	{
		return &_obj;
	}
private:
	mutable pthread_mutexattr_t _obj;

};//MutexAttr


class RecursiveMutex: public MutexBase
{
public:
	RecursiveMutex()
	{
		MutexAttr attr;
		os::pthread_mutexattr_settype(attr.handle(), PTHREAD_MUTEX_RECURSIVE);
		_createHandle(attr.handle());
	}
};//RecursiveMutex

namespace thread { typedef Mutex Synchronizer; }
//namespace thread { typedef RecursiveMutex Synchronizer; }

class Semaphore: private boost::noncopyable
{
public:
	Semaphore()
	{
		os::sem_init(&_obj, 0, 0);
	}

	~Semaphore()
	{
		os::sem_destroy(&_obj);
	}

	void set() const
	{
		os::sem_post(&_obj);
	}
	
	void wait() const
	{
		os::sem_wait(&_obj);
	}

	bool wait(unsigned int timeout) const
	{
		if (timeout != INFINITE)
		{
			const struct timespec abstime = {time(NULL) + timeout / 1000, (timeout % 1000) * 1000000};
			return os::sem_timedwait(&_obj, &abstime);
		} else
		{
			wait();
			return true;
		}
	}

	sem_t *handle() const throw() { return &_obj; }
	operator sem_t *() const throw() { return &_obj; }

private:
	mutable sem_t _obj;

};//Semaphore

class CondVar: private boost::noncopyable
{
public:
	CondVar()
	{
		os::pthread_cond_init(&_obj, NULL);
	}

	~CondVar()
	{
		os::pthread_cond_destroy(&_obj);
	}

	pthread_cond_t *handle() const throw() { return &_obj; }

	void set(bool broadcast) const
	{
		broadcast? os::pthread_cond_broadcast(&_obj): os::pthread_cond_signal(&_obj);
	}

	bool wait(pthread_mutex_t *mutex, unsigned int timeout) const
	{
		if (timeout != INFINITE)
		{
			const struct timespec abstime = {time(NULL) + timeout / 1000, (timeout % 1000) * 1000000};
			return os::pthread_cond_timedwait(&_obj, mutex, &abstime);
		} else
			return os::pthread_cond_wait(&_obj, mutex);
	}

private:
	mutable pthread_cond_t _obj;

};//CondVar

class Condition: private boost::noncopyable
{
public:
	Condition(bool broadcast): _broadcast(broadcast), _isSet(false), _isWaited(false) {}

	void set() const
	{
		ScopedLock<Mutex> hgfhg(_mutex);
		_isSet = true;
		if (_isWaited)
			_cv.set(_broadcast);
	}

	bool wait(unsigned int timeout) const
	{
		ScopedLock<Mutex> gjhf(_mutex);
		bool ret;
		if (_isSet)
			ret = true;
		else
		{
			_isWaited = true;
			ret = _cv.wait(_mutex.handle(), timeout);
		}
		if (!_broadcast)
			_isSet = false;
		return ret;
	}
	
	void reset() const
	{
		ScopedLock<Mutex> sdfg(_mutex);
		assert(_broadcast);
		_isSet = false;
	}

private:
	const bool _broadcast;
	Mutex _mutex;
	CondVar _cv;
	mutable bool _isSet;
	mutable bool _isWaited;

};//Condition

#endif//LINUX


#ifdef MSWINDOWS

class CriticalSection: private boost::noncopyable
{
public:
	CriticalSection() throw()
	{
		InitializeCriticalSection(&_obj);
	}

	~CriticalSection() throw()
	{
		DeleteCriticalSection(&_obj);
	}

	CRITICAL_SECTION *handle() const throw() { return &_obj; }

	void lock() const throw()
	{
		EnterCriticalSection(&_obj);
	}

	void unlock() const throw()
	{
		LeaveCriticalSection(&_obj);
	}

private:
	mutable CRITICAL_SECTION _obj;
};//CriticalSection

namespace thread { typedef CriticalSection Synchronizer; }

class Condition
{
public:
	Condition(bool broadcast): _evt(NULL, broadcast, FALSE, NULL) {}

	HANDLE handle() const throw() { return _evt.handle; }

	void set() const
	{
		os::SetEvent(_evt.handle);
	}

	bool wait(unsigned int timeout) const
	{
		return (os::WaitForSingleObject(_evt.handle, timeout) == WAIT_OBJECT_0);
	}

	void reset() const
	{
		os::ResetEvent(_evt.handle);
	}

private:
	os::Event _evt;
};//Condition

class Semaphore
{
public:
	Semaphore(): _cond(false) {}

	HANDLE handle() const throw() { return _cond.handle(); }

	void set() const
	{
		_cond.set();
	}

	void wait() const
	{
		_cond.wait(INFINITE);
	}

	bool wait(unsigned int timeout) const
	{
		return _cond.wait(timeout);
	}
private:
	Condition _cond;
};//Semaphore

#endif//MSWINDOWS

}//namespace tss

#define	TSS_SCOPED_THREAD_LOCK(sync)	const ScopedLock<thread::Synchronizer> threadLockObject(sync)

#endif
