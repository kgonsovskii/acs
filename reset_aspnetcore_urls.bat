@echo off
REM Remove ASPNETCORE_URLS environment variable for current user
setx ASPNETCORE_URLS "" /M
setx ASPNETCORE_URLS ""
echo ASPNETCORE_URLS has been reset for user (and attempted for machine).
pause 