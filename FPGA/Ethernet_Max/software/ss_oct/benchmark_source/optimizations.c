#include "system.h"
#include "ipport.h"
#include "libport.h"
#include "in_utils.h"
#include "osport.h"

#ifdef ALT_INICHE
#include "alt_iniche_dev.h"
#include "sys/alt_cache.h"
#endif

#ifdef UCOS_II
/* If uCOS-II, bring in the needed include files */
#include "includes.h"
#endif

#ifdef ALTERA_MRAM_FOR_PACKETS
#ifndef ALTERA_MRAM_ALLOC_BASE
#error ALTERA_MRAM_ALLOC_BASE must be defined when using ALTERA_MRAM_FOR_PACKETS
#endif

#ifndef ALTERA_MRAM_ALLOC_SPAN
#error ALTERA_MRAM_ALLOC_SPAN must be defined when using ALTERA_MRAM_FOR_PACKETS
#endif

extern OS_EVENT * mheap_sem_ptr;

char *
ncpballoc(unsigned size)
{
static unsigned int next=0;  // offset into memory
char* mem=0;


#ifdef UCOS_II
   INT8U err;
#endif

#ifdef UCOS_II
   OSSemPend(mheap_sem_ptr, 0, &err);
   if(err)
   {
      int errct = 0;

      /* sometimes we get a "timeout" error even though we passed a zero
       * to indicate we'll wait forever. When this happens, try again:
       */
      while(err == 10)
      {
         if(errct++ > 1000)
         {
            panic("npalloc");    /* fatal? */
            return NULL;
         }
         OSSemPend(mheap_sem_ptr, 0, &err);
      }
   }
#endif

   if(size > (ALTERA_MRAM_ALLOC_SPAN - next))
   {   
      panic("out of mem\n");
      return (NULL);       
   }    



#ifdef UCOS_II 
   err = OSSemPost(mheap_sem_ptr);
#endif
   mem = (char *) alt_remap_uncached((char*)(ALTERA_MRAM_ALLOC_BASE + next), size);  
   if(size & 0x3)
   {
      size &= ~0x3;   
      size += 0x4;
   }
   //printf("mram alloc: %u for %d\n", mem, size);
    
   next+=size;    
   MEMSET(mem, 0, size);
   return mem;      
}

int ncpbfree(char *ptr)
{
   panic("MRAM_FREE CALLED --- ERROR");
   dtrap(); 
   return 0;
}

#endif  //ALTERA_MRAM_FOR_PACKETS
