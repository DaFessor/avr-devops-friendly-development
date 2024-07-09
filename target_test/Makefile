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

.PHONY: all clean target_tests
all: target_tests

include $(PROJROOT)/configs_target.mk
include $(wildcard $(BUILDDIR)/*.dep)

UNITY_DIR   := $(DEPSROOT)/unity
CMOCK_DIR   := $(DEPSROOT)/cmock
TEST_SRCDIR := $(PROJROOT)/target_test/src
PROD_SRCDIR := $(PROJROOT)/target_firmware/src
INCLUDEDIRS := -I$(TEST_SRCDIR) -I$(UNITY_DIR)/src -I$(CMOCK_DIR)/src -I$(PROD_SRCDIR) -I$(BUILDDIR)

vpath %.h $(TEST_SRCDIR) $(PROD_SRCDIR) $(UNITY_DIR)/src $(CMOCK_DIR)/src $(BUILDDIR)
vpath %.c $(TEST_SRCDIR) $(PROD_SRCDIR) $(UNITY_DIR)/src $(CMOCK_DIR)/src $(BUILDDIR)
vpath %.cpp $(TEST_SRCDIR) $(PROD_SRCDIR) $(UNITY_DIR)/src $(CMOCK_DIR)/src $(BUILDDIR)

$(BUILDROOT)/release:
	mkdir -p $(BUILDROOT)/release

$(BUILDROOT)/debug:
	mkdir -p $(BUILDROOT)/debug

init: $(BUILDROOT)/release $(BUILDROOT)/debug

$(DEPSROOT)/.installed_unity:
	@$(MAKE) --directory=$(DEPSROOT) --no-builtin-rules --makefile=$(PROJROOT)/external_deps/Makefile

$(DEPSROOT)/.installed_cmock:
	@$(MAKE) --directory=$(DEPSROOT) --no-builtin-rules --makefile=$(PROJROOT)/external_deps/Makefile

$(BUILDDIR)/%.o: %.c
	cd $(BUILDDIR); \
	$(CC) -c $(CFLAGS) -Werror -MD -MP -MT "$@" -MT"$(patsubst %.o,%.dep,$@)" \
	 -MF "$(patsubst %.o,%.dep,$@)" $(INCLUDEDIRS) -o $@ $<

compile: init $(lastword $(MAKECMDGOALS))
	cd $(BUILDDIR); \
	$(CC) -c $(CFLAGS) -Werror $(INCLUDEDIRS) \
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
	$(CC) -c $(CFLAGS) -Werror -MD -MP -MT "$@" -MT "$(patsubst %.o,%.dep,$@)" \
	 -MF "$(patsubst %.o,%.dep,$@)" $(INCLUDEDIRS) -o $@ $(patsubst %.o,%.c,$@);


$(BUILDDIR)/mocks/Mock%.o: %.h
	cd $(BUILDDIR); \
	$(PROJROOT)/scripts/cmock_runner.sh $^; \
	$(CC) -c $(CFLAGS) -Werror -MD -MP -MT "$@" -MT "$(patsubst %.o,%.dep,$@)" \
	 -MF "$(patsubst %.o,%.dep,$@)" $(INCLUDEDIRS) -o $@ $(patsubst %.o,%.c,$@)

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
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(BUILDFILE).elf $$(notdir $$^) -Wl,--library-path $(WORKSPACE)/build/lib -Wl,-Map=$(BUILDFILE).map -Wl,--start-group $(LIBS) -Wl,--end-group ;\
	avr-objcopy -O ihex -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures $(BUILDFILE).elf $(BUILDFILE).hex ;\
	avr-objcopy -j .eeprom --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0 --no-change-warnings -O ihex $(BUILDFILE).elf $(BUILDFILE).eep || exit 0 ;\
	avr-objdump -h -S $(BUILDFILE).elf > $(BUILDFILE).lss ;\
	avr-objcopy -O srec -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures $(BUILDFILE).elf $(BUILDFILE).srec ;\
	/usr/bin/avr-size $(BUILDFILE).elf
endef

# ----------------------------------------------------------------------------------------
# To add a test, just call the TEST_DEFINITION macro with the names of the files
# that are used by the test. The general format is:
#
#$(eval $(call TEST_DEFINITION,<test_file>,<files_to_test>,<files_to_mock>))
#                               ^           ^               ^
#                               |           |               +-- This part is optional
#                               |           +------------------ Files to be tested, also optional
#                               +------------------------------ A single file w. unit tests
#
# Note 1: The name of the executable will be the same as the name of the test file minus
#         the .c extension. So if the unit test file is called test1.c, the executable will
#		  be called test1
#
# Note 2: If there are more than two files to be tested or mocked they are separated
#         by SPACES, NOT commas.
#
# Note 3: There must always be a single test file, but there can be zero or more files to
#         be tested or mocked. If there are no files to be tested or mocked, the corresponding
#         argument must be an empty string (absent). Just remember to leave the commas in so
#         that there's always 3 arguments to the TEST_DEFINITION macro (see examples below).
#
# Examples:
#$(eval $(call TEST_DEFINITION, test1.c,,))                   // No files to test or mock
#$(eval $(call TEST_DEFINITION, test2.c, funcuser.c func.c,)) // Two files to test, no mocks
#$(eval $(call TEST_DEFINITION, test3.c ,funcuser.c, func.h)) // One file to test, one mock
#
# Any mocks are create in a subfolder called mocks (inside in the build folder). You can
# add as many tests as you want, each with as many files (and mocks) as you want.
# ----------------------------------------------------------------------------------------

# ================== Define all tests BELOW this line ==================

$(eval $(call TEST_DEFINITION, test_add_op.c, serial_com.c add_op.c))

# ================== Define all tests ABOVE this line ==================

target_tests: init $(DEPSROOT)/.installed_unity $(DEPSROOT)/.installed_cmock $(ALLTESTS)
	@printf "\n\n********* There are $$(ls $(BUILDDIR)/*.hex | wc -w) flashable target test(s) in $(CONFIG_LOWER) config *********\n"
	@avr-size $(BUILDDIR)/*.elf
	@printf "\n\n"

#run_native_tests: target_tests.hex
#	@for test in $(ALLTESTS); do \
#		printf ">>>>>>>>> Start test: $$(basename $${test})\n"; \
#		$$test; \
#		printf "<<<<<<<<< End test: $$(basename $${test})\n\n\n"; \
#	done
