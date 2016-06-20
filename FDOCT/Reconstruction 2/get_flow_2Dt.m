function get_flow_2Dt(pathname,filename)
% This function will calculate the flow going through a ROI in a 2D+time
% reconstructed data set
wavelength=870e-6; %Wavelength in mm

smoothing_time=24;  % Size of the hanning window for smoothing data in ms
area_threshold=0.1;
load('doppler_color_map.mat')

if ~exist('pathname')
    [pathname,filename]=prompt_acquisition...
        ('Select reconstructed 2D + Time acquisitions');
end

reselect_ROI=questdlg(['Do you want to be asked to confirm the flow and reselect '...
    'the ROI for each acquisition?'],'Reselect ROI','Yes','No','Cancel','No');

for acquisition=1:numel(pathname)
    close all
    %This will load each acquisition
    clear acqui_info recons_info result
    load([pathname{acquisition} filename{acquisition}])
    %This will verify that it is the correct acquisition type and that it
    %has been reconstructed
    
    acquisition_valid=0;
    if acqui_info.ramp_type==1&&acqui_info.ecg==1&&exist('recons_info')
        acquisition_valid=1;
    end
    
    if acquisition_valid
        cycle_time_ms=[1:recons_info.size(3)]*recons_info.step(3)/1000;
        [Structure,Doppler1]=map_3D_files([pathname{acquisition} ...
            filename{acquisition}]);
        
        Doppler1_type=whos('Doppler1');
        
        if strcmp(Doppler1_type.class,'memmapfile')
            Doppler1_var=Doppler1.Data.Data;
            
            if ~isfield(recons_info,'doppler_normalization')
                recons_info.doppler_normalization=pi;
            end
            
            [Doppler1_var,max_possible_speed]=getspeed(Doppler1.Data.Data,acqui_info.line_period_us,...
                wavelength,recons_info.doppler_normalization);
