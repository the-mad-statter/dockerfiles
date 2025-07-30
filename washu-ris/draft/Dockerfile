# Use RIS-compatible CUDA 12.4 base noVNC image
FROM ghcr.io/washu-it-ris/novnc:ubuntu22.04_cuda12.4_runtime

# Set working directory
WORKDIR /opt/workspace

# Install system packages and Python3
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip and install required Python packages
RUN pip3 install --upgrade pip && pip3 install \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
RUN pip3 install \
    transformers \
    accelerate \
    datasets \
    pandas \
    numpy \
    outlines \
    pydantic \
    databricks-sql-connector \
    jupyterlab \
    tqdm \
    sentencepiece \
    matplotlib \
    scikit-learn \
    seaborn \
    "huggingface_hub[cli]"

# Set default display resolution (can be overridden in OOD)
ENV DISPLAY_WIDTH=2560 DISPLAY_HEIGHT=1440

# Set a fixed VNC password
ARG VNC_PASSWORD
RUN mkdir -p /root/.vnc 
RUN chmod 777 /root/.vnc
RUN x11vnc -storepasswd "$VNC_PASSWORD" /root/.vnc/passwd
# RUN x11vnc -rfbauth /root/.vnc/passwd