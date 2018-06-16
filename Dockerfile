FROM ruby:2.4.2-alpine as builder
RUN apk --update add --virtual gem-builddeps \
    git \
    build-base \
    curl-dev \
    linux-headers \
    postgresql-dev
RUN gem install bundler
WORKDIR /tmp
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_JOBS=4
RUN bundle install
RUN apk del gem-builddeps

FROM ruby:2.4.2-alpine
ENV LANG ja_JP.UTF-8
RUN apk --update add \
    bash \
    nodejs \
    postgresql-dev \
    tzdata
RUN gem install bundler

# Install Yarn
ENV PATH=/root/.yarn/bin:$PATH
RUN apk add --virtual build-yarn curl && \
    touch ~/.bashrc && \
    curl -o- -L https://yarnpkg.com/install.sh | sh && \
    apk del build-yarn

WORKDIR /tmp
COPY Gemfile Gemfile.lock ./
COPY --from=builder /usr/local/bundle /usr/local/bundle

ARG PROJECT_NAME="entry_point_2018"
ENV APP_HOME /usr/src/${PROJECT_NAME}
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY . $APP_HOME

# yarn install
# COPY package.json yarn.lock .postcssrc.yml ./
RUN yarn install

# docker-composeやkubernetesのcommandがある場合は実行されない
CMD ["rails", "server", "-b", "0.0.0.0"]
