#ifndef TSS_DYNLIB_HPP_INCLUDED
#define TSS_DYNLIB_HPP_INCLUDED

#pragma once

#include "config.hpp"
#ifdef LINUX
#include <dlfcn.h>
#else
#include <windows.h>
#endif
#include <stdexcept>
#include <boost/format.hpp>
#include "sys.hpp"

namespace tss
{

class DynLib
{
public:
#ifdef LINUX
	typedef void *Handle;
#else
	typedef HMODULE Handle;
#endif
	DynLib(const std::string& fileName_): fileName(fileName_)
	{
		_handle =
#ifdef LINUX
			::dlopen(fileName_.c_str(), RTLD_LAZY);
#else
			::LoadLibrary(fileName_.c_str());
#endif
		if (!_handle)
		{
#ifdef LINUX
			throw std::runtime_error(::dlerror());
#else
			boost::format f("Can't open '%s'");
			f %fileName_;
			throw std::runtime_error(errMsg(f.str(), ::GetLastError()));
#endif
		}
	}

	~DynLib()
	{
#ifdef LINUX
		if (::dlclose(_handle) != 0)
#else
		if (!::FreeLibrary(_handle))
#endif
		{
#ifdef LINUX
			throw FatalError(::dlerror());
#else
			throw FatalError();
#endif
		}
	}
	
	template <typename T>
	T *funcAddr(const char *name) const
	{
		return static_cast<T *>(_funcAddr(name));
	}

	Handle handle() const throw()
	{
		return _handle;
	}

	const std::string fileName;
	
private:
	void *_funcAddr(const char *name) const
	{
		void *r =
#ifdef LINUX
			::dlsym(_handle, name);
#else
			::GetProcAddress(_handle, name);
#endif
		if (!r)
		{
#ifdef LINUX
			throw std::runtime_error(::dlerror());
#else
			boost::format f("Can't find '%s' in '%s'");
			f %name %fileName;
			throw std::runtime_error(errMsg(f.str(), ::GetLastError()));
#endif
		}
		return r;
	}

	Handle _handle;
};

}

#endif
