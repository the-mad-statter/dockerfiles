#!/bin/sh

LSF_DOCKER_VOLUMES='/home/schuelke:/home/schuelke /storage2/fs1/a.wilcox/Active:/storage2/fs1/a.wilcox/Active'
LSF_DOCKER_PORTS='8787:8787'
bsub -Is -G compute-ohids-condo -q general-interactive -R 'select[port8787=1]' -a 'docker(themadstatter/washu-ris-rocker-tidyverse:4.0.2)' /bin/bash

# then at schuelke@compute1-exec-${N}:~$ rstudio-server start
# and visit http://compute1-exec-${N}.ris.wustl.edu:${PORT}
