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

# install LL app
ENV LL_TAG=v2.8.2
RUN git clone https://github.com/LearningLocker/learninglocker.git /opt/learninglocker \
    && cd /opt/learninglocker \
    && git checkout $LL_TAG \
    && yarn install \
    && yarn build-all

WORKDIR /opt/learninglocker

# make a copy of the origin storage directory that will be used in entrypoint-common.sh
# to fill up a volume mounted here, if it's empty
RUN cp -r storage storage.template

# service api exposes port 8080
# service ui exposes port 3000
# see env.template
EXPOSE 3000 8080

COPY env.template .env.template
COPY entrypoint-common.sh entrypoint-common.sh
COPY entrypoint-ui.sh entrypoint-ui.sh

ENTRYPOINT ["./entrypoint-common.sh"]

