# Copyright 2015 Jubic Oy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# 		http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM debian:stretch-slim

# Install base deps and Passenger
RUN  apt-get update \
  && apt-get install -y \
    apt-transport-https \
    autoconf \
    automake \
    bison \
    build-essential \
    ca-certificates \
    curl \
    gawk \
    gettext \
    gnupg \
    libffi-dev \
    libgdbm-dev \
    default-libmysqlclient-dev \
    libncurses5-dev \
    libnss-wrapper \
    libpq-dev \
    libreadline6-dev \
    libsqlite3-dev \
    libssl1.0-dev \
    libyaml-dev \
    libtool \
    nodejs \
    passenger \
    pkg-config \
    zlib1g-dev \
  && ln -sf /usr/bin/nodejs /usr/local/bin/node \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
  && echo deb https://oss-binaries.phusionpassenger.com/apt/passenger stretch main > /etc/apt/sources.list.d/passenger.list \
  && apt-get update \
  && apt-get install -y passenger \
  && passenger-config validate-install \
  && rm -rf /var/lib/apt/lists/*

# Install tini
ENV TINI_SHA 066ad710107dc7ee05d3aa6e4974f01dc98f3888
RUN curl -fL https://github.com/krallin/tini/releases/download/v0.5.0/tini-static -o /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA /bin/tini" | sha1sum -c -

# Setup NSS wrapper
ENV RUBY_HOME /ruby_home
RUN useradd -u 1001 -d ${RUBY_HOME} -m -s /bin/bash ruby \
  && mkdir -p "${RUBY_HOME}/nsswrap"
ADD passwd.template "${RUBY_HOME}/nsswrap/passwd.template"
USER ruby

# Install RVM
RUN set -ex \
  && for key in \
    409B6B1796C275462A1703113804BB82D39DC0E3 \
    7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
  ; do \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
  && curl -sSL https://get.rvm.io | bash -s stable

ADD install_ruby.sh ${RUBY_HOME}/
ADD entrypoint.sh ${RUBY_HOME}/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/bin/tini", "--", "/ruby_home/entrypoint.sh"]
