@echo off
chcp 65001
setlocal
REM Generate schema using Shared.Tool
set DOTNET_CMD=dotnet run --project ..\src\Shared.Db.Tool
if "%1"=="true" (
    %DOTNET_CMD% --recreate
    REM Drop and recreate Firebird database
    isql-fb -u SYSDBA -p masterkey localhost:3050/C:/ACS2/Base/Acs.fdb -i drop_database.sql
) else (
    %DOTNET_CMD%
)

REM Create database if it doesn't exist
isql-fb -u SYSDBA -p masterkey localhost:3050/C:/ACS2/Base/Acs.fdb -i create_database.sql

REM Run generated schema
set SCHEMA_FILE=%~dp0sql/schema.Firebird.sql
if exist "%SCHEMA_FILE%" (
    echo Applying sql/schema.Firebird.sql to Firebird database...
    isql-fb -u SYSDBA -p masterkey localhost:3050/C:/ACS2/Base/Acs.fdb -i "%SCHEMA_FILE%"
) else (
    echo sql/schema.Firebird.sql not found in %~dp0!
) 