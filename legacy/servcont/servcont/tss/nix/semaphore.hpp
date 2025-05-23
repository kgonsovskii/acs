#ifndef TSS_SEMAPHORE_HPP_INCLUDED
#define TSS_SEMAPHORE_HPP_INCLUDED

#pragma once

#include "../config.hpp"
#include <semaphore.h>
#include "../sys.hpp"

namespace tss { namespace os {

static inline void sem_init(sem_t *sem, int pshared, unsigned int value)
{
	if (::sem_init(sem, pshared, value) != 0)
		fatalError();
}

static inline void sem_destroy(sem_t *sem)
{
	if (::sem_destroy(sem) != 0)
		fatalError();
}

static inline void sem_post(sem_t *sem)
{
	if (::sem_post(sem) != 0)
		fatalError();
}

static inline void sem_wait(sem_t *sem)
{
	if (::sem_wait(sem) != 0)
		fatalError();
}

static inline bool sem_timedwait(sem_t *sem, const struct timespec *abstime)
{
	bool ret;
	if (::sem_timedwait(sem, abstime) != 0)
	{
		ret = errNo() != ETIMEDOUT;
		if (ret)
			fatalError();
	} else
		ret = true;
	return ret;
}

}//namespace os
}//namespace tss

#endif//TSS_SEMAPHORE_HPP_INCLUDED
