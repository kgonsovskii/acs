#ifndef TSS_ASSERTNOIOSTREAM_HPP_INCLUDED
#define TSS_ASSERTNOIOSTREAM_HPP_INCLUDED

#pragma once

#include "config.hpp"

#ifdef LINUX
#	ifdef _GLIBCXX_IOSTREAM
#		error IOSTREAM
#	endif
#endif

#ifdef MSWINDOWS
#	ifdef _IOSTREAM_
#		error IOSTREAM
#	endif
#endif

#endif
