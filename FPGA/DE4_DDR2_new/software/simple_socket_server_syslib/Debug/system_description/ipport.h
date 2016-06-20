/*
 * Filename: ipport.h (head)
 *
 * Copyright 2007 InterNiche Technologies. All rights reserved.
 *
 * All the platform specific defines for each port go here.
 * All these should be re-examined with each new port of the code.
 *
 * This file for:
 *   ALTERA Cyclone and Stratix Dev boards with the ALTERA Nios2 Core
 *   SMSC91C11 10/100 Ethernet Controller
 *   GNU C Compiler provided by ALTERA Quartus Toolset.
 *   Quartus HAL BSP
 *   uCOS-II RTOS Rel 2.76 (or later) as distributed by Altera/NIOS2
 *
 * 06/21/2004  Created.
 * 12/20/2007  Split into head and tail sections.
 */

#ifndef _IPPORT_H_
#define _IPPORT_H_ 1


 /*
  * Altera Niche Stack Nios port modification:
  * Note about "NOT_USED" nomenclature: Code within #ifdef NOT_USED
  * is presented for illustrative purposes. Options within a NOT_USED
  * block that you wish to enable should be moved out of the NOT_USED
  * block and then allowed to build.
  *
  * Note that the Niche Stack source code makes extensive use of #ifdef
  * rather than #if. Thus, to disable an option, move it into one of the
  * NOT_USED blocks, rather than changing its assigned value to 0.
  */
#ifdef NOT_USED
#error "NOT_USED" should not be defined
 /* Code within these blocks will not be compiled; use to disable options! */
#endif /* NOT_USED */

/* TTYIO.C has redefintions of printf, sprintf. So to resolve declarations,
 * we don't include stdio.h for compiling this file
 */
#ifndef _IN_TTYIO_
#include <stdio.h>   /* C compiler files */
#endif
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "system.h"

/*
 * Altera Niche Stack Nios port modifcation:
 * _POSIX_SOURCE not defined; newlib types.h contains u_int typedef.
 * The following prevents nptypes.h from re-defining u_int.
 */
#define UINT_ALREADY
#include "nptypes.h"   /* NicheStack data types */

/* Options to trade off features for size. Do not enable options 
 * for modules you don't have or your link will get unresolved 
 * externals.
 */

/**** Nios MicroC/OS-II Configuration **************************************/
#define UCOS_II         1  /* Build with uCOS-II RTOS (ver 2.76) */
#define NPDEBUG         1  /* turn on debugging dprintf()s */

#ifdef NOT_USED
#define MINI_IP         1  /* NicheLite API */
#endif /* NOT_USED */

#ifdef OS_TICKS_PER_SEC
    #define TPS            OS_TICKS_PER_SEC  /* cticks per second */
#else
#define TPS            20  /* cticks per second */
#endif

#ifdef NOT_USED
/*
 * Altera Niche Stack Nios port modifcation:
 * Do not build with USE_SMSC91X; Altera's alt_iniche_dev facility,
 * if used with device drivers for Ethernet interfaces supporting
 * Niche Stack, will register initialization routines for each MAC.
 * These are called sequentially at Niche Stack startup
 */
#define USE_SMSC91X     1  /* Build with SMSC LAN 91C111 Drivers */
#endif /* NOT_USED */

#define ALTERA_NIOS2    1  /* Build for the Altera NIOS 2 Cyclone Dev Board */
#define ALT_INICHE      1  /* Altera build */

#ifdef NOT_USED
/*
 * Altera Niche Stack Nios port modifcation:
 * LED/LCD support is design specific. The underlying routines
 * need to be mapped to talk to a device specific to the hardware
 * design Nios is running on. Interniche LCD/LED support will not
 * function unless these are modifed to support your specific design.
 */
#define USE_LCD         0  /* support LCD and LEDs */
#endif /* NOT_USED */

#define NO_INICHE_EXTENSIONS   1   /* NO Interniche Extensions to uC/OS-II */
#define CHRONOS         1  /* Define CHRONOS Macro to hook into uCOS-II RTOS */
#define OS_PREEMPTIVE   1  /* it's a preemptive OS */ 
#define _SDS_CC_        1


