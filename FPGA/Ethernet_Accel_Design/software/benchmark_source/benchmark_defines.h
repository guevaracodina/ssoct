#ifndef BENCHMARK_DEFINES_H_
#define BENCHMARK_DEFINES_H_

struct result_def  
tcp_receiver_plain
(unsigned short port, 
char * buff, 
int bsize, 
int (* callback)(void));

struct result_def 
tcp_sender_plain
(unsigned long  ip, 
unsigned short port, 
char *buff,
int bsize,
int dsize,
int (* callback)(void));

struct result_def 
udp_sender_plain
(unsigned long  ip, 
unsigned short port, 
char *buff,
int bsize,
int dsize,
int (* callback)(void));

struct result_def 
udp_receiver_plain
(unsigned short port, 
char * buff, 
int bsize, 
int (* callback)(void));

struct result_def  
tcp_receiver
(struct internal_command_def *command);

struct result_def 
tcp_sender
(struct internal_command_def *command);

struct result_def 
udp_sender
(struct internal_command_def *command);

struct result_def 
udp_receiver
(struct internal_command_def *command);



#endif /*BENCHMARK_DEFINES_H_*/
