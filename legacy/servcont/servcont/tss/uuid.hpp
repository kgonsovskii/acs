#ifndef TSS_UUID_HPP_INCLUDED
#define TSS_UUID_HPP_INCLUDED

#pragma once

#include "config.hpp"
#include <boost/cstdint.hpp>
#ifdef LINUX
#include <uuid/uuid.h>
#endif
#ifdef MSWINDOWS
#include <Rpc.h>
#pragma comment(lib, "Rpcrt4.lib")
#endif
#include <string>
#include <sstream>
#include <boost/array.hpp>

namespace tss
{

class uuid: public boost::array<boost::uint8_t, 16>
{
public:
	uuid()
	{
		assign(0);
	}

	explicit uuid(const void *p)
	{
		const boost::uint8_t * const pp = static_cast<const boost::uint8_t *>(p);
		std::copy(pp, pp + size(), begin());
	}

	bool isNull() const
	{
		return std::count(begin(), end(), 0) == static_cast<boost::array<boost::uint8_t, 16>::difference_type>(size());
	}

	operator std::string() const
	{
		std::ostringstream os;
		os << '{';
		os << std::hex << std::uppercase;
		_o(os, (*this)[3]);
		_o(os, (*this)[2]);
		_o(os, (*this)[1]);
		_o(os, (*this)[0]);
		os << '-';
		_o(os, (*this)[5]);
		_o(os, (*this)[4]);
		os << '-';
		_o(os, (*this)[7]);
		_o(os, (*this)[6]);
		os << '-';
		_o(os, (*this)[8]);
		_o(os, (*this)[9]);
		os << '-';
		_o(os, (*this)[10]);
		_o(os, (*this)[11]);
		_o(os, (*this)[12]);
		_o(os, (*this)[13]);
		_o(os, (*this)[14]);
		_o(os, (*this)[15]);
		os << '}';
		return os.str();
	}

	static uuid& gen(uuid& id)
	{
#ifdef LINUX
		::uuid_generate(*reinterpret_cast<uuid_t *>(id.c_array()));
#endif
#ifdef MSWINDOWS
		::UuidCreate(reinterpret_cast<UUID *>(id.c_array()));
#endif
		return id;
	}

	static uuid gen()
	{
		uuid id;
		gen(id);
		return id;
	}

protected:
	static void _o(std::ostringstream& os, boost::uint8_t x)
	{
		os.width(2);
		os.fill('0');
		os << static_cast<boost::uint16_t>(x);
	}
};

}

#endif
