% Interpolation script
% SYNTAX:
% 
% INPUTS:
% 
% OUTPUTS:
% 
%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara
% 2011/11/11

%% Reading .CSV file
fileName = 'TEST.csv';
pathName = 'D:\Edgar\ssoct\Matlab\Acquisition\DATA\Interpolation\';
% Buffer size for textscan function
BUFFER_SIZE = 2^16;
% Number of rows that contain headers
nHeaders = 8;
% Total number of columns in signaltap generated file
nCols = 44;
textFormat = '%d ';
textFormat = repmat(textFormat,[1 nCols]);

[fileName, pathName] = uigetfile({'*.csv', 'Comma Separated Value (*.csv)'},...
    'Pick a .CSV file',fullfile(pathName,fileName));
if isequal(fileName,0) || isequal(pathName,0)
    disp('User pressed cancel')
    return
else
    C = importdata(fullfile(pathName,fileName), ',', nHeaders);
end

% Clear unneeded data
C.data = [];

% Read .csv file as a text file
fid = fopen(fullfile(pathName,fileName));
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
end

% Convert cell to matrix
myData = cell2mat(myData1);

% Add a row of zeros
myData = [zeros(1,size(myData,2)); myData];

% Clean up
clear myData1 nCols nHeaders C BUFFER_SIZE fid textFormat iLines 

t           = double(myData(:,1));      % time in ns
trigger50   = double(myData(:,44));     % 50 kHz trigger
address     = double(myData(:,17));     % RAM address
ADC         = double(myData(:,2));      % ADC data
fs          = 125e6;                    % Sampling frequency in Hz

% Clean up
clear myData;

[~, fileName, ~] = fileparts(fileName);
save(fullfile(pathName,[fileName '.mat']),'t','trigger50','address','ADC','fs')

%% Interpolation starts here
clear
load('D:\Edgar\ssoct\Matlab\Acquisition\DATA\Interpolation\varFreq.mat')
addressVar      = address;              clear address;
trigger50Var    = trigger50;            clear trigger50;
ADCVar          = ADC;                  clear ADC;
tVar            = t;                    clear t;
load('D:\Edgar\ssoct\Matlab\Acquisition\DATA\Interpolation\fixedFreq125MHz.mat')

%% Trim signals to full periods
iStart          = 1373;
iEnd            = 128974;
tVar            = tVar                  (iStart:iEnd); 
addressVar      = addressVar            (iStart:iEnd);
ADCVar          = ADCVar                (iStart:iEnd);
trigger50Var    = trigger50Var          (iStart:iEnd);

t               = t                     (iStart:iEnd); 
address         = address               (iStart:iEnd);
ADC             = ADC                   (iStart:iEnd);
trigger50       = trigger50             (iStart:iEnd);

%% Reshape signals
samplesPeriod   = 2502;
nPeriods        = size(t,1) / samplesPeriod;
t               = reshape(t,            [samplesPeriod nPeriods]);
tVar            = reshape(tVar,         [samplesPeriod nPeriods]);
trigger50       = reshape(trigger50,    [samplesPeriod nPeriods]);
trigger50Var    = reshape(trigger50Var, [samplesPeriod nPeriods]);
ADC             = reshape(ADC,          [samplesPeriod nPeriods]);
ADCVar          = reshape(ADCVar,       [samplesPeriod nPeriods]);
address         = reshape(address,      [samplesPeriod nPeriods]);
addressVar      = reshape(addressVar,   [samplesPeriod nPeriods]);

%% Average signals
t               = t(:,1);
tVar            = tVar(:,1);
trigger50       = median(trigger50,     2);
trigger50Var    = median(trigger50Var,  2);
ADC             = median(ADC,           2);
ADCVar          = median(ADCVar,        2);
address         = median(address,       2);
addressVar      = median(addressVar,    2);
save('D:\Edgar\ssoct\Matlab\Acquisition\DATA\Interpolation\interpData',...
    'ADC', 'ADCVar', 'address', 'addressVar', 't', 'tVar', 'trigger50',...
    'trigger50Var', 'fs');
