# Fixed settings, always used
CC := /usr/bin/gcc
GCC := /usr/bin/g++
CFLAGS := -funsigned-char -funsigned-bitfields -ffunction-sections \
		  -fdata-sections -fpack-struct -fshort-enums -Wall -std=c17
CPPFLAGS := -funsigned-char -funsigned-bitfields -ffunction-sections \
			-fdata-sections -fpack-struct -fshort-enums -Wall -std=c++17
LDFLAGS := -Wl,--gc-sections
LIBS := -lm

# Config dependent settings
ifeq (RELEASE,$(CONFIG))
CFLAGS += -DRELEASE -DNDEBUG -Os
CPPFLAGS += -DRELEASE -DNDEBUG -Os
else ifeq (DEBUG,$(CONFIG))
CFLAGS += -DDEBUG -O0 -g2
CPPFLAGS += -DDEBUG -O0 -g2
else ifeq ($(strip $(CONFIG)),)
$(error No target configuration (must be set to RELEASE or DEBUG, like CONFIG=RELEASE))
else
$(error Invalid target configuration $(CONFIG) (must be RELEASE or DEBUG)) 
endif
