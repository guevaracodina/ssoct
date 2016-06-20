/* system.h
 *
 * Machine generated for a CPU named "cpu" as defined in:
 * h:\Project\Ethernet\software\simple_socket_server_0_syslib\..\..\std_2s60.ptf
 *
 * Generated: 2009-12-07 20:59:40.734
 *
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/*

DO NOT MODIFY THIS FILE

   Changing this file will have subtle consequences
   which will almost certainly lead to a nonfunctioning
   system. If you do modify this file, be aware that your
   changes will be overwritten and lost when this file
   is generated again.

DO NOT MODIFY THIS FILE

*/

/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2003 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
*                                                                             *
******************************************************************************/

/*
 * system configuration
 *
 */

#define ALT_SYSTEM_NAME "std_2s60"
#define ALT_CPU_NAME "cpu"
#define ALT_CPU_ARCHITECTURE "altera_nios2"
#define ALT_DEVICE_FAMILY "STRATIXII"
#define ALT_STDIN "/dev/jtag_uart"
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN_BASE 0x02131880
#define ALT_STDIN_DEV jtag_uart
#define ALT_STDIN_PRESENT
#define ALT_STDOUT "/dev/jtag_uart"
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT_BASE 0x02131880
#define ALT_STDOUT_DEV jtag_uart
#define ALT_STDOUT_PRESENT
#define ALT_STDERR "/dev/jtag_uart"
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDERR_BASE 0x02131880
#define ALT_STDERR_DEV jtag_uart
#define ALT_STDERR_PRESENT
#define ALT_CPU_FREQ 160000000
#define ALT_IRQ_BASE NULL

/*
 * processor configuration
 *
 */

#define NIOS2_CPU_IMPLEMENTATION "fast"
#define NIOS2_BIG_ENDIAN 0

#define NIOS2_ICACHE_SIZE 65536
#define NIOS2_DCACHE_SIZE 65536
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_DCACHE_LINE_SIZE 32
#define NIOS2_DCACHE_LINE_SIZE_LOG2 5
#define NIOS2_FLUSHDA_SUPPORTED

#define NIOS2_EXCEPTION_ADDR 0x01000020
#define NIOS2_RESET_ADDR 0x03000000
#define NIOS2_BREAK_ADDR 0x02130820

#define NIOS2_HAS_DEBUG_STUB

#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0

/*
 * A define for each class of peripheral
 *
 */

#define __ALTERA_AVALON_TRI_STATE_BRIDGE
#define __ALTERA_AVALON_CFI_FLASH
#define __ALTERA_NIOS_DEV_KIT_STRATIX_EDITION_SRAM2
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_LAN91C111
#define __ALTERA_AVALON_TIMER
#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ADBUF

/*
 * ext_ram_bus configuration
 *
 */

#define EXT_RAM_BUS_NAME "/dev/ext_ram_bus"
#define EXT_RAM_BUS_TYPE "altera_avalon_tri_state_bridge"
#define ALT_MODULE_CLASS_ext_ram_bus altera_avalon_tri_state_bridge

/*
 * ext_flash_bus configuration
 *
 */

#define EXT_FLASH_BUS_NAME "/dev/ext_flash_bus"
#define EXT_FLASH_BUS_TYPE "altera_avalon_tri_state_bridge"
#define ALT_MODULE_CLASS_ext_flash_bus altera_avalon_tri_state_bridge

/*
 * ext_flash configuration
 *
 */

#define EXT_FLASH_NAME "/dev/ext_flash"
#define EXT_FLASH_TYPE "altera_avalon_cfi_flash"
#define EXT_FLASH_BASE 0x03000000
#define EXT_FLASH_SPAN 16777216
#define EXT_FLASH_SETUP_VALUE 45
#define EXT_FLASH_WAIT_VALUE 160
#define EXT_FLASH_HOLD_VALUE 35
#define EXT_FLASH_TIMING_UNITS "ns"
#define EXT_FLASH_UNIT_MULTIPLIER 1
#define EXT_FLASH_SIZE 16777216
#define ALT_MODULE_CLASS_ext_flash altera_avalon_cfi_flash

/*
 * ext_ram configuration
 *
 */

#define EXT_RAM_NAME "/dev/ext_ram"
#define EXT_RAM_TYPE "altera_nios_dev_kit_stratix_edition_sram2"
#define EXT_RAM_BASE 0x02200000
#define EXT_RAM_SPAN 1048576
#define EXT_RAM_SRAM_MEMORY_SIZE 1048576
#define EXT_RAM_SRAM_MEMORY_UNITS 1
#define EXT_RAM_SRAM_DATA_WIDTH 32
#define EXT_RAM_SIMULATION_MODEL_NUM_LANES 4
#define ALT_MODULE_CLASS_ext_ram altera_nios_dev_kit_stratix_edition_sram2

