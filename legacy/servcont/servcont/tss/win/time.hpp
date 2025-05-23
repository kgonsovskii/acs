#ifndef TSS_WIN_TIME_HPP_INCLUDED
#define TSS_WIN_TIME_HPP_INCLUDED

#pragma once

#include "../config.hpp"
#include <ctime>

namespace tss { namespace os {

static inline time_t time() throw()
{
	time_t ret;
	::time(&ret);
	return ret;
}

static inline const struct tm *localtime(time_t timer) throw()
{
	return ::localtime(&timer);
}

}//namespace os
}//namespace tss

#endif//TSS_WIN_TIME_HPP_INCLUDED
