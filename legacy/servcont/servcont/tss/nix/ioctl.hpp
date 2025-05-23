#ifndef TSS_IOCTL_HPP_INCLUDED
#define TSS_IOCTL_HPP_INCLUDED

#pragma once

#include "../config.hpp"
#include <sys/ioctl.h>
#include "../sys.hpp"

namespace tss { namespace os {

static inline int ioctl(int d, int request, int x)
{
	const int ret = ::ioctl(d, request, x);
	if (ret == -1)
		fatalError();
	return ret;
}

}//namespace os
}//namespace tss

#endif//TSS_IOCTL_HPP_INCLUDED
