% MATLAB example using TCP/IP (matlab_tcpip_example.m)
% This simple code example demonstrates how you can use MATLAB to exchange data 
% with a remote application not developed in MATLAB. This code example is taken
% from a MATLAB Digest technical article written by Edward J. Mayhew from 
% George Mason University.  While HTTP was used as the higher-level protocol in 
% this example, you can use other protocols, as was the case in the project. 
% MATLAB supports TCP/IP using Instrument Control Toolbox.  Requires MATLAB and 
% Instrument Control Toolbox.  
%
% On line 14, substitute "www.EXAMPLE_WEBSITE.com" with an actual website with
% which you wish to communicate.

clc                                     % Clear scren
command = 's';

% Server machine (FPGA)
serverAddress = '192.168.1.234';
portNumber = 30;

% Create TCP/IP object 'TCP_IP_object'. Specify server machine and port number. 
TCP_IP_object = tcpip(serverAddress, portNumber); 

% Set size of receiving buffer, if needed. 
set(TCP_IP_object, 'InputBufferSize', 2^16); 

% Open connection to the server. 
fopen(TCP_IP_object); 

% Read Welcome message (8 lines)
for i=1:9,
	disp(fscanf(TCP_IP_object))
end

% Pause for the communication delay, if needed. 
pause(0.5)

% while 

fprintf('DataReceived = \n')
while (get(TCP_IP_object, 'BytesAvailable') > 0) && ~strcmp(command,'q')              % quits if command equals 'q'
    command = input('Enter Command: ','s');
%     command = getkey;                   % Open hidden window (sort of getche())
    % Transmit data to the server (or a request for data from the server). 
    fprintf(TCP_IP_object, num2str(command)); 
    disp(fscanf(TCP_IP_object))
    pause(0.125)
end

% Closed connection from the FPGA
% fprintf(TCP_IP_object, 'q'); 

% Disconnect and clean up the server connection. 
fclose(TCP_IP_object); 

% Deletes object TCP_IP_object
delete(TCP_IP_object); 
clear TCP_IP_object 
fprintf('Connection successfully closed\n')

% ==============================================================================
% [EOF]
