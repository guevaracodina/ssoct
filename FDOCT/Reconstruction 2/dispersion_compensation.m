function [Interference]=dispersion_compensation(Interference,wavenumbers,a)
% This function will apply an n-th degree dispersion compensation where the
% length of a is the dispersion compensation to apply.
% Interference is the interference pattern after reference substraction,
% division, hanning window and interpolation
% a is the dispersion compensation vector with a(1)=a_2, a(2)=a_3, etc.;
[m,n]=size(Interference);

S=hilbert(Interference);

omega0=wavenumbers.pixels(end/2)*1e-6; %m/2; %En 10e-6 m^-1
omega=wavenumbers.linear*1e-6; %1:m;

phase_compensation=zeros(m,1);
for i=1:length(a)
    phase_compensation=-a(i)*(omega-omega0).^(i+1)+phase_compensation;
end

S2=abs(S).*exp(j*angle(S)).*exp(j*repmat(phase_compensation,[1 n]));
Interference=real(S2);