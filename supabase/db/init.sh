#!/bin/bash
set -e

echo "Waiting for PostgreSQL to be ready..."
until psql -U postgres -c '\q' 2>/dev/null; do
  sleep 1
done

echo "Creating Supabase schemas and roles..."
psql -U postgres << 'EOF'
-- Create auth schema
CREATE SCHEMA IF NOT EXISTS auth;

-- Create required roles
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

-- Grant privileges
GRANT ALL PRIVILEGES ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL PRIVILEGES ON SCHEMA public TO supabase_auth_admin;
ALTER ROLE authenticator SET statement_timeout = '8s';
GRANT ALL PRIVILEGES ON DATABASE postgres TO supabase_auth_admin;
GRANT ALL PRIVILEGES ON DATABASE postgres TO authenticator;
ALTER DATABASE postgres OWNER TO supabase_auth_admin;

-- Set search_path for supabase_auth_admin
ALTER ROLE supabase_auth_admin SET search_path TO auth, public;

-- Grant schema usage
GRANT USAGE ON SCHEMA auth TO supabase_auth_admin;
GRANT USAGE ON SCHEMA auth TO authenticator;
GRANT ALL PRIVILEGES ON SCHEMA auth TO supabase_auth_admin;
EOF

echo "Supabase initialization complete"