/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
int main()
{
printf("Hello from Nios II!\n");
int count = 0;
int delay;
IOWR_ALTERA_AVALON_PIO_DATA(PIO_LED_BASE, 0xFF);        // Turn LEDs Off
while(1)
{
//    IOWR_ALTERA_AVALON_PIO_DATA(PIO_LED_BASE, count & 0x01);
    IOWR_ALTERA_AVALON_PIO_DATA(PIO_LED_BASE, count);
    delay = 0;
    while(delay < 2000000)
        {
        delay++;
        }
    count++;
}
return 0;
}
