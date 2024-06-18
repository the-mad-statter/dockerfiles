# About

Extensions of [databricksruntime/standard](https://github.com/databricks/containers/tree/master/ubuntu/standard) with [cowsay](https://en.wikipedia.org/wiki/Cowsay) and [fortune](https://en.wikipedia.org/wiki/Fortune_(Unix)).

# Images

These images are available on [Docker Hub](https://hub.docker.com/repository/docker/themadstatter/databricksruntime-standard-games/general).

# Databricks Notebook Examples

## Shell

```
%sh

fortune | cowsay -f tux
```
