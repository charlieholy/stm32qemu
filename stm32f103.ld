/* STM32F103 极简链接脚本 - 无语法错误 */
MEMORY
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 256K
    RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 64K
}

SECTIONS
{
    /* 中断向量表 - 必须放在FLASH最开始 */
    .isr_vector : { *(.isr_vector) } > FLASH

    /* 代码段 */
    .text : { *(.text) } > FLASH

    /* 已初始化数据段 */
    .data : { *(.data) } > RAM AT>FLASH

    /* 未初始化数据段 */
    .bss : { *(.bss) } > RAM
}
