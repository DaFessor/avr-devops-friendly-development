# Deduce the project root path from the path of the Makefile
PROJROOT := $(patsubst %/,%,$(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..))

DEPSROOT := $(PROJROOT)/build/deps_

.PHONY: all

all: $(DEPSROOT)/.installed_unity $(DEPSROOT)/.installed_cmock

UNITY_VER=2.6.1
CMOCK_VER=2.6.0

$(DEPSROOT)/.installed_unity:
	@cd $(DEPSROOT); \
	wget -O unity.zip https://github.com/ThrowTheSwitch/Unity/archive/refs/tags/v$(UNITY_VER).zip; \
	unzip -q unity.zip; \
	mv Unity-$(UNITY_VER)/* unity; \
	rm -rf unity.zip Unity-$(UNITY_VER); \
	[ -f unity/LICENSE.txt ] && touch $@

$(DEPSROOT)/.installed_cmock:
	@cd $(DEPSROOT); \
	wget -O cmock.zip https://github.com/ThrowTheSwitch/CMock/archive/refs/tags/v$(CMOCK_VER).zip; \
	unzip -q cmock.zip; \
	cp -a CMock-$(CMOCK_VER)/* cmock; \
	rm -rf cmock.zip CMock-$(CMOCK_VER); \
	cd cmock; \
	bundle install && touch $@

clean:
	@rm -rf $(DEPSROOT)/.installed_unity $(DEPSROOT)/.installed_cmock
	@rm -rf $(DEPSROOT)/*.zip Unity-$(UNITY_VER)/ CMock-$(CMOCK_VER)/
	@find $(DEPSROOT)/unity -type d -mindepth 1 | xargs rm -rf
	@find $(DEPSROOT)/unity -type f | grep -v ".gitemptyfolder" | xargs rm -rf
	@find $(DEPSROOT)/cmock -type d -mindepth 1 | xargs rm -rf
	@find $(DEPSROOT)/cmock -type f | grep -v ".gitemptyfolder" | xargs rm -rf
