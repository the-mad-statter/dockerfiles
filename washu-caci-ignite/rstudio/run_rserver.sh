#! /bin/sh

cat > /tmp/db.conf << EOL
provider=sqlite
directory=/tmp/rstudio-db
EOL

mkdir -p /tmp/rstudio-data
mkdir -p /tmp/rstudio-db

/usr/lib/rstudio-server/bin/rserver --www-port 8787 --server-daemonize 0 --server-user=schuelke --database-config-file=/tmp/db.conf --server-data-dir=/tmp/rstudio-data --secure-cookie-key-file=/tmp/rstudio-data/secure-cookie-key --auth-none 1
