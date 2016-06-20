// OCT acquisition and data transfer via TCP/IP
// Version 2011/09/21
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

/* Altera Avalon registers */
#include "altera_avalon_pio_regs.h" 

/* Constants */
#define NSAMPLES            1170    // 1170         (Fixed by the swept source laser)
#define NBYTES_PER_ALINE    2368    // 1170*2=2340  (Must be a multiple of 32 bytes) -> SSS_TX_BUF_SIZE

/* Global variables */
unsigned long   DDR2_address    = 0;
unsigned char*  dataPointer;

/*
 * sss_reset_connection()
 * 
 * This routine will, when called, reset our SSSConn struct's members 
 * to a reliable initial state. Note that we set our socket (FD) number to
 * -1 to easily determine whether the connection is in a "reset, ready to go" 
 * state.
 */
void sss_reset_connection(SSSConn* conn)
{
  memset(conn, 0, sizeof(SSSConn));

  conn->fd = -1;
  conn->state = READY;
  conn->rx_wr_pos = conn->rx_buffer;
  conn->rx_rd_pos = conn->rx_buffer;
  return;
}

/*
 * sss_send_menu()
 * 
 * This routine will transmit the menu out to the telnet client.
 */
void sss_send_menu(SSSConn* conn)
{
  alt_u8  tx_buf[SSS_TX_BUF_SIZE];
  alt_u8 *tx_wr_pos = tx_buf;
  unsigned short  bytes_sent;

  tx_wr_pos += sprintf(tx_wr_pos,"======================================\n\r");
  tx_wr_pos += sprintf(tx_wr_pos,"   Swept Source OCT Acquisition Menu  \n\r");
  tx_wr_pos += sprintf(tx_wr_pos,"======================================\n\r");
  tx_wr_pos += sprintf(tx_wr_pos,"B   : Take reference measurements     \n\r");
  tx_wr_pos += sprintf(tx_wr_pos,"C   : Continuously send data to PC    \n\r");
  tx_wr_pos += sprintf(tx_wr_pos,"Q   : Terminate session               \n\r");
  tx_wr_pos += sprintf(tx_wr_pos,"======================================\n\r");
  tx_wr_pos += sprintf(tx_wr_pos,"Enter your choice & press return:     \n\r");

  bytes_sent = send(conn->fd, tx_buf, tx_wr_pos - tx_buf, 0);
  printf("Bytes sent from the menu = %d\n",bytes_sent);
  return;
}

/*
 * sss_handle_accept()
 * 
 * This routine is called when ever our listening socket has an incoming
 * connection request. Since this example has only data transfer socket, 
 * we just look at it to see whether its in use... if so, we accept the 
 * connection request and call the telent_send_menu() routine to transmit
 * instructions to the user. Otherwise, the connection is already in use; 
 * reject the incoming request by immediately closing the new socket.
 * 
 * We'll also print out the client's IP address.
 */
void sss_handle_accept(int listen_socket, SSSConn* conn)
{
  int                 socket, len;
  struct sockaddr_in  incoming_addr;

  len = sizeof(incoming_addr);

  if ((conn)->fd == -1)
  {
     if((socket=accept(listen_socket,(struct sockaddr*)&incoming_addr,&len))<0)
     {
         alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE,
                                 "[sss_handle_accept] accept failed");
     }
     else
     {
        (conn)->fd = socket;
        sss_send_menu(conn);
        printf("[sss_handle_accept] accepted connection request from %s\n",
               inet_ntoa(incoming_addr.sin_addr));
     }
  }
  else
  {
    printf("[sss_handle_accept] rejected connection request from %s\n",
           inet_ntoa(incoming_addr.sin_addr));
  }

  return;
}

/*
 * sss_exec_command()
 * 
 * This routine is called whenever we have new, valid receive data from our 
 * sss connection. It will parse through the data simply looking for valid
 * commands to the sss server.
 * 
 * Incoming commands to talk to the board LEDs are handled by sending the 
 * MicroC/OS-II SSSLedCommandQ a pointer to the value we received.
 * 
 * If the user wishes to quit, we set the "close" member of our SSSConn
 * struct, which will be looked at back in sss_handle_receive() when it 
 * comes time to see whether to close the connection or not.
 */
