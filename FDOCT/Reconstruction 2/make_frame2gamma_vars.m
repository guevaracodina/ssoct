function [ref_2D,wavenumbers,HPF,window_2D]=make_frame2gamma_vars(acqui_info,dat2cpx_prop)
% Syntax
% [ref_2D,wavenumbers,HPF,window_2D]=make_frame2gamma_vars(acqui_info,dat2cpx_prop)

if 0
    dat2cpx_prop.window=1;
    dat2cpx_prop.HP=0.05;
end

% This will define the size of the frame that is mapped in the files
if isfield(acqui_info,'full_frame');
    if acqui_info.full_frame==1
        width_frame=acqui_info.ramp_length;
    else
        width_frame=acqui_info.resolution;
    end
else
    width_frame=acqui_info.resolution;
end

if acqui_info.ramp_type==6
    if isfield(acqui_info,'HD_info')
        slice_length=width_frame*acqui_info.HD_info.framesperslice;
    else
        slice_length=width_frame*40;
    end
else
    slice_length=width_frame;
end

[wavenumbers]=wavelengths2wavenumbers(acqui_info.wavelengths);
[HPF.b,HPF.a] = butter(2,dat2cpx_prop.HP,'high'); %Butterworth filter at n=2

%This will create the 2D reference matrix
ref_2D=acqui_info.reference*ones(1,slice_length);

%This will create the 2D hanning window
if dat2cpx_prop.window;
    w=hann(acqui_info.frame_depth);
else
    w=ones(acqui_info.frame_depth,1);
end
window_2D=w*ones(1,slice_length);
