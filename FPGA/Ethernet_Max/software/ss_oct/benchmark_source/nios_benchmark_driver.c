#include <stdio.h>
#include <sys/time.h>
#include <fcntl.h>
#include "benchmark.h"

// just to test getting ip
#include "ipport.h"
#include "q.h"
#include "netbuf.h"
#include "net.h"
#include "ip.h"


int nios_get_command_string(char *line)
{
    char c;
    int cindex=0;
    char last_char=0;
    
    while((c = getchar()))
    {
        if((errno == EWOULDBLOCK) && (c==EOF))
        {
            // do nothing but yield in super loop mode
#ifdef SUPERLOOP
            tk_yield();
#endif
        }
        // if end character
        else if((c == '\n') || (c=='\r'))
        {
            putchar(c);
            if((last_char == '\n') || (last_char == '\r'))
            {
                if(cindex != 0)  // 1st char... 
                    line[cindex]='\0';                  
                last_char = 0;
                break;
            }
            last_char = c;
        }
        else if((c == '\b') && (cindex != 0))
        {
            putchar(c);   
            cindex--;
            last_char = c;
        }
        else
        {
            line[cindex]=c;
            putchar(c);   
            cindex++;
            last_char = c;
        }
        
    } 
    return(cindex);   
}

void nios_format_string(int *num, char ** args, char *string)
{
    char * currc = string;
    *num = 0;
    while(*currc != '\0')
    {
        if(*currc == ' ')
        {           
            *currc = '\0';  //mark all spaces as null   
        }
        else
        {
            if((currc == string) || (*(currc-1) == '\0'))
            {
                *(args++) = currc;
                (*num)++;
            }
        }
        currc++;
    }
}

void benchmark_driver(void)
{    
    struct result_def bmresult;
    int nargc=0;
    char *nargv[10];

    char bmstring[128];
    struct command_def bmcommand;
    while(1)
    {
        //get command
        printf("> ");
        if(nios_get_command_string(bmstring) > 0) 
            nios_format_string(&nargc, (char**)&nargv, bmstring);

again:            
        if(bmcommand_from_console(nargc, nargv, &bmcommand)==BMTRUE)
        {
            print_test(bmcommand);
            bmresult = benchmark(bmcommand);    
            print_result(bmcommand, bmresult);   
        }
        if(bmcommand.repeat == BMTRUE)
            goto again;    
    }
}

