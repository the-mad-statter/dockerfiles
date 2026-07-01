FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    libatomic1 \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://lmstudio.ai/install.sh | bash

RUN cp -r /root/.lmstudio /opt/lmstudio-install && \
    chmod -R a+rwX /opt/lmstudio-install

EXPOSE 1234