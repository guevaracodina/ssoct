% Create a mapping function from pixel spacing to k-spacing
%% Load and prepare data
clear; close all; clc
load (fullfile('D:\Edgar\ssoct\Matlab\Misc','coupler_50_50.mat'))
load (fullfile('D:\Edgar\ssoct\Matlab\Misc','phase.mat'))
% Reference signal is filtered, because extreme care must be taken when
% deconvolving by a noisy signal
[b,a] = butter(16, 0.2, 'low');
ref_hi_filt = filtfilt(b, a, mean(ref_hi,2));
NSAMPLES = 1128;
nLinesPerFrame = 512;
fixedSampling = linspace(0,NSAMPLES - 1,NSAMPLES)';
% Reference subtraction and deconvolution
B_hi_corr = mean(B_hi(:)).*(B_hi - ref_hi_filt(:,ones(512, 1))) ./ ref_hi_filt(:,ones(512, 1));
% Our corrected Aline is the average of 5 A-lines, not all the B-frame, because
% oscillation appear because of vibrations
B_hi_corr = mean(B_hi_corr(:, 300:325),2);
figure(1)
plot(fixedSampling, B_hi_corr, fixedSampling, B_hi(:,200), fixedSampling, ref_hi_filt)
legend({'Reference Corrected' 'Raw' 'Reference'}, 'location', 'SouthEast')

%% Theoretical sinus zero-crossing
A_theo = 3000*sin(2*pi*0.0374*fixedSampling + 5);
[ind_theo, t_theo] = crossing(A_theo, fixedSampling);
ind_theo = ind_theo'; t_theo = t_theo';
figure(2)
subplot(211)
plot(fixedSampling, A_theo, 'k-', t_theo, 0, 'ro')
legend({'Theoretical' 'zero-cross'}, 'location', 'SouthEast')

%% Experimental zero-crossing
[ind_corr t_corr] = crossing(B_hi_corr, fixedSampling);
ind_corr = ind_corr'; t_corr = t_corr';
t_corr = round(t_corr);
figure(2)
subplot(212)
plot(fixedSampling, B_hi_corr, 'b-', t_corr, 0, 'ro')
legend({'Experimental' 'zero-cross'}, 'location', 'SouthEast')

%% T experimental vs Theoretical
figure(3)
subplot(211)
plot(t_theo, 'k-')
hold on
plot (t_corr, 'b*')
legend({'T theo' 'T exp'}, 'location', 'SouthEast')

%% Measured k-clock sampling
k0 = data.k;
figure(3)
subplot(212)
plot (fixedSampling, fixedSampling, 'k-', fixedSampling, k0, 'g.')
legend({'Pixel spacing' 'k spacing'}, 'location', 'SouthEast')

%% Instantaneous T
% Pad my t_corr vector with initial and final values in order to avoid edge
% artifacts
NPAD = 50;
t_corr_res = resample([repmat(t_corr(1), [NPAD 1]); t_corr; repmat(t_corr(end), ...
    [NPAD 1])], NSAMPLES, numel(t_corr), 40);
% Extract the relevant portion of the signal
extraElements = round(NPAD*NSAMPLES/numel(t_corr));
t_corr_res = t_corr_res(extraElements+1:end-extraElements-1);
% figure;
% plot(t_corr_res, 'b-')
fprintf('Interpolation samples: %d\n',numel(t_corr_res))

%% A-line Interpolation
% frame=interp1(wavenumbers.pixels,frame,wavenumbers.linear,'linear');
B_hi_interp = interp1(fixedSampling, B_hi_corr, t_corr_res, 'linear');
figure(4)
plot(fixedSampling, B_hi_corr, 'b-', fixedSampling, B_hi_interp, 'r-', fixedSampling, A_theo, 'k--')
legend({'Raw' 'Interpolated' 'Theoretical'}, 'location', 'SouthEast')

%% Calculate again zero-crossing
[ind_interp t_interp] = crossing(B_hi_interp, fixedSampling);
ind_interp = ind_interp'; t_interp = t_interp';
figure(5)
hold on
plot(diff(t_theo), 'k.')
plot(diff(t_corr), 'bo')
plot (diff(t_interp), 'rs')
legend({'\DeltaT Theo.' '\DeltaT Exp.' '\DeltaT Exp. Interp.'}, 'location', 'SouthEast')
% Arrange the figures windows (Optional)
% tilefigs

