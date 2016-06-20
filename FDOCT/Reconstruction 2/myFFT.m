% ------------------------ Blinkdagger function --------------------------------
function [Y,f] = myFFT(y,Fs)
% Works on column vectors/2D matrices along columns
% y = signal to be transformed
% Fs = sampling frequency of y (in Hz)
% Y = single sided spectrum of y
% f = frequency axis (in Hz)
N   =   size(y,1);  %get the number of points
k   =   0:N-1;      %create a vector from 0 to N-1
T   =   N/Fs;       %get the frequency interval
f   =   k/T;        %create the frequency range
Y   =   fft(y,[],1)/N;   % normalize the data

%only want the first half of the FFT, since it is redundant
cutOff = ceil(N/2);

%take only the first half of the spectrum
Y = abs(Y(1:cutOff,:));
f = f(1:cutOff);


% L = numel(y);                     % Length of signal
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% Y = fft(y,NFFT)/L;
% f = Fs/2*linspace(0,1,NFFT/2+1);
% Y = 2*abs(Y(1:NFFT/2+1));

% ---------------------- Plot single-sided amplitude spectrum. -----------------
% figure
% plot(f,Y) 
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
