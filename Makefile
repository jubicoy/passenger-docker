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

SHELL := /bin/bash

ifeq ($(RUBY),2.4)
	VERSION := ruby-2.4
else ifeq ($(RUBY),2.2)
	VERSION := ruby-2.2
else ifeq ($(RUBY),2.1)
	VERSION := ruby-2.1
endif
ifdef NOCACHE
	OPTS := --no-cache
endif

IMAGE_NAME := jubicoy/passenger
BASE_IMAGE_NAME := $(IMAGE_NAME)-base

baseimage:
	pushd common \
		&& docker build $(OPTS) -t $(BASE_IMAGE_NAME) . \
		&& popd

image: baseimage
ifndef VERSION
	$(error RUBY not set or invalid)
endif
	pushd $(VERSION) \
		&& docker build $(OPTS) -t $(IMAGE_NAME):$(VERSION) . \
		&& popd

push:
	docker push $(IMAGE_NAME):$(VERSION)
