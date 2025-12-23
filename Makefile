# 工具链配置
CROSS_COMPILE = arm-none-eabi-
CC      = $(CROSS_COMPILE)gcc
LD      = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
QEMU    = qemu-system-arm

# 编译参数：指定 Cortex-M3 内核，Thumb 指令集
CFLAGS  = -mcpu=cortex-m3 -mthumb -Wall -O0 -g
LDFLAGS = -T stm32f103.ld

# 目标文件
TARGET = stm32f103_led
OBJS   = main.o

# 默认目标：编译+生成二进制文件
all: $(TARGET).elf $(TARGET).bin

# 编译：生成 ELF 文件
$(TARGET).elf: $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

# 生成二进制文件（可选，用于真实硬件烧录）
$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

# 编译 .c 文件为 .o 文件
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

# 运行：在 QEMU 中启动
run: $(TARGET).elf
	$(QEMU) -M mps2-an385 -kernel $< -nographic 

debug: $(TARGET).elf
# 后台启动 QEMU 调试服务端
	qemu-system-arm -M stm32-p103 -kernel stm32f103_led.elf -nographic -S -s &
# 启动 GDB 客户端并连接
	arm-none-eabi-gdb $<

# 清理编译产物
clean:
	rm -f *.o *.elf *.bin
