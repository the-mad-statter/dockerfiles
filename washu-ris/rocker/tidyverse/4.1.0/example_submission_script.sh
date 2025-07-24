#!/bin/sh

LSF_DOCKER_VOLUMES_1="$HOME:$HOME"
LSF_DOCKER_VOLUMES_2="$HOME/rstudio_db/:/var/lib/rstudio-server"
LSF_DOCKER_VOLUMES_3="/storage2/fs1/a.wilcox/Active:/storage2/fs1/a.wilcox/Active"
LSF_DOCKER_VOLUMES="${LSF_DOCKER_VOLUMES_1} ${LSF_DOCKER_VOLUMES_2} ${LSF_DOCKER_VOLUMES_3}"
PATH="$HOME:$PATH" 
LSF_DOCKER_PORTS='8787:8787' 
bsub -Is -G compute-ohids -q general-interactive -R 'select[port8787=1]' -a 'docker(themadstatter/washu-ris-rocker-tidyverse:4.1.0)' /bin/bash

# then at schuelke@compute1-exec-${N}:~$ rstudio-server start
# and visit http://compute1-exec-${N}.ris.wustl.edu:${PORT}
