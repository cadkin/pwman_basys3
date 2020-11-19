NAME := main
HEX := $(NAME).hex
OUT := $(NAME).elf
MAP := $(NAME).map
# For C.
SOURCES := $(wildcard *.c)
# For AVR ASM.
#SOURCES := $(wildcard *.s)
HEADERS := $(wildcard *.h)
OBJECTS := $(patsubst %.c,%.o,$(SOURCES))

MCU := atmega2560
MCU_AVRDUDE := m2560
PARTNO := stk500v2
DEVICE := /dev/ttyACM0
BAUDRATE := 115200
AVRDUDE_FLAGS := -F -V -D -v
CPU_FREQ := 16000000

CC := avr-gcc
OBJCOPY := avr-objcopy
SIZE := avr-size -A
GDB := avr-gdb

CFLAGS := -Wall -pedantic -mmcu=$(MCU) -std=c99 -g -O2 -DF_CPU=$(CPU_FREQ)UL

all: $(HEX)

clean:
	rm -f $(HEX) $(OUT) $(MAP) $(OBJECTS)

flash: $(HEX)
	avrdude $(AVRDUDE_FLAGS) -c $(PARTNO) -p $(MCU_AVRDUDE) -P $(DEVICE) -b $(BAUDRATE) -U flash:w:$(HEX)

debug: simulate
	$(GDB) $(OUT) -ex 'target remote :1234' -ex 'load' -ex 'break main' -ex 'continue'

simulate: $(HEX)
	simavr -m $(MCU) -f $(CPU_FREQ) $(OUT) -g &

$(HEX): $(OUT)
	$(OBJCOPY) -R .eeprom -O ihex $< $@

#$(OUT): $(OBJECTS)
$(OUT): $(SOURCES)
	$(CC) $(CFLAGS) -o $@ -Wl,-Map,$(MAP) $^
	@echo
	@$(SIZE) $@
	@echo

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c -o $@ $<

%.pp: %.c
	$(CC) $(CFLAGS) -E -o $@ $<

%.ppo: %.c
	$(CC) $(CFLAGS) -E $<
