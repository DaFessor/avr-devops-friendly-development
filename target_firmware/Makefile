# Deduce the project root path from the path of the Makefile
PROJROOT := $(patsubst %/,%,$(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..))

# Use release as default configuration if none is specified, and export for use
# by other makefiles
ifndef CONFIG
CONFIG := RELEASE
endif

BUILDROOT := $(PROJROOT)/build/target_firmware_
CONFIG_LOWER := $(shell echo $(CONFIG) | tr A-Z a-z)
BUILDDIR := $(BUILDROOT)/$(CONFIG_LOWER)

.PHONY: all
all: target_firmware

include $(PROJROOT)/configs_target.mk
include $(PROJROOT)/deps/deps.mk
include $(wildcard $(BUILDDIR)/*.dep)

PROD_SRCDIR := $(PROJROOT)/target_firmware/src
INCLUDEDIRS := -I$(PROD_SRCDIR) -I$(BUILDDIR)

vpath %.h $(PROD_SRCDIR)
vpath %.c $(PROD_SRCDIR)

SRCS := $(wildcard $(PROD_SRCDIR)/*.c)
OBJS := $(patsubst $(PROD_SRCDIR)/%.c,$(BUILDDIR)/%.o,$(SRCS))

$(BUILDROOT)/release:
	mkdir -p $(BUILDROOT)/release

$(BUILDROOT)/debug:
	mkdir -p $(BUILDROOT)/debug

init: $(BUILDROOT)/release $(BUILDROOT)/debug

# The firmware file effectively depends on all .c files in $(APP_SRC).
$(BUILDDIR)/firmware.hex: $(OBJS)
	cd $(BUILDDIR);\
	$(CC) $(CFLAGS) $(LDFLAGS) -o firmware.elf $(notdir $^) -Wl,--library-path $(WORKSPACE)/build/lib -Wl,-Map=firmware.map -Wl,--start-group $(LIBS) -Wl,--end-group ;\
	avr-objcopy -O ihex -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures firmware.elf firmware.hex ;\
	avr-objcopy -j .eeprom --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0 --no-change-warnings -O ihex firmware.elf firmware.eep || exit 0 ;\
	avr-objdump -h -S firmware.elf > firmware.lss ;\
	avr-objcopy -O srec -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures firmware.elf firmware.srec ;\
	/usr/bin/avr-size firmware.elf

$(BUILDDIR)/%.o: %.c
	cd $(BUILDDIR); \
	$(CC) -c $(CFLAGS) -Werror -MD -MP -MT "$@" -MT"$(patsubst %.o,%.dep,$@)" \
	 -MF "$(patsubst %.o,%.dep,$@)" $(INCLUDEDIRS) -o $@ $<

compile: init $(lastword $(MAKECMDGOALS))
	cd $(BUILDDIR); \
	$(CC) -c $(CFLAGS) -Werror $(INCLUDEDIRS) \
	-o $(lastword $(notdir $(patsubst %.c,%.o,$^))) \
	$(lastword $^)

target_firmware: init $(BUILDDIR)/firmware.hex

clean:
	rm -rf $(BUILDROOT)