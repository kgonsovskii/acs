#ifndef TSS_TIME_HPP_INCLUDED
#define TSS_TIME_HPP_INCLUDED

#pragma once

#ifdef LINUX
#include "nix/sys/time.hpp"
#endif

#ifdef MSWINDOWS
#include "win/time.hpp"
#endif

namespace tss { namespace os {

static inline const struct tm *localtime() throw()
{
	return os::localtime(os::time());
}

}}

#endif//TSS_TIME_HPP_INCLUDED
