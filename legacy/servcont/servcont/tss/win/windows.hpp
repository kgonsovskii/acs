#ifndef TSS_WINDOWS_HPP_INCLUDED
#define TSS_WINDOWS_HPP_INCLUDED

#pragma once

#include "../config.hpp"
#include <windows.h>
#include <boost/noncopyable.hpp>
#include "../sys.hpp"

namespace tss { namespace os {

static inline HANDLE OpenProcess(DWORD dwDesiredAccess, BOOL bInheritHandle, DWORD dwProcessId)
{
	const HANDLE ret = ::OpenProcess(dwDesiredAccess, bInheritHandle, dwProcessId);
	if (!ret)
		fatalError();
	return ret;
}

static inline BOOL DuplicateHandle(
	HANDLE hSourceProcessHandle,
	HANDLE hSourceHandle,
	HANDLE hTargetProcessHandle,
	LPHANDLE lpTargetHandle,
	DWORD dwDesiredAccess,
	BOOL bInheritHandle,
	DWORD dwOptions)
{
	const BOOL ret = ::DuplicateHandle(hSourceProcessHandle, hSourceHandle, hTargetProcessHandle, lpTargetHandle, dwDesiredAccess, bInheritHandle, dwOptions);
	if (!ret)
		fatalError();
	return ret;
}

static inline HANDLE CreateFile(LPCTSTR lpFileName,
  DWORD dwDesiredAccess,
  DWORD dwShareMode,
  LPSECURITY_ATTRIBUTES lpSecurityAttributes,
  DWORD dwCreationDisposition,
  DWORD dwFlagsAndAttributes,
  HANDLE hTemplateFile)
{
	const HANDLE ret = ::CreateFile(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
	if (ret == INVALID_HANDLE_VALUE)
		fatalError();
}

static inline HANDLE CreateEvent(LPSECURITY_ATTRIBUTES lpEventAttributes, BOOL bManualReset, BOOL bInitialState, LPCTSTR lpName)
{
	const HANDLE ret = ::CreateEvent(lpEventAttributes, bManualReset, bInitialState, lpName);
	if (!ret)
		fatalError();
	return ret;
}

static inline void SetEvent(HANDLE hEvent)
{
	if (!::SetEvent(hEvent))
		fatalError();
}

static inline void ResetEvent(HANDLE hEvent)
{
	if (!::ResetEvent(hEvent))
		fatalError();
}

static inline DWORD WaitForSingleObject(HANDLE hHandle, DWORD dwMilliseconds)
{
	const DWORD ret = ::WaitForSingleObject(hHandle, dwMilliseconds);
	if (ret == WAIT_FAILED)
		fatalError();
	return ret;
}

static inline void CloseHandle(HANDLE hObject)
{
	if (!::CloseHandle(hObject))
		fatalError();
}

static inline void SetupComm(HANDLE hFile, DWORD dwInQueue, DWORD dwOutQueue)
{
	if (!::SetupComm(hFile, dwInQueue, dwOutQueue))
		fatalError();
}

static inline void GetCommState(HANDLE hFile, LPDCB lpDCB)
{
	if (!::GetCommState(hFile, lpDCB))
		fatalError();
}

static inline void SetCommState(HANDLE hFile, LPDCB lpDCB)
{
	if (!::SetCommState(hFile, lpDCB))
		fatalError();
}

static inline void SetCommTimeouts(HANDLE hFile, LPCOMMTIMEOUTS lpCommTimeouts)
{
	if (!::SetCommTimeouts(hFile, lpCommTimeouts))
		fatalError();
}

static inline void EscapeCommFunction(HANDLE hFile, DWORD dwFunc)
{
	if (!::EscapeCommFunction(hFile, dwFunc))
		fatalError();
}

static inline void SetCommMask(HANDLE hFile, DWORD dwEvtMask)
{
	if (!::SetCommMask(hFile, dwEvtMask))
		fatalError();
}

static inline void ClearCommError(HANDLE hFile, LPDWORD lpErrors, LPCOMSTAT lpStat)
{
	if (!::ClearCommError(hFile, lpErrors, lpStat))
		fatalError();
}

/**/

struct Handle: private boost::noncopyable
{
	Handle(HANDLE handle_) throw(): handle(handle_) {}
	~Handle() { os::CloseHandle(handle); }
	operator HANDLE() const throw() { return handle; }
	const HANDLE handle;
};

struct Event: private boost::noncopyable
{
	Event(LPSECURITY_ATTRIBUTES lpEventAttributes, BOOL bManualReset, BOOL bInitialState, LPCTSTR lpName)
		: handle(os::CreateEvent(lpEventAttributes, bManualReset, bInitialState, lpName)) {}
	operator HANDLE() const throw() { return handle; }
	const Handle handle;
};

struct Overlapped: OVERLAPPED
{
	Overlapped()
	{
		ZeroMemory(this, sizeof(OVERLAPPED));
	}
};

struct WaitableOverlapped: Overlapped
{
	WaitableOverlapped(): evt(NULL, TRUE, FALSE, NULL)
	{
		hEvent = evt.handle;
	}
	const os::Event evt;
};

}//namespace os
}//namespace tss

#endif//TSS_WINDOWS_HPP_INCLUDED
