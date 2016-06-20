function [frame_struct,frame_mask]=get_frame_struct(gamma_real,gamma_imag,mask_prop)
% This function will generate a structure out of complex data, it will
% also find the surface of the structure and cut out the points above it,
% finally it will create a frame_mask using a dB threshold
% The Structure returned is in values of dB above noise floor, the noise
% floor is the last 10% of the image.
% keyboard

frame_struct=sqrt(double(gamma_real).^2+double(gamma_imag).^2);
[nz nr]=size(frame_struct);

noise_floor=mean(...
    mean(frame_struct(round((1-mask_prop.noise_lower_fraction)*end):end,:)));

% This is in values of dB above noise floor
% I made a mistake, to get decibels, we must divide this by
% log(10)=2.3026
frame_struct=10*log(frame_struct/noise_floor);
frame_struct(frame_struct<0)=0;

if isfield(mask_prop,'surface')
    if mask_prop.surface
        [frame_struct,surface]=find_top_surface(frame_struct);
    end
end

if mask_prop.enable==1
    [nz nr]=size(frame_struct);
    frame_mask=int8(frame_struct);
    
    if isfield(mask_prop,'threshold_db')
        frame_mask(frame_mask<mask_prop.threshold_db)=0;
    end
    
    if isfield(mask_prop,'blur_window')
        frame_mask=convn(frame_mask,int8(mask_prop.blur_window),'same');
    end
    
    frame_mask(frame_mask>0)=1;
    
    frame_struct=frame_mask.*frame_struct;
else
    frame_mask=ones(size(frame_struct));
end