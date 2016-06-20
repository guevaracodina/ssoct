#include <stdio.h>
#include <string.h>
#include <ctype.h> 
#include <sys/time.h>

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
#include "socket.h"

/* MicroC/OS-II definitions */
#ifdef UCOS_II
#include "includes.h"
#endif
#include "system.h"

/* Simple Socket Server definitions */
#include "alt_error_handler.h"

#endif // ifdef WORKSTATION

#include "benchmark.h"
#include "benchmark_defines.h"

static void get_proper_units(float *number, char *metric_unit)
{
    float divisor[4] = {1,1000,1000000,1000000000};
    char metric[4] = {' ','K','M','G'};
    int index;
    
    for(index=0;index<=4;index++)
    {
        if(*number/divisor[index] < 1)
        {
            if((index-=1) < 0)
                index=0;
            break;
        }       
    }
        
    *number/=divisor[index];
    *metric_unit=metric[index];
}



// total:
// x seconds
// y usecs
// 4096 seconds (12 bits)
// 1024 msecs   (10 bits) 

// transfers (data)
// bytes (20 bits)

// returns a number which is the bits per second
// bytes/ second  (1 Gbit max (30 bits))
// subbytes / second (10 bits)

float get_total_time(const struct timeval start_time, const struct timeval stop_time)
{
    float total_time=0;
    float tv_sec;
    float tv_usec;

    tv_sec = (float)(stop_time.tv_sec -start_time.tv_sec);
    tv_usec = 0;

    if(stop_time.tv_usec < start_time.tv_usec)
    {
        tv_sec -=1;
        tv_usec = 1000000;       
    }
    tv_usec = (tv_usec + (float)(stop_time.tv_usec - start_time.tv_usec));
    total_time = tv_sec +  
        (tv_usec / (float)1000000);
  
   //printf("calcf: %f\n", total_time);
    return(total_time);    
}

float data_rate(const float total_time, const float total_bytes)
{
    float ratesecs=0;            
    if(total_time > 0)
        ratesecs = (total_bytes / total_time)*8;
    return(ratesecs);
}


// this function is either called from the nios_init.c or workstation_init.c
// initialization routines...
struct result_def benchmark(struct command_def the_command)
{
    struct result_def results = {0};
    struct internal_command_def test;

    char buffer[the_command.buffer_size];
    memset(&buffer, 0xaa, sizeof(the_command.buffer_size));
    unsigned long  ip_addr = inet_addr(the_command.ip_address);
    unsigned short port_number = htons(the_command.port_number);
    test.ip = inet_addr(the_command.ip_address);
    test.port = htons(the_command.port_number);
    test.bsize = the_command.buffer_size;
    test.buff = buffer;
    test.dsize = the_command.total_data_size;
               
    // if server (waiting for benchmark connections)
    if(the_command.mode == RECEIVER)
    {
        if(the_command.protocol == UDP)
        {
            results = udp_receiver_plain
                    (port_number, 
                    buffer, 
                    test.bsize, 
                    0);
                           
        }                
        else //(the_command.protocol == TCP)
        {
            results = tcp_receiver_plain
                    (port_number, 
                    buffer, 
                    test.bsize, 
                    0);
            
        }
    }
    else // if(the_command.mode == SENDER)   // if client (starting benchmark connections)
    {   
        if(the_command.protocol == UDP)
        {
            results = udp_sender_plain(      
                ip_addr, 
                port_number, 
                buffer,
                test.bsize,
                test.dsize,
                0);          
        }
        else // if (the_command.protocol == TCP)
        {

            results = tcp_sender_plain(      
                ip_addr, 
                port_number, 
                buffer,
                test.bsize,
                test.dsize,
                0);                         
        }
    }
      
    return results;
}

void print_test(struct command_def command)
{
    
    printf("-----------------------------------------------------------\n");
    printf("- Test Role: %s\n", (command.mode == SENDER) ? "Sender" : "Receiver");
    printf("- Protocol: %s\n", (command.protocol == UDP) ? "UDP" : "TCP");
    printf("- %s %s:%d\n", 
        ((command.mode == SENDER) ? 
            "Sending to " : "Receiving at "),
        ((command.mode == SENDER) ? 
            command.ip_address : " "),
            command.port_number);
    printf("- %s buffer size: %d bytes\n",         
        ((command.mode == SENDER) ? "Send " : "Receive "),
        command.buffer_size);
    printf("-----------------------------------------------------------\n");

}



void print_result(const struct command_def command, const struct result_def results)
{
    float rate=0;
    float total_time=0;
    char metric_unit = ' ';
    
    total_time = get_total_time(results.start_time, results.stop_time);
    rate = data_rate(total_time, results.total_bytes);
    get_proper_units(&rate,&metric_unit);
    printf("-----------------------------------------------------------\n");
    printf("- Test Role: %s\n", (command.mode == SENDER) ? "Sender" : "Receiver");    
    printf("- Protocol: %s\n", (command.protocol == UDP) ? "UDP" : "TCP");
    printf("- Status: %s\n", results.success ? "Completed" : "Interrupted");
    printf("- Total Bytes: %d\n", results.total_bytes);
    printf("- Total Time: %f seconds\n", total_time);
    printf("- Bits per second: %f %cbits/sec\n", rate, metric_unit);
    printf("- Total Packets: %d\n", results.total_packets);
    printf("-----------------------------------------------------------\n");

}

