# washu-ris-rocker-tidyverse:4.0.2

## Overview

This docker file extends docker.io/rocker/tidyverse:4.0.2:

1. ODBC driver manager
2. Spark ODBC Driver
3. System DSN file with entry for SQL warehouse "Wilcox Lab SQL01" on Databricks

## Hosted

[docker.io/themadstatter/washu-ris-rocker-tidyverse:4.0.2](https://hub.docker.com/repository/docker/themadstatter/washu-ris-rocker-tidyverse/general)

## Prerequisites

### .Rprofile

Add the following to your `~/.Rprofile` to set your library location to use storage:

```
vals <- paste('/storage${N}/fs1/${VOLUME}/Active/R_libraries/', paste(R.version$major, R.version$minor, sep="."), sep="")
for(devlib in vals) {
    if (!file.exists(devlib))
    dir.create(devlib)
x <- .libPaths()
x <- .libPaths(c(devlib, x))
}
rm(x, vals)
```

## Example Job Submission

```
LSF_DOCKER_VOLUMES='/home/${USER}:/home/${USER} /storage${N}/fs1/${VOLUME}/Active:/storage${N}/fs1/${VOLUME}/Active'
LSF_DOCKER_PORTS='8787:8787'
bsub -Is -G ${GROUP} -q ${QUEUE} -R 'select[port8787=1]' -a 'docker(themadstatter/washu-ris-rocker-tidyverse:4.0.2)' /bin/bash
```

See also an [example_submission_script.sh](example_submission_script.sh).

After landing at `${USER}@compute${N}-exec-${N}:~$` run

```
rstudio-server start
```

You can then access the instance via `https://compute1-exec-${N}.compute.ris.wustl.edu:${PORT}`, where `${N}` will be reported in your ssh session.
