FROM gcr.io/ris-registry-shared/rstudio:4.1.2

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
# https://stackoverflow.com/questions/58607146/unable-to-run-a-simple-jni-program-error-message-when-installing-rjava-on-r-3
ENV LD_LIBRARY_PATH=/usr/lib/jvm/java-1.11.0-openjdk-amd64/lib/server:$LD_LIBRARY_PATH
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update --fix-missing && \
apt-get install -y build-essential \
libcurl4-gnutls-dev libxml2-dev \
libssl-dev \
libssh-dev \
default-jdk \
libmariadb-dev && \
apt-get clean
