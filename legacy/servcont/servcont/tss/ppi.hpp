#ifndef PPI_HPP_
#define PPI_HPP_

#pragma once

#include "global.h"
#include <fcntl.h>
#include <stdexcept> 
#include <boost/format.hpp>
#include "exceptmsgs.hpp"
#include "osutils.hpp"
#include "exceptutils.hpp"

namespace tss
{

static const char PPI_DEVICE_FMT[] = "/dev/ppi%u";

class PPI
{
public:
	PPI(): _fd(-1), _deviceName() {}

	virtual ~PPI()
	{
		if (isOpen())
			close(true);
	}

	void open(unsigned char devNum)
	{
		if (isOpen())
		{
			boost::format f(ERR_MSG_PPI_ALREADY_OPEN);
			 f %_deviceName;
			throw std::logic_error(f.str());
		}
		
		_deviceName = boost::str(boost::format(PPI_DEVICE_FMT) %static_cast<unsigned short>(devNum));
		_fd = ::open(_deviceName.c_str(), O_RDWR, 0);
		if (!isOpen())
		{
			boost::format f(ERR_MSG_CANT_OPEN_PPI);
			f %_deviceName;
			throw std::runtime_error(errorMessage(f.str(), getLastOSError()));
		}
	}
	
	void close(bool noThrow = false)
	{
		if (!isOpen())
			throw std::logic_error(ERR_MSG_PPI_NOT_OPEN);

		if(::close(_fd) != 0)
		{
			if (!noThrow)
			{
				boost::format f(ERR_MSG_CANT_CLOSE_PPI);
				f % _deviceName;
				throw std::runtime_error(errorMessage(f.str(), getLastOSError()));
			}
		}
		_fd = -1;
		_deviceName.resize(0);
	}

	int read(char * data, int size)
	{
		if (!isOpen())
			throw std::logic_error(ERR_MSG_PPI_NOT_OPEN);
		int r = ::read(_fd, data, size);
		if (r < 0)
		{
			boost::format f(ERR_MSG_CANT_READ_PPI);
			f %_deviceName;
			throw std::runtime_error(errorMessage(f.str(), getLastOSError()));
		}
		else
			return r;
	}  

	bool isOpen() const
	{
		return (_fd != -1);
	}
	
	int descriptor() const
	{
		if (!isOpen())
			throw std::logic_error(ERR_MSG_PPI_NOT_OPEN);
		return _fd;
	}
	
	const std::string & deviceName() const
	{
		if (!isOpen())
			throw std::logic_error(ERR_MSG_PPI_NOT_OPEN);
		return _deviceName;
	}

private:
	int _fd;
	std::string _deviceName;
};

}

#endif /*PPI_HPP_*/
