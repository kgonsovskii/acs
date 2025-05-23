#include <tss/ntsvcutils.hpp>

namespace tss {

BOOL serviceStatus(LPCTSTR Name, LPDWORD Value)
{
	BOOL res = FALSE;
	SC_HANDLE scm, svc;
	SERVICE_STATUS ss;

	scm = OpenSCManager(NULL, NULL, SC_MANAGER_CONNECT);
	if (scm != NULL)
	{
		svc = OpenService(scm, Name, SERVICE_QUERY_STATUS);
		if (svc != NULL)
		{
			if (QueryServiceStatus(svc, &ss))
			{
				*Value = ss.dwCurrentState;
				res = TRUE;
			}
			CloseServiceHandle(svc);
		}
		CloseServiceHandle(scm);
	}
	return res;
}

BOOL startService(LPCTSTR Name)
{
	BOOL res = FALSE;
	SC_HANDLE scm, svc;

	scm = OpenSCManager(NULL, NULL, SC_MANAGER_CONNECT);
	if (scm != NULL)
	{
		svc = OpenService(scm, Name, SERVICE_START);
		if (svc != NULL)
		{
			res = StartService(svc, 0, NULL);
			CloseServiceHandle(svc);
		}
		CloseServiceHandle(scm);
	}
	return res;
}

BOOL stopService(LPCTSTR Name)
{
	BOOL res = FALSE;
	SC_HANDLE scm, svc;
	SERVICE_STATUS ss;

	scm = OpenSCManager(NULL, NULL, SC_MANAGER_CONNECT);
	if (scm != NULL)
	{
		svc = OpenService(scm, Name, SERVICE_STOP);
		if (svc != NULL)
		{
			res = ControlService(svc, SERVICE_CONTROL_STOP, &ss);
			CloseServiceHandle(svc);
		}
		CloseServiceHandle(scm);
	}
	return res;
}

BOOL uninstallService(LPCTSTR Name)
{
	BOOL res = FALSE;
	SC_HANDLE scm, svc;

	scm = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS);
	if (scm != NULL)
	{
		svc = OpenService(scm, Name, SERVICE_ALL_ACCESS);
		if (svc != NULL)
		{
			res = DeleteService(svc);
			CloseServiceHandle(svc);
		}
		CloseServiceHandle(scm);
	}
	return res;
}

BOOL installService(LPCTSTR FileName, LPCTSTR Name, LPCTSTR DisplayName, LPCTSTR Dependencies, BOOL IsAutoStart)
{
	const DWORD START_TYPE[] = {SERVICE_DEMAND_START, SERVICE_AUTO_START};
	BOOL res = FALSE;
	SC_HANDLE scm, svc;

	scm = OpenSCManager(NULL, NULL, SC_MANAGER_CREATE_SERVICE);
	if (scm != NULL)
	{
		svc = CreateService(scm,
			Name,
			DisplayName,
			SERVICE_ALL_ACCESS,
			SERVICE_WIN32_OWN_PROCESS,
			START_TYPE[IsAutoStart],
			SERVICE_ERROR_NORMAL,
			FileName,
			NULL,
			NULL,
			Dependencies,
			NULL,
			NULL);
		if (svc != NULL)
		{
			res = TRUE;
			CloseServiceHandle(svc);
		}
		CloseServiceHandle(scm);
	}
	return res;
}

}
