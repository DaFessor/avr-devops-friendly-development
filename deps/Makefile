.PHONY: download install

install: $(WORKSPACE)/build/lib/libarduino.a

download: arduino_core

arduino_core:
	wget -q -O arduino_core.zip https://github.com/arduino/ArduinoCore-avr/archive/refs/tags/1.8.6.zip
	unzip arduino_core.zip
	mv ArduinoCore-* arduino_core

ARDUINO_CORE_SRC := $(WORKSPACE)/build/deps/arduino_core/cores/arduino

include $(WORKSPACE)/configs_target.mk
vpath %.c $(ARDUINO_CORE_SRC)
vpath %.cpp $(ARDUINO_CORE_SRC)
vpath %.S $(ARDUINO_CORE_SRC)

C_OBJS := $(patsubst $(ARDUINO_CORE_SRC)/%.c,%.o,$(wildcard $(ARDUINO_CORE_SRC)/*.c))
CPP_OBJS := $(patsubst $(ARDUINO_CORE_SRC)/%.cpp,%.o,$(wildcard $(ARDUINO_CORE_SRC)/*.cpp))
ASM_OBJS := $(patsubst $(ARDUINO_CORE_SRC)/%.S.o,%.o,$(wildcard $(ARDUINO_CORE_SRC)/*.S))

$(WORKSPACE)/build/lib/libarduino.a : libarduino.a
	mkdir -p $(WORKSPACE)/build/lib
	cp -f libarduino.a $(WORKSPACE)/build/lib/libarduino.a

libarduino.a: $(C_OBJS) $(CPP_OBJS) $(ASM_OBJS)
	avr-gcc-ar rc libarduino.a $(C_OBJS) $(CPP_OBJS) $(ASM_OBJS)

%.o: %.c
	$(CC) -c $(CFLAGS) -o $@ -fno-fat-lto-objects -flto $<

%.o: %.cpp
	$(GCC) -c $(CPPFLAGS) -o $@ -fno-exceptions -fno-threadsafe-statics -fpermissive -flto $<

%.S.o: %.S
	$(CC) -c -x assembler-with-cpp -DPLATFORMIO=60115 -DARDUINO_AVR_MEGA2560 \
	  -DF_CPU=16000000L -DARDUINO_ARCH_AVR -DARDUINO=10808 -I$(WORKSPACE)/build/deps/arduino_core/cores/arduino \
	  -I$(WORKSPACE)/build/deps/arduino_core/variants/mega -o $@ $<




