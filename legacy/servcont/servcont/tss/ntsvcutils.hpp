#ifndef TSS_NTSVCUTILS_HPP_INCLUDED
#define TSS_NTSVCUTILS_HPP_INCLUDED

#pragma once

#include <windows.h>

namespace tss {

BOOL serviceStatus(LPCTSTR /*Name*/, LPDWORD /*Value*/);
BOOL startService(LPCTSTR /*Name*/);
BOOL stopService(LPCTSTR /*Name*/);
BOOL uninstallService(LPCTSTR /*Name*/);
BOOL installService(LPCTSTR /*FileName*/, LPCTSTR /*Name*/, LPCTSTR /*DisplayName*/, LPCTSTR /*Dependencies*/, BOOL /*IsAutoStart*/);

}

#endif
