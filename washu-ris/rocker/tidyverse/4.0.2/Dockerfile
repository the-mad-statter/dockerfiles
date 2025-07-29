# 1. from tidyverse (RStudio Server + tidyverse packages & devtools)
FROM rocker/tidyverse:4.0.2

# 2. install driver manager
RUN apt-get update && apt-get install -y odbcinst unixodbc

# 3. install spark driver
RUN apt-get install -y libsasl2-modules-gssapi-mit && \
    mkdir /simbaspark && \
    cd /simbaspark && \
    wget https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/odbc/2.9.1/SimbaSparkODBC-2.9.1.1001-Debian-64bit.zip && \
    unzip SimbaSparkODBC-2.9.1.1001-Debian-64bit.zip && \
    dpkg -i simbaspark_2.9.1.1001-2_amd64.deb && \
    cd / && \
    rm -r simbaspark

# 4. install DBI and odbc R packages
RUN R -e "install.packages(c('DBI', 'odbc'))"

# 5. copy system data source
COPY odbc.ini /etc/odbc.ini