%% Trim and correct spikes
clear; clc; close all
load('D:\Edgar\ssoct\Matlab\Acquisition\DATA\Interpolation\interpData',...
    'address', 'addressVar', 't', 'tVar', 'trigger50', 'trigger50Var', 'fs');
% Trim averaged data
iStart          = 2;
iEnd            = 1171;
t               = t                     (iStart:iEnd) / fs;
address         = address               (iStart:iEnd);

iStart          = 3;
iEnd            = 1130;
tVar            = tVar                  (iStart:iEnd) / fs;
addressVar      = addressVar            (iStart:iEnd);
% Manual corrections
address(1)      = 0;                    % Must be 0
address(257)    = 256;
address(513)    = 512;
address(769)    = 768;
address(1025)   = 1024;
addressVar(1)   = 0;                    % Must be 0

% Save data
save('D:\Edgar\ssoct\Matlab\Acquisition\DATA\Interpolation\kSpace',...
    'address', 'addressVar', 't', 'tVar', 'fs');

%% Load data to construct k-space sampling
% Clear global data
clear global ssOCTdefaults
% Load default parameters
ss_oct_get_defaults
global ssOCTdefaults
clear
load('D:\Edgar\ssoct\Matlab\Acquisition\DATA\Interpolation\kSpace',...
    'address', 'addressVar', 't', 'tVar', 'fs');

% Use a spline function to interpolate at higher rate
% nRate = 4;
% tVarInterp = interp(tVar, nRate);
% addressVarInterp = spline(tVar, addressVar, tVarInterp);

%% Smooth the interpolated function
filter_order = 4;
% Butterworth filter
[b,a] = butter(filter_order,0.1,'low');
addressVarInterp = filter(b,a,addressVar);
% Manual correction
addressVarInterp(2) = mean(addressVarInterp([1 3]));

% Go back to original rate
% addressVarInterp = decimate(addressVarInterp, nRate);
plot(addressVarInterp)
kClockSampling = addressVarInterp;
save('D:\Edgar\ssoct\Matlab\Acquisition\DATA\Interpolation\kSpaceFilt',...
'kClockSampling');

% first up-sampling the data using an FFT, zero padding and then performing
% IFFT. Usually two to four times up-sampling is sufficient for this application
% ssOCTdefaults.NSAMPLES = numel(tVar);
% ssOCTdefaults.nSamplesFFT = 2^nextpow2(2*ssOCTdefaults.NSAMPLES);
% tVarFFT = fftshift(fft(tVar,[],1),1);
% tVarFFT = padarray(tVarFFT, [(ssOCTdefaults.nSamplesFFT - ssOCTdefaults.NSAMPLES)/2 0]);
% tVarInterp = real(ifft(ifftshift(tVarFFT.*hann(ssOCTdefaults.nSamplesFFT),1),ssOCTdefaults.NSAMPLES,1));

%% Verify interpolation
clear global ssOCTdefaults
clear
% Load default parameters
ss_oct_get_defaults
global ssOCTdefaults
[rawBscan refBscan Bscan hFig] = browseVolume(6,...
    'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2011_11_12_Mirror\20_56_41_newTest1128\2011_11_12_20_57_42.dat');
%% Resampling comparison
% ssOCTdefaults.NSAMPLES = 1128;
B = median(squeeze(rawBscan(:,:,6)),2);
B = B(1:ssOCTdefaults.NSAMPLES);
resB = resample_B_scan(B);
r = median(refBscan,2);
r = r(1:ssOCTdefaults.NSAMPLES);
resr = resample_B_scan(r);
figure;
plot(1:ssOCTdefaults.NSAMPLES,B-r,'k-',1:ssOCTdefaults.NSAMPLES,resB-resr,'r-')
legend({'fixed' 'resampled'})

%% Spectrograms
window      = 128;
noverlap    = 120;
nfft        = 128;
figure
spectrogram(B-r, window, noverlap, nfft);
set(gcf,'Name','Data sampled @125 MHz')
figure
spectrogram(resB-resr, window, noverlap, nfft);
set(gcf,'Name','Data resampled in k-space')

% ==============================================================================
% [EOF]

