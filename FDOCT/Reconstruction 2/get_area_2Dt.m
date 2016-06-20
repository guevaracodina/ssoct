function get_area_2Dt(pathname,filename,revisit_ROInBG)
% This function will calculate the area change in a 2D+time acquisition

smoothing_time=1;  % Size of the hanning window for smoothing data in ms
area_threshold=0.1;
load('doppler_color_map.mat')

if ~exist('pathname')
    [pathname,filename]=prompt_acquisition...
        ('Select reconstructed 2D + Time acquisitions');
end

for acquisition=1:numel(pathname)
    close all
    %This will load each acquisition
    clear acqui_info recons_info result
    load([pathname{acquisition} filename{acquisition}])
    %This will verify that it is the correct acquisition type and that it
    %has been reconstructed
    %     keyboard
    
    acquisition_valid=0;
    if acqui_info.ramp_type==1&&acqui_info.ecg==1&&exist('recons_info')
        if isfield(result,'flow')
            if strcmp(result.flow,'Yes')
                [Structure,Doppler1]=map_3D_files([pathname{acquisition} ...
                    filename{acquisition}]);
                Doppler1_type=whos('Doppler1');
                if strcmp(Doppler1_type.class,'memmapfile')
                    acquisition_valid=1;
                end
            end
        end
    end
    
    if acquisition_valid
        cycle_time_ms=[1:recons_info.size(3)]*recons_info.step(3)/1000;
        Doppler1_var=Doppler1.Data.Data;
        Doppler_mean=mean(Doppler1_var,3);
        Structure_mean=mean(Structure.Data.Data,3);
        
        if isfield(result,'background_mean')
            Doppler1_var=Doppler1_var-result.background_mean;
            Doppler_mean=Doppler_mean-result.background_mean;
        end
        
        if ishandle(100);close(100);end
        draw_2D_roi2(100,Structure_mean,Doppler_mean,recons_info,result.ROI)
        
        current_position=get(gca,'position');
        set(gca,'position',[0 0 1 1])
        figure(100);pause(0.1)
        
        Doppler_thresholded=Doppler1_var.*repmat(int16(result.ROI.BW)',[1 1 100]);
        max_speed=max(max(max(abs(Doppler_thresholded))));
        Area=squeeze(sum(sum(abs(Doppler_thresholded)>max_speed*area_threshold)));
        
        figure;
        plot([(result.Aire').*(result.Aire')/min(result.Aire)^2 Area/min(Area) abs(result.blood_speed_filtered)'/min(abs(result.blood_speed_filtered))])
        legend('Estimation of diameter squared','Estimation of Area','Blood speed change','Location','Best')
        pause
    else
        disp(['Acq. ' num2str(acquisition) ': ' acqui_info.base_filename ' not valid'])
    end
end

end

function data_filtered=smooth_data_periodic(data,filter_width)
averaging_window=hann(filter_width)/sum(hann(filter_width));
data_triple=[data data data];
data_filtered=conv(data_triple,averaging_window,'same');
data_filtered=data_filtered(length(data)+1:2*length(data));
end

