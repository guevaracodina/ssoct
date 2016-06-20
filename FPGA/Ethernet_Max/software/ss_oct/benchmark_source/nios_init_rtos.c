#include "ipport.h"

#ifndef SUPERLOOP  
#include <stdio.h>

/* MicroC/OS-II definitions */
#include "includes.h"

/* Simple Socket Server definitions */
#include "nios_init.h"                                                                    
#include "alt_error_handler.h"

/* Nichestack definitions */
#include "libport.h"
#include "osport.h"


OS_STK    benchmark_initial_task_stack[2048];

/* Definition of task stack for the initial task which will initialize the NicheStack
 * TCP/IP Stack and then initialize the rest of the Simple Socket Server example tasks. 
 */
OS_STK    benchmark_stack[2048];


/* Declarations for creating a task with TK_NEWTASK.  
 * All tasks which use NicheStack (those that use sockets) must be created this way.
 * TK_OBJECT macro creates the static task object used by NicheStack during operation.
 * TK_ENTRY macro corresponds to the entry point, or defined function name, of the task.
 * inet_taskinfo is the structure used by TK_NEWTASK to create the task.
 */


TK_OBJECT(to_benchmark_driver);
TK_ENTRY(benchmark_driver);

struct inet_taskinfo benchmark_task = {
      &to_benchmark_driver,
      "benchmark task",
      benchmark_driver,
      4,
      APP_STACK_SIZE,
};

/* SSSInitialTask will initialize the NicheStack
 * TCP/IP Stack and then initialize the rest of the Simple Socket Server example 
 * RTOS structures and tasks. 
 */
void benchmark_initial_task(void *task_data)
{
  INT8U error_code;
  
  /*
   * Initialize Altera NicheStack TCP/IP Stack - Nios II Edition specific code.
   * NicheStack is initialized from a task, so that RTOS will have started, and 
   * I/O drivers are available.  Two tasks are created:
   *    "Inet main"  task with priority 2
   *    "clock tick" task with priority 3
   */   
  alt_iniche_init();
  netmain(); 

  /* Wait for the network stack to be ready before proceeding. 
   * iniche_net_ready indicates that TCP/IP stack is ready, and IP address is obtained.
   */   
  while (!iniche_net_ready)
    TK_SLEEP(1);

  /* Now that the stack is running, perform the application initialization steps */
  
  /* Application Specific Task Launching Code Block Begin */

  printf("\nBenchmark task starting up\n");

  /* Create the main simple socket server task. */
  TK_NEWTASK(&benchmark_task);
  
  /* Application Specific Task Launching Code Block End */
  
  /*This task is deleted because there is no need for it to run again */
  error_code = OSTaskDel(OS_PRIO_SELF);
  alt_uCOSIIErrorHandler(error_code, 0);
  
  while (1); /* Correct Program Flow should never get here */
}



/* Main creates a single task, SSSInitialTask, and starts task scheduler.
 */

int main (int argc, char* argv[], char* envp[])
{
  
  INT8U error_code;

  /* Clear the RTOS timer */
  OSTimeSet(0);

  /* SSSInitialTask will initialize the NicheStack
   * TCP/IP Stack and then initialize the rest of the Simple Socket Server example 
   * RTOS structures and tasks. 
   */  
  error_code = OSTaskCreateExt(benchmark_initial_task,
                             NULL,
                             (void *)&benchmark_initial_task_stack[TASK_STACKSIZE],
                             SSS_INITIAL_TASK_PRIORITY,
                             SSS_INITIAL_TASK_PRIORITY,
                             benchmark_initial_task_stack,
                             TASK_STACKSIZE,
                             NULL,
                             0);
  alt_uCOSIIErrorHandler(error_code, 0);

  /*
   * As with all MicroC/OS-II designs, once the initial thread(s) and 
   * associated RTOS resources are declared, we start the RTOS. That's it!
   */
  OSStart();

  
  while(1); /* Correct Program Flow never gets here. */

  return -1;
}
#endif //SUPERLOOP