/*
 * onchip_ram_64_kbytes configuration
 *
 */

#define ONCHIP_RAM_64_KBYTES_NAME "/dev/onchip_ram_64_kbytes"
#define ONCHIP_RAM_64_KBYTES_TYPE "altera_avalon_onchip_memory2"
#define ONCHIP_RAM_64_KBYTES_BASE 0x02120000
#define ONCHIP_RAM_64_KBYTES_SPAN 65536
#define ONCHIP_RAM_64_KBYTES_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_RAM_64_KBYTES_RAM_BLOCK_TYPE "M4K"
#define ONCHIP_RAM_64_KBYTES_INIT_CONTENTS_FILE "ethernet_standard"
#define ONCHIP_RAM_64_KBYTES_NON_DEFAULT_INIT_FILE_ENABLED 1
#define ONCHIP_RAM_64_KBYTES_GUI_RAM_BLOCK_TYPE "M4K"
#define ONCHIP_RAM_64_KBYTES_WRITEABLE 1
#define ONCHIP_RAM_64_KBYTES_DUAL_PORT 0
#define ONCHIP_RAM_64_KBYTES_SIZE_VALUE 65536
#define ONCHIP_RAM_64_KBYTES_SIZE_MULTIPLE 1
#define ONCHIP_RAM_64_KBYTES_USE_SHALLOW_MEM_BLOCKS 0
#define ONCHIP_RAM_64_KBYTES_INIT_MEM_CONTENT 1
#define ONCHIP_RAM_64_KBYTES_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_RAM_64_KBYTES_INSTANCE_ID "NONE"
#define ONCHIP_RAM_64_KBYTES_READ_DURING_WRITE_MODE "DONT_CARE"
#define ONCHIP_RAM_64_KBYTES_IGNORE_AUTO_BLOCK_TYPE_ASSIGNMENT 1
#define ONCHIP_RAM_64_KBYTES_CONTENTS_INFO ""
#define ALT_MODULE_CLASS_onchip_ram_64_kbytes altera_avalon_onchip_memory2

/*
 * lan91c111 configuration
 *
 */

#define LAN91C111_NAME "/dev/lan91c111"
#define LAN91C111_TYPE "altera_avalon_lan91c111"
#define LAN91C111_BASE 0x02110000
#define LAN91C111_SPAN 65536
#define LAN91C111_IRQ 2
#define LAN91C111_IS_ETHERNET_MAC 1
#define LAN91C111_LAN91C111_REGISTERS_OFFSET 768
#define LAN91C111_LAN91C111_DATA_BUS_WIDTH 32
#define ALT_MODULE_CLASS_lan91c111 altera_avalon_lan91c111

/*
 * sys_clk_timer configuration
 *
 */

#define SYS_CLK_TIMER_NAME "/dev/sys_clk_timer"
#define SYS_CLK_TIMER_TYPE "altera_avalon_timer"
#define SYS_CLK_TIMER_BASE 0x02131800
#define SYS_CLK_TIMER_SPAN 32
#define SYS_CLK_TIMER_IRQ 0
#define SYS_CLK_TIMER_ALWAYS_RUN 0
#define SYS_CLK_TIMER_FIXED_PERIOD 0
#define SYS_CLK_TIMER_SNAPSHOT 1
#define SYS_CLK_TIMER_PERIOD 1.0
#define SYS_CLK_TIMER_PERIOD_UNITS "ms"
#define SYS_CLK_TIMER_RESET_OUTPUT 0
#define SYS_CLK_TIMER_TIMEOUT_PULSE_OUTPUT 0
#define SYS_CLK_TIMER_LOAD_VALUE 159999
#define SYS_CLK_TIMER_COUNTER_SIZE 32
#define SYS_CLK_TIMER_MULT 0.0010
#define SYS_CLK_TIMER_TICKS_PER_SEC 1000
#define SYS_CLK_TIMER_FREQ 160000000
#define ALT_MODULE_CLASS_sys_clk_timer altera_avalon_timer

/*
 * jtag_uart configuration
 *
 */

#define JTAG_UART_NAME "/dev/jtag_uart"
#define JTAG_UART_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_BASE 0x02131880
#define JTAG_UART_SPAN 8
#define JTAG_UART_IRQ 1
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_READ_CHAR_STREAM ""
#define JTAG_UART_SHOWASCII 1
#define JTAG_UART_READ_LE 0
#define JTAG_UART_WRITE_LE 0
#define JTAG_UART_ALTERA_SHOW_UNRELEASED_JTAG_UART_FEATURES 0
#define ALT_MODULE_CLASS_jtag_uart altera_avalon_jtag_uart

/*
 * high_res_timer configuration
 *
 */

