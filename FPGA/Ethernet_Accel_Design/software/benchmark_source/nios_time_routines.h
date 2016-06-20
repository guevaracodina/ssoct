#ifndef NIOS_TIME_ROUTINES_H_
#define NIOS_TIME_ROUTINES_H_

#ifndef WORKSTATION

#define settimeofday nios_settimeofday
#define gettimeofday nios_gettimeofday

int nios_settimeofday (const struct timeval  *t,
                       const struct timezone *tz);
                      
int nios_gettimeofday (struct timeval  *ptimeval, 
                       struct timezone *ptimezone);

#endif
#endif /*NIOS_TIME_ROUTINES_H_*/
