FROM ruby:2.4.4-alpine

ENV LANG C.UTF-8
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    git \
    less \
    libxslt-dev \
    build-base \
    curl-dev \
    linux-headers \
    bash \
    nodejs \
    postgresql-dev \
    tzdata
RUN gem install bundler &&  \
    bundle config build.nokogiri --use-system-librarie

# Install Yarn
ENV PATH=/root/.yarn/bin:$PATH
RUN apk add --no-cache --virtual build-yarn curl && \
    touch ~/.bashrc && \
    curl -o- -L https://yarnpkg.com/install.sh | sh && \
    apk del build-yarn

ARG PROJECT_NAME=$PROJECT_NAME
ENV APP_HOME /usr/src/${PROJECT_NAME}
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_PATH=/usr/local/bundle

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile Gemfile.lock ./

RUN bundle install -j4
RUN yarn install
