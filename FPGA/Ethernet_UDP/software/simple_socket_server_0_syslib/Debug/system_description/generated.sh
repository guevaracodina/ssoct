#!/bin/sh
#
# generated.sh - shell script fragment - not very useful on its own
#
# Machine generated for a CPU named "cpu" as defined in:
# h:\Project\Ethernet\software\simple_socket_server_0_syslib\..\..\std_2s60.ptf
#
# Generated: 2009-12-07 21:07:11.859

# DO NOT MODIFY THIS FILE
#
#   Changing this file will have subtle consequences
#   which will almost certainly lead to a nonfunctioning
#   system. If you do modify this file, be aware that your
#   changes will be overwritten and lost when this file
#   is generated again.
#
# DO NOT MODIFY THIS FILE

# This variable indicates where the PTF file for this design is located
ptf=h:\Project\Ethernet\software\simple_socket_server_0_syslib\..\..\std_2s60.ptf

# This variable indicates whether there is a CPU debug core
nios2_debug_core=yes

# This variable indicates how to connect to the CPU debug core
nios2_instance=0

# This variable indicates the CPU module name
nios2_cpu_name=cpu

# These variables indicate what the System ID peripheral should hold
sidp=0x02131888
id=991051294u
timestamp=1260225362u

# Include operating system specific parameters, if they are supplied.

if test -f /cygdrive/c/altera/quartus80/nios2eds/components/micrium_uc_osii/build/os.sh ; then
   . /cygdrive/c/altera/quartus80/nios2eds/components/micrium_uc_osii/build/os.sh
fi
