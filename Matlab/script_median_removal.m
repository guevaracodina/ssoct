% Clear global data
clear global ssOCTdefaults
% % Load default parameters
ss_oct_get_defaults

%% ------------------------- MODIFY OPTIONS ------------------------------------
global ssOCTdefaults
ssOCTdefaults.resampleData      = false;
ssOCTdefaults.medianRefArm      = false;
ssOCTdefaults.GUI.displayLog        = true;

%% Get finger data
[rawBscan refBscan Bscan hFig] = browseVolume(125,...
    'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2011_11_07_Finger\14_10_36_Test\2011_11_07_14_21_44.dat');

%% Or get 2 tubes phantom
[rawBscan refBscan Bscan hFig] = browseVolume(25,...
    'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2011_11_07_Phantom\17_47_04_2tubes\2011_11_07_17_48_08.dat');

%% Mirror
[rawBscan refBscan Bscan hFig] = browseVolume(1,...
    'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2011_10_31_Mirror\18_26_54_0000um\2011_10_31_18_29_21.dat');
%% Try complex median removal
% Window function
tmpCorrArray = hann(ssOCTdefaults.NSAMPLES);
tmpCorrArray = tmpCorrArray(:,ones(ssOCTdefaults.nLinesPerFrame, 1));

% Apply hann function to B-scan
rawBscan = rawBscan .* tmpCorrArray;

% Get complex data from B-scan
fftBscan = (fftshift(fft(double(rawBscan),[],1),1));

% Get a median reference spectrum in Fourier domain
refAline = median(real(fftBscan),2) + 1j*median(imag(fftBscan),2);
refAline = refAline(:,ones([ssOCTdefaults.nLinesPerFrame 1]));
% Apply hann function to reference
refAline = refAline .* tmpCorrArray;

% Subtract median reference in complex domain
fftBscanCorr = fftBscan - refAline;

% Get structural B-scan
structBscan = abs(fftBscanCorr(ssOCTdefaults.NSAMPLES/2:-1:1,:));

% Convert to dB
noise_lower_fraction = 0.1;
noise_floor = median(...
    median(structBscan(round((1-noise_lower_fraction)*end):end,:)));
structBscan = 10*log10(structBscan / noise_floor);
structBscan(structBscan < 0) = 0;

%% Display figure
imageLimit = 2;                         % +- 4 dB
minColor = min(structBscan(:)) + imageLimit;
maxColor = max(structBscan(:)) - imageLimit;
figure; set(gcf,'color','w')
imagesc(1:ssOCTdefaults.nLinesPerFrame, 1e3*ssOCTdefaults.range.zAxis,...
    structBscan,[minColor maxColor]); colormap(ssOCTdefaults.GUI.OCTcolorMap); colorbar
title('Subtraction of the complex median of each horizontal-line data')
ylabel('z [mm] in tissue')
xlabel('A-lines')
axis tight

