# Deduce the project root path from the path of the Makefile
PROJROOT := $(patsubst %/,%,$(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..))

DEPSROOT := $(PROJROOT)/build/deps_

.PHONY: all

all: $(DEPSROOT)/.installed_unity \
	$(DEPSROOT)/.installed_cmock \
	$(DEPSROOT)/.installed_fff \
	$(DEPSROOT)/.installed_sep4lib


UNITY_VER=2.6.1
CMOCK_VER=2.6.0
FFF_VER=1.1
SEP4LIB_VER=S2026-1

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

$(DEPSROOT)/.installed_fff:
	@cd $(DEPSROOT); \
	mkdir -p fff; \
	wget -O fff/fff.h https://github.com/meekrosoft/fff/releases/download/v$(FFF_VER)/fff.h; \
	[ -f fff/fff.h ] && touch $@

$(DEPSROOT)/.installed_sep4lib:
	@$(MAKE) --directory=$(DEPSROOT) CONFIG=RELEASE \
	--makefile=$(PROJROOT)/external_deps/Makefile_for_sep4lib.mk static_sep4_hw_libs
	[ -d $(DEPSROOT)/sep4lib ] && touch $@

clean:
	@rm -rf $(DEPSROOT)/.installed_unity \
		$(DEPSROOT)/.installed_cmock \
		$(DEPSROOT)/.installed_fff \
		$(DEPSROOT)/.installed_sep4lib
	@rm -rf $(DEPSROOT)/*.zip Unity-$(UNITY_VER)/ CMock-$(CMOCK_VER)/
	@find $(DEPSROOT)/unity -type d -mindepth 1 | xargs rm -rf
	@find $(DEPSROOT)/unity -type f | grep -v ".gitemptyfolder" | xargs rm -rf
	@find $(DEPSROOT)/cmock -type d -mindepth 1 | xargs rm -rf
	@find $(DEPSROOT)/cmock -type f | grep -v ".gitemptyfolder" | xargs rm -rf
	@find $(DEPSROOT)/fff -type d -mindepth 1 | xargs rm -rf
	@find $(DEPSROOT)/fff -type f | grep -v ".gitemptyfolder" | xargs rm -rf
	@find $(DEPSROOT)/sep4lib -type d -mindepth 1 | xargs rm -rf
	@find $(DEPSROOT)/sep4lib -type f | grep -v ".gitemptyfolder" | xargs rm -rf
