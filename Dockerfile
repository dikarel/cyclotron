FROM node:6.9.1
MAINTAINER Darius I. Karel <me@dikarel.com>

# TODO: cyclotron-svc
# TODO: cyclotron-site
# TODO: Quiet install
# TODO: Volume and expose
# TODO: Deploy
# TODO: CI
# TODO: Trim and cleanup
# TODO: Logging
# TODO: Security audit
# TODO: Version locking
# TODO: Custom config
# TODO: Tests

# System deps
RUN apt-get update
RUN apt-get install -y mongodb supervisor git

# Cyclotron
ENV CYCLOTRON_REPO=https://github.com/ExpediaInceCommercePlatform/cyclotron
ENV CYCLOTRON_VERSION 6ce2eb0682bfcfeee9dc879c2cde4d0877ff5d7a
RUN git clone $CYCLOTRON_REPO /cyclotron
WORKDIR /cyclotron
RUN git reset $CYCLOTRON_VERSION --hard

# node-gyp
RUN apt-get install -y g++ make python
RUN npm install --progress false --silent -g node-gyp

# cyclotron-svc
WORKDIR /cyclotron/cyclotron-svc
RUN npm install --progress false --silent
RUN cp config/sample.config.js config/config.js
EXPOSE 8077

# wait-for-it
COPY wait-for-it.sh /usr/bin/wait-for-it
RUN chmod +x /usr/bin/wait-for-it

# RUN apt-get install -y ca-certificates
# RUN update-ca-certificates

RUN mkdir /data
COPY supervisord.conf /etc/supervisord.conf
ENTRYPOINT supervisord -c /etc/supervisord.conf
