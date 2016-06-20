function [posEnv negEnv] = detect_envelope(signal)
% This function implements envelope detection by the Hilbert transform. The
% signal's envelope is equivalent to its outline and an envelope detector
% connects all the peaks in this signal.
% SYNTAX:
% [posEnv negEnv] = detect_envelope(signal)
% INPUTS:
% signal    Discrete signal to be analyzed
% OUTPUTS:
% posEnv    Positive envelope of the original signal
% negEnv    Negative envelope of the original signal
%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara
% 2011/07/14

% Padded Hilbert transform of the original signal
% hil = paddedhilbert(signal);

% Analytical signal
% hil = hilbert(signal);

% Downsample Hilbert transform
% hilDown = downsample(abs(hil),4);

% posEnv = 2.*signal.^2;
% posEnv = downsample(posEnv,5);
% 
% % FIR parameters
% f = [0 0.1 0.1 1]; m = [1 1 0 0];
% % FIR coefficients
% b = fir2(30,f,m);
% [h,w] = freqz(b,1,128);
% figure;plot(f,m,w/pi,abs(h))
% % Filter signal
% posEnv = filter(b,1,posEnv);
% posEnv = sqrt(abs(posEnv));
% figure; plot(posEnv)
% figure; plot(signal,'k-')

% hilFilt = filtfilt(b,a,hilDown);

% Analytic signal envelope
% posEnv = abs(signal + 1i*hil);
% posEnv = abs(hil);

% Modifies values of global variable
global ssOCTdefaults

posEnv = env_secant(1:ssOCTdefaults.NSAMPLES, signal, 256, 'top');
% Negative part envelope
negEnv = env_secant(1:ssOCTdefaults.NSAMPLES, signal, 256, 'bottom');

% ==============================================================================
% [EOF]
