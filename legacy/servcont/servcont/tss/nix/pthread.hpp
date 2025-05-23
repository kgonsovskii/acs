#ifndef TSS_PTHREAD_HPP_INCLUDED
#define TSS_PTHREAD_HPP_INCLUDED

#pragma once

#include "../config.hpp"
#include <pthread.h>
#include "../sys.hpp"

namespace tss { namespace os {

static inline void pthread_create(pthread_t *thread, const pthread_attr_t *attr, void *(*start_routine)(void*), void *arg)
{
	if (::pthread_create(thread, attr, start_routine, arg) != 0)
		fatalError();
}

static inline void pthread_join(pthread_t thread, void **value_ptr)
{
	if (::pthread_join(thread, value_ptr) != 0)
		fatalError();
}

static inline void pthread_mutex_destroy(pthread_mutex_t *mutex)
{
	if (::pthread_mutex_destroy(mutex))
		fatalError();
}

static inline void pthread_mutex_lock(pthread_mutex_t *mutex)
{
	if (::pthread_mutex_lock(mutex))
		fatalError();
}

static inline void pthread_mutex_unlock(pthread_mutex_t *mutex)
{
	if (::pthread_mutex_unlock(mutex))
		fatalError();
}

static inline void pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr)
{
	if (::pthread_mutex_init(mutex, attr))
		fatalError();
}

static inline void pthread_mutexattr_init(pthread_mutexattr_t *attr)
{
	if (::pthread_mutexattr_init(attr))
		fatalError();
}

static inline void pthread_mutexattr_destroy(pthread_mutexattr_t *attr)
{
	if (::pthread_mutexattr_destroy(attr))
		fatalError();
}

static inline void pthread_mutexattr_settype(pthread_mutexattr_t *attr, int type)
{
	if (::pthread_mutexattr_settype(attr, type))
		fatalError();
}

static inline void pthread_cond_init(pthread_cond_t *cond, const pthread_condattr_t *attr)
{
	if (::pthread_cond_init(cond, attr))
		fatalError();
}

static inline void pthread_cond_destroy(pthread_cond_t *cond)
{
	if (::pthread_cond_destroy(cond))
		fatalError();
}

static inline void pthread_cond_signal(pthread_cond_t *cond)
{
	if (::pthread_cond_signal(cond))
		fatalError();
}

static inline void pthread_cond_broadcast(pthread_cond_t *cond)
{
	if (::pthread_cond_broadcast(cond))
		fatalError();
}

static inline bool pthread_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex)
{
	const int r = ::pthread_cond_wait(cond, mutex);
	if (r && (r != ETIMEDOUT))
		fatalError();
	return (r != ETIMEDOUT);
}

static inline bool pthread_cond_timedwait(pthread_cond_t *cond, pthread_mutex_t *mutex, const struct timespec *abstime)
{
	const int r = ::pthread_cond_timedwait(cond, mutex, abstime);
	if (r && (r != ETIMEDOUT))
		fatalError();
	return (r != ETIMEDOUT);
}

}//namespace os
}//namespace tss

#endif//TSS_PTHREAD_HPP_INCLUDED
