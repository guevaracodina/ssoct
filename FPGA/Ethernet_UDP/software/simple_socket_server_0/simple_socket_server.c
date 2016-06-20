/******************************************************************************
* Copyright (c) 2006 Altera Corporation, San Jose, California, USA.           *
* All rights reserved. All use of this software and documentation is          *
* subject to the License Agreement located at the end of this file below.     *
*******************************************************************************                                                                             *
* Date - October 24, 2006                                                     *
* Module - simple_socket_server.c                                             *
*                                                                             *                                                                             *
******************************************************************************/
 
/******************************************************************************
 * Simple Socket Server (SSS) example. 
 * 
 * This example demonstrates the use of MicroC/OS-II running on NIOS II.       
 * In addition it is to serve as a good starting point for designs using       
 * MicroC/OS-II and Altera NicheStack TCP/IP Stack - NIOS II Edition.                                          
 *                                                                             
 * -Known Issues                                                             
 *     None.   
 *      
 * Please refer to the Altera NicheStack Tutorial documentation for details on this 
 * software example, as well as details on how to configure the NicheStack TCP/IP 
 * networking stack and MicroC/OS-II Real-Time Operating System.  
 */
//#include  <stdlib.h>  
#include <stdio.h>
#include <string.h>
#include <ctype.h> 

/* MicroC/OS-II definitions */
#include "includes.h"

/* Simple Socket Server definitions */
#include "simple_socket_server.h"                                                                    
#include "alt_error_handler.h"

/* Nichestack definitions */
#include "ipport.h"
#include "tcpport.h"

//#include "io.h"
#include "altera_avalon_pio_regs.h"


void SSSSimpleSocketServerTask()
{
    int udp_socket;  // discriptor
    struct sockaddr_in cliaddr;

    int nSendBufSize = 2*SSS_TX_BUF_SIZE; 
             
    cliaddr.sin_family      = AF_INET;                    
    cliaddr.sin_port        = htons(UDP_PORT);
    cliaddr.sin_addr.s_addr = inet_addr("192.168.1.213");   

	udp_socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);                 
	setsockopt(udp_socket, SOL_SOCKET, SO_SNDBUF, (const char*)&nSendBufSize, sizeof(int)); 
        
	while(1) {
	   sendto(udp_socket, (void *)(AD_BUF_BASE+0x80000000), SSS_BUF_LEN, 0, (struct sockaddr *)&cliaddr, sizeof(cliaddr));
	}  

        close(udp_socket);

}

