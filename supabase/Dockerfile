FROM supabase/postgres:15.8.1.060

COPY db/init.sh /docker-entrypoint-initdb.d/99-init-supabase-roles.sh
RUN chmod +x /docker-entrypoint-initdb.d/99-init-supabase-roles.sh