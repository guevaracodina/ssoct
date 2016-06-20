function fftBscan = Bscan2FFT(Bmodescan)
% Computes the single-sided FFT of a B-mode scan, along the A-lines dimension (columns)
% SYNTAX:
% fftBscan = Bscan2FFT(Bmodescan)
% INPUTS:
% Bmodescan     2D raw data (B-scan)
% OUTPUTS:
% fftBscan      2D fft of a B-scan
%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara
% 2011/07/11
global ssOCTdefaults

% Complex median subtraction (works only on tissue/multiple scatterers)
if ssOCTdefaults.medianRefArm
    % Window function
    tmpCorrArray = myhann(ssOCTdefaults.nSamplesFFT);
    tmpCorrArray = tmpCorrArray(:,ones([size(Bmodescan,2) 1]));

    % Get complex data from B-scan
    fftBscan = fftshift(fft(double(Bmodescan),ssOCTdefaults.nSamplesFFT,1),1);

    % Get a median reference spectrum in Fourier domain
    refAline = median(real(fftBscan),2) + 1j*median(imag(fftBscan),2);
    refAline = refAline(:,ones([size(Bmodescan,2) 1]));
    
    % Apply windowing function to reference
    refAline = refAline .* tmpCorrArray;

    % Subtract median reference in complex domain
    fftBscan = fftBscan - refAline;

else

% FFT of the interferogram is a reflectivity profile, applying the FFT across
% the columns (dimension = 1), with ssOCTdefaults.nSamplesFFT points
fftBscan = fftshift(fft(double(Bmodescan),ssOCTdefaults.nSamplesFFT,1),1);

% Keep only the single-sided FFT (left half of the spectrum)
fftBscan = fftBscan(end/2:-1:1,:);

end
% ==============================================================================
% [EOF]