/* definitions for the BSD TCP code */
#define LITTLE_ENDIAN 1234
#define BIG_ENDIAN    4321
#define BYTE_ORDER    LITTLE_ENDIAN
 
#define STK_TOPDOWN     1  /* Stacks grow "top down" */
#define ALIGN_TYPE   4  /* 32 bit alignment */

/* define Ethernet header size and offset */
#define ETHHDR_SIZE  (16)
#define ETHHDR_BIAS  (2)

/* Compiler idiosyncracies */

/*
 * define away 16-bit x86 hooks
 */
#define CONST        const

#ifndef FAR
#define FAR
#endif

#define far

#ifndef HUGE
#define HUGE
#endif

#define SOCKERRORS_ALREADY    1  /* uC/OS-II defines common errno() errors */



/**** NicheStack Options **************************************************/

/*
 * Altera Niche Stack Nios port modifcation:
 * The following settings which are commented with "defined in system.h"
 * are generated based on a Nios II IDE (classic build flow) system library
 * settings, or BSP build flow BSP settings, into the system.h file.
 */
#ifdef ALT_INICHE
#include "system.h"

#ifdef NOT_USED
#define DHCP_CLIENT   1   /* include DHCP client code */
#define TCP_ZEROCOPY   1   /* use Sockets zero-copy extensions */
#define IP_FRAGMENTS   1   /* IP fragment reassembly */
#define INCLUDE_TCP   1   /* this link will include NetPort TCP w/MIB */
#define NET_STATS   1   /* include statistics printfs */
#endif /* NOT_USED */
#endif /* ALT_INICHE */

#define INCLUDE_ARP   1   /* use Ethernet ARP */
#define FULL_ICMP   1   /* use all ICMP || ping only */
#define MULTI_HOMED   1   /* more than one net interface */
#define BSD_SOCKETS     1  /* use BSD sockets API */
#define NB_CONNECT   1   /* support Non-Blocking connects (TCP, PPP, et al) */
#define IP_ROUTING   1   /* do real IP routing, not imbedded agent fake route */
#define IP_RAW   1   /* build raw sockets support */
#define IP_MULTICAST   1   /* support IP multicast capability in stack */
#define BLOCKING_APPS   1   /* applications block rather than poll */

/* Options which are disabled by default */
#ifdef NOT_USED

#define DNS_CLIENT   1   /* include DNS client code */
#define BOOTPTAB   1   /* DHCP supports a UNIX-ish bootptab file */
#define BTREE_ROUTES   1   /* Use binary tree IP route lookup */
#define NO_UDP_CKSUM   1   /* omit code for UDP checksums */
#define TCP_ECHOTEST   1   /* include a TCP Echo test */
#define TCP_SACK   1   /* Selective ACK per rfc2018 */
#define TCP_TIMESTAMP      
#define TCP_WIN_SCALE      
#define DNS_CLIENT_UPDT   1   /* Dynamic DNS client */
#define DO_DELAY_ACKS   1   /* TCP ACK piggybacking */
#define DYNAMIC_IFACES   1   /* Support runtime creation of interfaces */
#define IEEE_802_3   1   /* Support IEEE 802.3 (RFC-1042) */
#define IP_PMTU   1   /* path MTU discovery */
#define IP_RAW_ACCESS   1   /* allow direct-receive of IP datagrams */
#define LOSSY_IO   1   /* Do lossy packet IO for testing */
#define RAWIPTEST   1   /* Test for raw sockets */
#define ROUTE_TEST   1   /* Add menu & pseudo device for route metrics */
#define SHARED_IPADDRS   1   /* Add code for one IP address on two ifaces */
#define SUPPORT_SO_FULLMSS   1   /* Socket option for MAXS sized tcp segments */
#define UDP_ECHO_SVR   1   /* built-in UDP Echo server */
#define UDPSTEST   1   /* UDP Echo Sockets test app */
#define USE_IPFILTER   1   /* IP Filtering (RFC-2669) */
#define USE_SLIP   1   /* support SLIP driver iface(s) */
#define HEAPBUFS        1     /* support heap-based buffers */
#define HEAPBUFS_DEBUG  1     /* debug support for heapbufs */

