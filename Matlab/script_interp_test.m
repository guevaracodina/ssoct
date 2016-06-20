%% tempMirrorCharScript
% Clear global data
clear global ssOCTdefaults
% Load default parameters
ss_oct_get_defaults
% Access global variable
global ssOCTdefaults
ssOCTdefaults.resampleData = false;
dirExp = 'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2011_11_11_Mirror\17_34_56_interpTest';
mappedFile = readOCTmapFile(fullfile(dirExp,'2011_11_11_17_38_25.dat'));
load(fullfile(dirExp,'Reference_Measurements.mat'));
clear refArm sampleArm

%% Synthetic signal
fs          = 125E6;                    % Sampling frequency = 125 MHz
% 1128 samples time vector
t = 0:(1/fs):(ssOCTdefaults.NSAMPLES-1)/fs;
% phase offset
phi = pi/10;
% sinus frequency
f = 2.52e6;
% DC offset
dcOffset = 2^13;
% Sinus amplitude
A = 0.75*2^13;
% Column vector synthetic A-line
synthAline = dcOffset + A*sin(2*pi*f*t + phi)';
% Synthetic B-scan
synthBscan = synthAline(:,ones([size(rawBscanRef,2) 1]));

% -------------------- Interpolation and resampling ----------------------------
rawBscan = double(squeeze(mappedFile.Data.rawData(:,:,end-1)));
% If true take reference signal as the complex median of B-scan. Works only with
% tissue / multiple scatterers (i.e. Not a mirror)
ssOCTdefaults.medianRefArm = false;
% Type of window to test
win = @myhann;
% Update reference A-line
ssOCTdefaults.refArm    = median(rawBscanRef,2);
correctedBscan          = correct_B_scan(rawBscan,win,'sub');
% Resample acquired data
resampledRawBscan       = resample_B_scan(rawBscan);
resampledRawBscanRef    = resample_B_scan(rawBscanRef);
% Update reference A-line
ssOCTdefaults.refArm    = median(resampledRawBscanRef,2);
resampledCorrectedBscan = correct_B_scan(resampledRawBscan,win,'sub');
% Update synthetic reference measurement
ssOCTdefaults.refArm    = dcOffset(ones([ssOCTdefaults.NSAMPLES 1]), 1);
synthBscan              = correct_B_scan(synthBscan,win,'sub');


%% Figures of interferograms
figure; set(gcf,'color','w')
set(gcf,'name',sprintf('Window: %s.',func2str(win)))
subplot(241)
imagesc(rawBscanRef,[0 2^14]); 
colormap(ssOCTdefaults.GUI.OCTcolorMap); colorbar; title('Reference B-scan')
subplot(242)
imagesc(rawBscan,[0 2^14]); 
colormap(ssOCTdefaults.GUI.OCTcolorMap); colorbar; title('Raw B-scan')
subplot(243)
imagesc(correctedBscan,[-2^13 2^13]); 
colormap(ssOCTdefaults.GUI.OCTcolorMap); colorbar; title('Corrected B-scan')
subplot(245)
imagesc(resampledRawBscanRef,[0 2^14]); 
colormap(ssOCTdefaults.GUI.OCTcolorMap); colorbar; title('Resampled Reference B-scan')
subplot(246)
imagesc(resampledRawBscan,[0 2^14]); 
colormap(ssOCTdefaults.GUI.OCTcolorMap); colorbar; title('Resampled B-scan')
subplot(247)
imagesc(resampledCorrectedBscan,[-2^13 2^13]); 
colormap(ssOCTdefaults.GUI.OCTcolorMap); colorbar; title('Resampled Corrected B-scan')
subplot(248)
imagesc(synthBscan,[-2^13 2^13]); 
colormap(ssOCTdefaults.GUI.OCTcolorMap); colorbar; title('Synthetic B-scan')

