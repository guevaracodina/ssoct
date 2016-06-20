#include <sys/time.h>
#ifdef WORKSTATION
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#else //running on a Nios II board


/* Nichestack definitions */
#include "ipport.h"
#include "libport.h"
#include "osport.h"
#include "tcpport.h"
#include "nios_time_routines.h"

#include "system.h"

/* MicroC/OS-II definitions */
#ifdef UCOS_II
#include "includes.h"
#endif
#endif // ifdef WORKSTATION

#include "benchmark.h"
#include "benchmark_defines.h"

// These send/receive functions are the core elements of the benchmarking
// utility... They are designed to be small and re-usable outside
// of the benchmarking framework.
// All of them have the following operation:
// - Initialize network connections
// - Start packet send/receiving operations
// - Stop operation when "interrupt" received or end-of-operation


extern int DONE;
////debug
extern struct timeval  alt_resettime;
////debug
struct result_def  
udp_receiver
(struct internal_command_def *command)
{
    struct sockaddr_in server_addr;
    struct sockaddr_in client_addr;
    int sock, client_addr_length;
    struct result_def results={0};
    int length;
    int first_connect = BMTRUE;
    int temp=0;
    
    // set the static Done variable as false...
    DONE=BMFALSE;
    memset(&results, 0, sizeof(results));
    client_addr_length = sizeof(client_addr);
    memset(&client_addr, 0, client_addr_length);

    // for nios, reset the system clock
#ifndef WORKSTATION
    settimeofday(&results.start_time, 0);
#endif
    
    // create socket
    if((sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP))<0)
    {
        printf("Create socket() error\n");
        goto close_server;
    }
    
    // bind socket
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = command->port;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    if((temp=bind(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0))
    {
        printf("Bind bind() error\n");
        goto close_server;
    }
        
    while(DONE == BMFALSE)
    {    
        length = recvfrom(sock, command->buff, 
                          command->bsize, 0, (struct sockaddr *)&client_addr, 
                          &client_addr_length);
        
        // error condition                  
        if(length < 0)
        {
            printf("Error in recvfrom() call...\n");
            goto close_listener;
        }
        // end of transmission
        else if(length == 0)
        {
            if(gettimeofday(&(results.stop_time), 0) < 0)
            {
                printf("gettimeofday error\n");   
            }
            DONE = BMTRUE;
        }
        // no problems... we received data
        else
        {
            // start time on receipt of first packet
            if(first_connect == BMTRUE)  
            {
                first_connect = BMFALSE;
                if(gettimeofday(&(results.start_time), 0) < 0)
                {
                    printf("gettimeofday error\n");   
                } 
            }
            
            // update byte count
            results.total_bytes += length;
            results.total_packets ++;
        
            // user supplied call back function
            if(command->callback)
                (*command->callback)();
        }  
    }

close_listener:  
close_server:
    close(sock);

    if(DONE == BMTRUE)
        results.success = BMTRUE;
    else
        results.success = BMFALSE;
        
    return(results);
}


struct result_def  
udp_receiver_plain
(unsigned short port, 
char * buff, 
int bsize, 
int (* callback)(void))
{
    struct internal_command_def command;
    command.buff = buff;
    command.bsize = bsize;
    command.dsize = 0;
    command.ip = 0;   
    command.port = port;
    command.callback = callback;
    
    return(udp_receiver(&command));
};