#endif /* NOT_USED */


#ifdef IP_FRAGMENTS
#define MAX_FRAG_PKTS      5  /* max IP pkts we can simultaneously reassemble */
#endif /* IP_FRAGMENTS */

#ifdef DNS_CLIENT
#define MAXDNSSERVERS      3  /* max # of DNS servers to look at */
#endif   /* DNS_CLIENT */

#ifdef IP_MULTICAST
#define ETHMCAST           1   /* convert MAC addr to multicast MAC addr */
#define IGMP_V1            1   /* include IGMPv1 */
#define IGMP_V2            1   /* include IGMPv2 */
#define IP_MULTI_UMCTEST   1   /* include IP multicast test function */
#endif


/**** AllPorts Options *********************************************************/
#define INICHE_TIMERS   1   /* Provide Interval timers */

#ifdef NOT_USED

#define TK_STDIN_DEVICE   1   /* Include stdin (uart) console code */

#endif /* NOT_USED */


/**** MiscLib Options *********************************************************/


#ifdef NOT_USED
#define IN_MENUS   1   /* support for InterNiche menu system */
#define PING_APP   1   /* application provides a pingUpcall */
#define INCLUDE_NVPARMS   1   /* non-volatile (NV) parameters logic */
#define MEM_BLOCKS   1   /* old memory debug system */
#define MEM_WRAPPERS   1   /* include debug wrappers on heap calls */
#define PKT_CYCLES   1   /* Include Code to measure Packet Cycles */
#define HEAP_STATS   1   /* include the heap statistics menu */
#define PFDEBUG   1   /* Enable profiler debug code */
#define RF_SIMULATION   1   /* simulate wireless networks */
#define TESTMENU   1   /* Include special tests in menu */
#define PING_REQ_OUTDEV 1 /* PING stops if console/socket unavailable */

#endif /* NOT_USED */



/**** "net" Options *********************************************************/

#ifdef NOT_USED

#define LOCKNET_CHECKING   1   /* Check protection of net resources */
#define MAC_LOOPBACK   1   /* use MAC layer pseudo-Ethernet loopback driver */
#define QUEUE_CHECKING   1   /* include code to check critical queues */

#endif /* NOT_USED */



/**** AutoIP Options *********************************************************/


#ifdef NOT_USED

#define USE_UPNP   1   /* Universal Plug & Pray */
#define USE_AUTOIP   1   /* Automatic IPv4 address aquisition */

#endif /* NOT_USED */



/**** FTP Options *********************************************************/
#define MAXSENDLOOPS      50  /* MAX number of FTP server send loops */

#ifdef NOT_USED

#define FTP_SERVER         1  /* include FTP server code */
#define FTP_CLIENT         1  /* include FTP client code */
#define DRIVE_LETTERS    1
#define FTP_IDLECONN_TMO 1

#endif /* NOT_USED */


/**** Syslog Options ******************************************************/

#ifdef NOT_USED

#define INICHE_SYSLOG    1  /* support syslog client */
#define USE_SYSLOG_QUEUE 1  /* use queue for syslogs */
#define USE_SYSLOG_TASK  1  /* use task (not timer) for syslogs */

#endif /* NOT_USED */


/**** Telnet Options *********************************************************/

#ifdef NOT_USED

#define TELNET_SVR       1 /* then include this source file */

#endif /* NOT_USED */




/**** TFTP Options *********************************************************/

#ifdef NOT_USED

#define TFTP_CLIENT   1   /* include TFTP client code */
#define TFTP_SERVER   1   /* include TFTP server code */

#endif /* NOT_USED */



/**** VFS Options *********************************************************/
#define VFS_FILES          1  /* include Virtual File System */
#define USE_MEMDEV         1  /* Psuedo VFS files mem and null */

#ifdef NOT_USED

