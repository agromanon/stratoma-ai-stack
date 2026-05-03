FROM node:22-bookworm

ENV N8N_VERSION=1.71.2
ENV NODE_ENV=production

RUN apt-get update && apt-get install -y python3 python3-pip python3-venv postgresql-client \
    && pip3 install --break-system-packages virtualenv \
    && npm install -g n8n@${N8N_VERSION} \
    && apt-get clean \
    && npm cache clean --force \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/node
USER node

ENV DB_TYPE=postgresdb
ENV GENERIC_TIMEZONE=Europe/Madrid
ENV NODE_ENV=production

EXPOSE 5678

CMD ["n8n"]
