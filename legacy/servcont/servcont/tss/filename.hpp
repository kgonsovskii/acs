#ifndef TSS_FILENAME_HPP_INCLUDED
#define TSS_FILENAME_HPP_INCLUDED

#pragma once

#include "config.hpp"
#include <string>

namespace tss {

#ifdef LINUX
	const char pathSeparator = '/';
#endif
#ifdef MSWINDOWS
	const char pathSeparator = '\\';
#endif

std::string extractFileName(const std::string& filename);
std::string extractFileExt(const std::string& filename);
std::string extractFilePath(const std::string& filename);
std::string& excludeTrailingPathDelimiter(std::string& path);
std::string& includeTrailingPathDelimiter(std::string& path);
bool directoryExists(const char *path);

}

#endif