#define VFS_UNITTEST       1  /* Include in VFS test menu */
#define VFS_VERBOSE        1  /* Compile VFS in verbose debug mode */

#endif /* NOT_USED */


/**** Nios MicroC/OS-II Options ********************************************/

#define PRINTF_STDARG      1  /* C compiler supports VARARGS */
#define NATIVE_PRINTF      1  /* use target's printf() function */
#define NO_CC_PACKING      1  /* C compiler can't pack structs */

#ifdef NOT_USED
#define C_CHECKSUM      1     /* C checksum function only */
#endif /* NOT_USED */

#define DELAY_REPLY     1     /* process incoming packets in background loop */

/* Options for setting the MicroC/OS-II priorities and stack sizes
 * for the various tasks used by the stack 
 */

/* task stack sizes */
#define  DEMO_STACK_SIZE      (4096+8192)

#define  NETHEAP_SIZE         0x30000

/* task stack sizes */
#define  NET_STACK_SIZE       (4096+8192)
#define  APP_STACK_SIZE       (6144+8192) /* 4096 */     /* default for applications */
#define  CLOCK_STACK_SIZE     (4096+8192)

#define  IO_STACK_SIZE        (2048+8192)
#define  WEB_STACK_SIZE       (APP_STACK_SIZE+8192)
#define  FTP_STACK_SIZE       APP_STACK_SIZE
#define  PING_STACK_SIZE      (4096+8192)
#define  TN_STACK_SIZE        APP_STACK_SIZE
#define  TCP_ECHO_STACK_SIZE  APP_STACK_SIZE

/* TK_NETMAIN and TK_NETTICK are always used by NicheStack */
/* These priorities must be defined */

/* Note: Niche stack now uses TK_NETMAIN_TPRIO-1 (priority 1) for an 
 * internal mutex. If you wish to run application tasks at a higher priority
 * than Niche stack, all Niche stack task priority assignments must be 
 * adjusted down (to higher interger values).
 */
#define TK_NETMAIN_TPRIO 2
#define TK_NETMAIN_SSIZE NET_STACK_SIZE
#define TK_NETTICK_TPRIO 3
#define TK_NETTICK_SSIZE CLOCK_STACK_SIZE

#define TK_APP_TPRIO 4

#define TK_ECHOTEST_TPRIO 5
#define TK_ECHOTEST_SSIZE TCP_ECHO_STACK_SIZE
#define TK_CIPHERTEST_TPRIO 5
#define TK_CIPHERTEST_SSIZE APP_STACK_SIZE
#define TK_BROWCHECK_TPRIO 5
#define TK_BROWCHECK_SSIZE (APP_STACK_SIZE)*4
#define TK_CUEXECUTION_TPRIO 5
#define	TK_CUEXECUTION_SSIZE APP_STACK_SIZE
#define TK_WEBPORT_TPRIO 5
#define	TK_WEBPORT_SSIZE WEB_STACK_SIZE
#define TK_FTPCLNT_TPRIO 5
#define TK_FTPCLNT_SSIZE FTP_STACK_SIZE
#define TK_EMAILER_TPRIO 5
#define TK_EMAILER_SSIZE APP_STACK_SIZE
#define TK_DNSSRV_TPRIO 5
#define TK_DNSSRV_SSIZE APP_STACK_SIZE
#define TK_IKE_TPRIO 5
#define TK_IKE_SSIZE APP_STACK_SIZE
#define TK_FTPSRVR_TPRIO 6
#define TK_FTPSRVR_SSIZE FTP_STACK_SIZE
#define TK_TELNETSRV_TPRIO 7
#define TK_TELNETSRV_SSIZE APP_STACK_SIZE
#define TK_SNMP_TPRIO 8
#define TK_SNMP_SSIZE APP_STACK_SIZE
#define TK_KEYBOARD_TPRIO 9
#define TK_KEYBOARD_SSIZE IO_STACK_SIZE
#define TK_PINGCHECK_TPRIO 20
#define TK_PINGCHECK_SSIZE PING_STACK_SIZE
#define TK_SNTPC_TPRIO 21
#define TK_SNTPC_SSIZE APP_STACK_SIZE
#define TK_SNTPS_TPRIO 22
#define TK_SNTPS_SSIZE APP_STACK_SIZE
#define TK_SYSLOG_TPRIO 23
#define TK_SYSLOG_SSIZE APP_STACK_SIZE

