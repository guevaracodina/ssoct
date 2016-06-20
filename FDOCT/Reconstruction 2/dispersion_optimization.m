function [M]=dispersion_optimization(frame,wavenumbers,a)
% This calculates the contrast of the image and returns M, the lower the
% value of M, the higher the contrast is.
[frame]=dispersion_compensation(frame,wavenumbers,a);

frame=ifft(frame,[],1);

frame_of_interest=abs(frame);
derivative=abs(diff(frame_of_interest));
M=1/sum(sum(derivative));