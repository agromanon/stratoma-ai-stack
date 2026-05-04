#!/bin/sh
mkdir -p /root/.openclaw
cat > /root/.openclaw/openclaw.json << 'ENDOFFILE'
{
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "all"
  }
}
ENDOFFILE
openclaw gateway --allow-unconfigured
