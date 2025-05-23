#include <tss/ntsvc.hpp>

namespace tss {

static volatile LPTSTR gServiceName;
static SERVICE_STATUS gServiceStatus;
static SERVICE_STATUS_HANDLE gServiceStatusHandle;
static volatile NTSvcCallbackFunc gRunFunc;
static volatile NTSvcCallbackFunc gStopFunc;

static void setStatus(DWORD State)
{
  gServiceStatus.dwCurrentState = State;
  SetServiceStatus(gServiceStatusHandle, &gServiceStatus);
}

VOID WINAPI Handler(DWORD dwControl)
{
	if (dwControl == SERVICE_CONTROL_STOP || dwControl == SERVICE_CONTROL_SHUTDOWN)
	{
		setStatus(SERVICE_STOP_PENDING);
		if (gStopFunc) (*gStopFunc)();
		setStatus(SERVICE_STOPPED);
	}
	else setStatus(gServiceStatus.dwCurrentState);
}

VOID WINAPI ServiceMain(DWORD dwArgc, LPTSTR *lpszArgv)
{
	ZeroMemory(&gServiceStatus, sizeof(gServiceStatus));
	gServiceStatus.dwServiceType = SERVICE_WIN32_OWN_PROCESS;
	gServiceStatus.dwControlsAccepted = SERVICE_CONTROL_INTERROGATE | SERVICE_ACCEPT_STOP | SERVICE_ACCEPT_SHUTDOWN;
	gServiceStatusHandle = RegisterServiceCtrlHandler(gServiceName, Handler);
	if (gServiceStatusHandle == (SERVICE_STATUS_HANDLE)0) return;
	setStatus(SERVICE_RUNNING);
	if (gRunFunc) (*gRunFunc)();
}

BOOL createService(LPCTSTR ServiceName, NTSvcCallbackFunc RunFunc, NTSvcCallbackFunc StopFunc)
{
	SERVICE_TABLE_ENTRY DispatchTable[] = { {(LPTSTR)ServiceName, ServiceMain}, {NULL, NULL} };
	gServiceName = (LPTSTR)ServiceName;
	gRunFunc = RunFunc;
	gStopFunc = StopFunc;
	return StartServiceCtrlDispatcher(DispatchTable);
}

}