% figure; 
% subplot(131); plot(correctedBscan(:,ssOCTdefaults.nLinesPerFrame/2))
% axis tight; title('Non-resampled A-line')
% subplot(132); plot(resampledCorrectedBscan(:,ssOCTdefaults.nLinesPerFrame/2))
% axis tight; title('Resampled A-line')
% subplot(133); plot(synthBscan(:,ssOCTdefaults.nLinesPerFrame/2))
% axis tight; title('Synthetic A-line')

% ----------- Comparison between interpolated vs. non-interpolated -------------
figure; 
subplot(211)
plot(1e9*ssOCTdefaults.range.vectorLambda,median(rawBscan,2),'k-',...
   1e9* ssOCTdefaults.range.vectorLambda,median(resampledRawBscan,2),'r:'); 
legend('Original Interferogram','Resampled Interferogram'); set(gcf,'color','w')
xlabel('\lambda [nm]')
% Comparison between interpolated vs. synthetic
subplot(212)
plot(1e9*ssOCTdefaults.range.vectorLambda,synthAline,'b-',...
   1e9* ssOCTdefaults.range.vectorLambda,median(resampledRawBscan,2),'r:'); 
legend('Synthetic Interferogram','Resampled Interferogram'); set(gcf,'color','w')
xlabel('\lambda [nm]')

% -------------- Spectrogram of non-interpolated vs. interpolated --------------
figure;
windowSize  = 128;
nOverlap    = 120;
nFFT        = 128;
fs          = 125E6;
spectrogram(correctedBscan(:,size(correctedBscan,2)/2),windowSize,nOverlap,nFFT,fs);
title('non interpolated A-line')
figure;
spectrogram(resampledCorrectedBscan(:,size(resampledCorrectedBscan,2)/2),...
    windowSize,nOverlap,nFFT,fs);
title('interpolated A-line')
figure;
spectrogram(synthAline, windowSize,nOverlap,nFFT,fs);
title('synthetic A-line')
tilefigs

%% Structural data
% Linear display
ssOCTdefaults.GUI.displayLog        = false;
% B-scan
struct2D            = abs(Bscan2FFT(correctedBscan));
resampledStruct2D   = abs(Bscan2FFT(resampledCorrectedBscan));
synthStruct2D       = abs(Bscan2FFT(synthBscan));

%  A-line obtained from average along the rows [nSamplesFFT 1]
% Aline               = abs(Bscan2FFT(median(correctedBscan,2)));
% resampledAline      = abs(Bscan2FFT(median(resampledCorrectedBscan,2)));
% synthAlinefft       = abs(Bscan2FFT(median(synthBscan,2)));

Aline               = struct2D(:,ssOCTdefaults.nLinesPerFrame/2 + 1);
resampledAline      = resampledStruct2D(:,ssOCTdefaults.nLinesPerFrame/2 + 1);
synthAlinefft       = synthStruct2D(:,ssOCTdefaults.nLinesPerFrame/2 + 1);
 

% Normalize maximum peak to 1
Aline               = Aline ./ max(Aline);
resampledAline      = resampledAline ./ max(resampledAline);
synthAlinefft       = synthAlinefft ./ max(synthAlinefft);

% Separate left and right part of the spectrum
AlineRight          = Aline(ssOCTdefaults.nSamplesFFT/2 + 1 :ssOCTdefaults.nSamplesFFT);
AlineLeft           = Aline (ssOCTdefaults.nSamplesFFT/2 :-1 :1);
resampledAlineRight = resampledAline(ssOCTdefaults.nSamplesFFT/2 + 1 :ssOCTdefaults.nSamplesFFT);
resampledAlineLeft  = resampledAline (ssOCTdefaults.nSamplesFFT/2 :-1 :1);
synthAlinefftRight  = synthAlinefft(ssOCTdefaults.nSamplesFFT/2 + 1 :ssOCTdefaults.nSamplesFFT);
synthAlinefftLeft   = synthAlinefft (ssOCTdefaults.nSamplesFFT/2 :-1 :1);

% ---------------------- Figures and FWHM computation --------------------------
figure; set(gcf,'color','w');
set(gcf,'name',sprintf('Window: %s. FFT points: %d',func2str(win),ssOCTdefaults.nSamplesFFT))
plot(   1:ssOCTdefaults.nSamplesFFT,    Aline,          'k-',...
        1:ssOCTdefaults.nSamplesFFT,    resampledAline, 'r:',...
        1:ssOCTdefaults.nSamplesFFT,    synthAlinefft,  'b--'); 
