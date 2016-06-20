function [acqui_info]=read_bin_header(A,acqui_info)

% This will recognize which header version is used
Header_version=fread(A,1,'int16');

if Header_version>20
    Header_version=0;
end

%This will read the basic header information
if Header_version>=1
    acqui_info.version=Header_version;
    acqui_info.resolution=fread(A,1,'int16');
    acqui_info.ramp_type=fread(A,1,'int8');
    acqui_info.line_period_us=fread(A,1,'double');
    acqui_info.expo_time_us=fread(A,1,'double');
    acqui_info.x_FOV_um=fread(A,1,'double');
    acqui_info.y_FOV_um=fread(A,1,'double');
    acqui_info.z_FOV_um=fread(A,1,'double');
    acqui_info.ecg=0;
else
    acqui_info.version=-1;
    display('No header in current file.')
    frewind(A);
end

%This will read the galvo ramps found in versions 2 and up. Version 2 had a
%different way of encoding the ramplength.
if Header_version>=2
    if Header_version==2
        ramplength=fread(A,2,'int16');
    elseif Header_version>=3
        ramplength=fread(A,1,'uint32');
    end
    acqui_info.ramp_X=fread(A,ramplength(1),'double');
    acqui_info.ramp_Y=fread(A,ramplength(1),'double');
end

%This will declare that the ecg information is written in the file alongside 
%the frame data.
if Header_version>=4
    acqui_info.ecg=1;
end

if Header_version>=5
    acqui_info.pos_X=fread(A,1,'double');
    acqui_info.pos_Y=fread(A,1,'double');
end

if Header_version>=6
acqui_info.electrophysio=fread(A,1);
end

%%
%This will read the reference and the wavelengths
Reflength=fread(A,2,'int16');
acqui_info.reference=fread(A,Reflength(1),'int16');
%This will make sure there are no 0 values in the reference which would
%cause NaNs to appear when dividing by the reference
acqui_info.reference(acqui_info.reference==0)=1;

wavelengthslength=fread(A,2,'int16');
acqui_info.wavelengths=fread(A,wavelengthslength(1),'double');