#define HIGH_RES_TIMER_NAME "/dev/high_res_timer"
#define HIGH_RES_TIMER_TYPE "altera_avalon_timer"
#define HIGH_RES_TIMER_BASE 0x02131820
#define HIGH_RES_TIMER_SPAN 32
#define HIGH_RES_TIMER_IRQ 3
#define HIGH_RES_TIMER_ALWAYS_RUN 0
#define HIGH_RES_TIMER_FIXED_PERIOD 0
#define HIGH_RES_TIMER_SNAPSHOT 1
#define HIGH_RES_TIMER_PERIOD 1.0
#define HIGH_RES_TIMER_PERIOD_UNITS "ms"
#define HIGH_RES_TIMER_RESET_OUTPUT 0
#define HIGH_RES_TIMER_TIMEOUT_PULSE_OUTPUT 0
#define HIGH_RES_TIMER_LOAD_VALUE 159999
#define HIGH_RES_TIMER_COUNTER_SIZE 32
#define HIGH_RES_TIMER_MULT 0.0010
#define HIGH_RES_TIMER_TICKS_PER_SEC 1000
#define HIGH_RES_TIMER_FREQ 160000000
#define ALT_MODULE_CLASS_high_res_timer altera_avalon_timer

/*
 * reconfig_request_pio configuration
 *
 */

#define RECONFIG_REQUEST_PIO_NAME "/dev/reconfig_request_pio"
#define RECONFIG_REQUEST_PIO_TYPE "altera_avalon_pio"
#define RECONFIG_REQUEST_PIO_BASE 0x02131870
#define RECONFIG_REQUEST_PIO_SPAN 16
#define RECONFIG_REQUEST_PIO_DO_TEST_BENCH_WIRING 0
#define RECONFIG_REQUEST_PIO_DRIVEN_SIM_VALUE 0
#define RECONFIG_REQUEST_PIO_HAS_TRI 1
#define RECONFIG_REQUEST_PIO_HAS_OUT 0
#define RECONFIG_REQUEST_PIO_HAS_IN 0
#define RECONFIG_REQUEST_PIO_CAPTURE 0
#define RECONFIG_REQUEST_PIO_DATA_WIDTH 1
#define RECONFIG_REQUEST_PIO_RESET_VALUE 0
#define RECONFIG_REQUEST_PIO_EDGE_TYPE "NONE"
#define RECONFIG_REQUEST_PIO_IRQ_TYPE "NONE"
#define RECONFIG_REQUEST_PIO_BIT_CLEARING_EDGE_REGISTER 0
#define RECONFIG_REQUEST_PIO_FREQ 160000000
#define ALT_MODULE_CLASS_reconfig_request_pio altera_avalon_pio

/*
 * sysid configuration
 *
 */

#define SYSID_NAME "/dev/sysid"
#define SYSID_TYPE "altera_avalon_sysid"
#define SYSID_BASE 0x02131888
#define SYSID_SPAN 8
#define SYSID_ID 991051294u
#define SYSID_TIMESTAMP 1260225362u
#define SYSID_REGENERATE_VALUES 0
#define ALT_MODULE_CLASS_sysid altera_avalon_sysid

/*
 * sdram configuration
 *
 */

#define SDRAM_NAME "/dev/sdram"
#define SDRAM_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_BASE 0x01000000
#define SDRAM_SPAN 16777216
#define SDRAM_REGISTER_DATA_IN 1
#define SDRAM_SIM_MODEL_BASE 1
#define SDRAM_SDRAM_DATA_WIDTH 32
#define SDRAM_SDRAM_ADDR_WIDTH 12
#define SDRAM_SDRAM_ROW_WIDTH 12
#define SDRAM_SDRAM_COL_WIDTH 8
#define SDRAM_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_SDRAM_NUM_BANKS 4
#define SDRAM_REFRESH_PERIOD 15.625
#define SDRAM_POWERUP_DELAY 100.0
#define SDRAM_CAS_LATENCY 3
#define SDRAM_T_RFC 70.0
#define SDRAM_T_RP 20.0
#define SDRAM_T_MRD 3
#define SDRAM_T_RCD 20.0
#define SDRAM_T_AC 5.5
#define SDRAM_T_WR 14.0
#define SDRAM_INIT_REFRESH_COMMANDS 2
#define SDRAM_INIT_NOP_DELAY 0.0
#define SDRAM_SHARED_DATA 0
#define SDRAM_SDRAM_BANK_WIDTH 2
#define SDRAM_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_STARVATION_INDICATOR 0
#define SDRAM_IS_INITIALIZED 1
#define ALT_MODULE_CLASS_sdram altera_avalon_new_sdram_controller

/*
 * ad_buf configuration
 *
 */