void sss_exec_command(SSSConn* conn)
{
    int             bytes_to_process = conn->rx_wr_pos - conn->rx_rd_pos;
    INT8U           tx_buf[SSS_TX_BUF_SIZE];
    INT8U*          tx_wr_pos = tx_buf;
    //INT8U           error_code;

    // Local variables
    unsigned long   RAM_address     = 0;
    unsigned short  bytes_sent;
    unsigned short  iLoop;
    unsigned short  iFrames;
    unsigned long   iLines          = 0;
    unsigned short  nLinesPerFrame  = 0;
    unsigned char   byte0           = 0;
    unsigned char   byte1           = 0;
    unsigned short  nFrames         = 0;
    unsigned char   volAcqFinished  = 0;
    
    /*
    * "SSSCommand" is declared static so that the data will reside 
    * in the BSS segment. This is done because a pointer to the data in 
    * SSSCommand
    * will be passed via SSSLedCommandQ to the LEDManagementTask.  
    * Therefore SSSCommand cannot be placed on the stack of the 
    * SSSSimpleSocketServerTask, since the LEDManagementTask does not 
    * have access to the stack of the SSSSimpleSocketServerTask.
    */
    static unsigned long SSSCommand;
    
    SSSCommand = CMD_LEDS_BIT_0_TOGGLE;
    
    while(bytes_to_process--)
    {
        SSSCommand = toupper(*(conn->rx_rd_pos++));
        if(SSSCommand >= ' ' && SSSCommand <= '~')
        {
            tx_wr_pos += sprintf(tx_wr_pos,
                "--> Simple Socket Server Command %c.\n\r",
                (char)SSSCommand);
            if (SSSCommand == CMD_QUIT)
            {
                tx_wr_pos += sprintf(tx_wr_pos,"Terminating connection.\n\n\r");
                conn->close = 1;
            } // END if (SSSCommand == CMD_QUIT)
            else
            {
                switch (SSSCommand)
                {

                    case 65:
                        break;
                        
                    case 67:
//                    
//                        //////////////////////////////////////////////////////////
//                        // Reference measurements
//                        //////////////////////////////////////////////////////////
//                        printf("Reference measurements\n");
//                        
//                        // Transmit initial trigger to LabView
//                        IOWR_ALTERA_AVALON_PIO_DATA(VOL_TRANSFER_DONE_PIO_BASE,1);
//                        // Pause 1 000 microseconds
//                        usleep(1000);
//                        // Reset trigger to LabView
//                        IOWR_ALTERA_AVALON_PIO_DATA(VOL_TRANSFER_DONE_PIO_BASE,0);
//                        printf("First trigger sent!\n");
//                        
//                        // Discard \n
//                        byte0 = *conn->rx_rd_pos++;
//                        //Discard \r
//                        byte1 = *conn->rx_rd_pos++;
//                        // Read byte 0 of command nLinesPerFrame
//                        nLinesPerFrame = *conn->rx_rd_pos++;
//                        // Read byte 1 of command nLinesPerFrame
//                        nLinesPerFrame += (*conn->rx_rd_pos++) * 256;
//                        // Read byte 0 of command nFrames
//                        nFrames = *conn->rx_rd_pos++;
//                        // Read byte 1 of command nFrames
//                        nFrames += (*conn->rx_rd_pos++) * 256;
//                        printf("A-lines per B-frame: %d. B-frames per volume: %d\n",nLinesPerFrame,nFrames);
//                        
//                        //////////////////////////////////////////////////////////
//                        // Take 3 frames, the first is discarded by Matlab
//                        //////////////////////////////////////////////////////////
//                        for (iFrames = 1; iFrames <= 3; iFrames++)
//                        {
//                            // Read if volumeAcqfinished then transfer
//                            //volAcqFinished = IORD_ALTERA_AVALON_PIO_DATA(VOL_RECORDING_DONE_PIO_BASE);
//                            while(IORD_ALTERA_AVALON_PIO_DATA(VOL_RECORDING_DONE_PIO_BASE) == 0);
//                            
//                            // Transferred volume signal = 0
//                            IOWR_ALTERA_AVALON_PIO_DATA(VOL_TRANSFER_DONE_PIO_BASE,0);
//                            //////////////////////////////////////////////////////////
//                            // B-frame transfer loop
//                            //////////////////////////////////////////////////////////
//                            for (iLines = 0; iLines < nLinesPerFrame*nFrames; iLines++)
//                            {
//                                // Begin the transfer
//                                tx_wr_pos = tx_buf;
//                                //////////////////////////////////////////////////////////
//                                // Send single A-line
//                                //////////////////////////////////////////////////////////
//                                for (RAM_address = 0; RAM_address < NBYTES_PER_ALINE; RAM_address += 2)
//                                    {
//                                        // Write address port (to RAM)
//                                        dataPointer = (unsigned char*)DDR2_address;
//                                        // Send 16-bit data (swapped upper and lower bytes)
//                                        *tx_wr_pos++ = dataPointer[1]; 
//                                        *tx_wr_pos++ = dataPointer[0];
//                                        // Read 2 bytes
//                                        DDR2_address += 2;
//                                        if (DDR2_address >= 1073741824)
//                                            // Reset DDR2 address if greater than 1Gbyte
//                                            DDR2_address -= 1073741824;
//                                    } // END of A-line loop
//                                // Send a single A-line to the client
//                                bytes_sent = send(conn->fd, tx_buf, tx_wr_pos - tx_buf, 0);
//                                // Wait a little... Should know why...
//                                for (iLoop = 1; iLoop <= NSAMPLES; iLoop++);
//                            } // END of volume / B-frame loop
//                            // Assert signal when the whole volume is transferred
//                            IOWR_ALTERA_AVALON_PIO_DATA(VOL_TRANSFER_DONE_PIO_BASE,1);
//                            //printf("DDR2 address: %lu\n",DDR2_address);
//                        } // END 3 frames sent
//                    
//                    
                    
                        //////////////////////////////////////////////////////////
                        // Continuous acquisition loop
                        //////////////////////////////////////////////////////////
                    
                        // Transmit initial trigger to LabView
                        IOWR_ALTERA_AVALON_PIO_DATA(VOL_TRANSFER_DONE_PIO_BASE,1);
                        // Pause 10 000 microseconds
                        usleep(10000);
                        // Reset trigger to LabView
                        IOWR_ALTERA_AVALON_PIO_DATA(VOL_TRANSFER_DONE_PIO_BASE,0);
                        printf("Acquisition start trigger sent!\n");
                        
                        // Discard \n
                        byte0 = *conn->rx_rd_pos++;
                        //Discard \r
                        byte1 = *conn->rx_rd_pos++;
                        // Read byte 0 of command nLinesPerFrame
                        nLinesPerFrame = *conn->rx_rd_pos++;
                        // Read byte 1 of command nLinesPerFrame
                        nLinesPerFrame += (*conn->rx_rd_pos++) * 256;
                        // Read byte 0 of command nFrames
                        nFrames = *conn->rx_rd_pos++;
                        // Read byte 1 of command nFrames
                        nFrames += (*conn->rx_rd_pos++) * 256;
                        printf("A-lines per B-frame: %d. B-frames per volume: %d\n",nLinesPerFrame,nFrames);
                        
                        
                        printf("Continuous acquisition started! \n");
                        //////////////////////////////////////////////////////////
                        // Continuous acquisition loop (ASCII code = 67)
                        //////////////////////////////////////////////////////////
                        while(1)
                        {
                            // Read if volumeAcqfinished then transfer
                            volAcqFinished = IORD_ALTERA_AVALON_PIO_DATA(VOL_RECORDING_DONE_PIO_BASE);
                            if (volAcqFinished)
                            {
                                // Transferred volume signal = 0
                                IOWR_ALTERA_AVALON_PIO_DATA(VOL_TRANSFER_DONE_PIO_BASE,0);
                                //////////////////////////////////////////////////////////
                                // B-frame transfer loop
                                //////////////////////////////////////////////////////////
                                for (iLines = 0; iLines < nLinesPerFrame*nFrames; iLines++)
                                {
                                    // Begin the transfer
                                    tx_wr_pos = tx_buf;
                                    //////////////////////////////////////////////////////////
                                    // Send single A-line
                                    //////////////////////////////////////////////////////////
                                    for (RAM_address = 0; RAM_address < NBYTES_PER_ALINE; RAM_address += 2)
                                        {
                                            // Write address port (to RAM)
                                            dataPointer = (unsigned char*)DDR2_address;
                                            // Send 16-bit data (swapped upper and lower bytes)
                                            *tx_wr_pos++ = dataPointer[1]; 
                                            *tx_wr_pos++ = dataPointer[0];
                                            // Read 2 bytes
                                            DDR2_address += 2;
                                            if (DDR2_address >= 1073741824)
                                                // Reset DDR2 address if greater than 1Gbyte
                                                DDR2_address -= 1073741824;
                                        } // END of A-line loop
                                    // Send a single A-line to the client
                                    bytes_sent = send(conn->fd, tx_buf, tx_wr_pos - tx_buf, 0);
                                    // Wait a little... Should know why...
                                    for (iLoop = 1; iLoop <= NSAMPLES; iLoop++);
                                } // END of volume / B-frame loop
                                // Assert signal when the whole volume is transferred
                                IOWR_ALTERA_AVALON_PIO_DATA(VOL_TRANSFER_DONE_PIO_BASE,1);
                                //printf("DDR2 address: %lu\n",DDR2_address);
                            } // END if volume acquisition finished
                        } // END of continuous transfer loop
                        break;
                        
                    default:
                        //error_code = OSQPost(SSSLEDCommandQ, (void *)SSSCommand);    
                        //alt_SSSErrorHandler(error_code, 0);
                        break;
                } // END switch
            } // END else if(SSSCommand == CMD_QUIT)
        } // END if(SSSCommand >= ' ' && SSSCommand <= '~')
    } // END while(bytes_to_process--)
    // ORIGINAL POSITION OF SEND COMMAND!!! 
    return;
} // END void sss_exec_command(SSSConn* conn)

