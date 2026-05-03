FROM python:3.12-slim-bookworm AS python
RUN pip install --break-system-packages virtualenv

FROM n8nio/n8n:latest
COPY --from=python /usr/local/bin/python3 /usr/local/bin/python3
COPY --from=python /usr/local/bin/pip* /usr/local/bin/
COPY --from=python /usr/local/lib/python3.12 /usr/local/lib/python3.12
COPY --from=python /usr/local/include/python3.12 /usr/local/include/python3.12
ENV PATH="/usr/local/bin:$PATH"