legend('Original A-line','Resampled A-line','Synthetic A-line'); 

figure; set(gcf,'color','w')
set(gcf,'name',sprintf('Window: %s. FFT points: %d',func2str(win),ssOCTdefaults.nSamplesFFT))
subplot(231)
[~, peak_pos, FWHMum, peak_pos_m] = fwhm(AlineRight);
plot(1e3*ssOCTdefaults.range.posZaxis_air,AlineRight,'k-',...
    1e3*peak_pos_m,AlineRight(peak_pos),'ro')
legend('Original (Right side)')
title([sprintf('FWHM = %.2f',FWHMum) ' \mum'])
xlabel('z [mm]'); xlim([0 0.5])

subplot(234)
[~, peak_pos, FWHMum, peak_pos_m] = fwhm(AlineLeft);
plot(1e3*ssOCTdefaults.range.posZaxis_air,AlineLeft,'k-',...
    1e3*peak_pos_m,AlineLeft(peak_pos),'ro')
legend('Original (Left side)')
title([sprintf('FWHM = %.2f',FWHMum) ' \mum'])
xlabel('z [mm]'); xlim([0 0.5])

subplot(232)
[~, peak_pos, FWHMum, peak_pos_m] = fwhm(resampledAlineRight);
plot(1e3*ssOCTdefaults.range.posZaxis_air,resampledAlineRight,'k-',...
    1e3*peak_pos_m,resampledAlineRight(peak_pos),'ro')
legend('Resampled (Right side)')
title([sprintf('FWHM = %.2f',FWHMum) ' \mum'])
xlabel('z [mm]'); xlim([0 0.5])

subplot(235)
[~, peak_pos, FWHMum, peak_pos_m] = fwhm(resampledAlineLeft);
plot(1e3*ssOCTdefaults.range.posZaxis_air,resampledAlineLeft,'k-',...
    1e3*peak_pos_m,resampledAlineLeft(peak_pos),'ro')
legend('Resampled (Left side)')
title([sprintf('FWHM = %.2f',FWHMum) ' \mum'])
xlabel('z [mm]'); xlim([0 0.5])

subplot(233)
[~, peak_pos, FWHMum, peak_pos_m] = fwhm(synthAlinefftRight);
plot(1e3*ssOCTdefaults.range.posZaxis_air,synthAlinefftRight,'k-',...
    1e3*peak_pos_m,synthAlinefftRight(peak_pos),'ro')
legend('Synthetic (Right side)')
title([sprintf('FWHM = %.2f',FWHMum) ' \mum'])
xlabel('z [mm]'); xlim([0 0.5])

subplot(236)
[~, peak_pos, FWHMum, peak_pos_m] = fwhm(synthAlinefftLeft);
plot(1e3*ssOCTdefaults.range.posZaxis_air,synthAlinefftLeft,'k-',...
    1e3*peak_pos_m,synthAlinefftLeft(peak_pos),'ro')
legend('Synthetic (Left side)')
title([sprintf('FWHM = %.2f',FWHMum) ' \mum'])
xlabel('z [mm]'); xlim([0 0.5])


%% 

% Clear global data
clear global ssOCTdefaults
% Load default parameters
ss_oct_get_defaults
% Access global variable
global ssOCTdefaults
close all
% ------------------------------------------------------------------------------
Fs = 125e6;                             % Sampling frequency = 125 MHz
% Acquisition noise: obtained with a 75 ohm terminator on the ADC
[rawBscan refBscan Bscan hFig] = browseVolume(1,...
    'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2011_10_31_Mirror\17_35_18_darkNoise\2011_10_31_17_44_34.dat');
[AlineDark,f] = myFFT(rawBscan, Fs);
AlineDark = mean(AlineDark,2);
% Pixel spacing in frequency
pixSpace = mean(diff(f));
[FWHM, peak_pos, FWHMum, peak_pos_m] = fwhm(Aline);

