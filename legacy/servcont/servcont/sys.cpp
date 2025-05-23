#include "pch.h"
#include <tss/sys.hpp>
#include <cstdio>
#include <cstdlib>
#ifdef LINUX
#include <cstring>
#endif
#include <sstream>
#include <boost/lexical_cast.hpp>
#include <boost/format.hpp>
#include <tss/time.hpp>
#ifndef TSS_ST_OUT
#include <tss/sync.hpp>
#endif

using namespace std;
using namespace boost;

namespace tss {

void log(const char * const s) throw()
{
#ifndef TSS_ST_OUT
	static thread::Synchronizer sync;
	TSS_SCOPED_THREAD_LOCK(sync);
#endif
	const struct tm * const now = os::localtime(os::time());
	fprintf(stdout, "%.4d-%.2d-%.2d_%.2d:%.2d:%.2d %s\n",
		now->tm_year + 1900, now->tm_mon + 1, now->tm_mday, now->tm_hour, now->tm_min, now->tm_sec, s);
	fflush(stdout);

#ifndef NDEBUG
#ifdef MSWINDOWS
	char buf[512];
	sprintf_s(buf, sizeof(buf), "%.2d:%.2d:%.2d %s\n",
		now->tm_hour, now->tm_min, now->tm_sec, s);
	OutputDebugString(buf);
#endif
#endif
}

void handleException(const std::exception& e, const char * const prefix, const char * const suffix) throw()
{
	if (typeid(e) == typeid(Abort))
		return;
	ostringstream os;
	if (prefix)
		os << prefix << ' ';
	os << e.what();
	if (suffix)
		os << ' ' << suffix;
	log(os.str());
	if (typeid(e) == typeid(FatalError))
		_exit(EXIT_FAILURE);
}

namespace os {
string errDesc(const int ec)
{
	char buf[1024];
	string s;
#ifdef LINUX
	char *r = strerror_r(ec, buf, sizeof(buf));
	if (errno == -1)
		fatalError();
	s = r;
#endif
#ifdef MSWINDOWS
	DWORD len = FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM|FORMAT_MESSAGE_IGNORE_INSERTS|FORMAT_MESSAGE_ARGUMENT_ARRAY,
		NULL, ec, 0, buf, sizeof(buf), NULL);
	if (len == 0)
		fatalError();
	for (int i = len - 1; i >= 0; --i) {
		if ('\x0A' == buf[i] || '\x0D' == buf[i] || '\x20' == buf[i] || '.' == buf[i])
			--len;
		else
			break;
	}
	s.assign(buf, len);
#endif
	return s;
}
}//namespace os

string errMsg(const char * const msg, const int ec)
{
	format f("%s; OS ec: %d, desc: '%s'.");
	f %msg %ec %os::errDesc(ec);
	return f.str();
}

namespace process {

//ID find(const char *name)
//{
//#ifdef LINUX
//	FILE *p = popen(str(format("pidof %s") %name).c_str(), "r");
//	//FILE *p = popen("ps | grep program | cut -f1 -d ' '", "r"); // ���� ��� pidof
//	if (p)
//	{
//		char buf[11];
//		const size_t r = fread(buf, 1, sizeof(buf), p);
//		if (r < 2)
//			return 0;
//		pclose(p);
//		buf[r - 1] = '\0';
//		return lexical_cast<pid_t, const char *>(buf);
//	} else
//		return 0;
//#else
//	return 0;
//#endif
//}

}//namespace process

}//namespace tss
