
#ifndef WORKSTATION
#include <sys/time.h>
#include <sys/times.h>
#include <errno.h>

#include "sys/alt_alarm.h"
#include "alt_types.h"
#include "os/alt_syscall.h"
#include "sys/alt_errno.h"

/*
 * Macro defining the number of micoseconds in a second.
 */

#define ALT_US (1000000)
alt_u32 reset_ticks=0;
/*
 * "alt_timezone" and "alt_resettime" are the values of the the reset time and
 * time zone set through the last call to settimeofday(). By default they are
 * zero initialised.
 */

extern struct timezone alt_timezone;
extern struct timeval  alt_resettime;

/*
 * gettimeofday() can be called to obtain a time structure which indicates the
 * current "wall clock" time. This is calculated using the elapsed number of
 * system clock ticks, and the value of "alt_resettime" and "alt_timezone" set
 * through the last call to settimeofday().  
 *
 * Warning: if this function is called concurrently with a call to 
 * settimeofday(), the value returned by gettimeofday() will be unreliable. 
 *
 * ALT_GETTIMEOFDAY is mapped onto the gettimeofday() system call in 
 * alt_syscall.h
 */
 
int nios_gettimeofday (struct timeval  *ptimeval, struct timezone *ptimezone)
{
  alt_u32 nticks = alt_nticks (); 
  alt_u32 tick_rate = alt_ticks_per_second ();
  
  /* 
   * Check to see if the system clock is running. This is indicated by a 
   * non-zero system clock rate. If the system clock is not running, an error
   * is generated and the contents of "ptimeval" and "ptimezone" are not
   * updated.
   */

//  printf("snapshot_ticks: %u\n", nticks);

  if (tick_rate)
  {
    ptimeval->tv_sec  = alt_resettime.tv_sec  + (nticks-reset_ticks)/tick_rate;
    ptimeval->tv_usec = alt_resettime.tv_usec + 
      ((((nticks-reset_ticks) * ALT_US)/tick_rate)%ALT_US);
 
    if (ptimezone)
    { 
      ptimezone->tz_minuteswest = alt_timezone.tz_minuteswest;
      ptimezone->tz_dsttime     = alt_timezone.tz_dsttime;
    }

    return 0;
  }

  return -ENOTSUP;
}

/******************************************************************************
*                                                                             *
* THIS IS A LIBRARY READ-ONLY SOURCE FILE. DO NOT EDIT IT DIRECTLY.           *
*                                                                             *
* Overriding HAL Functions                                                    *
*                                                                             *
* To provide your own implementation of a HAL function, include the file in   *
* your Nios II IDE application project. When building the executable, the     *
* Nios II IDE finds your function first, and uses it in place of the HAL      *
* version.                                                                    *
*                                                                             *
******************************************************************************/



/*
 * Macro defining the number of micoseconds in a second.
 */

#define ALT_US (1000000)


/*
 * settimeofday() can be called to calibrate the system clock, so that 
 * subsequent calls to gettimeofday() will return the elapsed "wall clock" 
 * time.
 *
 * This is done by updating the global structures "alt_resettime" and 
 * "alt_timezone" so that an immediate call to gettimeofday() would return
 * the value specified by "t" and "tz". 
 *
 * Warning: if this function is called concurrently with a call to 
 * gettimeofday(), the value returned by gettimeofday() will be unreliable.  
 *
 * ALT_SETTIMEOFDAY is mapped onto the settimeofday() system call in 
 * alt_syscall.h
 */


 
int nios_settimeofday (const struct timeval  *t,
                      const struct timezone *tz)
{
  alt_u32 nticks    = alt_nticks ();
  alt_u32 tick_rate = alt_ticks_per_second ();
  reset_ticks = nticks;

//  printf("reset_ticks: %u\n", reset_ticks);
  /* If there is a system clock available, update the current time */

  if (tick_rate)
  {
    alt_resettime.tv_sec  = t->tv_sec;
    alt_resettime.tv_usec = t->tv_usec;

    alt_timezone.tz_minuteswest = tz->tz_minuteswest;
    alt_timezone.tz_dsttime     = tz->tz_dsttime;
    
    return 0;
  }
  
  /* There's no system clock available */

  ALT_ERRNO = ENOSYS;
  return -1;
}

#endif // #ifndef WORKSTATION

