#include "ipport.h"
#include <fcntl.h>

#ifdef SUPERLOOP
#include <stdio.h>
#include "sys/alt_alarm.h"
#include "alt_types.h"

#include "nosport.h"
/* Simple Socket Server definitions */
#include "nios_init.h"   
                                                                 

/* Nichestack definitions */

#include "libport.h"

void
tk_yield(void)
{
   packet_check();   /* see if there's a newly received network packet */
   inet_timer();     /* standard polls and timeouts */
#ifdef IN_MENUS
   kbdio();          /* process user keys */
#endif
#ifdef WEBPORT
   http_check();     /* spin http server */
#endif
#ifdef SMTP_ALERTS
   smtpalert_task(); /* spin email alerter... */
#endif
#ifdef FTP_SERVER
   ftps_check();     /* spin FTP server */
#endif
#ifdef FTP_CLIENT
   fc_check();       /* spin FTP client */
#endif
#ifdef UDPSTEST
   udp_echo_poll();
#endif
#ifdef TCP_ECHOTEST
   tcp_echo_poll();
#endif
#ifdef SNMP_SOCKETS
   snmp_check();
#endif
#ifdef USE_SLIP
   uart_check();
#endif
#ifdef INCLUDE_SNMPV3
   v3_check();
#endif 
#ifdef TELNET_SVR
   tel_check();
#endif 
//  benchmark_driver();
}

unsigned long cticks;
static alt_alarm alarm;
int netmain_init_done=0;

#if 1
alt_u32 SplTimeTick(void * context)
{
   cticks++;
//   if((netmain_init_done==1) && (cticks%5 == 0))
//    printf("x/n");
//    tk_yield();
}

void set_SplTimeTick(void)
{
   int systps = alt_ticks_per_second(); 
   int ratio = 0;
   cticks=0;
   
   ratio = systps/TPS;

/*   nticks = 100; // sysTPS; */
/*   nticks = sysTPS/TPS;   */

   if (alt_alarm_start(&alarm, 2, SplTimeTick, NULL) < 0)
   {
      dprintf("No system clock available\n");
      dtrap();
   }

}

#endif

/* Main creates a single task, SSSInitialTask, and starts task scheduler.
 */

int main (int argc, char* argv[], char* envp[])
{
    
  int e = 0;
  int count =0;
  // go ahead and init the clock
  set_SplTimeTick();
  
//  alt_iniche_init();
  pre_task_setup();
  e = prep_modules();
  
  if(e != 0)
  {
    printf("Module initialization failed\n");   
  }
  netmain_init(); 
    netmain_init_done=1;

  /* Wait for the network stack to be ready before proceeding. 
   * iniche_net_ready indicates that TCP/IP stack is ready, and IP address is obtained.
   */
  //while (!iniche_net_ready){};  <--- no need to call this as this is only for threading
  
  //printf("NicheStack Initialized\n");

  fcntl(0, F_SETFL, O_NONBLOCK);  
  while(1)
//      tk_yield();
    benchmark_driver();
  return -1;
}
#endif //SUPERLOOP

