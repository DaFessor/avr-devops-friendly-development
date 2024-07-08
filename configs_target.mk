# Fixed settings, always used
CC := /usr/bin/avr-gcc
GCC := /usr/bin/avr-g++
CFLAGS := -funsigned-char -funsigned-bitfields -ffunction-sections \
		  -fdata-sections -fpack-struct -fshort-enums -mrelax -Wall \
		  -mmcu=atmega2560 -std=c17 \
		  -DPLATFORMIO=60115 -DARDUINO_AVR_MEGA2560 -DF_CPU=16000000UL \
		  -DARDUINO_ARCH_AVR -DARDUINO=10808
CPPFLAGS := -funsigned-char -funsigned-bitfields -ffunction-sections \
			-fdata-sections -fpack-struct -fshort-enums -mrelax -Wall \
			-mmcu=atmega2560 -std=c++17 -fno-exceptions -fno-threadsafe-statics \
			-DPLATFORMIO=60115 -DARDUINO_AVR_MEGA2560 -DF_CPU=16000000UL \
		  	-DARDUINO_ARCH_AVR -DARDUINO=10808
LDFLAGS := -Wl,--gc-sections -mmcu=atmega2560
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
