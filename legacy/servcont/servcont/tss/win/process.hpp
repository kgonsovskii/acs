#ifndef TSS_WIN_PROCESS_HPP_INCLUDED
#define TSS_WIN_PROCESS_HPP_INCLUDED

#pragma once

#include "../config.hpp"
#include <process.h>
#include "../sys.hpp"

namespace tss { namespace os {

static inline HANDLE _beginthreadex(void *security,
						   unsigned stack_size,
						   unsigned (WINAPI *start_address)(void *),
						   void *arglist, unsigned initflag,
						   unsigned *thrdaddr)
{
	const HANDLE ret = reinterpret_cast<HANDLE>(::_beginthreadex(security, stack_size, start_address, arglist, initflag, thrdaddr));
	if (ret == NULL)
		fatalError();
	return ret;
}

}//namespace os
}//namespace tss

#endif
