#include <sys/time.h>
#include "benchmark.h"

#ifdef WORKSTATION
#include <sys/socket.h>
#include <netinet/in.h>
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

/* Simple Socket Server definitions */
#include "alt_error_handler.h"



#endif // ifdef WORKSTATION

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
tcp_receiver
(struct internal_command_def *command)
{
    struct sockaddr_in addr;
    struct sockaddr_in listen_addr;
    int listen_socket, listen_addr_length;
    struct result_def results={0};
    int length;
    int server_socket;
    int optval = 1;

    
    // set the static Done variable as false...
    DONE=BMFALSE;
    memset(&results, 0, sizeof(results));
    
    // for nios, reset the system clock
#ifndef WORKSTATION
    settimeofday(&results.start_time, 0);
#endif
    
    // create socket
    if((server_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP))<0)
    {
        printf("Create socket() error\n");
        goto close_server;
    }
    setsockopt(server_socket, SOL_SOCKET, SO_REUSEADDR, (char *)&optval, sizeof(optval));
    setsockopt(server_socket, IPPROTO_TCP, TCP_NODELAY, (char *)&optval, sizeof(optval));
    

    // bind socket
    addr.sin_family = AF_INET;
    addr.sin_port = command->port;
    addr.sin_addr.s_addr = INADDR_ANY;
    if(bind(server_socket, (struct sockaddr *)&addr, sizeof(addr)) < 0)
    {
        printf("Bind bind() error\n");
        goto close_server;
    }
    
    // start listening
    listen(server_socket, 1);
    
    // wait until a connection comes in
    listen_addr_length = sizeof(listen_addr);
    listen_socket = accept(server_socket, 
                 (struct sockaddr *) &listen_addr, 
                 &listen_addr_length);
                 

    if(gettimeofday(&(results.start_time), 0) < 0)
    {
        printf("gettimeofday error\n");   
    }
    
    while(DONE == BMFALSE)
    {    
        length = recv(listen_socket, command->buff, command->bsize, 0);
        if(length < 0)
        {
            printf("Error in recv() call...\n");
            goto close_listener;
        }
        else if(length == 0)
        {
            if(gettimeofday(&(results.stop_time), 0) < 0)
            {
                printf("gettimeofday error\n");   
            }
            DONE = BMTRUE;
        }
        else
        {
            results.total_bytes += length;
            results.total_packets ++;
#if 0       
            for(i=0; i<length; i++)
            {
                if(*(command->buff + i) != (char)((j+k) % 256))
                    printf("Recv: %u; Expt: %u\n", 
                        (char)*(command->buff + i),
                        (char)((j+k) % 256));
                

                if(++j == 256)
                {
                    j=0;
                    k++;
                }
            
                if(k == 256)
                    k=0;                
            }
#endif
        }  
    }

close_listener:  
    close(listen_socket);
close_server:
    close(server_socket);

    if(DONE == BMTRUE)
        results.success = BMTRUE;
    else
        results.success = BMFALSE;
        
    return(results);
};

struct result_def  
tcp_receiver_plain
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
    
    return(tcp_receiver(&command));
};

