#!/bin/sh
cd ~
while getopts p:v: flag
do
  case "${flag}" in
    p) password=${OPTARG};;
  esac
done
if [ -z "$password" ]
then
  echo "Password not found. Use -p <password> to pass."
  exit 1
fi
export PASSWORD=$password
export LSF_DOCKER_PORTS='8080:8080'
export LSF_DOCKER_VOLUMES="/storage1/fs1/babulalg/Active:/storage1/fs1/babulalg/Active"
bsub -Is -R 'select[port8080=1]' -q general-interactive -a 'docker(themadstatter/washu-roelab-drives:rstudio-4.1.2)' supervisord -c /app/supervisord.conf
