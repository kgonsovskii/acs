@echo off
REM Usage: linux-arm.bat [projectname] [configuration]
REM
REM Well-known .NET 8 RIDs (Runtime Identifiers) for reference:
REM   win-x86    (Windows 32-bit)
REM   win-x64    (Windows 64-bit)
REM   linux-x64  (Linux 64-bit)
REM   linux-arm  (Linux ARM 32-bit)
REM   linux-arm64 (Linux ARM 64-bit)
REM   osx-x64    (macOS Intel 64-bit)
REM   osx-arm64  (macOS Apple Silicon)
REM
setlocal
set PUBLISH_CALLER=linux-arm

REM Use PUBLISH_PROJECT env or default to 'monolith' if not provided as first arg
set "PROJECTNAME=%1"
if "%PROJECTNAME%"=="" (
  if not "%PUBLISH_PROJECT%"=="" (
    set "PROJECTNAME=%PUBLISH_PROJECT%"
  ) else (
    set "PROJECTNAME=monolith"
  )
)
set "CONFIG=%2"
if "%CONFIG%"=="" set CONFIG=Release

call "%~dp0publish.bat" linux-arm %PROJECTNAME% %CONFIG% 