/* library definitions */

/*   moved to libport.h_h */

#ifdef NATIVE_PRINTF
/*
 * Use native printf from the C library for debug output.
 */
#define dprintf  printf
#define dputchar putchar
#else
/*
** Use UART driver for debug output
*/
#ifdef putchar
#undef putchar
#endif
#define putchar dputchar
#define printf  dprintf
#ifndef _IN_TTYIO_
void dprintf( char *, ... );
#endif
void dputchar( int );
#endif

/* Send startup errors to the right place */
#define initmsg  dprintf

/* net stats printf with redirectable device: */
extern int ns_printf( void * pio, char * format, ... );

/* file system definitions */

#ifdef VFS_FILES
#define HT_EXTDEV      1  /* allow custom file devices (memdev, null, etc.) */
#define HT_RWVFS       1  /* support read/write VFS */
#define VFS_STRIPPATH  1  /* used to strip path from filenames in vfsfiles.c */
#define UNIX_VFS       1  /* make VFS look UNIX-like */

#ifdef NOTDEF   /* unused VFS options */
#define HT_SYNCDEV     1  /* support sync to flash device */
#endif /* NOTDEF */

/* define pesky macros away */
#define vfs_lock()
#define vfs_unlock()
#undef  ferror

/* set up memory device size and offset */
#ifdef USE_MEMDEV
#define MEMDEV_BASE 0x00200000
#define MEMDEV_SIZE 0x00200000
#else
#undef MEMDEV_BASE
#undef MEMDEV_SIZE
#endif

#endif /* VFS_FILES */

/* UART include file for mdmport.h */
#define UART_INCLUDE "../../nios2/uart.h"

extern unsigned long cticks;  /* clock ticks since startup */
void clock_init(void);   /* start clock tick counting; called at init time */
void clock_c(void);      /* undo clock_init (ie: restore ISR vector */

#define CMPTIME(T,C)  (((T)<=(C)) && (((C)-(T))<(60*TPS)))
#define HISTORY(T)    CMPTIME((T),cticks)


/* convert little/big endian - these should be efficient, 
 * inline code or MACROs
 */
#define lswap(x) ((((x >> 24) & 0x000000ff)) | \
		  (((x >>  8) & 0x0000ff00)) | \
		  (((x) & 0x0000ff00) <<  8) | \
		  (((x) & 0x000000ff) << 24))
#define htonl(l) (lswap(l))
#define ntohl(l) (lswap(l))
#define htons(s) ((((s) >> 8) & 0xff) | \
		  (((s) << 8) & 0xff00))
#define ntohs(s) htons(s)


/* Stack supports two methods of protecting its queues and data
 * structs from destructive re-entries by ISRs, multiple tasks, etc. One
 * is to lock a "resource ID" which makes code wait when trying to access
 * a shared resource, the other is a CRITICAL SECTION frame. You should
 * use one or the other, not both. See manual for details.
 */

#include "includes.h"
#include "tk_crnos.h"

#define USE_RESOURCE_LOCKS 1
#define BLOCKING_APPS      1  /* applications block rather than poll */
#define TCPWAKE_ALREADY    1  /* ChronOS has it's own tcp_sleep & tcp_wakeup */
/* use the sleep/wakeup in misclib/netmain.c */
/*#define TCPWAKE_RTOS    1*/

void tcp_sleep(void * event);
void tcp_wakeup(void * event);

/*#define  GLOBWAKE_SZ     200*/

#define OSPORT_H "../nios2/osport.h"

/* resource locking definitions have been moved to h/tk_crnos.h */

#define SYS_SHORT_SLEEP      1

#define YIELD tk_yield

extern char * pre_task_setup(void);
extern char * post_task_setup(void);


/* define the various IP stack block and buffer allocation routines */

