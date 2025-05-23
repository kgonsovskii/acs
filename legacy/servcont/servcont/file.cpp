#include "pch.h"
#include <tss/file.hpp>

#ifdef LINUX
#include <sys/stat.h>
#else
#include <windows.h>
#endif
#include <tss/sys.hpp>
#include <tss/filename.hpp>

using namespace std;

namespace tss {

void createDir(const char *name)
{
#ifdef LINUX
	if (mkdir(name, static_cast<mode_t>(-1)) != 0)
#else
	if (!CreateDirectory(name, NULL))
#endif
	{
		int i = os::errNo();
		boost::format f("Can't create directory '%s'");
		f %name;
		throw std::runtime_error(errMsg(f.str(), i));
	}
}

void createPath(string path)
{
	excludeTrailingPathDelimiter(path);
#ifdef LINUX
	if ( path.empty() || directoryExists(path.c_str()) ) return;
#endif
#ifdef MSWINDOWS
	if ( (path.length() < 3) || directoryExists(path.c_str()) || (extractFilePath(path) == path) ) return; // avoid 'xyz:\' problem.
#endif
	createPath(extractFilePath(path));
	createDir(path.c_str());
}

void throwFileOpenErr(const char *name)
{
	const int i = os::errNo();
	boost::format f("Can't open file '%s'.");
	f %name;
	throw runtime_error(errMsg(f.str(), i)); 
}

size_t fileSize(const char *name)
{
	ifstream fs;
	openFile(name, ios_base::in | ios_base::binary, fs);
	return fileSize(fs);
}

}
