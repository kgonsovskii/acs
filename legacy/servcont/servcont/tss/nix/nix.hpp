#ifndef TSS_NIX_HPP_INCLUDED
#define TSS_NIX_HPP_INCLUDED

#pragma once

#include "../config.hpp"
#include "fcntl.hpp"
#include <boost/noncopyable.hpp>
#include "../sys.hpp"

#define	HANDLE					int
#define	INVALID_HANDLE_VALUE	-1

namespace tss { namespace os {

struct Handle: private boost::noncopyable
{
	Handle(HANDLE handle_) throw(): handle(handle_) {}
	~Handle() { os::close(handle); }
	operator HANDLE() const throw() { return handle; }
	const HANDLE handle;
};

}//namespace os
}//namespace tss

#endif//TSS_NIX_HPP_INCLUDED
