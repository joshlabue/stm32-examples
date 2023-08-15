CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
CFLAGS = -Iinclude -mcpu=cortex-m0plus -mfloat-abi=soft -mthumb -nostdlib -g

SRCDIRS := $(wildcard src/*)

BINS := $(patsubst src/%,%,$(SRCDIRS))

LINKER_SCRIPT = STM32G030F6Px_FLASH.ld

all: $(BINS)

$(BINS): startup.o stubs.o 
	$(CC) $(CFLAGS) -c src/$@/$@.c -o src/$@/$@.o
	$(CC) $(CFLAGS) -T $(LINKER_SCRIPT) -o src/$@/$@.elf src/$@/$@.o startup.o stubs.o

startup.o: startup.s
	$(AS) -o startup.o startup.s

stubs.o: stubs.c
	$(CC) $(CFLAGS) -c stubs.c

deploy-%:
	@openocd -f interface/stlink.cfg -f target/stm32g0x.cfg -c "program src/$*/$*.elf verify reset exit"

clean: 
	rm -f *.o
	rm -f *.elf
	rm -f src/*/*.o
	rm -f src/*/*.elf
