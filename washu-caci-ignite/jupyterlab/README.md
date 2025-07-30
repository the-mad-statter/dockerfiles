# washu-caci-ignite:jupyterlab

## Overview

This docker file extends ghcr.io/washu-it-ris/novnc:ubuntu22.04_cuda12.4_runtime:

1. Python Runtime Support (python3, python3-pip)
2. PyTorch with CUDA 12.4 (torch, torchvision, torchaudio)
3. Machine Learning / AI Libraries (transformers, accelerate, datasets, sentencepiece, outlines)
4. Data Science & Analysis Tools (numpy, pandas, matplotlib, seaborn, scikit-learn, tqdm)
5. Hugging Face CLI (huggingface-hub[cli])
6. Databricks Connectivity (databricks-sql-connector)

## Hosted

[docker.io/themadstatter/washu-caci-ignite:jupyterlab](https://hub.docker.com/repository/docker/themadstatter/washu-caci-ignite/tags/jupyterlab)

## Usage

Run as a Custom noVNC Image in [Open OnDemand](https://ood.ris.wustl.edu/pun/sys/dashboard/batch_connect/sys/custom_novnc_image/session_contexts/new).

### Docker Image Field

```
docker.io/themadstatter/washu-caci-ignite:jupyterlab
```

### Number of hours Field

Ensure a sufficient number of hours as the job will terminate at the given time.

### JupyterLab

Start JupyterLab at `http://localhost:8888`

```
jupyter lab
```
