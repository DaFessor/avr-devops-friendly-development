# Deduce the project root path from the path of the Makefile
PROJROOT := $(patsubst %/,%,$(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..))

SEP4LIB_VER=S2026-1

include $(PROJROOT)/configs_target.mk

.phony: static_sep4_libs static_sep4_lib_rel static_sep4_lib_dbg

CONFIG_LOWER := $(shell echo $(CONFIG) | tr A-Z a-z)
DEPSROOT := $(PROJROOT)/build/deps_
LIBROOT := $(DEPSROOT)/sep4lib
DOWNLOAD_DIR := $(LIBROOT)/SEP4_API-$(SEP4LIB_VER)
BUILDDIR := $(LIBROOT)/build_$(CONFIG_LOWER)

vpath %.h $(DOWNLOAD_DIR)/lib/drivers \
		$(DOWNLOAD_DIR)/lib/Util
vpath %.c $(DOWNLOAD_DIR)/lib/drivers \
		$(DOWNLOAD_DIR)/lib/Util
INCLUDEDIRS := -I$(DOWNLOAD_DIR)/lib/drivers \
		-I$(DOWNLOAD_DIR)/lib/Util

SRCS1 := $(wildcard $(DOWNLOAD_DIR)/lib/drivers/*.c)
SRCS2 := $(wildcard $(DOWNLOAD_DIR)/lib/Util/*.c)
SRCS := $(SRCS1) $(SRCS2)
OBJS1 := $(SRCS1:$(DOWNLOAD_DIR)/lib/drivers/%.c=$(BUILDDIR)/%.o)
OBJS2 := $(SRCS2:$(DOWNLOAD_DIR)/lib/Util/%.c=$(BUILDDIR)/%.o)
OBJS := $(OBJS1) $(OBJS2)

$(BUILDDIR)/%.o: %.c
	cd $(BUILDDIR); \
	$(CC) -c $(CFLAGS) $(INCLUDEDIRS) -o $@ $<

$(DOWNLOAD_DIR):
	mkdir -p $(LIBROOT)
	cd $(LIBROOT); \
	wget -O sep4lib.zip https://github.com/erlvia/SEP4_API/archive/refs/tags/$(SEP4LIB_VER).zip; \
	unzip -q sep4lib.zip;\
	mkdir -p $(LIBROOT)/build_release; \
	mkdir -p $(LIBROOT)/build_debug;
	$(MAKE) --directory=$(DEPSROOT) CONFIG=RELEASE \
	--makefile=$(PROJROOT)/external_deps/Makefile_for_sep4lib.mk static_sep4_hw_lib_rel
	$(MAKE) --directory=$(DEPSROOT) CONFIG=DEBUG \
	--makefile=$(PROJROOT)/external_deps/Makefile_for_sep4lib.mk static_sep4_hw_lib_dbg

$(LIBROOT)/include: $(DOWNLOAD_DIR)
	cd $(LIBROOT); \
	mkdir -p include; \
	cp -a SEP4_API-$(SEP4LIB_VER)/lib/drivers/*.h include; \
	cp -a SEP4_API-$(SEP4LIB_VER)/lib/Util/*.h include

$(LIBROOT)/libsep4_hw_rel.a: $(OBJS)
	cd $(BUILDDIR); \
	ar rcs $(LIBROOT)/libsep4_hw_rel.a *.o

$(LIBROOT)/libsep4_hw_dbg.a: $(OBJS)
	cd $(BUILDDIR); \
	ar rcs $(LIBROOT)/libsep4_hw_dbg.a *.o

static_sep4_hw_lib_rel: $(LIBROOT)/include $(LIBROOT)/libsep4_hw_rel.a
static_sep4_hw_lib_dbg: $(LIBROOT)/include $(LIBROOT)/libsep4_hw_dbg.a

static_sep4_hw_libs: static_sep4_hw_lib_rel static_sep4_hw_lib_dbg
	cd $(LIBROOT); \
	rm -rf build_* SEP4_API-$(SEP4LIB_VER) sep4lib.zip
