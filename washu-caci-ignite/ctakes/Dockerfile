FROM ghcr.io/washu-it-ris/novnc:ubuntu22.04_cuda12.4_runtime

# Set environment variables for Java
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Install Java 17 and Python 3
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-17-jdk \
        python3 \
        python3-pip \
        python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
