# Deduce the project root path from the path of the Makefile
PROJROOT := $(patsubst %/,%,$(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..))

# Use release as default configuration if none is specified, and export for use
# by other makefiles
ifndef CONFIG
CONFIG := RELEASE
endif

BUILDROOT := $(PROJROOT)/build/target_test_
CONFIG_LOWER := $(shell echo $(CONFIG) | tr A-Z a-z)
BUILDDIR := $(BUILDROOT)/$(CONFIG_LOWER)
DEPSROOT := $(PROJROOT)/build/deps_
WORKSPACE := $(PROJROOT)/target_test

.PHONY: all clean target_tests
all: target_tests

include $(PROJROOT)/configs_target.mk

ifeq (RELEASE,$(CONFIG))
SEP4_LIB := sep4_hw_rel
else
SEP4_LIB := sep4_hw_dbg
endif

UNITY_DIR   := $(DEPSROOT)/unity
FFF_DIR     := $(DEPSROOT)/fff
SEP4LIB_DIR := $(DEPSROOT)/sep4lib

TEST_SRCDIR := $(PROJROOT)/target_test/src
PROD_SRCDIR := $(PROJROOT)/target_firmware/src

INCLUDEDIRS := -I$(TEST_SRCDIR) \
			-I$(UNITY_DIR)/src \
			-I$(FFF_DIR) \
			-I$(SEP4LIB_DIR)/include \
			-I$(PROD_SRCDIR) \
			-I$(BUILDDIR)

vpath %.h $(TEST_SRCDIR) \
		$(PROD_SRCDIR) \
		$(UNITY_DIR)/src \
		$(FFF_DIR) \
		$(SEP4LIB_DIR)/include \
		$(BUILDDIR)

vpath %.c $(TEST_SRCDIR) \
		$(PROD_SRCDIR) \
		$(UNITY_DIR)/src \
		$(BUILDDIR)

vpath %.cpp $(TEST_SRCDIR) \
		$(PROD_SRCDIR) \
		$(UNITY_DIR)/src \
		$(BUILDDIR)

$(BUILDROOT)/release:
	mkdir -p $(BUILDROOT)/release

$(BUILDROOT)/debug:
	mkdir -p $(BUILDROOT)/debug

init: $(BUILDROOT)/release \
	$(BUILDROOT)/debug \
	$(DEPSROOT)/.installed_unity \
	$(DEPSROOT)/.installed_fff \
	$(DEPSROOT)/.installed_vialibs

$(DEPSROOT)/.installed_unity:
	@$(MAKE) --directory=$(DEPSROOT) --no-builtin-rules --makefile=$(PROJROOT)/external_deps/Makefile

$(DEPSROOT)/.installed_fff:
	@$(MAKE) --directory=$(DEPSROOT) --no-builtin-rules --makefile=$(PROJROOT)/external_deps/Makefile

$(DEPSROOT)/.installed_vialibs:
	@$(MAKE) --directory=$(DEPSROOT) --no-builtin-rules --makefile=$(PROJROOT)/external_deps/Makefile


$(BUILDDIR)/%.o: %.c
	cd $(BUILDDIR); \
	$(CC) -c $(CFLAGS) $(INCLUDEDIRS) -o $@ $<

compile: init $(lastword $(MAKECMDGOALS))
	cd $(BUILDDIR); \
	$(CC) -c $(CFLAGS) $(INCLUDEDIRS) \
	-o $(lastword $(notdir $(patsubst %.c,%.o,$^))) \
	$(lastword $^)

clean:
	@find $(BUILDROOT)/debug -type d -mindepth 1 | xargs rm -rf
	@find $(BUILDROOT)/debug -type f | grep -v ".gitemptyfolder" | xargs rm -rf
	@find $(BUILDROOT)/release -type d -mindepth 1 | xargs rm -rf
	@find $(BUILDROOT)/release -type f | grep -v ".gitemptyfolder" | xargs rm -rf

$(BUILDDIR)/%_runner.o: %.c
	ruby $(UNITY_DIR)/auto/generate_test_runner.rb $< $(patsubst %.o,%.c,$@)
	cd $(BUILDDIR); \
	$(CC) -c $(CFLAGS) $(INCLUDEDIRS) -o $@ $(patsubst %.o,%.c,$@);

# This looks (extra) complicated, but it's just a way to define what is effectively a macro
# to generate a rule for each test. The macro is called TEST_DEFINITION and it takes two
# arguments. # The first argument $(1) is the name of the test, and the other $(2) is a
# list of the files used by the test.
define TEST_DEFINITION =
ALLTESTS += $(BUILDDIR)/$(patsubst %.c,%.hex,$(strip $(1)))
$(BUILDDIR)/$(patsubst %.c,%.hex,$(strip $(1))): \
	$(BUILDDIR)/$(patsubst %.c,%,$(strip $(1)))_runner.o \
	$(BUILDDIR)/unity.o $(patsubst %.c,$(BUILDDIR)/%.o,$(1) $(2))
	$(eval BUILDFILE=$(patsubst %.c,%,$(strip $(1))))
	cd $(BUILDDIR);\
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(BUILDFILE).elf $$(notdir $$^) -Wl,--library-path $(SEP4LIB_DIR) -Wl,-Map=$(BUILDFILE).map -Wl,--start-group $(LIBS) -l$(SEP4_LIB) -Wl,--end-group ;\
	avr-objcopy -O ihex -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures $(BUILDFILE).elf $(BUILDFILE).hex ;\
	avr-objcopy -j .eeprom --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0 --no-change-warnings -O ihex $(BUILDFILE).elf $(BUILDFILE).eep || exit 0 ;\
	avr-objdump -h -S $(BUILDFILE).elf > $(BUILDFILE).lss ;\
	avr-objcopy -O srec -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures $(BUILDFILE).elf $(BUILDFILE).srec ;\
	/usr/bin/avr-size $(BUILDFILE).elf
endef

# Load the test definitions from the test_list.mk file,
# which calls the TEST_DEFINITION macro for each test
include $(WORKSPACE)/test_list.mk

target_tests: init $(ALLTESTS)
	@printf "\n\n********* There are $$(ls $(BUILDDIR)/*.hex | wc -w) flashable target test(s) in $(CONFIG_LOWER) config *********\n"
	@avr-size $(BUILDDIR)/*.elf | sed "s/elf/hex/"
	@printf "\n\n"
