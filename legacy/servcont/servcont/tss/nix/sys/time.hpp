#ifndef TSS_NIX_SYS_TIME_HPP_INCLUDED
#define TSS_NIX_SYS_TIME_HPP_INCLUDED

#pragma once

#include "../../config.hpp"
#include <ctime>
#include <sys/time.h>
#include "../../sys.hpp"

namespace tss { namespace os {

static inline time_t time()
{
	time_t ret;
	::time(&ret);
	if (ret == static_cast<time_t>(-1))
		fatalError();
	return ret;
}

static inline const struct tm *localtime(time_t timer)
{
	const struct tm * const ret = ::localtime(&timer);
	if (!ret)
		fatalError();
	return ret;
}

}//namespace os
}//namespace tss

#endif//TSS_NIX_SYS_TIME_HPP_INCLUDED
