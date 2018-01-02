FROM node:8.7.0-alpine as node

FROM ruby:2.4.2-alpine3.6

# timezone
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del --purge tzdata

ARG PROJECT_NAME
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

COPY Gemfile Gemfile.lock $APP_ROOT/

ENV BUNDLE_GEMFILE=$APP_ROOT/Gemfile \
    BUNDLE_JOBS=4 \
    BUNDLE_PATH=/usr/local/bundle

# デプロイ時には不要なライブライを削除する
# RUN apk --no-cache --virtual gem-builddeps add alpine-sdk build-base && \
#     bundle install && \
#     apk del --purge gem-builddeps

RUN apk --no-cache --virtual gem-builddeps add alpine-sdk build-base && \
    bundle install

# yarn install
COPY package.json yarn.lock .postcssrc.yml ./
RUN yarn install

# # assets precompile
# COPY Rakefile .babelrc ./
# COPY config config
# COPY app/assets app/assets
# COPY app/javascript app/javascript
# COPY bin bin
# RUN RAILS_ENV=production bundle exec rails assets:precompile

COPY .rubocop.yml ./

COPY . $APP_ROOT

EXPOSE 3000

# docker-composeやkubernetesのcommandがある場合は実行されない
CMD ["rails", "server", "-b", "0.0.0.0"]
