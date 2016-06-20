#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>
#include "benchmark.h"
#include "benchmark_console.h"

char bmconsole_error[128];

void bmprint_menu(void)
{
    printf("bm <flags>\n");
    printf("Flags:\n");
    printf("-m <ip>:<port> (test Mode)\n");
    printf("   <ip> (optional) - The IP address to send to. No IP indicates that you are the receiver.\n");
    printf("   <port> (optional) - Port number for test.\n");
    printf("-p <type> (test tyPe)\n");
    printf("   <type> - Set to the option \"udp\" or \"tcp\"\n");
    printf("-d <size> (Data size)\n");
    printf("   <size> Number of bytes to transmit\n");
    printf("-b <size> (Buffer size)\n");
    printf("   <size> Set the send or receive buffer size\n");
    printf("-x (repeat command forever)\n");
}


int bmcommand_from_console(int nargc, char **nargv, struct command_def *command)
{
    int c=0; 
    opterr=0;
    optind=1;
    optopt=0;
    int num;
    char *cptr;
    int retval=BMTRUE;
    
    command->mode=UNK_MODE;
    while ((c = getopt (nargc, nargv, "m:p:d:b:x?")) != -1)
    {
        switch (c)
        {
            case 'm':           // send
            {
                command->mode=RECEIVER;                    
                cptr = optarg;
                while(*cptr != '\0')
                    if(*cptr == ':')
                        break;
                    else
                        cptr++;

                if(*cptr != 0)  // we found ':' and more chars
                    command->port_number = atoi(cptr+1);    // one char beyond ':'
                
                if(optarg-cptr) // found something before the ':'... we're sending                                                                              
                {
                    strncpy(command->ip_address, optarg, cptr-optarg); // copy ip
                    command->ip_address[cptr-optarg] = 0;
                    command->mode=SENDER;   
                }
                break;
            }
            case 'p':
            {
                if(strcmp(optarg,"udp") == 0)
                    command->protocol=UDP;
                else if(strcmp(optarg, "tcp") ==0)
                    command->protocol=TCP;
                else
                    command->protocol=UNK_PROT;      
                break;  
            }
            case 'd':
            {
                num = atoi(optarg);                // get data size   
                command->total_data_size = num;
                break;
            }
            case 't':
            {
                                // set refresh time
                break;                                   
            }
            case 'b':
            {
                num = atoi(optarg);                // get data size   
                command->buffer_size = num;
                break;   
            }
            case 'x':
            {
                // keep repeating benchmark   
                command->repeat= 1;                
            }
            case '?':
                break;
        }
    }
    
    if((c == '?') || (optind > nargc))
    {
        if(optind > nargc)
            printf("Unknown option on command line\n");
        bmprint_menu();
        retval=BMFALSE;
    }
    else
    {
        //validate stuff here

        if((0 > command->buffer_size)||(0 > command->total_data_size))
            retval=BMFALSE;

        if((0 > command->port_number)||(command->port_number > 65535))
            retval=BMFALSE;
        

        if(command->mode == SENDER)
        {
            int dot_count=3;
            int numerals=4;
            int last_was_digit=BMFALSE;
            char *ip = command->ip_address;
            while(*ip != 0)
            {               
                if(*ip == '.')
                {
                    dot_count--;
                    last_was_digit=BMFALSE;
                }
                else if(('0' <= *ip) && (*ip <= '9'))
                { 
                    if(last_was_digit==BMFALSE)
                    {
                        last_was_digit=BMTRUE;
                        numerals--;   
                    }
                }
                else
                {
                    retval=BMFALSE;   
                }
                ip++;
            }
            if((numerals!=0) || (dot_count!=0))
                retval=BMFALSE;
        }    
        else if(command->mode != RECEIVER)
        {
            retval=BMFALSE;
        }    
    }
    return(retval);   
}
