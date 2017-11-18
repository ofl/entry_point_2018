FROM node:8.7.0-alpine as node

FROM ruby:2.4.2-alpine3.6

# timezone
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del --purge tzdata

EXPOSE 3000

ENV PROJECT_NAME entry_point_2018
ENV APP_ROOT /usr/src/$PROJECT_NAME

# user
RUN apk --no-cache add shadow

WORKDIR $APP_ROOT

# install nodejs yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/include/node /usr/local/include/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /opt/yarn /opt/yarn
RUN ln -s /usr/local/bin/node /usr/local/bin/nodejs && \
    ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && \
    ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn

RUN gem install bundler

# install dependency package
RUN apk --no-cache add tzdata libstdc++ postgresql-dev

# bundle install
#    bundle install --without development test --path vendor/bundle && \
COPY Gemfile Gemfile.lock $APP_ROOT/

ENV BUNDLE_GEMFILE=$APP_ROOT/Gemfile \
    BUNDLE_JOBS=4

RUN apk --no-cache --virtual gem-builddeps add alpine-sdk && \
    bundle install --path vendor/bundle && \
    apk del --purge gem-builddeps
