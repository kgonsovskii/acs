#ifndef TSS_GPIO_HPP_INCLUDED
#define TSS_GPIO_HPP_INCLUDED

#pragma once

#include "config.hpp"
#include "nix/nix.hpp"
#include <boost/noncopyable.hpp>

namespace tss
{

class GPIO: private boost::noncopyable
{
public:
	enum Direction { high, low, in };
	GPIO(char);
	~GPIO();
	void setDirection(Direction);
	bool isIn() const;
	void value(bool) const;
	bool value() const;
	const char no;
protected:
	os::Handle *_handle;
};

}

#endif
