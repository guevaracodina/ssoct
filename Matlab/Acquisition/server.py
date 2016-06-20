# Server Program

# import socket modules
from socket import *
from ctypes import *
import binascii
import string
import time
import sys

# Set the socket parameters
host = '192.168.1.213'
port = 1739 
addr = (host, port)
reclen = 1468

# Set the packet parameters
PacketNum = 1000   
MBits = 1048576

# Create the socket and bind to address
UDPSock = socket(AF_INET,    # Internet
                 SOCK_DGRAM) # UDP
UDPSock.setsockopt(SOL_SOCKET, SO_RCVBUF, reclen*PacketNum) # set receive buffer size (int value)
UDPSock.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1) # allow resuse of local address
UDPSock.bind((host, port))

# Create a binary file
filename = 'test.dat'
FILE0 = open(filename, 'wb', 0) # in "write & binary" mode

# ================ Receive messages ================= #
data,address = UDPSock.recvfrom(reclen)
t0 = time.time()
for j in range(0, PacketNum):
    data,address = UDPSock.recvfrom(reclen)
    FILE0.write(data)   
t1 = time.time()



# Close socket
UDPSock.close()
# Close file
FILE0.close()

# ================= Post-processing ================= #
# run time
runtime = t1 - t0
speed = float(reclen*8.0*PacketNum)/(runtime*MBits)
print('%d packets complete with the raw-data speed of %f Mbps'\
      % (PacketNum, speed))

# file format conversion
FILE1 = open('test.dat', 'rb');
data_bytes = FILE1.read(reclen*PacketNum)
FILE1.close()
data_string = bytes.decode(binascii.hexlify(data_bytes))
FILE2 = open('test.txt', 'w')
FILE2.write(data_string)
FILE2.close()
print('file complete.')

