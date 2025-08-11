# washu-caci-ignite:ctakes

## Overview

This docker file extends ghcr.io/washu-it-ris/novnc:ubuntu22.04_cuda12.4_runtime:

1. Java 17
2. Python 3

## Hosted

[docker.io/themadstatter/washu-caci-ignite:ctakes](https://hub.docker.com/repository/docker/themadstatter/washu-caci-ignite/tags/ctakes)

## Usage

Run as a Custom noVNC Image in [Open OnDemand](https://ood.ris.wustl.edu/pun/sys/dashboard/batch_connect/sys/custom_novnc_image/session_contexts/new).

### Docker Image Field

```
docker.io/themadstatter/washu-caci-ignite:ctakes
```

### Memory (GB) Field

Use of the UMLS dictionary will require 4+ GB.

### Number of hours Field

Ensure a sufficient number of hours as the job will terminate at the given time.

## Install cTAKES

### Download

Download a pre-built copy of cTAKES from [github](https://github.com/apache/ctakes/releases) and unzip the release file.

See [download_ctakes_6.0.0.sh](download_ctakes_6.0.0.sh) for an example script.

### UMLS License

Obtain a [Unified Medical Language System](https://www.nlm.nih.gov/research/umls/index.html) (UMLS) License.

### Run UMLS Package Fetcher

Use the [UMLS Package Fetcher](https://github.com/apache/ctakes/wiki/cTAKES+UMLS+Package+Fetcher).

```
bin/getUmlsDictionary.sh
```

## Example Clinical Pipeline

See [exampleClinicalPipeline/runClinicalPipeline.sh](exampleClinicalPipeline/runClinicalPipeline.sh) for an example of running the default clinical pipeline.
