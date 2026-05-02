FROM node:22-alpine

WORKDIR /app

RUN npm install -g openclaw

RUN echo '{"gateway":{"port":18789,"host":"0.0.0.0"},"accounts":{"main":{"type":"telegram","token":"TOKEN_PLACEHOLDER","name":"Main Bot"}},"channels":{"whatsapp":{"dmPolicy":"pairing","groupPolicy":"deny","allowFrom":[]}},"paperclip":{"url":"http://paperclip:3100","apiKey":"APIKEY_PLACEHOLDER"}}' > /tmp/openclaw.json && \
    mkdir -p /root/.openclaw && \
    cp /tmp/openclaw.json /root/.openclaw/openclaw.json

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]