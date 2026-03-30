FROM node:24-slim

ARG OPENCLAW_VERSION=2026.3.28
RUN npm install -g openclaw@${OPENCLAW_VERSION}

RUN mkdir -p /root/.openclaw

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME ["/root/.openclaw"]

EXPOSE 18789

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["openclaw", "gateway", "--port", "18789", "--allow-unconfigured"]
