function [speed,max_speed]=getspeed(doppler_int16,line_period_us,...
    wavelength,doppler_normalization)
% This will give the speed in the units of the wavelength

if ~exist('doppler_normalization')
    doppler_normalization=pi;
end

Doppler_frequency=doppler_normalization/pi*double(doppler_int16)...
    /double(intmax('int16'))/2/line_period_us/1e-6;
speed=Doppler_frequency*wavelength/2;
speed=speed/2; %This is the correction factor determined by the test on the fantom

max_doppler_frequency=1/2/line_period_us/1e-6; %Acquisition frequency in Hz
max_speed=max_doppler_frequency*wavelength/2; %Speed in mm/s

max_speed=max_speed/2; %This is an experimentally determined correction factor. Needs to be verified.