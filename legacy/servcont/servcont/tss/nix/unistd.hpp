#ifndef TSS_NIX_UNISTD_HPP_INCLUDED
#define TSS_NIX_UNISTD_HPP_INCLUDED

#pragma once

#include "../config.hpp"
#include <unistd.h>
#include "../sys.hpp"

namespace tss { namespace os
{

static inline int fsync(int fd)
{
	const int ret = ::fsync(fd);
	if (ret == -1)
		fatalError();
	return ret;
}

}}

#endif
