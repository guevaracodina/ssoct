#ifndef BENCHMARK_H_
#define BENCHMARK_H_

// files using this header must include the following
// header files:
#define BMTRUE 1
#define BMFALSE 0


// "mode" field
enum {
    UNK_MODE,
    SENDER,
    RECEIVER   
};

// "protocol" field
enum {
    UNK_PROT,
    UDP,
    TCP    
};


// this command structure is used by the benchmark console to 
// populate values
struct command_def {
  int mode;
  int protocol;  
  int buffer_size;
  int port_number;
  int total_data_size;
  char ip_address[64];  
  int repeat;
};

// this command structure is used by the benchmark console to 
// populate values
struct internal_command_def {
  unsigned long  ip;
  unsigned short port;
  int bsize;
  int dsize;
  char *buff;
  int (* callback)(void);
};

struct result_def {
  int success;
  struct timeval start_time;
  struct timeval stop_time;
  int total_packets;
  int total_bytes;
  int curr_time;
  int last_packet_bytes;
};

struct result_def benchmark(struct command_def the_command);
void print_result(struct command_def command, struct result_def results);
void print_test(struct command_def command);
int bmcommand_from_console(int nargc, char *nargv[], struct command_def *command);
float get_total_time(const struct timeval start_time, const struct timeval stop_time);
float data_rate(const float total_time, const float total_bytes);

#endif /*BENCHMARK_H_*/
