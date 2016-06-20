function dimensions=define_dimensions(acqui_info,recons_info)
% This function will define the dimensions of a 3D result file for quick
% viewing
dimensions{2}.type='Z';
dimensions{2}.FOV=round(acqui_info.z_FOV_um);
dimensions{2}.size=acqui_info.frame_depth/2;
dimensions{2}.units='um';

switch acqui_info.ramp_type
    
    case 1 % In the case of a 2Dtime Volume
        if abs(acqui_info.y_FOV_um)<1
            dimensions{1}.type='X';
        elseif abs(acqui_info.x_FOV_um)<1;
            dimensions{1}.type='Y';
        else
            dimensions{1}.type='Arbitrary';
        end
        dimensions{1}.FOV=round(sqrt(acqui_info.y_FOV_um^2+acqui_info.x_FOV_um^2));
        dimensions{1}.size=acqui_info.resolution;
        dimensions{1}.units='um';
        
        if acqui_info.ecg==1
            dimensions{3}.type='T';
            dimensions{3}.FOV=recons_info.dt_us/1000*recons_info.number_of_time_gates;
            dimensions{3}.size=recons_info.number_of_time_gates;
            dimensions{3}.units='ms';
        else
            dimensions{3}.type='Frame';
            dimensions{3}.FOV=acqui_info.nframes;
            dimensions{3}.size=acqui_info.nframes;
            dimensions{3}.units='';
        end
        
    case 4 % In the case of a standard 3D volume
        dimensions{1}.type='X';
        dimensions{1}.FOV=round(acqui_info.x_FOV_um);
        dimensions{1}.size=acqui_info.resolution;
        dimensions{1}.units='um';
        
        dimensions{3}.type='Y';
        dimensions{3}.FOV=round(acqui_info.y_FOV_um);
        dimensions{3}.size=acqui_info.nframes;
        dimensions{3}.units='um';
        
    case 6 % In the case of a 3D HD volume
        dimensions{1}.type='X';
        dimensions{1}.FOV=round(acqui_info.x_FOV_um);
        dimensions{1}.size=round(acqui_info.x_FOV_um);
        dimensions{1}.units='um';
        
        dimensions{3}.type='Y';
        dimensions{3}.FOV=round(acqui_info.y_FOV_um);
        dimensions{3}.size=acqui_info.HD_info.slicesperfile*acqui_info.nfiles;
        dimensions{3}.units='um';
end
end