char *   npalloc(unsigned size);
void     npfree(void * ptr);

#define RT_ALLOC(size)     npalloc(size)  /* route block alloc */
#define RT_FREE(ptr)       npfree(ptr)
#define NB_ALLOC(size)     npalloc(size)  /* netbuf structure alloc */
#define NB_FREE(ptr)       npfree(ptr)

/*
 * Altera Niche Stack Nios port modification:
 * The triple speed mac driver utilizes a scatter-gather DMA controller to
 * transfer data between Ethernet MAC and Nios system memory. For Nios
 * systems with data cache, all packet data structures must therfore be
 * marked as uncached. The "nc" palloc/pfree routines wrap the default
 * npalloc()/npfree() with Nios II library calls to mark the returned
 * pointers as cache-bypassed.
 */
#ifdef ALTERA_TRIPLE_SPEED_MAC
char * ncpalloc(unsigned size);
void ncpfree(void *ptr);
#define BB_ALLOC(size)     ncpalloc(size)  /* Big packet buffer alloc */
#define BB_FREE(ptr)       ncpfree(ptr)
#define LB_ALLOC(size)     ncpalloc(size)  /* Little packet buffer alloc */
#define LB_FREE(ptr)       ncpfree(ptr)
#else /* Not ALTERA_TRIPLE_SPEED_MAC */
#define BB_ALLOC(size)     npalloc(size)  /* Big packet buffer alloc */
#define BB_FREE(ptr)       npfree(ptr)
#define LB_ALLOC(size)     npalloc(size)  /* Little packet buffer alloc */
#define LB_FREE(ptr)       npfree(ptr)
#endif /* ALTERA_TRIPLE_SPEED_MAC */

#define UC_ALLOC(size)     npalloc(size)  /* UDP connection block alloc */
#define UC_FREE(ptr)       npfree(ptr)
#define TK_ALLOC(size)     npalloc(size)  /* task control block */
#define TK_FREE(ptr)       npfree(ptr)
#define STK_ALLOC(size)    npalloc(size)  /* task stack */
#define STK_FREE(ptr)      npfree(ptr)
#define PMTU_ALLOC(size)   npalloc(size)  /* path MTU cache */
#define PMTU_FREE(ptr)     npfree(ptr)

#ifdef DYNAMIC_IFACES
#define NET_ALLOC(size)    npalloc(size)  /* struct net */
#define NET_FREE(ptr)      npfree(ptr)
#define IFM_ALLOC(size)    npalloc(size)  /* struct IfMib */
#define IFM_FREE(ptr)      npfree(ptr)
#endif   /* DYNAMIC_IFACES */

#define IPR_ALLOC(size)    npalloc(size)  /* IP reassembly block allocation */
#define IPR_FREE(ptr)      npfree(ptr)    /* IP reassembly block deallocation */
#define HB_ALLOC(size)     npalloc(size)  /* allocate block (greater than bigbufsiz) from heap */
#define HB_FREE(ptr)       npfree(ptr)    /* return block (greater than bigbufsiz) to heap */

extern void dtrap( void );

/*
 * Structure packing is achieved using NO_CC_PACKING
 */
#define START_PACKED_STRUCT(sname)    struct sname {
#define END_PACKED_STRUCT(sname)      };

int   prep_ppp(int);    /* in ..\ppp\sys_np.c */
int   prep_ifaces(int firstIface);   /* set up interfaces */

/* 
 * define number and sizes of free packet buffers 
 */
#define NUMBIGBUFS   30
#define NUMLILBUFS   30

/* some maximum packet buffer numbers */
#define MAXBIGPKTS   30
#define MAXLILPKTS   30
#define MAXPACKETS (MAXLILPKTS+MAXBIGPKTS)


/********************* ipport.h_h common ****************************/

#ifndef TRUE
#define TRUE            1
#endif

#ifndef FALSE
#define FALSE           0
#endif

#ifndef NULL
#define NULL            ((void*)0)
#endif

#define PRINTF_STDARG   1     /* C compiler supports VARARGS */

