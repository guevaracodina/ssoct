% Reads .CSV file from Altera SignalTap
%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara
% 2012/02/21
filename = 'signal_tap_ramp_ADA_DCO.csv';
pathname = 'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2012_02_17_Ramp\';
% Buffer size for textscan function
BUFFER_SIZE = 2^20;
% Number of rows that contain headers
nHeaders = 9;
% Total number of columns in signaltap generated file (350)
nCols = 305;
textFormat = '%d ';
textFormat = repmat(textFormat,[1 nCols]);
% Columns with Binary data
binCols = [2 17 33 49];

% Read 2nd, 17th, 33rd and 49th columns as a string of binary numbers
% textFormat(3*2-1) = 's';
% textFormat(3*17-1) = 's';
% textFormat(3*33-1) = 's';
% textFormat(3*49-1) = 's';
for iCols=1:numel(binCols)
    textFormat(3*binCols(iCols)-1) = 's';
end

[filename, pathname] = uigetfile({'*.csv', 'Comma Separated Value (*.csv)'},...
    'Pick a .CSV file',fullfile(pathname,filename));
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
    return
else
    C = importdata(fullfile(pathname,filename), ',', nHeaders);
end

% Clear unneeded data
C.data = [];

% Read .csv file as a text file
fid = fopen(fullfile(pathname,filename));
myData = textscan(fid, '%s', 'Delimiter', '\n', 'BufSize', BUFFER_SIZE);
fclose(fid);

% Remove header lines
myData = myData{1,1}(nHeaders+1:end);

% Preallocating memory
myData1 = cell(size(myData,1),nCols);

% Filling up cells
for iLines=1:size(myData,1),
    myData1(iLines,:) = textscan(myData{iLines}, textFormat, 'Delimiter', ',' ,...
        'BufSize', BUFFER_SIZE);
    
%     % Convert 2nd column to decimal number
%     myData1{iLines,2} = int32(base2dec(myData1{iLines,2},2));
%     % Convert 17th column to decimal number
%     myData1{iLines,17} = int32(base2dec(myData1{iLines,17},2));
%     % Convert 33nd column to decimal number
%     myData1{iLines,33} = int32(base2dec(myData1{iLines,33},2));
%     % Convert 49th column to decimal number
%     myData1{iLines,49} = int32(base2dec(myData1{iLines,49},2));

    for iCols=1:numel(binCols)
        myData1{iLines,binCols(iCols)} = int32(base2dec(myData1{iLines,binCols(iCols)},2));
    end
    
end

% Convert cell to matrix
myData = cell2mat(myData1);

% Add a row of zeros
myData = [zeros(1,size(myData,2)); myData];

% Clean up
clear myData1;

t = myData(:,1); % time in ns
trigger50 = myData(:,32); % 50 kHz trigger
address = myData(:,33); % RAM address
% ADC = myData(:,17); % ADC data

% Clean up
clear myData;

% ==============================================================================
% [EOF]