% Readout noise: electrical noise obtained with both the reference and sample
% arms blocked
[rawBscan refBscan Bscan hFig] = browseVolume(1,...
    'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2011_10_31_Mirror\17_50_26_readoutNoise\2011_10_31_17_51_29.dat');
[AlineReadout,f] = myFFT(rawBscan, Fs);
AlineReadout = mean(AlineReadout,2);

% Pixel spacing in frequency
pixSpace = mean(diff(f));
[FWHM, peak_pos, FWHMum, peak_pos_m] = fwhm(Aline);

% Noise floor: Obtained with the sample arm blocked
[rawBscan refBscan Bscan hFig] = browseVolume(1,...
    'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2011_10_31_Mirror\17_57_01_referenceLight\2011_10_31_17_57_56.dat');
[Aline,f] = myFFT(mean(refBscan,2), Fs);
% Pixel spacing in frequency
pixSpace = mean(diff(f));
[FWHM, peak_pos, FWHMum, peak_pos_m] = fwhm(Aline);
% plot(f,Aline,'k-',peak_pos*pixSpace,FWHM*pixSpace,'ro')
% title(sprintf('FWHM = %.2f Hz at %.2f Hz',FWHM*pixSpace,f(peak_pos)))
% xlabel('f [Hz]')
% xlim([0 15e6])

%% Comparison between 125 and 100 MHz. Mirror close to the surface
[rawBscan refBscan Bscan hFig] = browseVolume(1,...
    'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2011_10_31_Mirror\18_26_54_0000um\2011_10_31_18_29_21.dat');
[Aline,f] = myFFT(rawBscan, Fs);
Aline = mean(Aline,2);
% Pixel spacing in frequency
pixSpace = mean(diff(f));
[FWHM, peak_pos, FWHMum, peak_pos_m] = fwhm(Aline);

% ------------------------------------------------------------------------------
% Mirror close to the surface but acquired at 100 MHz
Fs100 = 100e6;                             % Sampling frequency = 100 MHz
[rawBscan100 refBscan100 Bscan100 hFig] = browseVolume(1,...
    'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2011_11_01_Mirror\13_33_23_acq100MHz\2011_11_01_13_34_21.dat');
[Aline100,f100] = myFFT(rawBscan100, Fs100);
Aline100 = mean(Aline100,2);
% Pixel spacing in frequency
pixSpace100 = mean(diff(f100));
[FWHM100, peak_pos100, FWHMum100, peak_pos_m100] = fwhm(Aline100);

[refAline,~] = myFFT(refBscan, Fs);
[refAline100,~] = myFFT(refBscan100, Fs100);
refAline = mean(refAline,2);
refAline100 = mean(refAline100,2);

figure; set(gcf,'color','w')
set(gcf,'Name','fs=125MHz and fs=100MHz comparison')
plot(f100,Aline100,'k-',f,Aline,'r-',f100,refAline100,'k--',f,refAline,'r--')
legend({'Mirror @100MHz' 'Mirror @125MHz' 'Reference @100MHz' 'Reference @125MHz'})
xlabel('f [Hz]')
xlim([0 12e6])
ylim([-10 1.5e3])

% log display
figure; set(gcf,'color','w')
set(gcf,'Name','Noise @ fs=125MHz')
plot(f,log(Aline),'k-',f,log(refAline),'r-',...
    f,log(AlineReadout),'b--',f,log(AlineDark),'b-')
legend({'PSF' 'Noise Floor'...
    'Readout noise' 'Acquisition noise'})
xlabel('f [Hz]')
ylabel('log(Amplitude)')
xlim([0 18e6])
ylim([-4 10])

figure; set(gcf,'color','w')
plot(f100,Aline100-refAline100,'k-',f,Aline-refAline,'r-')
legend({'Mirror-Ref @100MHz' 'Mirror-Ref @125MHz'})
xlabel('f [Hz]')
xlim([0 12e6])
ylim([0 1.5e3])

tilefigs
