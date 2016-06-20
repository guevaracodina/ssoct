% Example 9.3
% Use SI units throughout

pathname = 'D:\Edgar\ssoct\Matlab\Misc\';
cd(pathname)

lambda0 = 1310E-9; % center wavelength
dlambda = 200E-9; % bandwidth (delta lambda)
c = 3E8; % speed of light

lc = 4*log(2)/pi*lambda0^2/dlambda 	% coherence length
Number_of_periods = 0.5*lc/(lambda0/2) 	% # of periods in FWHM

figure(1);

N = 2^12; % number of sampling points
dl = lc*linspace(-2,2, N); % array for Delta_l
k0 = 2*pi/lambda0; % propagation constant

subplot(4, 1, 1) % interferogram
Iac = exp(-16*log(2)*(dl/lc).^2) .* cos(2*k0 * dl);
plot(dl/lc, Iac, 'k')
title('(a) Interferogram')
xlabel('\Deltal/l_c')
ylabel('Signal')
axis([-0.6, 0.6, -1, 1])

subplot(4, 1, 2) % rectified interferogram
Irec = abs(Iac); 
plot(dl/lc, Irec, 'k')
title('(b) Rectified interferogram')
xlabel('\Deltal/l_c')
ylabel('Signal')
axis([-0.6, 0.6, -1, 1])

subplot(4, 1, 3) % spectrum of the rectified interferogram 
Frec1 = fft(Irec)/sqrt(N);
% order of frequencies: 0,1...(N/2-1),-N/2,-(N/2-1)...-1
Frec2 = fftshift(Frec1); 
% shifted order of frequencies: -N/2,-(N/2-1)...-1, 0,1...(N/2-1)
dfreq = 1/(4*lc); % freq bin size = 1/sampling range
freq = dfreq*(-N/2:N/2-1); % frequency array

plot(freq*lambda0, abs(Frec2), 'k')
title('(c) Spectrum of the rectified interferogram')
xlabel('Frequency (1/\lambda_0)')
ylabel('Amplitude')
axis([-10, 10, 0, 5])

subplot(4, 1, 4) % envelope
freq_cut = 1/lambda0/2; % cut-off frequency for filtering
i_cut = round(freq_cut/dfreq); % convert freq_cut to an array index
Ffilt = Frec1; % initialize array
Ffilt(i_cut:N-i_cut+1) = 0; % filter
Ifilt = abs(ifft(Ffilt))*sqrt(N); % amplitude of inverse FFT

plot(dl/lc, Ifilt/max(Ifilt), 'k')
Iac_en = exp(-16*log(2)*(dl/lc).^2); % envelope
hold on;
plot(dl(1:N/32:N)/lc, Iac_en(1:N/32:N), 'ko')
hold off;
title('(d) Envelopes')
xlabel('\Deltal/l_c')
ylabel('Signals')
axis([-0.6, 0.6, -1, 1])
legend('Demodulated','Original')


% Copy of the interferogram

figure
set(gcf,'color','w')
plot(dl/lc, Iac, 'r', 'LineWidth', 3)
% title('(a) Interferogram')
% xlabel('\Deltal/l_c')
% ylabel('Signal')
axis([-0.6, 0.6, -1, 1])
axis off
% export_fig(gcf,'D:\Edgar\Dropbox\Docs\OCT\Screenshots\OCT_signal.png')

%% FFT of interferogram
Aline = abs(fft(Iac));
figure
set(gcf,'color','w')
plot(Aline, 'r', 'LineWidth', 3)
axis([0, 47*2, 0, 275])
axis off
% export_fig(gcf,'D:\Edgar\Dropbox\Docs\OCT\Screenshots\A_line.png')
% ==============================================================================
% [EOF]
