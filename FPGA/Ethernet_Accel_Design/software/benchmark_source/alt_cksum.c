/* FUNCTION: alt_cksum
 * 
 * Internet checksum function for Altera
 * 
 * PARAM1: ptr          pointer to data buffer (16-bit aligned)
 * PARAM2: count        number of 16-bit elements to accumulate
 * 
 * RETURN: cksum        unsigned, 16-bit checksum value
 *
 * NOTE:  Use the connection pragma to specify the memory(s) containing the
 *        data used in the checksum.  This will only connect the Avalon
 *        master "addr" to the memory specified.  If the data can reside
 *        in multiple memories add new connection pragma statments for
 *        each memory that will potentially contain data.
 */


#pragma altera_accelerate connect_variable alt_cksum/addr to ext_ssram_bus
#pragma altera_accelerate connect_variable alt_cksum/addr to packet_memory/s1
//#pragma altera_accelerate connect_variable alt_cksum/addr to ddr_sdram_0

unsigned short alt_cksum(void * ptr, int count)
{
   void * addr = ptr;
   unsigned long sum = 0;
   unsigned long temp_data;

   /* Compute Internet Checksum for "count" byte      
    * beginning at location "addr".
    * This loop will become a DMA engine capable of
    * one 16-bit read + accumulate per clock cycle
    */
   while (count > 1) 
   {
      /*  This is the inner loop */
      temp_data = *(unsigned long *)addr;
      sum += ((temp_data >> 16) & 0xFFFF) + (temp_data & 0xFFFF);
      count -= 2; /* advancing two half words at a time */
      addr += 4;  /* advancing four bytes at a time */
   }

   /* read in the last half word if the data didn't end on a word boundary */
   sum += (count == 1)? *(unsigned short *)addr : 0;

   /*  Fold 32-bit sum to 16 bits */
   /*  2nd fold occurs in the return value */
   sum = (sum & 0xffff) + (sum >> 16);

#ifdef NOT_INTERNICHE
      /* InterNiche TCP/IP expects to do the final 1s complement
       * of the checksum, so don't do that here
       */
      return ((unsigned short)~((sum & 0xffff) + (sum >> 16)));
#else
      return ((unsigned short)((sum & 0xffff) + (sum >> 16)));
#endif

}