/*
 * sss_handle_receive()
 * 
 * This routine is called whenever there is a sss connection established and
 * the socket assocaited with that connection has incoming data. We will first
 * look for a newline "\n" character to see if the user has entered something 
 * and pressed 'return'. If there is no newline in the buffer, we'll attempt
 * to receive data from the listening socket until there is.
 * 
 * The connection will remain open until the user enters "Q\n" or "q\n", as
 * deterimined by repeatedly calling recv(), and once a newline is found, 
 * calling sss_exec_command(), which will determine whether the quit 
 * command was received.
 * 
 * Finally, each time we receive data we must manage our receive-side buffer.
 * New data is received from the sss socket onto the head of the buffer,
 * and popped off from the beginning of the buffer with the 
 * sss_exec_command() routine. Aside from these, we must move incoming
 * (un-processed) data to buffer start as appropriate and keep track of 
 * associated pointers.
 */
void sss_handle_receive(SSSConn* conn)
{
  int data_used = 0, rx_code = 0;
  INT8U *lf_addr; 
  
  conn->rx_rd_pos = conn->rx_buffer;
  conn->rx_wr_pos = conn->rx_buffer;
  
  printf("[sss_handle_receive] processing RX data\n");
  
  while(conn->state != CLOSE)
  {
    /* Find the Carriage return which marks the end of the header */
    lf_addr = strchr(conn->rx_buffer, '\n');
      
    if(lf_addr)
    {
      /* go off and do whatever the user wanted us to do */
      sss_exec_command(conn);
    }
    /* No newline received? Then ask the socket for data */
    else
    {
      rx_code = recv(conn->fd, conn->rx_wr_pos, 
        SSS_RX_BUF_SIZE - (conn->rx_wr_pos - conn->rx_buffer) -1, 0);
          
     if(rx_code > 0)
      {
        conn->rx_wr_pos += rx_code;
        
        /* Zero terminate so we can use string functions */
        *(conn->rx_wr_pos+1) = 0;
      }
    }

    /* 
     * When the quit command is received, update our connection state so that
     * we can exit the while() loop and close the connection
     */
    conn->state = conn->close ? CLOSE : READY;

    /* Manage buffer */
    data_used = conn->rx_rd_pos - conn->rx_buffer;
    memmove(conn->rx_buffer, conn->rx_rd_pos, 
       conn->rx_wr_pos - conn->rx_rd_pos);
    conn->rx_rd_pos = conn->rx_buffer;
    conn->rx_wr_pos -= data_used;
    memset(conn->rx_wr_pos, 0, data_used);
  }

  printf("[sss_handle_receive] closing connection\n");
  close(conn->fd);
  sss_reset_connection(conn);
  
  return;
}

