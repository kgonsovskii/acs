@echo off
setlocal
set DIR=%~dp0
call "%DIR%create-acs-db.bat" true
endlocal 