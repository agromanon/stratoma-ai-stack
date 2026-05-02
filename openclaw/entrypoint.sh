#!/bin/sh
mkdir -p /root/.openclaw
cat > /root/.openclaw/openclaw.json << ENDOFFILE
{
  "gateway": {"port": 18789, "host": "0.0.0.0"},
  "accounts": {
    "main": {
      "type": "telegram",
      "token": "${TELEGRAM_BOT_TOKEN}",
      "name": "Main Bot"
    }
  },
  "channels": {
    "whatsapp": {"dmPolicy": "pairing", "groupPolicy": "deny", "allowFrom": []}
  },
  "paperclip": {
    "url": "http://paperclip:3100",
    "apiKey": "${PAPERCLIP_API_KEY}"
  }
}
ENDOFFILE
openclaw gateway start