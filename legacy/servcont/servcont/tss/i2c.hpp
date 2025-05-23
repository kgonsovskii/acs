#ifndef TSS_I2C_HPP_INCLUDED
#define TSS_I2C_HPP_INCLUDED

#pragma once

#include "config.hpp"
#include "nix/nix.hpp"

namespace tss
{

class I2C: public os::Handle
{
public:
	struct O
	{
		O(char *staticBuf): p(staticBuf) {}
		char& operator [](char idx) throw()
		{
			return p[idx + 1];
		}
		operator char *() throw()
		{
			return (p + 1);
		}
		char *p;
	};
	I2C(char);
	void write(const char *, char) const;
	void write(char, char *, char) const;
	void write(char, O&, char) const;
	int read(char, char *, char) const;
	const char id;
	static const char * const devStr;
};

}

#endif
