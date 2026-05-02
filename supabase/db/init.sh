#!/bin/bash
set -e

echo "Waiting for PostgreSQL to be ready..."
until psql -U postgres -c '\q' 2>/dev/null; do
  sleep 1
done

echo "Creating required Supabase roles..."
psql -U postgres << 'EOF'
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'supabase_auth_admin') THEN
    CREATE ROLE supabase_auth_admin WITH LOGIN PASSWORD 'Afmg248635!';
  END IF;
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'authenticator') THEN
    CREATE ROLE authenticator WITH LOGIN;
  END IF;
END
$$;

GRANT ALL PRIVILEGES ON DATABASE postgres TO supabase_auth_admin;
ALTER ROLE authenticator SET statement_timeout = '8s';
GRANT ALL PRIVILEGES ON DATABASE postgres TO authenticator;
ALTER DATABASE postgres OWNER TO supabase_auth_admin;
EOF

echo "Roles created successfully"
exec docker-entrypoint.sh postgres