%             keyboard
            Doppler_mean=mean(Doppler1_var,3);
            Structure_mean=mean(Structure.Data.Data,3);
            
            % This will ask the user to confirm whether flow is present or
            % not in the current data set
            default_answer='Yes';
            if exist('result','var')
                ask_for_verification=1;
                if isfield(result,'flow')
                    if strcmp(result.flow,'Yes')
                        ask_for_verification=0;
                    elseif strcmp(result.flow,'No')
                        ask_for_verification=1;
                        default_answer='No';
                        if strcmp(reselect_ROI,'No')
                            ask_for_verification=0;
                        end
                    end
                end
            else
                ask_for_verification=1;
            end
            
            if ask_for_verification
                draw_2D_roi(1,Doppler_mean,0,acqui_info.base_filename)
                result.flow=questdlg('Flow present?','Flow','Yes','No',...
                    'Cancel',default_answer);
            end
            
            if strcmp(result.flow,'Yes')
                %This will display the image for selection of the background, ROI and
                %diameter
                draw_2D_roi(1,Doppler_mean,0,{acqui_info.base_filename;...
                    'Select background, double click to confirm'})
                
                if isfield(result,'select_background')
                    if result.select_background==0
                        button_answer='No'; 
                    else
                        button_answer='Yes';
                    end
                else
                    result.select_background=1;
                    button_answer = questdlg('Select a background?');
                end
                
                if strcmp(button_answer,'Yes')
                    [BW_background] = roipoly;
                    result.background_mean=sum(sum((BW_background').*...
                        (Doppler_mean)))...
                        /sum(sum((BW_background)));
                    
                    result.select_background=0;
                end
                
                if isfield(result,'background_mean')
                    Doppler1_var=Doppler1_var-result.background_mean;
                    Doppler_mean=Doppler_mean-result.background_mean;
                end
                
                if isfield(result,'ROI')
                    draw_2D_roi(1,Doppler_mean,result.ROI,[acqui_info.base_filename ' ROI'])
                    
                    if strcmp(reselect_ROI,'Yes')
                        button_answer = questdlg('Select a new ROI?',...
                            'ROI','Yes','No','Cancel','No');
                    else
                        button_answer='No';
                    end
                    if strcmp(button_answer,'Yes')
                        result=rmfield(result,'ROI');
                    end
                else
                    button_answer='Yes';
                end
                
                if strcmp(button_answer,'Yes')
                    no_ROI_selected=1;
                    while no_ROI_selected
                        draw_2D_roi(1,Doppler_mean,0,'Select ROI, double click to confirm')
                        [result.ROI.BW,result.ROI.x_poly,result.ROI.z_poly] = roipoly;%(color_img_doppler);
                        draw_2D_roi(1,Doppler_mean,result.ROI,'Select vessel diameter')
                        [result.ROI.x_diam,result.ROI.z_diam] = ginput(2);
                        draw_2D_roi(1,Doppler_mean,result.ROI,[acqui_info.base_filename ' ROI'])
                        if size(result.ROI.BW)~=size(Doppler_mean')
                            msgbox('ROI exceeds image size, please reselect','ROI too large','warn');
                            result=rmfield(result,'ROI');
                        else
                            no_ROI_selected=0;
                        end
                    end
                else
                    result.ROI.BW = POLY2MASK(result.ROI.x_poly,result.ROI.z_poly,...
                        recons_info.size(2),recons_info.size(1));
                end
                
                if ishandle(100);close(100);end
                draw_2D_roi2(100,Structure_mean,Doppler_mean,recons_info,result.ROI)
                
                %This will make the figure larger and save it to a png image
                current_position=get(gca,'position');
                set(gca,'position',[0 0 1 1])
                figure(100);pause(0.1)
                print(100,[acqui_info.filename '-roi.tiff'],'-dtiff')
                print(100,[acqui_info.filename '-roi.pdf'],'-dpdf')
                
                % This will redefine the BW mask to insure it is the same size as
                % the single frame, this is necessary if the frame size has changed
                % of 1 or 2 pixels but that the roi was not reselected
                ROI_size=sum(sum(result.ROI.BW));
                for i=1:recons_info.size(3);
                    current_frame=squeeze(Doppler1_var(:,:,i)).*(result.ROI.BW)';
                    
                    frame_trimmed{i}=current_frame(floor(min(result.ROI.x_poly)):...
                        ceil(max(result.ROI.x_poly)),...
                        floor(min(result.ROI.z_poly)):ceil(max(result.ROI.z_poly)));
                    
                    
                      %This is not accurate, this is not actually a measure
                      %of the blood speed but really a measure of the blood flow.
                    blood_speed(i)=double(sum(sum(frame_trimmed{i})));
                    
                    
                    %This is the blood flow in nLps projected onto the z
                    %axis
                    blood_flow_projected(i)=blood_speed(i)*recons_info.step(1)*recons_info.step(2)*1e-3;
                    
                    max_speed(i)=double(max(max(abs(frame_trimmed{i}))));
                    
                    if rem(i,10)==0
                        draw_2D_roi2(2,double(Structure.Data.Data(:,:,i)),...
                            Doppler1_var(:,:,i),recons_info)
                        print(['Figures/' acqui_info.base_filename 'Time_slice' num2str(i) '.pdf'],'-dpdf')
                    end
                end
                
                Doppler_thresholded=Doppler1_var.*repmat((result.ROI.BW)',[1 1 100]);
                maximal_speed=max(max(max(abs(Doppler_thresholded))));
                Area=squeeze(sum(sum(abs(Doppler_thresholded)>maximal_speed*area_threshold)));
                                
                % This is the new technique for calculating the width of the
                % vessel, it will estimate the vessel width using a 2nd
                % degree polynomial and find the width by calculating the
                % distance between it's zeros                
                if 0
                    width=zeros(size(frame_trimmed{i},1),recons_info.size(3));
                    for i=1:recons_info.size(3);
                        frame_not_trimmed{i}=squeeze(Doppler1_var(floor(min(result.ROI.x_poly)):...
                            ceil(max(result.ROI.x_poly)),floor(min(result.ROI.z_poly)):...
                            ceil(max(result.ROI.z_poly)),i));
                        frame_estimated{i}=zeros(size(frame_trimmed{i}));
                        
                        max_line{i}=zeros(size(frame_trimmed{i},1),1);
                        min_line{i}=zeros(size(frame_trimmed{i},1),1);
                        for j=3:size(frame_trimmed{i},1)-3
                            non_zero_positions=find(abs(frame_trimmed{i}(j,:))>area_threshold*max(max_possible_speed));
                            if numel(non_zero_positions)>10
                                positions=non_zero_positions(1):non_zero_positions(end);
                                % plot(frame_trimmed{i}(j,positions))
                                % pause
                                p=polyfit(positions,double(frame_trimmed{i}(j,positions)),2);
                                
                                
                                % fitted_vessel(j,:)=polyval(p,1:size(frame_trimmed{i},2));
                                diameter_roots=roots(p);
                                diameter=abs(diameter_roots(2)-diameter_roots(1));
                                if (diameter<2*numel(positions))&&isreal(roots(p))
                                    width(j,i)=diameter;
                                    max_line{i}(j)=diameter_roots(2);
                                    min_line{i}(j)=diameter_roots(1);
                                    zero_indexes=[1:round(min(diameter_roots))...
                                        round(max(diameter_roots)):size(frame_trimmed{i},2)];
                                    if numel(zero_indexes)>0
                                    if (max(zero_indexes)<size(frame_trimmed{i},2))&&(min(zero_indexes)>=1)
                                        frame_estimated{i}(j,:)=polyval(p,1:size(frame_trimmed{i},2));
                                        frame_estimated{i}(j,zero_indexes)=0;
                                    end
                                    end
                                else
                                    width(j,i)=0;%numel(positions);
                                end
                                
                            end
                            %figure(1);plot([frame_estimated{1}(j,:);frame_not_trimmed{1}(j,:)]');title([num2str(i) ' ' num2str(diameter_roots')]);pause(0.1)
                        end
                        
                        if 0 %This is to display the vessel width
                            current_FOV_x=recons_info.step(1)*[1:size(frame_trimmed{i},1)];
                            current_FOV_z=recons_info.step(2)*[1:size(frame_trimmed{i},2)];
                            
                            figure(1);subplot(1,3,1);
                            imagesc(current_FOV_z,current_FOV_x,frame_not_trimmed{i},max_possible_speed*[-1 1]);
                            
                            title(num2str(i));
                            subplot(1,3,2);
                            imagesc(current_FOV_z,current_FOV_x,frame_estimated{i},max_possible_speed*[-1 1]);
                            
                            colormap(doppler_color_map)
                            
                            [positions_with_diameter]=find(max_line{i});
                            line(recons_info.step(2)*max_line{i}...
                                (positions_with_diameter),positions_with_diameter)
                            line(recons_info.step(2)*min_line{i}...
                                (positions_with_diameter),positions_with_diameter)
                            
                            subplot(1,3,3);
                            difference=abs(frame_not_trimmed{i}-int16(frame_estimated{i}));
                            imagesc(current_FOV_z,current_FOV_x,difference,max_possible_speed*[-1 1])
                            
                            pause(0.005)
                        end
                        Vessel_width(i)=mean(nonzeros(width(:,i)));
                    end
                else
                    Vessel_width(i)=0;
                end
                result.blood_speed=blood_speed;
                 
                blood_speed=abs(blood_speed); %This will make sure everything is treated the same
                smooth_filter_width=round(smoothing_time/recons_info.step(3));
                blood_speed_filtered=smooth_data_periodic(blood_speed,smooth_filter_width);
                %                 size(Area)
                Area_filtered=smooth_data_periodic(Area,smooth_filter_width);
                Vessel_width_filtered=smooth_data_periodic(Vessel_width,smooth_filter_width);
                
                %This will evaluate the quality of fit, the lower the
                %better
                qof_values=(blood_speed_filtered-blood_speed)./blood_speed;
                qof_values=abs(qof_values);
                QOF=mean(qof_values); %This is the quality of fit
                
                baseline_blood_speed=min(blood_speed_filtered);
                blood_speed_change=(blood_speed_filtered-baseline_blood_speed)/...
                    baseline_blood_speed;
                baseline_shift=find(blood_speed_change==0);
                systole_position=find(blood_speed_change==max(blood_speed_change));
                systole_blood_speed_change=blood_speed_change(systole_position);
                blood_speed_change_shifted=[blood_speed_change(baseline_shift:end)...
                    blood_speed_change(1:baseline_shift-1)];
                
                baseline_Area=Area_filtered(baseline_shift);
                Area_change=(Area_filtered-baseline_Area)/baseline_Area;
                
                systole_Area_change=Area_change(systole_position);
                Area_change_shifted=[Area_change(baseline_shift:end)...
                    Area_change(1:baseline_shift-1)];
                
                baseline_Vessel_width=Vessel_width_filtered(baseline_shift);
                Vessel_width_change=(Vessel_width_filtered-baseline_Vessel_width)/baseline_Vessel_width;
                
                systole_Vessel_width_change=Vessel_width_change(systole_position);
                Vessel_width_change_shifted=[Vessel_width_change(baseline_shift:end)...
                    Vessel_width_change(1:baseline_shift-1)];
                
                if 0
                    %This will print the output from the calculations
                    figure(7) %This is a graph that shows the averaging
                    plot(cycle_time_ms,blood_speed/max(blood_speed),'ko',...
                        cycle_time_ms,blood_speed_filtered/max(blood_speed),'k-',...
                        cycle_time_ms,Area/max(Area),'kx',...
                        cycle_time_ms,Area_filtered/max(Area),'k:',...
                        cycle_time_ms,Vessel_width/max(Vessel_width),'k+',...
                        cycle_time_ms,Vessel_width_filtered/max(Vessel_width),'k.-',...
                        'Linewidth',1.5);
                    
                    
                    h(1)=xlabel('Time in cardiac cycle (ms)');
                    h(2)=ylabel('A.U.');
                    h(3)=title({acqui_info.base_filename;...
                        ['Filtering window : ' num2str(smoothing_time) 'ms']});
                    h(4)=legend('Blood Speed','Filtered Blood Speed',...
                        'Vessel area','Filtered Vessel area','Vessel width','Filtered Vessel width','Location','Best');
                    set(h,'Fontsize',14)
                    print(7,'-dpdf',[acqui_info.filename '_flow_on_cardiac_cycle.pdf'])
                    
                    figure(8)
                    plot(cycle_time_ms,100*blood_speed_change_shifted,'k-',...
                        cycle_time_ms,100*Area_change_shifted,'k:',...
                        cycle_time_ms,100*Vessel_width_change_shifted,'k.-','Linewidth',1.5)
                    
                    h(1)=xlabel('Time after baseline flow (ms)');
                    h(2)=ylabel('Change from diastole baseline (%)');
                    h(3)=legend('Blood flow','Vessel area','Location','Best');
                    h(4)=title({acqui_info.base_filename;...
                        ['Systole flow change ' num2str(round(...
                        systole_blood_speed_change*1000)/10) ...
                        ' %, Systole area change ' num2str(round(...
                        systole_Area_change*1000)/10) ' %'];...
                        ['Quality of fit :' num2str(round(QOF*1000)/10) '%']});
                    set(h,'Fontsize',14)
                    print(8,'-dpdf',[acqui_info.filename '_baseline_comparison.pdf'])
                end
                
                %These are all the results I want to save
                result.QOF=QOF;
                result.blood_flow_projected=blood_flow_projected; %This is in nLps
                result.systole_blood_speed_change=systole_blood_speed_change;
                result.systole_Area_change=systole_Area_change;
                result.blood_speed_filtered=blood_speed_filtered;
                speed_change_variability=std(abs(result.blood_speed_filtered))/mean(abs(result.blood_speed_filtered));
                result.speed_change_variability=speed_change_variability;
                result.blood_speed_change_shifted=blood_speed_change_shifted;
                result.baseline_shift=baseline_shift;
                result.Area=Area;
                result.Area_filtered=Area_filtered;
                result.Structure_mean=Structure_mean;
                result.Doppler_mean=Doppler_mean;
                result.diameter=sqrt((recons_info.step(1)*(result.ROI.x_diam(1)-result.ROI.x_diam(2)))^2+(recons_info.step(2)*(result.ROI.z_diam(1)-result.ROI.z_diam(2)))^2);
                result.width=Vessel_width*recons_info.step(2);
                
%                 keyboard
                disp(['Acq. ' num2str(acquisition) ': ' acqui_info.base_filename ' blood speed change calculated'])
                
            else
                disp(['Acq. ' num2str(acquisition) ': ' acqui_info.base_filename ' no flow visible'])
            end
            resave_acqui_info;
        else
            disp(['Acq. ' num2str(acquisition) ': ' acqui_info.base_filename ' not reconstructed'])
            
        end
    else
        disp(['Acq. ' num2str(acquisition) ': ' acqui_info.base_filename ' invalid for 2D+time blood speed characterization'])
    end
    
end
end

function data_filtered=smooth_data_periodic(data,filter_width)

averaging_window=hann(filter_width)/sum(hann(filter_width));
data_triple=[data(:);data(:);data(:)]';
data_filtered=conv(data_triple,averaging_window,'same');
data_filtered=data_filtered(length(data)+1:2*length(data));
end

