#ifndef TSS_CONFIG_HPP_INCLUDED
#define TSS_CONFIG_HPP_INCLUDED

#pragma once

#if !defined(MSWINDOWS) && ( defined(WIN32) || defined(_WIN32) )
#	define	MSWINDOWS
#endif

#ifdef linux
#	define	LINUX
#endif

#ifdef _MSC_VER
#	pragma warning(disable: 4996 4355 4290)
	// 4996: <symbol> was declared deprecated
	// 4355: 'this' : used in base member initializer list
	// 4290: C++ exception specification ignored except to indicate a function is not __declspec(nothrow)
#endif

#if defined(MSWINDOWS) && !defined(WIN32_LEAN_AND_MEAN)
#	define WIN32_LEAN_AND_MEAN
#endif

#if defined(MSWINDOWS) && !defined(_USE_32BIT_TIME_T)
#	define _USE_32BIT_TIME_T
#endif

#endif
