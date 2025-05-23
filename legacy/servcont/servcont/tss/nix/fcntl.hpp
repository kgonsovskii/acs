#ifndef TSS_NIX_FCNTL_HPP_INCLUDED
#define TSS_NIX_FCNTL_HPP_INCLUDED

#pragma once

#include "../config.hpp"
#include <fcntl.h>
#include "../sys.hpp"

namespace tss { namespace os {

static inline int open(const char *path, int oflag)
{
	trace(path);
	const int ret = ::open(path, oflag);
	if (ret == -1)
		fatalError();
	return ret;
}

static inline void close(int fd)
{
	if (::close(fd) != 0)
		fatalError();
}

static inline int fcntl(int fd, int cmd, int arg)
{
	const int ret = ::fcntl(fd, cmd, arg);
	if (ret == -1)
		fatalError();
	return ret;
}

static inline ssize_t read(int fd, char *buf, size_t count)
{
	const ssize_t ret = ::read(fd, buf, count);
	if (ret == -1)
		fatalError();
	return ret;
}

static inline ssize_t write(int fd, const void *buf, size_t count)
{
	const ssize_t ret = ::write(fd, buf, count);
	if (ret == -1)
		fatalError();
	return ret;
}


}//namespace os
}//namespace tss

#endif
