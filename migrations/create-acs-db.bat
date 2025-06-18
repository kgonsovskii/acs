@echo off
setlocal
set PATH=C:\Program Files\PostgreSQL\17\bin;%PATH%
REM Generate schema using Shared.Tool
set DOTNET_CMD=dotnet run --project ..\src\Shared.Db.Tool
if "%1"=="true" (
    %DOTNET_CMD% --recreate
    REM Disconnect all users from acs before dropping
    psql -U postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'acs' AND pid <> pg_backend_pid();"
    psql -U postgres -c "DROP DATABASE IF EXISTS acs;" || echo Database acs may not exist.
    psql -U postgres -c "DROP USER IF EXISTS tss;" || echo User tss may not exist.
) else (
    %DOTNET_CMD%
)
set PGPASSWORD=postgres
psql -U postgres -c "ALTER USER tss WITH PASSWORD '123';" || echo User tss may not exist yet.
psql -U postgres -c "CREATE USER tss WITH PASSWORD '123';" || echo User tss may already exist.
psql -U postgres -c "CREATE DATABASE acs OWNER tss;" || echo Database acs may already exist.

REM Run generated schema as tss user
set PGPASSWORD=123
set SCHEMA_FILE=%~dp0schema.generated.sql
if exist "%SCHEMA_FILE%" (
    echo Applying schema.generated.sql to acs database...
    psql -U tss -d acs -f "%SCHEMA_FILE%"
) else (
    echo schema.generated.sql not found in %~dp0!
)
endlocal 