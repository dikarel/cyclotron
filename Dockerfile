FROM debian:jessie
MAINTAINER Darius I. Karel <me@dikarel.com>

# Repo locations
ENV ALPINE_REPO http://dl-3.alpinelinux.org/alpine/edge/testing
ENV CYCLOTRON_REPO=https://github.com/ExpediaInceCommercePlatform/cyclotron

# Version locks
ENV GIT_VERSION 2.10.2-r0
ENV GULP_VERSION 3.9.1
ENV MONGODB_VERSION 3.2.10-r1
ENV NODEJS_VERSION 6.9.1-r0
ENV SUPERVISOR_VERSION 3.2.0-r0

# Install system dependencies
RUN apk --no-cache add --repository $ALPINE_REPO \
    git=$GIT_VERSION \
    mongodb=$MONGODB_VERSION \
    nodejs=$NODEJS_VERSION \
    supervisor=$SUPERVISOR_VERSION && \
    npm install -g --progress=false -s \
    gulp@$GULP_VERSION

RUN git clone $CYCLOTRON_REPO /cyclotron

# Cyclotron 1.43.0
ENV CYCLOTRON_VERSION 6ce2eb0682bfcfeee9dc879c2cde4d0877ff5d7a

WORKDIR /cyclotron
RUN git reset $CYCLOTRON_VERSION --hard
RUN apk del git

WORKDIR /cyclotron/cyclotron-svc
RUN cp config/sample.config.js config/config.js

# TODO: Expose and volume
# TODO: Clean this up

# Run cyclotron and mongodb using supervisord
COPY supervisord.conf /etc/supervisord.conf

ENTRYPOINT mongod
# ENTRYPOINT supervisord -c /etc/supervisord.conf
