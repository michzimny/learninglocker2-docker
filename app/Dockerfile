FROM debian:9

RUN apt-get update \
    && apt-get install -y \
        wget \
        procps \
        curl \
        git \
        python \
        build-essential \
        xvfb \
        apt-transport-https \
        unzip \
        gettext-base \
        socat \
    && wget -qO- https://deb.nodesource.com/setup_8.x | bash \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn

ENV LL_TAG=v2.8.2
RUN git clone https://github.com/LearningLocker/learninglocker.git /opt/learninglocker \
    && cd /opt/learninglocker \
    && git checkout $LL_TAG \
    && yarn install \
    && yarn build-all

WORKDIR /opt/learninglocker

EXPOSE $UI_PORT $API_PORT

COPY env.template .env.template
COPY entrypoint-common.sh entrypoint-common.sh
COPY entrypoint-ui.sh entrypoint-ui.sh

ENTRYPOINT ["./entrypoint-common.sh"]

