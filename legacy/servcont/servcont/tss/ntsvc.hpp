#ifndef TSS_NTSVC_HPP_INCLUDED
#define TSS_NTSVC_HPP_INCLUDED

#pragma once

#include <windows.h>

namespace tss {

typedef void (*NTSvcCallbackFunc)();
BOOL createService(LPCTSTR /* ServiceName */, NTSvcCallbackFunc /* RunFunc */, NTSvcCallbackFunc /* StopFunc */);

}

#endif