#define AD_BUF_NAME "/dev/ad_buf"
#define AD_BUF_TYPE "adBUF"
#define AD_BUF_BASE 0x00000000
#define AD_BUF_SPAN 4096
#define AD_BUF_TERMINATED_PORTS ""
#define ALT_MODULE_CLASS_ad_buf adBUF

/*
 * MicroC/OS-II configuration
 *
 */

#define ALT_MAX_FD 32
#define OS_MAX_TASKS 10
#define OS_LOWEST_PRIO 20
#define OS_FLAG_EN 1
#define OS_THREAD_SAFE_NEWLIB 1
#define OS_MUTEX_EN 1
#define OS_SEM_EN 1
#define OS_MBOX_EN 1
#define OS_Q_EN 1
#define OS_MEM_EN 1
#define OS_FLAG_WAIT_CLR_EN 1
#define OS_FLAG_ACCEPT_EN 1
#define OS_FLAG_DEL_EN 1
#define OS_FLAG_QUERY_EN 1
#define OS_FLAG_NAME_SIZE 32
#define OS_MAX_FLAGS 20
#define OS_FLAGS_NBITS 16
#define OS_MUTEX_ACCEPT_EN 1
#define OS_MUTEX_DEL_EN 1
#define OS_MUTEX_QUERY_EN 1
#define OS_SEM_ACCEPT_EN 1
#define OS_SEM_SET_EN 1
#define OS_SEM_DEL_EN 1
#define OS_SEM_QUERY_EN 1
#define OS_MBOX_ACCEPT_EN 1
#define OS_MBOX_DEL_EN 1
#define OS_MBOX_POST_EN 1
#define OS_MBOX_POST_OPT_EN 1
#define OS_MBOX_QUERY_EN 1
#define OS_Q_ACCEPT_EN 1
#define OS_Q_DEL_EN 1
#define OS_Q_FLUSH_EN 1
#define OS_Q_POST_EN 1
#define OS_Q_POST_FRONT_EN 1
#define OS_Q_POST_OPT_EN 1
#define OS_Q_QUERY_EN 1
#define OS_MAX_QS 20
#define OS_MEM_QUERY_EN 1
#define OS_MEM_NAME_SIZE 32
#define OS_MAX_MEM_PART 60
#define OS_ARG_CHK_EN 1
#define OS_CPU_HOOKS_EN 1
#define OS_DEBUG_EN 1
#define OS_SCHED_LOCK_EN 1
#define OS_TASK_STAT_EN 1
#define OS_TASK_STAT_STK_CHK_EN 1
#define OS_TICK_STEP_EN 1
#define OS_EVENT_NAME_SIZE 32
#define OS_MAX_EVENTS 60
#define OS_TASK_IDLE_STK_SIZE 512
#define OS_TASK_STAT_STK_SIZE 512
#define OS_TASK_CHANGE_PRIO_EN 1
#define OS_TASK_CREATE_EN 1
#define OS_TASK_CREATE_EXT_EN 1
#define OS_TASK_DEL_EN 1
#define OS_TASK_NAME_SIZE 32
#define OS_TASK_PROFILE_EN 1
#define OS_TASK_QUERY_EN 1
#define OS_TASK_SUSPEND_EN 1
#define OS_TASK_SW_HOOK_EN 1
#define OS_TIME_TICK_HOOK_EN 1
#define OS_TIME_GET_SET_EN 1
#define OS_TIME_DLY_RESUME_EN 1
#define OS_TIME_DLY_HMSM_EN 1
#define OS_TMR_EN 0
#define OS_TMR_CFG_MAX 16
#define OS_TMR_CFG_NAME_SIZE 16
#define OS_TMR_CFG_TICKS_PER_SEC 10
#define OS_TMR_CFG_WHEEL_SIZE 2
#define OS_TASK_TMR_STK_SIZE 512
#define OS_TASK_TMR_PRIO 1
#define ALT_SYS_CLK SYS_CLK_TIMER
#define ALT_TIMESTAMP_CLK none
#define OS_TICKS_PER_SEC 1000

/*
 * NicheStack TCP/IP Stack configuration
 *
 */

#define INICHE_DEFAULT_IF "lan91c111"
#define LICENSE_SUPPRESS 1
#define TCP_ZEROCOPY 1
#define INCLUDE_TCP 1
#define IP_FRAGMENTS 1

/*
 * Devices associated with code sections.
 *
 */

#define ALT_TEXT_DEVICE       EXT_RAM
#define ALT_RODATA_DEVICE     ONCHIP_RAM_64_KBYTES
#define ALT_RWDATA_DEVICE     ONCHIP_RAM_64_KBYTES
#define ALT_EXCEPTIONS_DEVICE SDRAM
#define ALT_RESET_DEVICE      EXT_FLASH


#endif /* __SYSTEM_H_ */