/*
 * SSSSimpleSocketServerTask()
 * 
 * This MicroC/OS-II thread spins forever after first establishing a listening
 * socket for our sss connection, binding it, and listening. Once setup,
 * it perpetually waits for incoming data to either the listening socket, or
 * (if a connection is active), the sss data socket. When data arrives, 
 * the approrpriate routine is called to either accept/reject a connection 
 * request, or process incoming data.
 */
void SSSSimpleSocketServerTask()
{
  int fd_listen, max_socket;
  struct sockaddr_in addr;
  static SSSConn conn;
  fd_set readfds;
  
  /*
   * Sockets primer...
   * The socket() call creates an endpoint for TCP of UDP communication. It 
   * returns a descriptor (similar to a file descriptor) that we call fd_listen,
   * or, "the socket we're listening on for connection requests" in our sss
   * server example.
   */ 
  if ((fd_listen = socket(AF_INET, SOCK_STREAM, 0)) < 0)
  {
    alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE,"[sss_task] Socket creation failed");
  }
  
  /*
   * Sockets primer, continued...
   * Calling bind() associates a socket created with socket() to a particular IP
   * port and incoming address. In this case we're binding to SSS_PORT and to
   * INADDR_ANY address (allowing anyone to connect to us. Bind may fail for 
   * various reasons, but the most common is that some other socket is bound to
   * the port we're requesting. 
   */ 
  addr.sin_family = AF_INET;
  addr.sin_port = htons(SSS_PORT);
  addr.sin_addr.s_addr = INADDR_ANY;
  
  if ((bind(fd_listen,(struct sockaddr *)&addr,sizeof(addr))) < 0)
  {
    alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE,"[sss_task] Bind failed");
  }
    
  /*
   * Sockets primer, continued...
   * The listen socket is a socket which is waiting for incoming connections.
   * This call to listen will block (i.e. not return) until someone tries to 
   * connect to this port.
   */ 
  if ((listen(fd_listen,1)) < 0)
  {
    alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE,"[sss_task] Listen failed");
  }

  /* At this point we have successfully created a socket which is listening
   * on SSS_PORT for connection requests from any remote address.
   */
  sss_reset_connection(&conn);
  printf("[sss_task] Simple Socket Server listening on port %d\n", SSS_PORT);
   
  while(1)
  {
    /* 
     * For those not familiar with sockets programming...
     * The select() call below basically tells the TCPIP stack to return 
     * from this call when any of the events I have expressed an interest 
     * in happen (it blocks until our call to select() is satisfied). 
     * 
     * In the call below we're only interested in either someone trying to 
     * connect to us, or data being available to read on a socket, both of 
     * these are a read event as far as select is called.
     * 
     * The sockets we're interested in are passed in in the readfds 
     * parameter, the format of the readfds is implementation dependant
     * Hence there are standard MACROs for setting/reading the values:
     * 
     *   FD_ZERO  - Zero's out the sockets we're interested in
     *   FD_SET   - Adds a socket to those we're interested in
     *   FD_ISSET - Tests whether the chosen socket is set 
     */
    FD_ZERO(&readfds);
    FD_SET(fd_listen, &readfds);
    max_socket = fd_listen+1;

    if (conn.fd != -1)
    {
      FD_SET(conn.fd, &readfds);
      if (max_socket <= conn.fd)
      {
        max_socket = conn.fd+1;
      }
    }

    select(max_socket, &readfds, NULL, NULL, NULL);

    /* 
     * If fd_listen (the listening socket we originally created in this thread
     * is "set" in readfs, then we have an incoming connection request. We'll
     * call a routine to explicitly accept or deny the incoming connection 
     * request (in this example, we accept a single connection and reject any
     * others that come in while the connection is open).
     */
    if (FD_ISSET(fd_listen, &readfds))
    {
      sss_handle_accept(fd_listen, &conn);
    }
    /*
     * If sss_handle_accept() accepts the connection, it creates *another*
     * socket for sending/receiving data over sss. Note that this socket is
     * independant of the listening socket we created above. This socket's
     * descriptor is stored in conn.fd. If conn.fs is set in readfs... we have
     * incoming data for our sss server, and we call our receiver routine
     * to process it.
     */
    else
    {
      if ((conn.fd != -1) && FD_ISSET(conn.fd, &readfds))
      {
        sss_handle_receive(&conn);
      }
    }
  } /* while(1) */
}



/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2006 Altera Corporation, San Jose, California, USA.           *
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

/******************************************************************************
                Representation of Data Types
Type                Size (Bytes)    Representation
char, signed char   1               two’s complement (ASCII)
unsigned char       1               binary (ASCII)
short, signed short 2               two’s complement
unsigned short      2               binary
int, signed int     4               two’s complement
unsigned int        4               binary
long, signed long   4               two’s complement
unsigned long       4               binary
float               4               IEEE
double              8               IEEE
pointer             4               binary
long long           8               two’s complement
unsigned long long  8               binary
******************************************************************************/
