#ifndef	TSS_TERMIOS_HPP_INCLUDED
#define	TSS_TERMIOS_HPP_INCLUDED

#pragma once

#include "../config.hpp"
#include <termios.h>
#include <unistd.h>
#include "../sys.hpp"

namespace tss { namespace os {

static inline void tcgetattr(int fd, struct termios *p)
{
	if (::tcgetattr(fd, p) == -1)
		fatalError();
}

static inline void tcsetattr(int fd, int optional_actions, const struct termios *p)
{
	if (::tcsetattr(fd, optional_actions, p) == -1)
		fatalError();
}

static inline void cfsetispeed(struct termios *p, speed_t speed)
{
	if (::cfsetispeed(p, speed) == -1)
		fatalError();
}

static inline void cfsetospeed(struct termios *p, speed_t speed)
{
	if (::cfsetospeed(p, speed) == -1)
		fatalError();
}

static inline void tcdrain(int fd)
{
	if (::tcdrain(fd) == -1)
		fatalError();
}

}}

#endif
