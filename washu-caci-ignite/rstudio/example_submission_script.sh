#!/bin/sh

# allow container to bind to host ports
export LSF_DOCKER_NETWORK=host

# map desired volumes to mount locations
VOLUME_MAPS=(
    "/home/schuelke:/home/schuelke"
    "/storage2/fs1/a.wilcox/Active:/storage2/fs1/a.wilcox/Active"
)

# collapse maps to space delimited string
export LSF_DOCKER_VOLUMES="${VOLUME_MAPS[*]}"

# prepend path with user home (optional)
export PATH="/home/schuelke:$PATH"

# map target port (before colon) to RStudio port (after colon)
export LSF_DOCKER_PORTS='8787:8787'

# submit job
## -Is creates pseudo-terminal in shell mode
## -G desired user group
## -q desired queue
## -R specify resource requirements
## -a specify an execution substitution (esub) application with job command
bsub -Is -G compute-ohids -q ohids-interactive -R 'select[port8787=1]' -a 'docker(themadstatter/washu-caci-ignite:rstudio)' /bin/bash

# when forwarded to schuelke@compute${N}-exec-${NODE}:~$ run `./scripts/caci/run_rserver.sh`

# finally visit http://compute${N}-exec-${NODE}.ris.wustl.edu:${PORT}
