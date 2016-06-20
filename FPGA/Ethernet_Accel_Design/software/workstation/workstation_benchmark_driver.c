#ifdef WORKSTATION

#include <sys/time.h>
#include "benchmark.h"
#include "benchmark_console.h"
//#include "common.h"
#include <stdio.h>

void benchmark_driver(void)
{
    struct command_def command;
     
    while(1)
    {
        //get command       
        // start benchmark
        benchmark(command);   
    }
}

int main(int argc, char *argv[])
{
//    FILE *foo;
    int i=0;
    int j=0;
    float total_time;
    float total_rate;
    
    struct command_def bmcommand;
    struct result_def bmresult;
    
#if 1
        if(bmcommand_from_console(argc, argv, &bmcommand) == BMTRUE)
        {
            print_test(bmcommand);
            bmresult = benchmark(bmcommand);    
            print_result(bmcommand, bmresult);       
        }
//        printf("m: %d, p: %d, ip: %s, ds: %d, bs: %d\n",
//            bmcommand.mode,bmcommand.port_number,bmcommand.ip_address,bmcommand.total_data_size,bmcommand.buffer_size); 
        
#else
       for(i=256; i< 1459;i+=1202)
       {
       for(j=0;j<6;j++)
       {
       // fudging it for now...
        bmcommand.buffer_size = 2000;
        bmcommand.mode = RECEIVER;
        if(j>=3)
        {
            bmcommand.mode = SENDER;
            bmcommand.buffer_size = i;        
        }
        bmcommand.port_number = 50;
        bmcommand.protocol = TCP;
        // command.ip_address not needed for receiver  
        strcpy(bmcommand.ip_address,"192.168.0.50");
        // command.total_data_size not needed for receiver
        bmcommand.total_data_size = 100000000;

        print_test(bmcommand);
        bmresult = benchmark(bmcommand);
///        total_time = get_total_time(bmresult.start_time, bmresults.stop_time);
        print_result(bmcommand, bmresult);
        if(j<=3)
            sleep(1);
        else
            sleep(4);
        }   
       }
#endif
    return 0;
}
#endif