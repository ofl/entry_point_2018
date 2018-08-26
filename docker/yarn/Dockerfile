FROM node:8.11.4-alpine
LABEL maintainer "towerofl <towerofl@gmail.com>"

ENV DEV_PACKAGES="build-base libpng-dev lcms2-dev bash"

RUN mkdir -p /app && \
    mkdir -p /opt
WORKDIR /app

# Install dependencies
RUN \
  set -x && \
  apk update && apk upgrade && apk add --no-cache $DEV_PACKAGES && \
  npm install -g npm && \
  npm install -g yarn

ENTRYPOINT ["yarn"]
