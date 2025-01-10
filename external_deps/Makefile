# Deduce the project root path from the path of the Makefile
PROJROOT := $(patsubst %/,%,$(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..))

DEPSROOT := $(PROJROOT)/build/deps_

.PHONY: all

all: $(DEPSROOT)/.installed_unity $(DEPSROOT)/.installed_cmock

$(DEPSROOT)/.installed_unity:
	@cd $(DEPSROOT); \
	wget -O unity.zip https://github.com/ThrowTheSwitch/Unity/archive/refs/tags/v2.6.0.zip; \
	unzip -q unity.zip; \
	cp -a Unity-2.6.0/* unity; \
	rm -rf unity.zip Unity-2.6.0; \
	[ -f unity/LICENSE.txt ] && touch $@

$(DEPSROOT)/.installed_cmock:
	@cd $(DEPSROOT); \
	wget -O cmock.zip https://github.com/ThrowTheSwitch/CMock/archive/refs/tags/v2.5.3.zip; \
	unzip -q cmock.zip; \
	cp -a CMock-2.5.3/* cmock; \
	rm -rf cmock.zip CMock-2.5.3; \
	cd cmock; \
	bundle install && touch $@

clean:
	@rm -f $(DEPSROOT)/.installed_unity $(DEPSROOT)/.installed_cmock
	@find $(DEPSROOT)/unity -type d -mindepth 1 | xargs rm -rf
	@find $(DEPSROOT)/unity -type f | grep -v ".gitemptyfolder" | xargs rm -rf
	@find $(DEPSROOT)/cmock -type d -mindepth 1 | xargs rm -rf
	@find $(DEPSROOT)/cmock -type f | grep -v ".gitemptyfolder" | xargs rm -rf
