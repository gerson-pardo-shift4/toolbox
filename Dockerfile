FROM ubuntu:noble

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        redis-tools \
        mysql-client \
        postgresql-client \
        curl \
        wget \
        lsb-release \
        gnupg2 \
        socat \
        nginx \
        ca-certificates \
        unzip && \
    rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates

RUN curl -fsSL https://get.docker.com|sh

ENV TELEPORT_EDITION="oss"
ENV TELEPORT_VERSION="16.4.0"
RUN curl https://cdn.teleport.dev/install-v16.4.0.sh | bash -s ${TELEPORT_VERSION?} ${TELEPORT_EDITION?}

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

ENV GO_VERSION=1.23.1
RUN GO_ARCH=$(dpkg --print-architecture) && \
    wget https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-${GO_ARCH}.tar.gz && \
    rm go${GO_VERSION}.linux-${GO_ARCH}.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

WORKDIR /app
