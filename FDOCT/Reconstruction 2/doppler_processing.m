function [doppler_angle]=doppler_processing(gamma_real,gamma_imag,...
    filter_kernel,window,mask)
%This will obtain the doppler frequency of a 2D complex information slice
%it uses a filter_kernel to high pass filter the static tissue contribution
% Syntax : [doppler_angle_norm]=doppler_processing(gamma_real,gamma_imag,filter_kernel,window,mask)
%       gamma_real and gamma_imag are the real and imaginary parts of the
%       data obtained from the fft operation
%       - filter_kernel is the filter applied to remove the doppler shift
%       from stationnary tissue
%       - window is the window over which the angle is calculated (it must be
%       a M by N 2D array of ones
%       - mask is a mask that has the same dimensions of the final Doppler
%       image that will threshold where there is Doppler Data. It has
%       values of ones and zeros.


gamma=double(gamma_real)+j*double(gamma_imag);
gamma=squeeze(gamma);

mask=double(mask);

filter_kernel=reshape(filter_kernel,1,length(filter_kernel));

% Load filter_kernel_default
M = convn(gamma,filter_kernel,'same');
A=M(:,1:end-1).*conj(M(:,2:end));

window=double(window);
A_sum=convn(A,window,'same');

A_sum=A_sum.*mask(:,1:end-1);

doppler_angle=angle(A_sum);
doppler_angle_original=doppler_angle;
doppler_angle_unwrapped=unwrap(doppler_angle);
difference=sum(doppler_angle_unwrapped~=doppler_angle);
positions_to_unwrap=find(difference~=0);

for i=positions_to_unwrap
    %This is a more careful way of unwrapping that makes sure the operation
    %is done in both directions
    doppler_angle(:,i)=unwrap_single_line(doppler_angle(:,i));
end

%This will give the result file the same dimension as the input file
doppler_angle=[doppler_angle(:,1) doppler_angle/2]...
    +[doppler_angle/2 doppler_angle(:,end)];