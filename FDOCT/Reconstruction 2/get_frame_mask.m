function frame_mask=get_frame_mask(frame_struct,mask_prop)
%This function will take a frame and create a binary mask that will be used
%to filter the Doppler Data

% frame_struct is the structure in units of dB above noise floor

if mask_prop.enable==1
    
    [nz nr]=size(frame_struct);
    frame_mask=int8(frame_struct);

%     if isfield(mask_prop,'noise_lower_fraction')
%     else
%         mask_prop.noise_lower_fraction=0.1;
%     end
%     
%     noise_range=round(nz*(1-mask_prop.noise_lower_fraction):nz);
%     noise_floor=mean(frame_struct(noise_range,:),1);
%     noise_floor=ones(size(noise_floor))*mean(noise_floor);
%     noise_floor=ones(nz,1)*(noise_floor);
%     frame_struct=frame_struct./noise_floor;

    if isfield(mask_prop,'threshold_db')
        frame_mask(frame_mask<mask_prop.threshold_db)=0;
    end
        
    if isfield(mask_prop,'blur_window')
        frame_mask=convn(frame_mask,int8(mask_prop.blur_window),'same');
    end
    
    frame_mask(frame_mask>0)=1;
    
else
    frame_mask=ones(size(frame_struct)); 
end

imagesc(frame_mask.*frame_struct)
colormap gray