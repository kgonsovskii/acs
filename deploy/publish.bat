@echo off
REM Usage: publish.bat <runtime> <projectname> [configuration]
setlocal
set RUNTIME=%1
set PROJECTNAME=%2
set CONFIG=%3

if "%RUNTIME%"=="" (
  echo Usage: %0 ^<runtime^> ^<projectname^> [configuration]
  exit /b 1
)
if "%PROJECTNAME%"=="" (
  echo Usage: %0 ^<runtime^> ^<projectname^> [configuration]
  exit /b 1
)

REM Capitalize first letter for folder and csproj
set "PROJECTFOLDER=%PROJECTNAME:~0,1%%PROJECTNAME:~1%"
for %%A in ("%~f0") do set SCRIPTNAME=%%~nA
REM If called from another script, use its name for output folder
if not "%PUBLISH_CALLER%"=="" set SCRIPTNAME=%PUBLISH_CALLER%
set PROJECT=..\src\%PROJECTFOLDER%\%PROJECTFOLDER%.csproj
set OUTPUT=output\%SCRIPTNAME%\%PROJECTNAME%

dotnet publish %PROJECT% -c %CONFIG% -r %RUNTIME% --self-contained true -o %OUTPUT%
echo Publish complete: %OUTPUT% 