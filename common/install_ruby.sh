#!/bin/bash
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
if [ -z "${RUBY_VERSION}" ]; then
  echo "Ruby version not set. Exiting ..."
  exit 1
fi
/bin/bash -l -c "rvm autolibs disable" \
  && /bin/bash -l -c "rvm requirements" \
  && /bin/bash -l -c "rvm install ruby-${RUBY_VERSION}" \
  && /bin/bash -l -c "rvm --default use ruby-${RUBY_VERSION}" \
  && /bin/bash -l -c "gem install bundler --no-rdoc --no-ri" \
  && passenger-config build-native-support \
  || cat /ruby_home/.rvm/log/*/make.log
