FROM databricksruntime/standard:12.2-LTS

RUN apt-get update \
    && apt-get install -y --no-install-recommends cowsay fortune fortunes \
    && apt-get clean

ENV PATH="$PATH:/usr/games"
RUN export PATH
