@echo off
setlocal
set DIR=%~dp0
call "%DIR%postgres.bat" true
endlocal 