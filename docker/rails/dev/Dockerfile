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
RUN gem install bundler

# Install Yarn
ENV PATH=/root/.yarn/bin:$PATH
RUN apk add --no-cache --virtual build-yarn curl && \
    touch ~/.bashrc && \
    curl -o- -L https://yarnpkg.com/install.sh | sh && \
    apk del build-yarn

ARG PROJECT_NAME=$PROJECT_NAME
ENV APP_HOME /usr/src/${PROJECT_NAME}

ENV ENTRYKIT_VERSION 0.4.0

RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && mv entrykit /bin/entrykit \
    && chmod +x /bin/entrykit \
    && entrykit --symlink \
    && bundle config build.nokogiri --use-system-librarie

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN yarn install

ENTRYPOINT [ \
  "prehook", "ruby -v", "--", \
  "prehook", "bundle install -j4 --path vendor/bundle", "--", \
  "prehook", "rm -f /app/tmp/pids/server.pid", "--" \
  ]
