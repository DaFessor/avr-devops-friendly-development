# Deduce the absolute path to the project/workspace folder (based on the location
# of this "master" makefile) and export for use by other makefiles invoked from
# this one
ROOTDIR := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

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
.PHONY: all target_firmware target_tests native_tests clean reset

# The default target if no specific target was specified = build all executables
all: target_firmware target_tests native_tests

target_firmware:
	@$(MAKE) --directory=$(ROOTDIR)/build/target_firmware_/$(LOWER_CONFIG) --no-builtin-rules\
	  --makefile=$(ROOTDIR)/target_firmware/Makefile

target_tests:
	@$(MAKE) --directory=$(ROOTDIR)/build/target_test_/$(LOWER_CONFIG) --no-builtin-rules\
	  --makefile=$(ROOTDIR)/target_test/Makefile

native_tests:
	@$(MAKE) --directory=$(ROOTDIR)/build/native_test_/$(LOWER_CONFIG) --no-builtin-rules\
	  --makefile=$(ROOTDIR)/native_test/Makefile

# Since all derived files and stuff goes into the build directory,
# it's easy to clean up for fresh builds by just deleting the build
# directory. But on "normal clean" we don't want to delete the deps_
# directory (with all our downloads that are never changed anyway),
# so we just delete the build directory.
clean:
	@$(MAKE) --makefile=$(ROOTDIR)/target_firmware/Makefile clean
	@$(MAKE) --makefile=$(ROOTDIR)/target_test/Makefile clean
	@$(MAKE) --makefile=$(ROOTDIR)/native_test/Makefile clean

# A reset totally resets the project, deleting all build AND
# downloaded deps. This is useful if you want to start completely
# from scratch.
reset: clean
	@$(MAKE) --makefile=$(ROOTDIR)/external_deps/Makefile clean
