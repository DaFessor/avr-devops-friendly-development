# Deduce the absolute path to the project/workspace folder (based on the location
# of this "master" makefile) and export for use by other makefiles invoked from
# this one
WORKSPACE := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

# Use release as default configuration if none is specified, and export for use
# by other makefiles
ifndef CONFIG
CONFIG := RELEASE
endif
# We make a lowercase version of the CONFIG var for use in folder names (because folder
# names in pure upper case are ugly)
LOWER_CONFIG := $(shell echo $(CONFIG) | tr A-Z a-z)

# By declaring these targets phony, we stop make from assuming that they are
# files or folders. This allows us to use target names that are the same as
# the folders we use, without make getting confused and trying to create files
# or folders with the same names.
.PHONY: all init target_firmware target_tests native_tests run_native flash_firmware flash_test

# The default target if no specific target was specified = build all executables
all: target_firmware target_tests native_tests

$(WORKSPACE)/build:
	@mkdir -p $(WORKSPACE)/build

$(WORKSPACE)/build/target_firmware_:
	@mkdir -p $(WORKSPACE)/build/target_firmware_

$(WORKSPACE)/build/target_test_:
	@mkdir -p $(WORKSPACE)/build/target_test_

$(WORKSPACE)/build/native_test_:
	@mkdir -p $(WORKSPACE)/build/native_test_

init: $(WORKSPACE)/build $(WORKSPACE)/build/target_firmware_ $(WORKSPACE)/build/target_test_ (WORKSPACE)/build/native_test_

target_firmware: init
	@mkdir -p $(WORKSPACE)/build/target_firmware/$(LOWER_CONFIG)
	@$(MAKE) --directory=$(WORKSPACE)/build/target_firmware/$(LOWER_CONFIG) --no-builtin-rules\
	  --makefile=$(WORKSPACE)/target_firmware/Makefile

target_tests: init
	@mkdir -p $(WORKSPACE)/build/target_test/$(LOWER_CONFIG)
	@$(MAKE) --directory=$(WORKSPACE)/build/target_test/$(LOWER_CONFIG) --no-builtin-rules\
	  --makefile=$(WORKSPACE)/target_test/Makefile

native_tests: init
	@mkdir -p $(WORKSPACE)/build/native_test/$(LOWER_CONFIG)
	@$(MAKE) --directory=$(WORKSPACE)/build/native_test/$(LOWER_CONFIG) --no-builtin-rules\
	  --makefile=$(WORKSPACE)/native_test/Makefile


# Since all derived files and stuff goes into the build directory,
# it's easy to clean up for fresh builds by just deleting the build
# directory. But on "normal clean" we don't want to delete the deps
# directory (with all our downloads that are never changed anyway),
# so we just delete the build directory.
clean:
	rm -rf $(WORKSPACE)/build

# A reset totally resets the project, deleting all build AND
# downloaded deps. This is useful if you want to start from scratch.
# All ordinary files in deps are left untouched, but all subdirectories
# are deleted.
reset: clean
	rm -rf $$(find $(WORKSPACE)/deps/ -mindepth 1 -type d) | xargs rm -rf
