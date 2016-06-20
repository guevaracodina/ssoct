/******************************************************************************
* Copyright (c) 2006 Altera Corporation, San Jose, California, USA.           *
* All rights reserved. All use of this software and documentation is          *
* subject to the License Agreement located at the end of this file below.     *
******************************************************************************
* Date - October 24, 2006                                                     *
* Module - network_utilities.c                                                *             *
*                                                                             *
******************************************************************************/

#include <alt_types.h>
#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <sys/alt_flash.h>
#include "includes.h"
#include "io.h"
#include "simple_socket_server.h"

#include <alt_iniche_dev.h>

#include "ipport.h"
#include "tcpport.h"
#include "network_utilities.h"

#define IP4_ADDR(ipaddr, a,b,c,d) ipaddr = \
    htonl((((alt_u32)(a & 0xff) << 24) | ((alt_u32)(b & 0xff) << 16) | \
          ((alt_u32)(c & 0xff) << 8) | (alt_u32)(d & 0xff)))

#define ETHERNET_OPTION_BITS         0x00008000

/*
* get_mac_addr
*
* Read the MAC address in a board specific way
*
*/
int get_mac_addr(NET net, unsigned char mac_addr[6])
{
    return (get_board_mac_addr(mac_addr));
}

/*
 * get_ip_addr()
 *
 * This routine is called by InterNiche to obtain an IP address for the
 * specified network adapter. Like the MAC address, obtaining an IP address is
 * very system-dependant and therefore this function is exported for the
 * developer to control.
 *
 * In our system, we are either attempting DHCP auto-negotiation of IP address,
 * or we are setting our own static IP, Gateway, and Subnet Mask addresses our
 * self. This routine is where that happens.
 */
int get_ip_addr(alt_iniche_dev *p_dev,
                ip_addr* ipaddr,
                ip_addr* netmask,
                ip_addr* gw,
                int* use_dhcp)
{

    IP4_ADDR(*ipaddr, IPADDR0, IPADDR1, IPADDR2, IPADDR3);
    IP4_ADDR(*gw, GWADDR0, GWADDR1, GWADDR2, GWADDR3);
    IP4_ADDR(*netmask, MSKADDR0, MSKADDR1, MSKADDR2, MSKADDR3);

#ifdef DHCP_CLIENT
    *use_dhcp = 1;
#else /* not DHCP_CLIENT */
    *use_dhcp = 0;

    printf("Static IP Address is %d.%d.%d.%d\n",
        ip4_addr1(*ipaddr),
        ip4_addr2(*ipaddr),
        ip4_addr3(*ipaddr),
        ip4_addr4(*ipaddr));
#endif /* not DHCP_CLIENT */

    /* Non-standard API: return 1 for success */
    return 1;
}

int FindLastFlashSectorOffset(
    alt_u32                     *pLastFlashSectorOffset);

alt_u32 last_flash_sector_offset;
alt_u32 last_flash_sector;

/*
 * generate_and_store_mac_addr()
 * 
 * This routine is called when, upon program initialization, we discover
 * that there is no valid network settings (including MAC address) programmed
 * into flash memory at the last flash sector.  If it is not safe to use the 
 * contents of this last sector of flash, the user is prompted to
 * enter the serial number at the console.  A MAC address is then
 * generated using 0xFF followed by the last 2 bytes of the serial number 
 * appended to Altera's Vendor ID, an assigned MAC address range with the first
 * 3 bytes of 00:07:ED.  For example, if the Nios Development Board serial 
 * number is 040800017, the corresponding ethernet number generated will be
 * 00:07:ED:FF:8F:11.
 * 
 * It should be noted that this number, while unique, will likely differ from
 * the also unique (but now lost forever) MAC address programmed into the 
 * development board on the production line.
 * 
 * As we are erasing the entire flash sector, we'll re-program it with not
 * only the MAC address, but static IP, subnet, gateway, and "Use DHCP" 
 * sections. These fail-safe static settings are compatible with previous
 * Nios Ethernet designs, and allow the "factory-safe" design to behave 
 * as expected if the last flash sector is erased.
 */
