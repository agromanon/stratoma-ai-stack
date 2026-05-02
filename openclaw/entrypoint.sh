#!/bin/sh
mkdir -p /root/.openclaw
cat > /root/.openclaw/openclaw.json << 'ENDOFFILE'
{
  "gateway": {"port": 18789},
  "accounts": {
    "main": {
      "type": "telegram",
      "token": "PLACEHOLDER_TOKEN",
      "name": "Main Bot"
    }
  },
  "channels": {
    "whatsapp": {"dmPolicy": "pairing", "groupPolicy": "deny", "allowFrom": []}
  }
}
ENDOFFILE
sed -i "s/PLACEHOLDER_TOKEN/$TELEGRAM_BOT_TOKEN/g" /root/.openclaw/openclaw.json
openclaw gateway start