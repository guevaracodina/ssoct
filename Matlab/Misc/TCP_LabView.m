%% Create TCP object
rport = 30;
obj = tcpip('127.0.0.1',rport);

% Set buffer size
obj.InputBufferSize = 2^20;

% Connect the TCPIP object to the host.
fopen(obj);

% byte3 = uint32(A(1));
% byte3 = bitshift(byte3,24);
% byte2 = uint32(A(2));
% byte2 = bitshift(byte2,16);
% byte1 = uint32(A(3));
% byte1 = bitshift(byte1,8);
% byte0 = uint32(A(4));
%
% nPoints = bitor(byte3, byte2);
% nPoints = bitor(nPoints, byte1);
% nPoints = bitor(nPoints, byte0);

%% Read the data and plot
nCols = 100;
for iCols = 1:nCols,
    % Read 4 bytes from the host
    nPoints = fread(obj, 1, 'uint32');
    nPoints = bitshift(nPoints,-3);
    fprintf('Loop: %d, # of points: %d\n', iCols, nPoints)
    if iCols == 1,
        % Initialize data
        data = zeros([nPoints nCols]);
    end
    data(:,iCols) = fread(obj, nPoints, 'double');
    plot(data(:,iCols));
end

%% Write 'Q' to the host
fwrite(obj,'Q')

%% Close connection
fclose(obj);
