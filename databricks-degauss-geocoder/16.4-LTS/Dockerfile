FROM databricksruntime/standard:16.4-LTS

# Suppress interactive configuration prompts
ENV DEBIAN_FRONTEND=noninteractive

# DeGAUSS container metadata
ENV degauss_name="geocoder"
ENV degauss_version="3.3.0"
ENV degauss_description="geocodes"
ENV degauss_argument="valid_geocode_score_threshold [default: 0.5]"

# Add OCI labels based on environment variables too
LABEL "org.degauss.name"="${degauss_name}"
LABEL "org.degauss.version"="${degauss_version}"
LABEL "org.degauss.description"="${degauss_description}"
LABEL "org.degauss.argument"="${degauss_argument}"

# Install Linux packages
RUN apt-get update \
  && apt-get install --yes \
    flex \
 	libcurl4-openssl-dev \
 	libsqlite3-dev \
	libssh2-1-dev \
	libssl-dev \
	libxml2-dev \
	make \
	pkg-config \
	ruby-dev \
	sqlite3 \
  && apt-get clean

RUN gem install sqlite3 json Text

# Install R as per databricksruntime/rbase
RUN apt-get update \
  && apt-get install --yes software-properties-common apt-transport-https \
  && gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
  && gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | sudo apt-key add - \
  && add-apt-repository -y "deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
  && apt-get update \
  && apt-get install --yes \
    libssl-dev \
    r-base \
    r-base-dev \
  && add-apt-repository -r "deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
  && apt-key del E298A3A825C0D65DFD57CBB651716619E084DAB9 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# hwriterPlus is used by Databricks to display output in notebook cells
# hwriterPlus is removed for newer version of R, so we hardcode the dependency to archived version
# Rserve allows Spark to communicate with a local R process to run R code
RUN R -e "options(repos = list(CRAN = 'https://packagemanager.posit.co/cran/latest')); install.packages(c('hwriter', 'TeachingDemos', 'htmltools'))" \
 && R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/hwriterPlus/hwriterPlus_1.0-3.tar.gz', repos=NULL, type='source')" \
 && R -e "install.packages('Rserve', repos='http://rforge.net/')"

# Install R Libraries for entrypoint.R 
RUN R -e "install.packages(c('docopt', 'knitr', 'jsonlite', 'remotes'), repos = 'https://cloud.r-project.org')" \
  && R -e "remotes::install_github('degauss-org/dht')" \
  && R -e "remotes::install_github('cole-brokamp/mappp')"

# Copy
RUN mkdir /app
WORKDIR /app
COPY geocoder/Makefile.ruby .
COPY geocoder/src ./src
COPY geocoder/lib ./lib
COPY geocoder/gemspec ./gemspec
COPY geocoder/geocode.rb .
COPY geocoder/entrypoint.R .

# Make
RUN make -f Makefile.ruby install \
  && gem install Geocoder-US-2.0.4.gem

# Add TIGER/Line Database
ADD https://geomarker.s3.amazonaws.com/geocoder_2021.db /opt/geocoder.db
