function [gamma_real,gamma_imag,dispersion]=...
    frame2gamma(frame,reference,wavenumbers,dispersion)
% This function will

if ~exist('dispersion')
    dispersion.compensate=1;
    dispersion.a=[0 0];
end

frame=double(frame);
[m,n]=size(frame);

ref_2D=repmat(reference,[1 n]);

%% Remove the reference

frame=(frame-ref_2D)./ref_2D;

%% Interpolate the data on the wavenumber space
frame=interp1(wavenumbers.pixels,frame,wavenumbers.linear,'linear'); %I tried to use interp1q, but this is faster

%% This will apply a Window to the data
frame=frame.*repmat(hann(m),[1 n]);

%% This will high pass filter the data, this step is no longer necessary
% frame=filter(HPF.b,HPF.a,frame,[],1);

%% This is the step that will implement dispersion compensation I just need
%% to put the factor a inside the recons_info structure.
% frame_before_dispersion=abs(ifft(frame,[],1));
% figure(1);subplot(2,1,1);imagesc(frame_before_dispersion(50:200,:))
% title('Frame before dispersion compensation');pause(0.01)

if dispersion.compensate==1;
    dispersion.a = fminsearch(@(a) dispersion_optimization(frame,wavenumbers,a),dispersion.a);
    dispersion.compensate=0;
    save last_dispersion_parameter -struct dispersion
end

[frame]=dispersion_compensation(frame,wavenumbers,dispersion.a);

%% This will do the ifft of the Data
frame=ifft(frame,[],1);

% figure(1);subplot(2,1,2);imagesc(abs(frame(50:200,:)))
% title(['Frame after dispersion compensation, a = ' num2str(a)]);pause(0.01)

% This extracts the real and imaginary parts
gamma_real=real(frame(1:end/2,:));
gamma_imag=imag(frame(1:end/2,:));

end

function display_frame_status(frame)
figure
imagesc(frame)
title(['Min : ' num2str(min(min(frame))) ', Max : ' num2str(max(max(frame)))])
end