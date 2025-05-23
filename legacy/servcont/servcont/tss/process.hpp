#ifndef TSS_PROCESS_HPP_INCLUDED
#define TSS_PROCESS_HPP_INCLUDED

#pragma once

#include <tss/config.hpp>
#ifdef LINUX
#include <cstdio>
#include <cstdlib>
#else
#include <Psapi.h>
#include <cstring>

#pragma comment(lib, "Psapi.lib")
#endif

#include <tss/sys.hpp>

namespace tss { namespace process {

static inline ID find(const char *name)
{
#ifdef LINUX
	char s[64] = "pidof ";
	sprintf(&s[6], "%s", name);
	FILE *p = popen(s, "r");
	//FILE *p = popen("ps | grep program | cut -f1 -d ' '", "r");
	if (p) {
		char buf[11];
		const size_t r = fread(buf, 1, sizeof(buf), p);
		if (r < 2) {
			pclose(p);
			return 0;
		}
		pclose(p);
		buf[r - 1] = '\0';
		//return lexical_cast<pid_t, const char *>(buf);
		return atoi(buf);
	}
#else
	DWORD needed, pids[1024];
	if (!EnumProcesses(pids, sizeof(pids), &needed))
		os::throwFatalErr();
	const DWORD count = needed / sizeof(DWORD);
	char baseName[MAX_PATH];
	for (DWORD i = 0; i != count; ++i) {
		const HANDLE handle = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, pids[i]);
		if (handle) {
			GetModuleBaseName(handle, 0, baseName, sizeof(baseName));
			// TODO: locale or UNICODE.
			if (_stricmp(baseName, name) == 0)
				return pids[i];
		}
	}
#endif
	return 0;
}

}}

#endif
