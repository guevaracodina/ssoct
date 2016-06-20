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
udp_sender(struct internal_command_def * command)
{
    int num_sent=0;
    struct result_def results={0};
    int send_length=0;
    int sock;
    struct sockaddr_in server_addr;
    int packet_sleep_trigger=0;
    
    // set the static Done variable as false...
    DONE=BMFALSE;
    memset(&results, 0, sizeof(results));
    
    // open socket
    if((sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP))<0)
    {
        printf("Create socket() error\n");
        goto close_client;     
    }
   
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = command->ip;
    server_addr.sin_port = command->port;
    
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
        
        // send data
        num_sent = sendto(sock, command->buff, send_length, 0,
                          (struct sockaddr *)& server_addr, 
                          sizeof(server_addr));
        if(num_sent < 0)
        {
            printf("Error in sendto() call...\n");
            goto close_sender;
        }
        else if(num_sent == 0)
        {
            if(DONE == BMFALSE)
                if(gettimeofday(&(results.stop_time), 0) < 0)
                {
                    printf("gettimeofday error\n");   
                }   
            DONE = BMTRUE;

           // if(--close_socket_countdown == 0)
                goto close_sender;
        }
        else
        {
            command->bsize -= num_sent;
            results.total_bytes += num_sent;
            results.total_packets ++;

            packet_sleep_trigger++;
            if(packet_sleep_trigger==0)
            {
                packet_sleep_trigger=0;
                usleep(1);
            }
            // user supplied call back function
            //if(callback)
            //    (*callback)(callback_args);
        }                      
    }
    
close_sender:  
close_client:
    close(sock);

    if(DONE == BMTRUE)
        results.success = BMTRUE;
    else
        results.success = BMFALSE;
        
    return(results);
}

struct result_def 
udp_sender_plain(
    unsigned long ip, 
    unsigned short port, 
    char *buff,
    int dsize,
    int bsize,
    int (* callback)(void))
{
    struct internal_command_def command;
    command.buff = buff;
    command.bsize = bsize;
    command.dsize = dsize;
    command.ip = ip;   
    command.port = port;
    command.callback = callback; 
    return(udp_sender(&command));
}
