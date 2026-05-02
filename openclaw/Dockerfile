FROM node:22-alpine

WORKDIR /app

RUN npm install -g openclaw

# Generate openclaw.json at runtime using env vars
# Token will be replaced at container startup
CMD sh -c 'cat > /root/.openclaw/openclaw.json << "OPENCLAW_EOF"
{
  "gateway": {
    "port": 18789,
    "host": "0.0.0.0"
  },
  "accounts": {
    "main": {
      "type": "telegram",
      "token": "${TELEGRAM_BOT_TOKEN}",
      "name": "Main Bot"
    }
  },
  "channels": {
    "whatsapp": {
      "dmPolicy": "pairing",
      "groupPolicy": "deny",
      "allowFrom": []
    }
  },
  "paperclip": {
    "url": "http://paperclip:3100",
    "apiKey": "${PAPERCLIP_API_KEY}"
  }
}
OPENCLAW_EOF
openclaw gateway start'