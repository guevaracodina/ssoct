#ifndef NIOS_INIT_H_
#define NIOS_INIT_H_

/* 
 * The IP, gateway, and subnet mask address below are used as a last resort if 
 * if no network settings can be found, and DHCP (if enabled) fails. You can
 * edit these as a quick-and-dirty way of changing network settings if desired.
 * 
 * Default fall-back address:
 *           IP: 192.168.1.234
 *      Gateway: 192.168.1.1
 *  Subnet Mask: 255.255.255.0
 */
//#define IPADDR0   192
//#define IPADDR1   168
//#define IPADDR2   0
//#define IPADDR3   50     //howard may7

//#define IPADDR0   137      //howard may7
//#define IPADDR1   57
//#define IPADDR2   235
//#define IPADDR3   80
//
//#define GWADDR0   192
//#define GWADDR1   168
//#define GWADDR2   0
//#define GWADDR3   1
//
//#define MSKADDR0  255
//#define MSKADDR1  255
//#define MSKADDR2  255
//#define MSKADDR3  0

/* 
 * The IP, gateway, and subnet mask address below are used as a last resort
 * if no network settings can be found, and DHCP (if enabled) fails. You can
 * edit these as a quick-and-dirty way of changing network settings if desired.
 * 
 * Default IP addresses are set to all zeros so that DHCP server packets will
 * penetrate secure routers.  If DHCP will not be used, select valid static
 * IP addresses here, for example:
 *           IP: 192.168.1.234
 *      Gateway: 192.168.1.1
 *  Subnet Mask: 255.255.255.0
 */
#define IPADDR0   192
#define IPADDR1   168
#define IPADDR2   1
#define IPADDR3   234

#define GWADDR0   192
#define GWADDR1   168
#define GWADDR2   1
#define GWADDR3   1

#define MSKADDR0  255
#define MSKADDR1  255
#define MSKADDR2  255
#define MSKADDR3  0

/* Definition of Task Stack size for tasks not using Nichestack */
#define TASK_STACKSIZE       2048
#define SSS_INITIAL_TASK_PRIORITY               5



#endif /*NIOS_INIT_H_*/
