# washu-ris-ris-registry-shared-rstudio:4.1.2

## Overview

This docker file extends [gcr.io/ris-registry-shared/rstudio:4.1.2](https://console.cloud.google.com/gcr/images/ris-registry-shared/GLOBAL/rstudio@sha256:839b8bcb94f4129d7f82223b5976d017ae014a906f312ad144d1a711e2631eef/details?tag=4.1.2):

1. build-essential
    - meta-package that provides the essential tools and libraries required for compiling and building software from source code
2. libcurl4-gnutls-dev
    - provides the development files (ie. includes, static library, manual pages) that allow one to build software which uses libcurl
3. libxml2-dev
    - XML parsing library
4. libssl-dev
    - provides the necessary header files and libraries for using the OpenSSL library's TLS (Transport Layer Security) and SSL (Secure Sockets Layer) functionalities
5. libssh-dev
    - remotely execute programs, transfer files, use a secure and transparent tunnel for your remote programs
6. default-jdk
    - java development kit
7. libmariadb-dev
    - MariaDB Connector

## Hosted

[docker.io/themadstatter/washu-ris-ris-registry-shared-rstudio:4.1.2](https://hub.docker.com/repository/docker/themadstatter/washu-ris-ris-registry-shared-rstudio/general)

## Prerequisites

### .Rprofile

Add the following to your `~/.Rprofile` to set your library location to use storage:

```
vals <- paste('/storage${N}/fs1/${VOLUME}>/Active/R_libraries/', paste(R.version$major, R.version$minor, sep="."), sep="")
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
export PASSWORD=${NOVNC_PASSWORD}
export LSF_DOCKER_PORTS="${PORT}:${PORT}"
export LSF_DOCKER_VOLUMES="/storage${N}/fs1/${VOLUME}/Active:/storage${N}/fs1/${VOLUME}/Active"
bsub -Is -R 'select[port${PORT}=1]' -q ${QUEUE} -a 'docker(themadstatter/washu-ris-ris-registry-shared-rstudio:4.1.2)' supervisord -c /app/supervisord.conf
```

See also an [example_submission_script.sh](example_submission_script.sh).

You can then access the instance via `https://compute${N}-exec-${NODE}.compute.ris.wustl.edu:${PORT}/vnc.html`, where `${NODE}` will be reported in your ssh session.
