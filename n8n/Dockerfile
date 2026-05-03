FROM n8nio/n8n:1.71.2
USER root
RUN apt-get update && apt-get install -y python3 python3-pip && pip3 install --break-system-packages virtualenv && apt-get clean
USER node
