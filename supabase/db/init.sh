#!/bin/bash
set -e

echo "DEBUG: Waiting for PostgreSQL to be ready..."
until psql -U postgres -c '\q' 2>/dev/null; do
  sleep 1
done

echo "DEBUG: postgres is ready, running init script..."
psql -U postgres --set ON_ERROR_STOP=1 <<'EOF'
-- DEBUG: Starting Supabase init script
SELECT 'DEBUG: Starting Supabase init script' as init_status;

-- Create auth schema
CREATE SCHEMA IF NOT EXISTS auth;

-- Create required roles
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'supabase_auth_admin') THEN
    CREATE ROLE supabase_auth_admin WITH LOGIN PASSWORD 'Afmg248635!';
    RAISE NOTICE 'Created role supabase_auth_admin';
  ELSE
    RAISE NOTICE 'Role supabase_auth_admin already exists';
  END IF;
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'authenticator') THEN
    CREATE ROLE authenticator WITH LOGIN;
    RAISE NOTICE 'Created role authenticator';
  ELSE
    RAISE NOTICE 'Role authenticator already exists';
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

-- Verify roles exist before continuing
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'supabase_auth_admin') THEN
    RAISE EXCEPTION 'supabase_auth_admin role was NOT created';
  END IF;
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'authenticator') THEN
    RAISE EXCEPTION 'authenticator role was NOT created';
  END IF;
  RAISE NOTICE 'Roles verified: supabase_auth_admin, authenticator';
END
$$;

-- Create GoTrue schema tables
CREATE TABLE IF NOT EXISTS auth.schema_migrations (
  version varchar(255) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS auth.structurestorage (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at timestamptz DEFAULT now(),
  name varchar(255) NOT NULL,
  structure jsonb NOT NULL DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS auth.migrations (
  id SERIAL PRIMARY KEY,
  name varchar(255) NOT NULL UNIQUE,
  executed_at timestamptz DEFAULT now()
);

-- Grant table permissions
GRANT ALL PRIVILEGES ON auth.schema_migrations TO supabase_auth_admin, authenticator;
GRANT ALL PRIVILEGES ON auth.structurestorage TO supabase_auth_admin, authenticator;
GRANT ALL PRIVILEGES ON auth.migrations TO supabase_auth_admin, authenticator;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA auth TO supabase_auth_admin, authenticator;

-- Change ownership so GoTrue (supabase_auth_admin) can run migrations
ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;
ALTER TABLE auth.structurestorage OWNER TO supabase_auth_admin;
ALTER TABLE auth.migrations OWNER TO supabase_auth_admin;
ALTER SCHEMA auth OWNER TO supabase_auth_admin;

-- Set password for authenticator so PostgREST can connect
-- Password must match SUPABASE_DB_PASSWORD env var
ALTER ROLE authenticator WITH LOGIN PASSWORD 'Afmg248635!';

-- Mark as migrated
INSERT INTO auth.schema_migrations (version) VALUES ('20231212100000') ON CONFLICT (version) DO NOTHING;
INSERT INTO auth.migrations (name) VALUES ('init_schema') ON CONFLICT (name) DO NOTHING;

SELECT 'DEBUG: Supabase init script completed successfully' as init_status;
EOF

echo "Supabase initialization complete"