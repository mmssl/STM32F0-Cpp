# Define compilers
CC=arm-none-eabi-gcc
CXX=arm-none-eabi-g++

# Define compiler flags
CFLAGS  = -Wall -g -std=c99 -Os  
CFLAGS += -mlittle-endian -mcpu=cortex-m0 -march=armv6-m -mthumb
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -Wl,--gc-sections -Wl,-Map=$(PROJ_NAME).map

# Define C++ flags
CXXFLAGS = $(CFLAGS) # You can adjust this as necessary

# Define linker flags (if different from CXXFLAGS)
LDFLAGS = $(CXXFLAGS)

# Define object copy and dump utilities
OBJCOPY=arm-none-eabi-objcopy
OBJDUMP=arm-none-eabi-objdump
SIZE=arm-none-eabi-size

# Define project name
PROJ_NAME=main

# Define source files
C_SRCS = system_stm32f0xx.c
CPP_SRCS = main.cpp
ASM_SRCS = Device/startup_stm32f0xx.s

#Specify the directories
vpath %.c src 
vpath %.cpp src
vpath %.s Device

# Define object files
C_OBJS = $(C_SRCS:.c=.o)
CPP_OBJS = $(CPP_SRCS:.cpp=.o)
ASM_OBJS = $(ASM_SRCS:.s=.o)
OBJS = $(C_OBJS) $(CPP_OBJS) $(ASM_OBJS)

# Define include directories
INCLUDES = -Iinc -ILibraries -ILibraries/CMSIS/Device/ST/STM32F0xx/Include -ILibraries/CMSIS/Include -ILibraries/STM32F0xx_StdPeriph_Driver/inc

# Define library paths and libraries
LIBS = -L$(STD_PERIPH_LIB) -lstm32f0
LIBDIRS = -LDevice/ldscripts
LDSCRIPT = -Tstm32f0.ld

# Default rule
all: $(PROJ_NAME).elf

# Rule to make the elf file
$(PROJ_NAME).elf: $(OBJS)
	$(CXX) $(LDFLAGS) $(LIBDIRS) $(LDSCRIPT) $(OBJS) $(LIBS) -o $@
	$(OBJCOPY) -O ihex $@ $(PROJ_NAME).hex
	$(OBJCOPY) -O binary $@ $(PROJ_NAME).bin
	$(OBJDUMP) -St $@ >$(PROJ_NAME).lst
	$(SIZE) $@

# Rule to make the C object files
%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# Rule to make the C++ object files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Rule to make the assembly object files
%.o: %.s
	$(CC) $(CFLAGS) -c $< -o $@

# Clean rule
clean:
	rm -f $(OBJS)
	rm -f $(PROJ_NAME).elf
	rm -f $(PROJ_NAME).hex
	rm -f $(PROJ_NAME).bin
	rm -f $(PROJ_NAME).map
	rm -f $(PROJ_NAME).lst

.PHONY: all clean


