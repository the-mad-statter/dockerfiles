#!/bin/bash
#SBATCH -A compute2-morven
#SBATCH -p general-cpu
#SBATCH -J lmstudio-server
#SBATCH --mem=16G
#SBATCH --time=2-00:00:00
#SBATCH -o lmstudio_%j.log

export CONTAINER_IMAGE='themadstatter/washu-sph-lmstudio:latest'
export CONTAINER_MOUNTS="/storage3/fs1/morven/Active/lmstudio-data:/home/${USER}/.lmstudio"
export LMS_HOME="/home/${USER}/.lmstudio"

srun --container-image="$CONTAINER_IMAGE" \
     --container-mounts="$CONTAINER_MOUNTS" \
     /bin/sh -c "
       if [ ! -f ${LMS_HOME}/bin/lms ]; then
         cp -r /opt/lmstudio-install/. ${LMS_HOME}/
       fi &&
       ${LMS_HOME}/bin/lms daemon up &&
       ${LMS_HOME}/bin/lms server start --port 1234 --bind 0.0.0.0 &&
       ${LMS_HOME}/bin/lms get qwen/qwen3-4b-2507 -y &&
       ${LMS_HOME}/bin/lms load qwen/qwen3-4b-2507 &&
       tail -f /dev/null
     "
