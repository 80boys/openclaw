FROM node:24-slim

ENV TZ=Asia/Shanghai

RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    curl \
    wget \
    dnsutils \
    iputils-ping \
    net-tools \
    telnet \
    jq \
    vim-tiny \
    nano \
    unzip \
    zip \
    tar \
    gzip \
    bzip2 \
    xz-utils \
    procps \
    htop \
    less \
    tree \
    file \
    openssh-client \
    rsync \
    socat \
    traceroute \
    tcpdump \
    iproute2 \
    bc \
    diffutils \
    findutils \
    sed \
    gawk \
    python3-minimal \
    lsof \
    strace \
    git \
    locales \
    tzdata \
  && rm -rf /var/lib/apt/lists/* \
  && sed -i 's/# zh_CN.UTF-8/zh_CN.UTF-8/' /etc/locale.gen \
  && locale-gen \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone

ENV LANG=zh_CN.UTF-8

ARG OPENCLAW_VERSION=2026.4.1
RUN npm install -g openclaw@${OPENCLAW_VERSION}

RUN npm install -g \
    @aws-sdk/client-bedrock \
    @slack/web-api \
    json

RUN mkdir -p /root/.openclaw

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME ["/root/.openclaw"]

EXPOSE 18789

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["openclaw", "gateway", "--port", "18789", "--allow-unconfigured"]