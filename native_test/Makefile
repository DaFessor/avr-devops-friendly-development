# Deduce the project root path from the path of the Makefile
PROJROOT := $(patsubst %/,%,$(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..))

# Use release as default configuration if none is specified, and export for use
# by other makefiles
ifndef CONFIG
CONFIG := RELEASE
endif

BUILDROOT := $(PROJROOT)/build/native_test_
BUILDDIR := $(BUILDROOT)/$(shell echo $(CONFIG) | tr A-Z a-z)
DEPSROOT := $(PROJROOT)/build/deps_
WORKSPACE := $(PROJROOT)/native_test

.PHONY: all native_tests alltests run_all_tests clean compile
all: native_tests

include $(PROJROOT)/configs_native.mk
include $(wildcard $(BUILDDIR)/*.dep)

UNITY_DIR   := $(DEPSROOT)/unity
CMOCK_DIR   := $(DEPSROOT)/cmock
FFF_DIR     := $(DEPSROOT)/fff
VIALIB_DIR := $(DEPSROOT)/via

TEST_SRCDIR := $(PROJROOT)/native_test/src
PROD_SRCDIR := $(PROJROOT)/target_firmware/src
INCLUDEDIRS := -I$(UNITY_DIR)/src \
				-I$(CMOCK_DIR)/src \
				-I$(FFF_DIR) \
				-I$(PROD_SRCDIR) \
				-I$(TEST_SRCDIR) \
				-I$(VIALIB_DIR) \
				-I$(BUILDDIR)

vpath %.h $(TEST_SRCDIR) $(PROD_SRCDIR) $(UNITY_DIR)/src $(CMOCK_DIR)/src $(FFF_DIR) $(VIALIB_DIR) $(BUILDDIR)
vpath %.c $(TEST_SRCDIR) $(PROD_SRCDIR) $(UNITY_DIR)/src $(CMOCK_DIR)/src $(VIALIB_DIR) $(BUILDDIR)
vpath %.cpp $(TEST_SRCDIR) $(PROD_SRCDIR) $(UNITY_DIR)/src $(CMOCK_DIR)/src $(VIALIB_DIR) $(BUILDDIR)

native_tests: init $(DEPSROOT)/.installed_unity $(DEPSROOT)/.installed_cmock $(DEPSROOT)/.installed_fff alltests

$(BUILDROOT)/release:
	mkdir -p $(BUILDROOT)/release

$(BUILDROOT)/debug:
	mkdir -p $(BUILDROOT)/debug

init: $(BUILDROOT)/release $(BUILDROOT)/debug \
	$(DEPSROOT)/.installed_unity \
	$(DEPSROOT)/.installed_fff \
	$(DEPSROOT)/.installed_cmock \
	$(DEPSROOT)/.installed_vialibs

$(DEPSROOT)/.installed_unity:
	@$(MAKE) --directory=$(DEPSROOT) --no-builtin-rules --makefile=$(PROJROOT)/external_deps/Makefile

$(DEPSROOT)/.installed_cmock:
	@$(MAKE) --directory=$(DEPSROOT) --no-builtin-rules --makefile=$(PROJROOT)/external_deps/Makefile

$(DEPSROOT)/.installed_fff:
	@$(MAKE) --directory=$(DEPSROOT) --no-builtin-rules --makefile=$(PROJROOT)/external_deps/Makefile

$(DEPSROOT)/.installed_vialibs:
	@$(MAKE) --directory=$(DEPSROOT) --no-builtin-rules --makefile=$(PROJROOT)/external_deps/Makefile


$(BUILDDIR)/%.o: %.c
	cd $(BUILDDIR); \
	$(CC) -c $(CFLAGS) -MD -MP -MT "$@" -MT"$(patsubst %.o,%.dep,$@)" \
	 -MF "$(patsubst %.o,%.dep,$@)" $(INCLUDEDIRS) --coverage -o $@ $<

compile: init $(lastword $(MAKECMDGOALS))
	cd $(BUILDDIR); \
	$(CC) -c $(CFLAGS) $(INCLUDEDIRS) \
	-o $(lastword $(notdir $(patsubst %.c,%.o,$^))) \
	$(lastword $^)

#%.o: %.cpp
#	cd $(BUILDDIR); \
#	$(GCC) -c $(CPPFLAGS) -Werror -MD -MP -MT "$@" -MT "$(patsubst %.o,%.dep,$@)" \
#	 -MF "$(patsubst %.o,%.dep,$@)" $(INCLUDEDIRS) -o $@ $<

clean:
	@find $(BUILDROOT)/debug -type d -mindepth 1 | xargs rm -rf
	@find $(BUILDROOT)/debug -type f | grep -v ".gitemptyfolder" | xargs rm -rf
	@find $(BUILDROOT)/release -type d -mindepth 1 | xargs rm -rf
	@find $(BUILDROOT)/release -type f | grep -v ".gitemptyfolder" | xargs rm -rf

$(BUILDDIR)/%_runner.o: %.c
	ruby $(UNITY_DIR)/auto/generate_test_runner.rb $< $(patsubst %.o,%.c,$@)
	cd $(BUILDDIR); \
	$(CC) -c $(CFLAGS) -Werror -MD -MP -MT "$@" -MT "$(patsubst %.o,%.dep,$@)" \
	 -MF "$(patsubst %.o,%.dep,$@)" $(INCLUDEDIRS) -o $@ $(patsubst %.o,%.c,$@)

$(BUILDDIR)/mocks/Mock%.o: %.h
	cd $(BUILDDIR); \
	$(PROJROOT)/scripts/make_cmock_runner.sh $^; \
	$(CC) -c $(CFLAGS) -Werror -MD -MP -MT "$@" -MT "$(patsubst %.o,%.dep,$@)" \
	 -MF "$(patsubst %.o,%.dep,$@)" $(INCLUDEDIRS) -o $@ $(patsubst %.o,%.c,$@)

# This looks (extra) complicated, but it's just a way to define what is effectively a macro
# to generate a rule for each test. The macro is called TEST_DEFINITION and it takes two
# arguments. # The first argument $(1) is the name of the test, and the other $(2) is a
# list of the files used by the test.
define TEST_DEFINITION =
ALLTESTS += $(BUILDDIR)/$(patsubst %.c,%,$(strip $(1)))
ifneq ($(3),)
$(BUILDDIR)/$(patsubst %.c,%,$(strip $(1))): \
	$(foreach dep,$(3),$(BUILDDIR)/mocks/$(patsubst %.h,%.o,$(patsubst %,Mock%,$(dep)))) \
	$(patsubst %.c,$(BUILDDIR)/%,$(strip $(1)))_runner.o \
	$(BUILDDIR)/cmock.o $(BUILDDIR)/unity.o $(patsubst %.c,$(BUILDDIR)/%.o,$(1) $(2))
else
$(BUILDDIR)/$(patsubst %.c,%,$(strip $(1))): \
	$(BUILDDIR)/$(patsubst %.c,%,$(strip $(1)))_runner.o \
	$(BUILDDIR)/unity.o $(patsubst %.c,$(BUILDDIR)/%.o,$(1) $(2))
endif
	cd $(BUILDDIR);\
	echo "Linking test: $$^";\
	$(CC) $(LDFLAGS) -lgcov --coverage -o $$(patsubst %.c,%,$(strip $(1))) $$^
	chmod +x $(BUILDDIR)/$(patsubst %.c,%,$(strip $(1)))
endef

include $(WORKSPACE)/test_list.mk

alltests: $(ALLTESTS)

run_all_tests: native_tests
	@cd $(BUILDDIR); rm -rf testreport.txt covdata.txt testreport/
	@for test in $(ALLTESTS); do \
		printf "**** Running test: $$test\n\n" >> $(BUILDDIR)/testreport.txt; \
		$$test >> $(BUILDDIR)/testreport.txt; \
		printf "\n\n" >> $(BUILDDIR)/testreport.txt; \
	done
	@cd $(BUILDDIR); \
	lcov --capture --directory . --exclude "cmock" --exclude unity --output-file coverage.info &> covdata.txt; \
	genhtml coverage.info --exclude "math.h" --output-directory testreport &> covdata.txt; \
	tail -n 3 $(BUILDDIR)/covdata.txt >> $(BUILDDIR)/testreport.txt;printf "\n\n"; \
	printf "\n\n"; cat $(BUILDDIR)/testreport.txt; printf "\n\n"
