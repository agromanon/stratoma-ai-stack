#!/bin/sh
sed -i "s/TOKEN_PLACEHOLDER/$TELEGRAM_BOT_TOKEN/g" /root/.openclaw/openclaw.json
sed -i "s/APIKEY_PLACEHOLDER/$PAPERCLIP_API_KEY/g" /root/.openclaw/openclaw.json
openclaw gateway start