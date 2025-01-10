# Deduce the project root path from the path of the Makefile
PROJROOT := $(patsubst %/,%,$(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..))

DEPSROOT := $(PROJROOT)/build/deps_

.PHONY: all

all: $(DEPSROOT)/.installed_unity $(DEPSROOT)/.installed_cmock

$(DEPSROOT)/.installed_unity:
	@cd $(DEPSROOT); \
	echo "Installing Unity..."; \
	wget -O unity.zip https://github.com/ThrowTheSwitch/Unity/archive/refs/tags/v2.6.0.zip; \
	unzip unity.zip; \
	mv Unity-2.6.0 unity; \
	[ -f unity/LICENSE.txt ] && touch $@

$(DEPSROOT)/.installed_cmock:
	@cd $(DEPSROOT); \
	wget -q -O cmock.zip https://github.com/ThrowTheSwitch/CMock/archive/refs/tags/v2.5.3.zip; \
	unzip cmock.zip; \
	mv CMock-2.5.3 cmock; \
	cd cmock; \
	bundle install && touch $@

clean:
	@rm -f $(DEPSROOT)/.installed_unity $(DEPSROOT)/.installed_cmock
	@find $(DEPSROOT)/unity -type d -mindepth 1 | xargs rm -rf
	@find $(DEPSROOT)/unity -type f | grep -v ".gitemptyfolder" | xargs rm -rf
	@find $(DEPSROOT)/cmock -type d -mindepth 1 | xargs rm -rf
	@find $(DEPSROOT)/cmock -type f | grep -v ".gitemptyfolder" | xargs rm -rf