/*
 * Set sizes of large and small packet buffers
 * The web server frequently uses packets of about 160 bytes, so
 * increase the small packet size, rather than use large buffers.
 */
#ifndef BIGBUFSIZE
#define BIGBUFSIZE      1536
#endif
#ifndef LILBUFSIZE
#ifdef WEBPORT
#define LILBUFSIZE      200
#else
#define LILBUFSIZE      128
#endif
#endif

#define COMMSIZE        64    /* max bytes in community string */

#define MAX_NVSTRING   128    /* MAX length of an nvparms string */

/* A portable macro to check whether a ptr is within a certain range.
 * In an environment where selectors are important, this macro will
 * be altered to reflect that.
 */
 
#define IN_RANGE(p1, len1, p2) \
   (((p1) <= (p2)) && (((p1) + (len1)) > (p2)))

/*
 * Use the new FD_xxx() implementation for socket select()
 */
#define USE_FDS            1  /* use Standard C FD_xxx() macros */
 

/* NicheStack error codes: generally full success is 0,
 * definite errors are negative numbers, and indeterminate conditions
 * are positive numbers. These may be changed if they conflict with
 * defines in the target system. They apply to the all NicheStack
 * modules. If you have to change these values, be sure to recompile
 * ALL NicheStack sources.
 */

#define SUCCESS          0 /* whatever the call was, it worked */

/* programming errors */
#define ENP_PARAM      -10 /* bad parameter */
#define ENP_LOGIC      -11 /* sequence of events that shouldn't happen */
#define ENP_NOCIPHER   -12 /* No corresponding cipher found for the cipher id */

/* system errors */
#define ENP_NOMEM      -20 /* malloc or calloc failed */
#define ENP_NOBUFFER   -21 /* ran out of free packets */
#define ENP_RESOURCE   -22 /* ran out of other queue-able resource */
#define SEND_DROPPED   ENP_RESOURCE /* full queue or similar lack of resource */
#define ENP_BAD_STATE  -23 /* TCP layer error */
#define ENP_TIMEOUT    -24 /* TCP layer error */

#define ENP_NOFILE     -25 /* expected file was missing */
#define ENP_FILEIO     -26 /* file IO error */

/* net errors */
#define ENP_SENDERR    -30 /* send to net failed at low layer */
#define ENP_NOARPREP   -31 /* no ARP for a given host */
#define ENP_BAD_HEADER -32 /* bad header at upper layer (for upcalls) */
#define ENP_NO_ROUTE   -33 /* can't find a reasonable next IP hop */
#define ENP_NO_IFACE   -34 /* can't find a reasonable interface */
#define ENP_HARDWARE   -35 /* detected hardware failure */

/* conditions that are not really fatal OR success: */
#define ENP_SEND_PENDING 1 /* packet queued pending an ARP reply */
#define ENP_NOT_MINE     2 /* packet was not of interest (upcall reply) */
#define EHAVEOOB       217 /* out-of-band */
#define EIEIO          227 /* bad input/output on socket */

/* ARP holding packet while awaiting a response from fhost */
#define ARP_WAITING    ENP_SEND_PENDING


/* #define PID port resource IDs */
#define NET_RESID         0     /* stack code resource lock */
#define RXQ_RESID         1     /* received packet queue resource lock */
#define FREEQ_RESID       2     /* free packet queue resource lock */
#define CE_RESID          3     /* crypto-engine resource lock */
#define PINGQ_RESID       4     /* PING client task's message queue lock */
#define FTPCQ_RESID       5     /* FTP  client task's message queue lock */
#define SNTPv4C_RESID     6     /* SNTP */
#define RTP_RESID         7
#define RTPQ_RESID        8
#define RTSPQ_RESID       9
#define RTPANNOUN_RESID   10
#define RTPQHAR_RESID     11
#define WIN_RESID         12
#define RESID_NET         13
#define RESID_FREEQ       14
#define RESID_RCVDQ       15


/* application semaphore identifiers */
#define PING_SEMID   1        /* PING client task */
#define FTPC_SEMID   2        /* FTP client task */
#define TFTP_SEMID   3
#define RTP_SEMID    4
 
