#!/bin/sh

# map desired volumes to mount locations
VOLUME_MAPS=(
    "/home/schuelke:/home/schuelke"
    "/storage2/fs1/a.wilcox/Active:/storage2/fs1/a.wilcox/Active"
)

# collapse maps to space delimited string
LSF_DOCKER_VOLUMES="${VOLUME_MAPS[*]}"

# prepend path with user home
PATH="/home/schuelke:$PATH"

# map target port (before colon) to RStudio port (after colon)
LSF_DOCKER_PORTS='8787:8787'

# submit job
## -Is creates pseudo-terminal in shell mode
## -G desired user group
## -q desired queue
## -R specify resource requirements
## -a specify an execution substitution (esub) application with job command
bsub -Is -G compute-ohids -q ohids-interactive -R 'select[port8787=1]' -a 'docker(themadstatter/washu-ris-rocker-tidyverse:4.0.2)' /bin/bash

# when forwarded to schuelke@compute${N}-exec-${NODE}:~$ run `rstudio-server start`

# finally visit http://compute${N}-exec-${NODE}.ris.wustl.edu:${PORT}
