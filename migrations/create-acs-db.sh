#!/bin/bash
set -e
export PATH="/usr/pgsql-17/bin:/usr/local/pgsql/bin:/usr/local/bin:$PATH"
export PGCLIENTENCODING=UTF8
# Generate schema using Shared.Tool
if [[ "$1" == "true" ]]; then
  dotnet run --project ../src/Shared.Db.Tool -- --recreate
else
  dotnet run --project ../src/Shared.Db.Tool
fi
RECREATE=false
if [[ "$1" == "true" ]]; then
  RECREATE=true
fi
# Set password for postgres superuser
export PGPASSWORD=postgres
# Always reset passwords for tss and postgres
psql -U postgres -c "ALTER USER tss WITH PASSWORD '123';" || echo 'User tss may not exist yet.'
if $RECREATE; then
  psql -U postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'acs' AND pid <> pg_backend_pid();"
  psql -U postgres -c "DROP DATABASE IF EXISTS acs;" || true
  psql -U postgres -c "DROP USER IF EXISTS tss;" || true
fi
psql -U postgres -c "CREATE USER tss WITH PASSWORD '123';" || echo 'User tss may already exist.'
psql -U postgres -c "CREATE DATABASE acs OWNER tss;" || echo 'Database acs may already exist.'

# Run generated schema as tss user
export PGPASSWORD=123
if [ -f "$(dirname "$0")/schema.sql" ]; then
  echo "Applying schema.sql to acs database..."
  psql -U tss -d acs -f "$(dirname "$0")/schema.sql"
else
  echo "schema.sql not found in $(dirname "$0")!"
fi 