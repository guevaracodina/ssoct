function [meaningful_mean_FWHM]=optimize_dispersion(a)

load Fantom_mirror_old_setup
important_peaks=3:13;
a=[0 a(1) a(2)];
[m,n]=size(Interference);

Interference2=double(Interference)-Reference;
Interference2=Interference2./Reference*max(max((Reference)));
[wavenumbers]=wavelengths2wavenumbers(Wavelengths);
Interference3=interp1(wavenumbers.pixels,Interference2,wavenumbers.linear,'linear');
Interference3=Interference3.*repmat(hann(m),[1 31]);
Interference3=dispersion_compensation(Interference3,wavenumbers,a);

reconstructed=fft(Interference3);
signal=abs(reconstructed(1:end/2,:));
%This is to remove the low frequency component that is sometimes stronger
%then the actual signal
signal(1:5,2:end)=0;

[FWHM,peak_pos]=calculate_FWHM(signal);

meaningful_mean_FWHM=mean(FWHM(important_peaks));