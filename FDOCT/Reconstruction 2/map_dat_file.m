function [FrameData,acqui_info]=map_dat_file(acqui_info)
% This function will generate the memmapfile handle for a .dat file

% The size of the data in the dat file is now stored in only one variable
% in the acqui_info structure. This if will ensure backwards compatibility
% while at the same time updating the acqui_info files to include this new
% simple variable

if ~isfield(acqui_info,'dat_size');
    if isfield(acqui_info,'full_frame');
        if acqui_info.full_frame==1
            width=acqui_info.ramp_length;
        else
            width=acqui_info.resolution;
        end
    else
        width=acqui_info.resolution;
    end
    acqui_info.dat_size=[acqui_info.frame_depth width acqui_info.nframes];
    resave_acqui_info;
end

if isfield(acqui_info,'nfiles')
    if acqui_info.nfiles==1
        FrameData{1}=memmapfile([acqui_info.filename '.dat'],...
            'Format',{'int16' acqui_info.dat_size 'frames'});
    else
        for file_number=1:acqui_info.nfiles
            start_frame=(file_number-1)*acqui_info.nframes+acqui_info.framenumber(1);
            FrameData{file_number}=memmapfile([acqui_info.filename '-' num2str(start_frame) '.dat'],...
            'Format',{'int16' acqui_info.dat_size 'frames'});
        end
    end
else
    FrameData=memmapfile([acqui_info.filename '.dat'],...
        'Format',{'int16' acqui_info.dat_size 'frames'});
end
