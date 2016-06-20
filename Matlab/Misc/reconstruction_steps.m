%%
load (fullfile('D:\Edgar\ssoct\Matlab\Misc','phase.mat'))
% load values to new variables
k0 = data.k;
Aline = data.Aline;
ref = data.refB;

% K-clock resampling of a B-scan
% Position when sampling at a fixed frequency (125 MHz)
NSAMPLES = 1128;
fixedSampling = linspace(0,NSAMPLES - 1,NSAMPLES)';

% Resampling (Interpolation/Decimation) along columns (A-lines)
Aline = interp1(k0, Aline, fixedSampling, 'linear');
ref = interp1(k0, ref, fixedSampling, 'linear');

% window
tmpCorrArray = myhann(NSAMPLES);
Aline = Aline.*tmpCorrArray;
ref = ref.*tmpCorrArray;

% fourier transform on 4096 points
NFFT = 4096;
Afft = abs(fftshift(fft(double(Aline),NFFT,1),1));
Rfft = abs(fftshift(fft(double(ref),NFFT,1),1));

% Reference subtraction in fourier domain



%%
load (fullfile('D:\Edgar\ssoct\Matlab\Misc','coupler_50_50.mat'))
load (fullfile('D:\Edgar\ssoct\Matlab\Misc','phase.mat'))
global ssOCTdefaults
ss_oct_get_defaults
clc; close all

% load values to new variables
k0 = data.k;
Aline = mean(B(:,269:277),2) - 2^13;
ref = mean(ref,2) - 2^13;

% Position when sampling at a fixed frequency (125 MHz)
NSAMPLES = 1128;
fixedSampling = linspace(0,NSAMPLES - 1,NSAMPLES)';

% Reference subtraction and deconvolution
Aline_corr = (Aline - ref)./ref;

% window
tmpCorrArray = rectwin(NSAMPLES);
Aline_corr = Aline_corr.*tmpCorrArray;

% Resampling (Interpolation/Decimation) along columns (A-lines)
Aline_interp = interp1(k0, Aline_corr, fixedSampling, 'linear');
figure(1); plot(Aline_interp,'r-')
hold on; plot(Aline_corr,'b-')

% Theoretical sinus
fs = 125e6;
ts = 1/fs;
t = (0:NSAMPLES-1)*ts; 
A_theo = 5*sin(2*pi*1.1e6*t - 0.3)';
figure (1); hold on; plot(A_theo, 'k-')
legend({'Exp. Interpolated' 'Exp. Raw' 'Theoretical'})

%%
% fourier transform on 4096 points
NFFT = 2^12;
ssOCTdefaults.nSamplesFFT = NFFT;
% Positive z-axis in m (air)
ssOCTdefaults.range.posZaxis_air        = linspace(ssOCTdefaults.range.delta_Z_Nq_air ./...
    ssOCTdefaults.nSamplesFFT,ssOCTdefaults.range.delta_Z_Nq_air,ssOCTdefaults.nSamplesFFT/2);
z = ssOCTdefaults.range.posZaxis_air;
A_corr_fft = abs(fftshift(fft(Aline_corr,NFFT,1),1));
Afft = abs(fftshift(fft(Aline_interp,NFFT,1),1));
Rfft = abs(fftshift(fft(ref,NFFT,1),1));

% Keep only positive half
Afft_half = Afft(NFFT/2+1:end);
Afft_corr_half = A_corr_fft(NFFT/2+1:end);

% Hi-pass
Afft_filter = Afft_half;
Afft_filter(1:5) = 0;
Afft_corr_filter = Afft_corr_half;
Afft_corr_filter(1:5) = 0;
% Normalize by the maximum
Afft_filter = Afft_filter ./ max(Afft_filter);
Afft_corr_filter = Afft_corr_filter ./ max(Afft_corr_filter);
figure(3); hold on; plot(z, Afft_filter, 'r-')
plot(z, Afft_corr_filter, 'b:')

% FWHM
[FWHM, peak_pos, FWHM_um, peak_pos_m] = fwhm(Afft_filter);
fprintf('Experimental FWHM: %.4f um\n',FWHM_um)
figure(3); hold on; plot(peak_pos_m, Afft_filter(peak_pos), 'ro')

% Theoretical sinus fft
A_theo_fft = abs(fftshift(fft(A_theo,NFFT,1),1));
A_theo_fft = A_theo_fft(NFFT/2+1:end);
% Normalize by the maximum
A_theo_fft = A_theo_fft ./ max(A_theo_fft);
figure(3); hold on; plot(z, A_theo_fft,'k-')

% FWHM
[FWHM, peak_pos, FWHM_um, peak_pos_m] = fwhm(A_theo_fft);
fprintf('Theoretical FWHM: %.4f um\n',FWHM_um)
fprintf('Axial resolution: %.4f um\n',1e6*ssOCTdefaults.axial.zr_air)
figure(3); hold on; plot(peak_pos_m, A_theo_fft(peak_pos), 'ko')
xlim ([0 500e-6])
legend({'Exp. Interpolated' 'Exp. Raw' 'Exp FWHM' 'Theoretical' 'Theo FWHM'})

