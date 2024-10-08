ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION-slim-buster

ARG PG_MAJOR
ARG NODE_MAJOR
ARG BUNDLER_VERSION
ARG YARN_VERSION

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
    imagemagick \
    pkg-config \
    shared-mime-info \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

ADD https://dl.yarnpkg.com/debian/pubkey.gpg /tmp/yarn-pubkey.gpg
RUN apt-key add /tmp/yarn-pubkey.gpg && rm /tmp/yarn-pubkey.gpg
RUN echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    libpq-dev \
    libcurl4-openssl-dev \
    postgresql-client-$PG_MAJOR \
    nodejs \
    yarn=$YARN_VERSION-1 \
    $(cat /tmp/Aptfile | xargs) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

RUN gem update --system && \
    rm /usr/local/lib/ruby/gems/*/specifications/default/bundler-*.gemspec && \
    gem uninstall bundler && \
    gem install bundler -v $BUNDLER_VERSION

#### Chromedriver dependencies & Chrome
ENV PATH="/root/.webdrivers:${PATH}"
ENV CHROME_VERSION="92.0.4515.107"
RUN apt-get update && apt-get install -y wget curl unzip xvfb libxi6 libgconf-2-4 libnss3 wget \
    && TEMP_DEB="$(mktemp)" \
    && wget -O "$TEMP_DEB" 'http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_92.0.4515.107-1_amd64.deb' \
    && dpkg -i "$TEMP_DEB" \
    ; apt-get -f -y install \
    && rm -f "$TEMP_DEB";
#####

RUN mkdir -p /app

WORKDIR /app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
