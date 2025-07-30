# washu-caci-ignite:rstudio

## Overview

This docker file extends ghcr.io/washu-it-ris/novnc:ubuntu22.04:

1. r-base (v4.5.1)
2. RStudio Server (v2025.05.1-513)
3. Simba Spark ODBC Driver (v2.9.1)
4. System DSN file with entry for SQL warehouse "Wilcox Lab SQL01" on Databricks

## Hosted

[docker.io/themadstatter/washu-caci-ignite:rstudio](https://hub.docker.com/repository/docker/themadstatter/washu-caci-ignite/tags/rstudio)

## Usage

Run as a Custom noVNC Image in [Open OnDemand](https://ood.ris.wustl.edu/pun/sys/dashboard/batch_connect/sys/custom_novnc_image/session_contexts/new).

### Docker Image Field

```
docker.io/themadstatter/washu-caci-ignite:rstudio
```

### Number of hours Field

Ensure a sufficient number of hours as the job will terminate at the given time.

### RStudio

See example script for how to start RStudio and connect at `http://localhost:8787`.

## Optional Prerequisites

### .Rprofile

Edit and add the following to your `~/.Rprofile` to set your library location to use storage:

```
d <- sprintf("/home/${user}/lib/R/%s.%s/", R.version$major, R.version$minor)
if (!file.exists(d))
    dir.create(d, recursive = TRUE)
.libPaths(c(d, .libPaths()))
rm(d)
```

See also an example [.Rprofile](.Rprofile).

### Example Script to Run RStudio

Edit and add the following to a file in storage to make starting RStudio easier:

```
#! /bin/sh

cat > /tmp/db.conf << EOL
provider=sqlite
directory=/tmp/rstudio-db
EOL

mkdir -p /tmp/rstudio-data
mkdir -p /tmp/rstudio-db

/usr/lib/rstudio-server/bin/rserver --www-port 8787 --server-daemonize 0 --server-user=${user} --database-config-file=/tmp/db.conf --server-data-dir=/tmp/rstudio-data --secure-cookie-key-file=/tmp/rstudio-data/secure-cookie-key --auth-none 1
```

See also an example [run_rserver.sh](run_rserver.sh).

Make sure your script is executable:

```
chmod +x ./run_rserver.sh
```

Then you can start RStudio with:

```
./run_rserver.sh
```
