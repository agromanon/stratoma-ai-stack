FROM n8nio/n8n:latest
USER root
RUN if command -v apt-get >/dev/null 2>&1; then \
      apt-get update && apt-get install -y python3 python3-pip && pip3 install --break-system-packages virtualenv && apt-get clean; \
    elif command -v apk >/dev/null 2>&1; then \
      apk add --no-cache python3 py3-pip && pip3 install --break-system-packages virtualenv; \
    fi
USER node
