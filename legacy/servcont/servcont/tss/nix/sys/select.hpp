#ifndef TSS_NIX_SYS_SELECT_HPP_INCLUDED
#define TSS_NIX_SYS_SELECT_HPP_INCLUDED

#pragma once

#include "../../config.hpp"
#include <sys/select.h>
#include "../../sys.hpp"

namespace tss { namespace os {

static inline int select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout)
{
	const int r = ::select(nfds, readfds, writefds, exceptfds, timeout);
	if (-1 == r)
		fatalError();
	return r;
}

}}

#endif