/* Functions invoked to wait for or signal the occurence of events significant
 * to the PING client and the FTP client tasks.
 */
void wait_app_sem (unsigned long int semid);
void post_app_sem (unsigned long int semid);


/* Global variables */

extern int iniche_net_ready;

unsigned short cksum(void *, unsigned);

/* macros to get rid of "unused argument" warnings. With compilers that
 * can suppress these warnings, define this to nothing.
 */
#define MUTE_WARNS         1  /* gen extra code to suppress compiler warnings */

#define USE_ARG(x)            { x = x; }
#define USE_VOID(x)           { x = x; }

/* default setups of some sub-options */

/* if any SNMP agent is used, then INCLUDE_SNMP should be enabled */
#if (defined(INCLUDE_SNMPV1)||defined(INCLUDE_SNMPV2C)||defined(INCLUDE_SNMPV3))
#define INCLUDE_SNMP    1  /* update SNMP counters in TCPIP stack */
#endif

#ifdef INCLUDE_SNMP
#if !defined(PREBIND_AGENT) && !defined(SNMP_SOCKETS)
#define PREBIND_AGENT   1   /* hardcode SNMP port into UDP */
#endif
#endif

/*
 * Altera Niche Stack Nios port modifcation:
 * Add friendly pre-processor error check, to prevent
 * cryptic link error
 */
#if (!defined(NET_STATS) && defined(IN_MENUS))
#error NET_STATS must be defined for IN_MENUS
#endif

#if (!defined(USE_CRYPTOENG) && defined(TCP_CIPHERTEST))
#error TCP_CIPHERTEST should not be defined if USE_CRYPTOENG is not used
#endif

#if defined(INCLUDE_SSLAPP) && !defined(ENABLE_SSL)
#error ENABLE_SSL must be defined for INCLUDE_SSLAPP
#endif

#if defined(MINI_IP) && defined(HEAPBUFS)
#error HEAPBUFS are not available in MINI_IP
#endif

#ifdef LB_XOVER
#ifndef MULTI_HOMED
#define MULTI_HOMED 1
#endif
#endif

#ifdef MULTI_HOMED
#ifndef IP_ROUTING
#define IP_ROUTING 1    /* force IP routing on multi-homed compiles */
#endif
#endif

#ifdef INCLUDE_TCP
#ifndef FULL_ICMP
#define FULL_ICMP 1     /* force full ICMP for TCP support */
#endif
#endif

#ifdef MULTI_HOMED
#define STATIC_NETS   4  /* static network interfaces to allow for... */  
#else
#define STATIC_NETS   1
#endif

#ifdef DYNAMIC_IFACES
#define MAXNETS       8  /* max ifaces to support at one time */
#else
#define MAXNETS       STATIC_NETS
#endif

/* number of entries in IP routing table */
#define RT_TABS      16

#ifdef IP_FRAGMENTS
#ifndef MAX_FRAG_PKTS
#define MAX_FRAG_PKTS 5 /* max IP pkts we can simultaneously reassemble */
#endif
#endif

#ifndef ALTERA_NIOS2
#if defined(IN_MENUS) && defined(NATIVE_PRINTF)
#error IN_MENUS do not work with NATIVE_PRINTF.
#endif
#endif


/*
 * temporary workaround for files which do not include libport.h
 */
#ifndef _LIBPORT_H_
#include "libport.h"
#endif

/********************* ipport.h_h common ****************************/

/*
 * Altera Niche Stack Nios port modifications:
 * - Prototypes to remove build warning.
 */
void evtmap_setup(void);
u_char TK_OSTaskQuery(void);

/*
 * Altera Niche Stack Nios port modification:
 * Provide delcaration of timeval struct used in Altera software examples
 */
#ifdef ALT_INICHE
#include <unistd.h>
#include <sys/time.h>
#define BSD_TIMEVAL_T struct timeval
#endif /* ALT_INICHE */

#endif  /* _IPPORT_H_ */


/**** ipport.h_h generated Tue, 22 Jan 2008 15:09:35 -0800 ****/
