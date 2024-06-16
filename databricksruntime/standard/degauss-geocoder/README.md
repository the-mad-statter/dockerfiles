## About

Extensions of databricksruntime/standard with the [DeGAUSS](https://degauss.org) [geocoder](https://degauss.org/geocoder)

## Images

These images are available on [Docker Hub](https://hub.docker.com/repository/docker/themadstatter/databricksruntime-standard-degauss-geocoder/general).

## Databricks Notebook Examples

```
%sh

ruby /app/geocode.rb "3333 Burnet Ave Cincinnati OH 45229"
```

```
%sh

wget https://raw.githubusercontent.com/degauss-org/geocoder/master/test/my_address_file.csv
Rscript /app/entrypoint.R my_address_file.csv 0.5
```
