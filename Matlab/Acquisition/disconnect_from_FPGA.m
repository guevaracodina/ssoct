function disconnect_from_FPGA
%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara
% 2011/07/11

% Modifies values of global variable
global ssOCTdefaults

% Change timeouts
pnet(ssOCTdefaults.tcpConn,'setreadtimeout',1)
pnet(ssOCTdefaults.tcpConn,'setwritetimeout',1);
   
% Closes a tcpconnection (send first a 'Q\n\r')
pnet(ssOCTdefaults.tcpConn,'write',[uint8(81) uint8(10) uint8(13)]);
% Receive 35+2 characters from FPGA
textReceived = uint8(swapbytes(pnet(ssOCTdefaults.tcpConn,'read',[37 1],'uint8')));
if ~isempty(textReceived)
    disp(char(textReceived'))
end
% pause(0.1);
pnet(ssOCTdefaults.tcpConn,'close')
% Closes all pnet connections/sockets used in this matlab session.
pnet('closeall')

% Kill NIOS terminal
[~,~] = system('taskkill /F /FI "IMAGENAME eq nios2-terminal.exe"'); 
% Kill NIOS task
[~,~] = system('taskkill /F /FI "IMAGENAME eq bash*"');
% Kill Quartus programmer task
[~,~] = system('taskkill /F /FI "IMAGENAME eq quartus_pgm.exe"'); 

fprintf('Connection closed from %s at port %d\n',ssOCTdefaults.serverAddress,ssOCTdefaults.portNumber)

% ==============================================================================
% [EOF]
