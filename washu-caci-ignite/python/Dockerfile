# Use RIS-compatible CUDA 12.4 base noVNC image
FROM ghcr.io/washu-it-ris/novnc:ubuntu22.04_cuda12.4_runtime

# Set working directory
WORKDIR /opt/workspace

# Install system packages and Python
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip and install required Python packages
RUN pip3 install --upgrade pip && \
    pip3 install \
        torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124 && \
    pip3 install \
        accelerate \
        databricks-sql-connector \
        datasets \
        huggingface_hub[cli] \
        jupyterlab \
        matplotlib \
        numpy \
        outlines \
        pandas \
        pydantic \
        scikit-learn \
        seaborn \
        sentencepiece \
        tqdm \
        transformers
