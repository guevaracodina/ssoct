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

struct result_def 
tcp_sender(struct internal_command_def *command)
{
    int num_sent=0;
    struct result_def results={0};
    int send_length=0;
    int sender_socket;
    struct sockaddr_in addr;
    
    int optval = 1; 
    
    // set the static Done variable as false...
    DONE=BMFALSE;
    memset(&results, 0, sizeof(results));
    
    // open socket
    if((sender_socket = socket(PF_INET, SOCK_STREAM, 0))<0)
    {
        printf("Create socket() error\n");
        goto close_sender;     
    }
    setsockopt(sender_socket, SOL_SOCKET, SO_REUSEADDR, (char *)&optval, sizeof(optval));
    setsockopt(sender_socket, IPPROTO_TCP, TCP_NODELAY, (char *)&optval, sizeof(optval));
 
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = command->ip;
    addr.sin_port = command->port;
    
    // connect to target
    if(connect(sender_socket, (struct sockaddr *) &addr, sizeof(addr)) >0)
    {
        printf("Create socket() error\n");
        goto close_sender;   
    }

    if(gettimeofday(&(results.start_time), 0) < 0)
    {
        printf("gettimeofday error\n");   
    }

    while(DONE == BMFALSE)
    {
     
        // adjust send buffer ptrs
        send_length = command->bsize;    
        if(send_length > command->dsize)
            send_length = command->dsize;

        // set the buffer with known data
#if 0        
        for(i=0; i<command->bsize; i++)
        {
            *(command->buff + i) = (char)((j+k) % 256);

            if(++j == 256)
            {
                j=0;
                k++;
            }
            
            if(k == 256)
                k=0;                
        }
#endif        
        //memset(command->buff, results.total_packets % 256, command->bsize);
               
        // send data
        num_sent = send(sender_socket, command->buff, send_length, 0);
        if(num_sent < 0)
        {
            printf("Error in send() call...\n");
            goto close_sender;
        }
        else if(num_sent == 0)
        {
            DONE = BMTRUE;
            goto close_sender;   
        }
        else
        {
            command->dsize -= num_sent;
            results.total_bytes += num_sent;
            results.total_packets ++;            
        }                      
    }
    
close_sender:  
    if(gettimeofday(&(results.stop_time), 0) < 0)
    {
        printf("gettimeofday error\n");   
    }
    close(sender_socket);


    if(DONE == BMTRUE)
        results.success = BMTRUE;
    else
        results.success = BMFALSE;
        
    return(results);
}

struct result_def 
tcp_sender_plain(
    unsigned long ip, 
    unsigned short port, 
    char *buff,
    int bsize,
    int dsize,
    int (* callback)(void))
{
    struct internal_command_def command;
    command.buff = buff;
    command.bsize = bsize;
    command.dsize = dsize;
    command.ip = ip;   
    command.port = port;
    command.callback = callback; 
    return(tcp_sender(&command));
}
