#ifndef TSS_STR_HPP_INCLUDED
#define TSS_STR_HPP_INCLUDED

#pragma once

#include "config.hpp"
#include <ctype.h>
#include <cassert>

namespace tss { namespace str {

static bool equal(const char a, const char b)
{
	return (a == b);
}

static bool equali(const char a, const char b)
{
	return (toupper(a) == toupper(b));
}

template <class T1, class T2, class Pr>
static bool equal(const T1& a, const T2& b, Pr cmp)
{
	assert(a.size() == b.size());
	typename T1::const_iterator ita = a.begin();
	typename T2::const_iterator itb = b.begin();
	for (; ita != a.end(); ++ita, ++itb)
		if (!cmp(*ita, *itb))
			return false;
	return true;
}

template <class T1, class T2>
static bool equal(const T1& a, const T2& b, bool caseSensitive)
{
	if (a.size() != b.size())
		return false;
	return equal(a, b, caseSensitive? &equal: &equali);
}

}}

#endif
