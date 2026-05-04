#!/bin/sh
mkdir -p /root/.openclaw
cat > /root/.openclaw/openclaw.json << 'ENDOFFILE'
{
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "lan",
    "auth": {
      "mode": "trusted-proxy"
    },
    "controlUi": {
      "allowedOrigins": [
        "http://localhost:18789",
        "http://127.0.0.1:18789",
        "https://openclaw.aidreambuild.com"
      ],
      "allowInsecureAuth": true
    },
    "tailscale": {
      "mode": "off",
      "resetOnExit": false
    }
  },
  "agents": {
    "defaults": {
      "workspace": "/root/.openclaw/workspace",
      "model": {
        "primary": "minimax-portal/MiniMax-M2.7"
      }
    }
  },
  "session": {
    "dmScope": "per-channel-peer"
  },
  "tools": {
    "profile": "coding",
    "web": {
      "search": {
        "provider": "duckduckgo",
        "enabled": true
      }
    }
  },
  "plugins": {
    "entries": {
      "minimax": {
        "enabled": true
      },
      "telegram": {
        "enabled": true
      },
      "duckduckgo": {
        "enabled": true
      }
    }
  },
  "models": {
    "providers": {
      "minimax-portal": {
        "baseUrl": "https://api.minimax.io/anthropic/v1",
        "api": "anthropic-messages",
        "authHeader": true,
        "models": []
      }
    }
  },
  "auth": {
    "profiles": {
      "minimax-portal:default": {
        "provider": "minimax-portal",
        "mode": "oauth"
      }
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "groups": {
        "*": {
          "requireMention": true
        }
      },
      "botToken": "8678108345:AAE4v_npKEV08hrG_8ylYjl204g_UozLcpc"
    }
  }
}
ENDOFFILE
openclaw gateway --allow-unconfigured
