#!/bin/sh

LSF_DOCKER_VOLUMES_1="/home/schuelke:/home/schuelke"
LSF_DOCKER_VOLUMES_2="/storage2/fs1/a.wilcox/Active:/storage2/fs1/a.wilcox/Active"
LSF_DOCKER_VOLUMES="${LSF_DOCKER_VOLUMES_1} ${LSF_DOCKER_VOLUMES_2}"
PATH="/home/schuelke:$PATH"
LSF_DOCKER_PORTS='8787:8787'
bsub -Is -G compute-ohids -q ohids-interactive -R 'select[port8787=1]' -a 'docker(themadstatter/washu-ris-rocker-tidyverse:4.0.2)' /bin/bash

# then at schuelke@compute1-exec-${N}:~$ rstudio-server start
# and visit http://compute1-exec-${N}.ris.wustl.edu:${PORT}