%% FFT parameters
% fourier transform on 4096 points
NFFT = 2^12;
% Center wavelength
lambda0             = 1310e-9;
% Wavelength range
minLambda           = 1258e-9;
maxLambda           = 1361.2e-9;
delta_lambda        = maxLambda - minLambda;
% Index of refraction (air)
n = 1;
% FWHM in wavelength% Scan Range of a FDOCT
delta_Z_Nq = lambda0^2 * NSAMPLES / (4*delta_lambda*n);
% Axial resolution
zr              = (2/pi)*log(2)*lambda0^2 / (delta_lambda*n);
% Positive z-axis in m (air)
z = linspace(delta_Z_Nq ./ NFFT, delta_Z_Nq, NFFT/2);
pixelWidth = 2*delta_Z_Nq ./ (NFFT+1);

%% FFT comparison
Afft_corr = abs(fftshift(fft(B_hi_corr,NFFT,1),1));
Afft_interp = abs(fftshift(fft(B_hi_interp,NFFT,1),1));

% Keep only positive half
Afft_interp_half = Afft_interp(NFFT/2+1:end);
Afft_corr_half = Afft_corr(NFFT/2+1:end);

% Hi-pass
Afft_interp_filter = Afft_interp_half;
Afft_interp_filter(1:5) = 0;
Afft_corr_filter = Afft_corr_half;
Afft_corr_filter(1:5) = 0;

% Normalize by the maximum
Afft_interp_filter = Afft_interp_filter ./ max(Afft_interp_filter);
Afft_corr_filter = Afft_corr_filter ./ max(Afft_corr_filter);
figure(6); plot(z, Afft_interp_filter, 'r-');  hold on
title('|A-line|')
xlabel('z [m]')

% Calculate FWHM of interpolated signal
[FWHM, peak_pos] = calculate_FWHM(Afft_interp_filter);
% Output in um
FWHM_um     = FWHM      * pixelWidth * 1e6;
% Output in m
peak_pos_m  = peak_pos  * pixelWidth;
fprintf('Interpolated FWHM: %.4f um\n',FWHM_um)
figure(6); plot(peak_pos_m, Afft_interp_filter(peak_pos), 'ro')

figure(6); plot(z, Afft_corr_filter, 'b-')
% Calculate FWHM of raw signal
[FWHM, peak_pos] = calculate_FWHM(Afft_corr_filter);
% Output in um
FWHM_um     = FWHM      * pixelWidth * 1e6;
% Output in m
peak_pos_m  = peak_pos  * pixelWidth;
fprintf('Non-interpolated FWHM: %.4f um\n',FWHM_um)
figure(6); plot(peak_pos_m, Afft_corr_filter(peak_pos), 'bo')

% Theoretical sinus fft
A_theo_fft = abs(fftshift(fft(A_theo,NFFT,1),1));
A_theo_fft = A_theo_fft(NFFT/2+1:end);
% Normalize by the maximum
A_theo_fft = A_theo_fft ./ max(A_theo_fft);
figure(6); plot(z, A_theo_fft,'k-')

% Calculate FWHM of theoretical signal
[FWHM, peak_pos] = calculate_FWHM(A_theo_fft);
% Output in um
FWHM_um     = FWHM      * pixelWidth * 1e6;
% Output in m
peak_pos_m  = peak_pos  * pixelWidth;

fprintf('Theoretical FWHM: %.4f um\n',FWHM_um)
fprintf('Axial resolution: %.4f um\n',1e6*zr)
figure(6); hold on; plot(peak_pos_m, A_theo_fft(peak_pos), 'ko')
xlim ([0 500e-6])
legend({'Exp. Interpolated' 'Interp. FWHM' 'Exp. Raw'  'Raw FWHM' 'Theoretical' 'Theo FWHM' },'location','northwest')

%% Hilbert transform (phase linearity)
figure(7); hold on;
title('Phase linearity')
plot(fixedSampling, unwrap(angle(hilbert(B_hi_interp))),'r-')
plot(fixedSampling, unwrap(angle(hilbert(B_hi_corr))),'b-')
plot(fixedSampling, unwrap(angle(hilbert(A_theo))),'k-')
legend({'\phi Interp.' '\phi Non-Interp.' '\phi Theo.'},'location','southeast')
tilefigs