error_t generate_and_store_mac_addr()
{
  error_t error = -1;
  alt_u32 ser_num = 0;
  char serial_number[9], flash_content[32];
  alt_flash_fd* flash_handle;
  int i = 0;
  
  printf("Can't read the MAC address from your board (this probably means\n");
  printf("that your flash was erased). We will assign you a MAC address and\n");
  printf("static network settings\n\n");
  
  while(!ser_num)
  {
    printf("Please enter your 9-digit serial number. This is printed on a \n");
    printf("label under your Nios dev. board. The first 3 digits of the \n");
    printf("label are ASJ and the serial number follows this.\n -->");
    
    for(i=0; i<9; i++)
    {
      serial_number[i] = getchar();
      putchar(serial_number[i]);
      
      /* Handle backspaces.  How civilized. */
      if ((serial_number[i] == 0x08) && (i >= 0)) 
      {
        i--;
      }
    }
    printf("\n");
            
    for(i=0; i<9; i++)
    {
      if (isdigit(serial_number[i]))
      {
        ser_num *= 10;
        ser_num += serial_number[i] - '0';
      }
      else
      {
        ser_num = 0;
        printf("Serial number only contains decimal digits and is non-zero\n");
        break;
      }
    }
    
    if (ser_num)
    {
      /* This says the image is safe */
      flash_content[0] = 0xfe;
      flash_content[1] = 0x5a;
      flash_content[2] = 0x0;
      flash_content[3] = 0x0;
      
      /* This is the Altera Vendor ID */
      flash_content[4] = 0x0;
      flash_content[5] = 0x7;
      flash_content[6] = 0xed;
      
      /* Reserverd Board identifier for erase boards */
      flash_content[7] = 0xFF;
      flash_content[8] = (ser_num & 0xff00) >> 8;
      flash_content[9] = ser_num & 0xff;

      /* Then comes a 16-bit "flags" field */
      flash_content[10] = 0xFF;
      flash_content[11] = 0xFF;
      
      /* Then comes the static IP address */
      flash_content[12] = IPADDR0;
      flash_content[13] = IPADDR1;
      flash_content[14] = IPADDR2;
      flash_content[15] = IPADDR3;
      
      /* Then comes the static nameserver address */
      flash_content[16] = 0xFF;
      flash_content[17] = 0xFF;
      flash_content[18] = 0xFF;
      flash_content[19] = 0xFF;
      
      /* Then comes the static subnet mask */
      flash_content[20] = MSKADDR0;
      flash_content[21] = MSKADDR1;
      flash_content[22] = MSKADDR2;
      flash_content[23] = MSKADDR3;
      
      /* Then comes the static gateway address */
      flash_content[24] = GWADDR0;
      flash_content[25] = GWADDR1;
      flash_content[26] = GWADDR2;
      flash_content[27] = GWADDR3;
      
      /* And finally whether to use DHCP - set all bits to be safe */
      flash_content[28] = 0xFF;
      flash_content[29] = 0xFF;
      flash_content[30] = 0xFF;
      flash_content[31] = 0xFF;
      
      /* Write the MAC address to flash */
      flash_handle = alt_flash_open_dev(EXT_FLASH_NAME);
      if (flash_handle)
      {
        alt_write_flash(flash_handle,
                        ETHERNET_OPTION_BITS,
                        flash_content,
                        32);
        alt_flash_close_dev(flash_handle);
        error = 0;
      }
    }
  }
  return error;    
}

/*
* get_board_mac_addr
*
* Read the MAC address in a board specific way
*
*/
error_t get_board_mac_addr(unsigned char mac_addr[6])
{
  error_t error = 0;

  alt_u32 signature;
  alt_u32 mac_addr_ptr = EXT_FLASH_BASE + ETHERNET_OPTION_BITS;
  
/* This last_flash_sector region of flash is examined to see if 
 * valid network settings are present, indicated by a signature of 0x00005afe at 
 * the first address of the last flash sector.  This hex value is chosen as the 
 * signature since it looks like the english word "SAFE", meaning that it is 
 * safe to use these network address values.  
*/

  /* Get the flash sector with the MAC address. */
  signature = IORD_32DIRECT(mac_addr_ptr, 0);
    
  if (signature != 0x00005afe)
  {
    error = generate_and_store_mac_addr();
  }
  
  if (!error)
  {
    mac_addr[0] = IORD_8DIRECT(mac_addr_ptr, 4);
    mac_addr[1] = IORD_8DIRECT(mac_addr_ptr, 5);
    mac_addr[2] = IORD_8DIRECT(mac_addr_ptr, 6);
    mac_addr[3] = IORD_8DIRECT(mac_addr_ptr, 7);
    mac_addr[4] = IORD_8DIRECT(mac_addr_ptr, 8);
    mac_addr[5] = IORD_8DIRECT(mac_addr_ptr, 9);
    
    printf("Your Ethernet MAC address is %02x:%02x:%02x:%02x:%02x:%02x\n", 
            mac_addr[0],
            mac_addr[1],
            mac_addr[2],
            mac_addr[3],
            mac_addr[4],
            mac_addr[5]);

  }

  return error;
}

/*******************************************************************************
 *
 * Flash service functions.
 *
 ******************************************************************************/

#include "sys/alt_flash.h"
#include "sys/alt_flash_dev.h"

/*
 * FindLastFlashSectorOffset
 *
 *   <-- pLastFlashSectorOffset Offset of last sector in flash.
 *
 *   This function finds the offset to the last sector in flash and returns it
 * in pLastFlashSectorOffset.
 */

int FindLastFlashSectorOffset(
    alt_u32                     *pLastFlashSectorOffset)
{
    alt_flash_fd                *fd;
    flash_region                *regions;
    int                         numRegions;
    flash_region                *pLastRegion;
    int                         lastFlashSectorOffset;
    int                         n;
    int                         error = 0;

    /* Open the flash device. */
    fd = alt_flash_open_dev(EXT_FLASH_NAME);
    if (fd <= 0)
        error = -1;

    /* Get the flash info. */
    if (!error)
        error = alt_get_flash_info(fd, &regions, &numRegions);

    /* Find the last flash sector. */
    if (!error)
    {
        pLastRegion = &(regions[0]);
        for (n = 1; n < numRegions; n++)
        {
            if (regions[n].offset > pLastRegion->offset)
                pLastRegion = &(regions[n]);
        }
        lastFlashSectorOffset =   pLastRegion->offset
                                + pLastRegion->region_size
                                - pLastRegion->block_size;
    }

    /* Return results. */
    if (!error)
        *pLastFlashSectorOffset = lastFlashSectorOffset;

    return (error);
}


/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2004 Altera Corporation, San Jose, California, USA.           *
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
* Altera does not recommend, suggest or require that this reference design    *
* file be used in conjunction or combination with any other product.          *
******************************************************************************/
