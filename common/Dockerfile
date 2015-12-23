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
FROM debian:jessie
MAINTAINER Vilppu Vuorinen "vilppu.vuorinen@jubic.fi"

ADD apt/unstable.pref /etc/apt/preferences.d/unstable.pref
ADD apt/unstable.list /etc/apt/sources.list.d/unstable.list

# Base deps
RUN apt-get update \
  && apt-get install -y \
    curl \
    apt-transport-https \
    ca-certificates \
    build-essential \
    gawk \
    libreadline6-dev \
    zlib1g-dev \
    libssl-dev \
    libyaml-dev \
    libsqlite3-dev \
    libpq-dev \
    libmysqlclient-dev \
    autoconf \
    libgdbm-dev \
    libncurses5-dev \
    automake \
    libtool \
    bison \
    pkg-config \
    libffi-dev \
    gettext \
  && apt-get install -y -t unstable libnss-wrapper

# Install Passenger
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
  && echo deb https://oss-binaries.phusionpassenger.com/apt/passenger jessie main > /etc/apt/sources.list.d/passenger.list \
  && apt-get update \
  && apt-get install -y passenger \
  && passenger-config validate-install

# Install NodeJS (some legacy version I presume)
RUN apt-get install -y nodejs \
  && ln -sf /usr/bin/nodejs /usr/local/bin/node

# Cleanup
RUN rm -rf /var/lib/apt/lists/*

# Install tini
ENV TINI_SHA 066ad710107dc7ee05d3aa6e4974f01dc98f3888
RUN curl -fL https://github.com/krallin/tini/releases/download/v0.5.0/tini-static -o /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA /bin/tini" | sha1sum -c -

# Setup NSS wrapper
ENV RUBY_HOME /ruby_home
RUN useradd -u 1001 -d ${RUBY_HOME} -m -s /bin/bash ruby
RUN mkdir -p "${RUBY_HOME}/nsswrap"
ADD passwd.template "${RUBY_HOME}/nsswrap/passwd.template"
USER ruby

# Install RVM
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
  && curl -sSL https://get.rvm.io | bash -s stable

ADD install_ruby.sh ${RUBY_HOME}/
ADD entrypoint.sh ${RUBY_HOME}/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/bin/tini", "--", "/ruby_home/entrypoint.sh"]
