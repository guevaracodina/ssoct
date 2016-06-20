defs = -D=WORKSTATION
ipath = ../benchmark_source
cpath = ../benchmark_source
commonf = benchmark.c \
		tcp_receiver.c \
		tcp_sender.c \
		udp_receiver.c \
		udp_sender.c \
		common.c \
		benchmark_console.c 

workstation = workstation_benchmark_driver.c
objlist= $(commonf:.c=.o) $(workstation:.c=.o)
#objlist= $(commonf) $(workstation)


bm: $(objlist) 
	gcc $(objlist) -o ./$@
	rm -rf *.o

$(commonf:.c=.o): 
	gcc -c -I $(ipath) $(defs) $(cpath)/$(@:.o=.c) -o ./$@

$(workstation:.c=.o): 
	gcc -c -I $(ipath) $(defs) $(@:.o=.c) -o ./$@

clean:
	@rm -rf *.o
	@rm -rf *.exe
