FROM kong:2.8.1

# Embed kong.yml inline so no volume mount needed
RUN echo '_format_version: "3.0"\n\
\nservices:\n\
  - name: supabase-auth\n\
    url: http://supabase-auth:9999\n\
    routes:\n\
      - name: auth-api\n\
        paths:\n\
          - /auth\n\
        strip_path: false\n\
\n  - name: supabase-rest\n\
    url: http://supabase-rest:3000\n\
    routes:\n\
      - name: rest-api\n\
        paths:\n\
          - /rest\n\
        strip_path: false\n\
\nplugins:\n\
  - name: cors\n\
    config:\n\
      origins:\n\
        - "*"\n\
      methods:\n\
        - GET\n\
        - POST\n\
        - PUT\n\
        - PATCH\n\
        - DELETE\n\
        - OPTIONS\n\
      headers:\n\
        - Accept\n\
        - Authorization\n\
        - Content-Type\n\
      credentials: true' > /var/lib/kong/kong.yml

CMD ["kong", "docker-start"]