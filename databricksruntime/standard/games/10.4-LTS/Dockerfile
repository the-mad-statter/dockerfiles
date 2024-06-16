FROM databricksruntime/standard:10.4-LTS

RUN apt-get update \
    && apt-get install -y --no-install-recommends cowsay fortune fortunes \
    && apt-get clean

ENV PATH="$PATH:/usr/games"
RUN export PATH
