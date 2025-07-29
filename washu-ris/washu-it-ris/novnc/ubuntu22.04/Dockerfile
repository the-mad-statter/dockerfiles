FROM ghcr.io/washu-it-ris/novnc:ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        dirmngr \
        fonts-dejavu \
        gdebi-core \
        gnupg \
        libapparmor1 \
        libclang-dev \
        libcurl4-openssl-dev \
        libfontconfig1-dev \
        libjpeg-dev \
        libpng-dev \
        libpq5 \
        libssl-dev \
        libxml2-dev \
        psmisc \
        software-properties-common \
        sudo \
        wget \
        libsasl2-modules-gssapi-mit \
        odbcinst \
        unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | apt-key add - && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" && \
    apt-get update && \
    apt-get install -y --no-install-recommends r-base && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2025.05.1-513-amd64.deb && \
    gdebi -n rstudio-server-2025.05.1-513-amd64.deb && \
    rm rstudio-server-2025.05.1-513-amd64.deb
    
RUN wget https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/odbc/2.9.1/SimbaSparkODBC-2.9.1.1001-Debian-64bit.zip && \
    unzip SimbaSparkODBC-2.9.1.1001-Debian-64bit.zip && \
    dpkg -i simbaspark_2.9.1.1001-2_amd64.deb && \
    rm simbaspark_2.9.1.1001-2_amd64.deb SimbaSparkODBC-2.9.1.1001-Debian-64bit.zip



#echo "provider=sqlite" >> /tmp/db.conf
#echo "directory=/tmp/rstudio-db" >> /tmp/db.conf
#mkdir -p /tmp/rstudio-data /tmp/rstudio-db
#/usr/lib/rstudio-server/bin/rserver --www-port 8787 --server-daemonize 0 --server-user=schuelke --database-config-file=/tmp/db.conf --server-data-dir=/tmp/rstudio-data --secure-cookie-key-file=/tmp/rstudio-data/secure-cookie-key --auth-none 1
