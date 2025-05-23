#include "pch.h"
#include <tss/filename.hpp>

#ifdef LINUX
#include <sys/stat.h>
#else
#include <windows.h>
#endif
#include <cstring>

using namespace std;

namespace tss
{

string extractFileName(const string& filename)
{
	string s;
	string::size_type r = filename.rfind(pathSeparator);
	if (r != string::npos) {
		++r;
		s.assign(filename, r, filename.length() - r);
	}
	return s;
}

string extractFileExt(const string& fileName)
{
	string s;
	const string::size_type r = fileName.rfind('.');
	if (r != string::npos)
		s.assign(fileName, r, fileName.length() - r);
	return s;
}

string extractFilePath(const string& fileName)
{
	string s;
	const string::size_type r = fileName.rfind(pathSeparator);
	if (r != string::npos)
		s.assign(fileName, 0, r + 1);
	return s;
}

string& excludeTrailingPathDelimiter(string& path)
{
	size_t i = path.length();
	if (i > 0)
		if (path[--i] == pathSeparator)
			path.resize(i);
	return path;
}

string& includeTrailingPathDelimiter(string& path)
{
	size_t i = path.length();
	if (i > 0)
		if (path[--i] != pathSeparator)
			path += pathSeparator;
	return path;
}

bool directoryExists(const char *path)
{
#ifdef LINUX
	struct stat st;
	if (stat(path, &st) == 0)
	    return S_ISDIR(st.st_mode);
	else
		return false;
#endif
#ifdef MSWINDOWS
	const DWORD r = GetFileAttributes(path);
#pragma warning(push)
#pragma warning(disable : 4311)
	return (r != reinterpret_cast<DWORD>(INVALID_HANDLE_VALUE)) && ((FILE_ATTRIBUTE_DIRECTORY & r) != 0);
#pragma warning(pop)
#endif
}

}
