# Deduce the project root path from the path of the Makefile
PROJROOT := $(patsubst %/,%,$(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..))

DEPSROOT := $(PROJROOT)/build/deps_

.PHONY: all init download

$(DEPSROOT)/unity:
	mkdir -p $@

$(DEPSROOT)/cmock:
	mkdir -p $@

init: $(DEPSROOT)/unity $(DEPSROOT)/cmock

all: init download

$(DEPSROOT)/unity: init
	cd $(DEPSROOT); \
	wget -q -O $(DEPSROOT)/unity.zip https://github.com/ThrowTheSwitch/Unity/archive/refs/tags/v2.6.0.zip; \
	unzip unity.zip; \
	mv ?nity-* unity; \
	rm unity.zip

$(DEPSROOT)/cmock:
	cd $(DEPSROOT); \
	wget -q -O $(DEPSROOT)/cmock.zip https://github.com/ThrowTheSwitch/CMock/archive/refs/tags/v2.5.3.zip; \
	unzip cmock.zip; \
	mv ??ock-* cmock; \
	rm cmock.zip; \
	cd cmock; \
	bundle install
