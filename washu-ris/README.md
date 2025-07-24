# washu-ris <img src="img/ris_logo.jpg" align="right" width="125px" />

## Overview

This repository contains Dockerfiles for different Docker containers for use on the [Washington University in St. Louis (WashU) Information Technology (IT) Research Infrastructure Services (RIS) Compute Platforms](https://washu.atlassian.net/wiki/spaces/RUD/overview).

## Prerequisites

### Required

1. [Activate Compute Services](https://ris.wustl.edu/services/compute/resources/)

### Optional

2. Install [Git](https://git-scm.com/downloads)
3. Create [Docker Hub Account](https://hub.docker.com/)
4. Install [Docker](https://docs.docker.com/get-docker/)

## Prepare Container

### Use a Hosted Image

[docker.io/themadstatter](https://hub.docker.com/repositories/themadstatter)

### Build from Source

1. `git clone https://github.com/the-mad-statter/dockerfiles
2. navigate to desired Dockerfile directory
3. `docker build -t ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG} .` (note the trailing dot)
4. `docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG}`

## Run the Container on the Compute Platform

1. `ssh ${COMPUTE_USERNAME}@compute${N}-client-${NODE}.ris.wustl.edu`
2. submit a job

## About

### Washington University in Saint Louis <img src="img/brookings_seal.png" align="right" width="125px"/>

Established in 1853, [Washington University in Saint
Louis](https://www.wustl.edu) is among the world’s leaders in teaching,
research, patient care, and service to society. Bosting 24 Nobel
laureates to date, the University is ranked 7th in the world for most
cited researchers, received the 4th highest amount of NIH medical
research grants among medical schools in 2019, and was tied for 1st in
the United States for genetics and genomics in 2018. The University is
committed to learning and exploration, discovery and impact, and
intellectual passions and challenging the unknown.