#ifndef TSS_FILE_HPP_INCLUDED
#define TSS_FILE_HPP_INCLUDED

#pragma once

#include "config.hpp"
#ifdef LINUX
#include <unistd.h>
#else
#include <io.h>
#endif
#include "sys.hpp"
#include "filename.hpp"
#include <fstream>
#include <boost/format.hpp>

namespace tss {

static inline bool fileExists(const char *name) throw()
{
	return ::_access(name, 0) != -1;
}

void createDir(const char *);
void createPath(std::string);
void throwFileOpenErr(const char *);

template<class FileStream>
FileStream& openFile(const char *name, std::ios_base::openmode mode, FileStream& fs)
{
	fs.open(name, mode);
	if (!fs.is_open())
		throwFileOpenErr(name);
	return fs;
}

template <class FileStream>
static inline std::size_t fileSize(FileStream& fs)
{
	fs.seekg(0, std::ios::end);
	return fs.tellg();
}

std::size_t fileSize(const char *name);

template <class T>
class FileStream: public T
{
public:
	FileStream(const char *name, std::ios_base::openmode mode)
	{
		openFile(name, mode, *this);
	}
	~FileStream()
	{
		this->close();
		if (this->bad())
			os::fatalError();
	}
};

}

#endif
