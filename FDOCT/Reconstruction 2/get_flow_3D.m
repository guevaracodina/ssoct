function get_flow_3D(pathname,filename)
wavelength=870e-6; %Wavelength in mm

load('doppler_color_map.mat')

if ~exist('pathname')
    [pathname,filename]=prompt_acquisition...
        ('Select file containing result of 3D reconstruction');
end

for acquisition=1:numel(pathname)
    %This will load each acquisition
    [Structure,Doppler1]=map_3D_files([pathname{acquisition} ...
        filename{acquisition}]);
    clear acqui_info recons_info result
    load([pathname{acquisition} filename{acquisition}])
    
    acquisition_valid=0;
    Doppler1_type=whos('Doppler1');
    if acqui_info.ramp_type==4&&exist('recons_info')...
            &&strcmp(Doppler1_type.class,'memmapfile')%&&acqui_info.rev_fast_axis==1
        acquisition_valid=1;
    end
    if acquisition_valid
        if ~exist('result')
            result.temp=1;
        end
        
        %% This first part is to select the depths to analyse
        Doppler1_mean=mean(Doppler1.Data.Data,3);
        draw_side_projection(2,Doppler1_mean,recons_info,result)
        
        if isfield(result,'top')
            button_answer=questdlg('Select new top and bottom?','Depths','Yes','No','Cancel','No');
        else
            button_answer='Yes';
        end
        
        if strcmp(button_answer,'Yes')
            draw_side_projection(2,Doppler1_mean,recons_info,struct([]))
            title({acqui_info.base_filename;...
                'Select top and bottom of vessels'})
            top_bottom=ginput(2);
            top_bottom=top_bottom/recons_info.step(2);
            result.top=floor(min(top_bottom(:,2)));
            result.bottom=ceil(max(top_bottom(:,2)));
        end
        depth_range=result.top:result.bottom;
        
        close all
        if ~isfield(result,'vessel_angle')
            result.vessel_angle=determine_vessel_angle(Doppler1.Data.Data,recons_info);
        end
        
        draw_side_projection(2,Doppler1_mean,recons_info,result)
        
        if ~isfield(recons_info,'doppler_normalization')
            recons_info.doppler_normalization=pi;end
        
        [XY_speed_3D,max_speed]=getspeed(squeeze(Doppler1.Data.Data(:,depth_range,:)),...
            acqui_info.line_period_us,wavelength,recons_info.doppler_normalization);
        
        % This is the area of each pixel in mm^2
        area_per_pixel=recons_info.step(1)*recons_info.step(3)*1e-6;
        
        Speed_to_display=squeeze(max(abs(XY_speed_3D),[],2)).*squeeze(sign(mean(XY_speed_3D,2)));
        draw_top_projection(1,Speed_to_display,max_speed,recons_info,result)
        
        if isfield(result,'y_poly')
            button_answer=questdlg('Select new ROI?','ROI','Yes','No','Cancel','No');
        else
            button_answer='Yes';
        end
        
        if strcmp(button_answer,'Yes')
            draw_top_projection(1,Speed_to_display,max_speed,recons_info,struct([]))
            title({acqui_info.base_filename;...
                'Select ROI, double click to confirm'})
            [result.BW,result.y_poly,result.x_poly] = roipoly; %This will open up a roi selection tool
            draw_top_projection(1,Speed_to_display,max_speed,recons_info,result)
            title('Select diameter of vessel')
            pause(0.1)
            [result.diam_pos_y,result.diam_pos_x] = ginput(2);
        end
        
        draw_top_projection(1,Speed_to_display,max_speed,recons_info,result)
        
        diameter=round(sqrt((result.diam_pos_y(1)-result.diam_pos_y(2))^2+...
            (result.diam_pos_x(1)-result.diam_pos_x(2))^2));
        area=sum(sum(result.BW))*area_per_pixel; % This is the area of the selected roi in mm^2
        
        title({[filename{acquisition}];...
            ['Area ~' num2str(round(area*1000))...
            ' X 10^{-3} mm^2, Vessel diameter : ' num2str(diameter) ' um']})
        
        BW_3D=zeros(size(XY_speed_3D));
        for i=1:numel(depth_range)
            BW_3D(:,i,:)=result.BW;
        end
        
        flow_positive=sum(sum(BW_3D.*XY_speed_3D.*(XY_speed_3D>0),1),3)*area_per_pixel*1e3;
        flow_negative=sum(sum(BW_3D.*XY_speed_3D.*(XY_speed_3D<0),1),3)*area_per_pixel*1e3;
        flow_difference=abs(flow_positive+flow_negative);
        flow_sum=flow_positive-flow_negative;
        
        figure(5);h=plot(depth_range*recons_info.step(2),[flow_positive;-1*flow_negative;flow_difference;flow_sum]');
        set(h(1),'color','r')
        set(h(2),'color','b')
        set(h(3),'color','k')
        
        legend('Positive flow','Negative flow','Flow difference','Flow sum')
        xlabel('Depth (um)')
        ylabel('Blood Flow (nL/s)')
        
        speed=sum(sum(BW_3D.*XY_speed_3D,1),3);
        flow_uLps=speed*area_per_pixel;
        
        flow_Lpm=flow_uLps*1e-6*60;
        flow_nLps=flow_uLps*1e3;
        max_flow=max(abs(flow_nLps));
        min_flow=min(abs(flow_nLps));
        depth_max_flow=depth_range(find(abs(flow_nLps)==max_flow));
        
        figure(3)
        plot(depth_range*recons_info.step(2),flow_uLps*1000./sign(flow_uLps))
        title({['Mean flow : ' num2str(mean(flow_uLps*1000)) ' nL/s, Std : '...
            num2str(std(flow_uLps*1000))];...
            ['Max flow : ' num2str(round(max_flow*10)/10) ' nL/s, Min flow : '...
            num2str(round(min_flow*10)/10) ' nL/s']})
        xlabel('Depth (um)')
        ylabel('Blood Flow (nL/s)')
        
        %         position_initial=get(1,'position');
        %         set(1,'position',[200 500 position_initial(3) position_initial(4)])
        %         set(3,'position',[850 500 position_initial(3) position_initial(4)])

        button_keep=questdlg('Keep Data?','Data Valid','Keep','Reject','Cancel','Keep');
        
        if strcmp(button_keep,'Keep')
            result.valid=1;
        elseif strcmp(button_keep,'Reject')
            result.valid=0;
        else
        end
        
        pause(0.5)
        
        print(1,['Figures/3D ROI/' acqui_info.base_filename 'roi.pdf'],'-dpdf')
        print(2,['Figures/3D ROI/' acqui_info.base_filename 'depth.pdf'],'-dpdf')
        print(3,['Figures/3D ROI/' acqui_info.base_filename 'flow.pdf'],'-dpdf')
        
        result.depth_range=depth_range;
        result.depth_max_flow=depth_max_flow;
        result.diameter=diameter;
        result.flow_nLps=flow_nLps;
        result.max_flow=max_flow;
        result.min_flow=min_flow;
        resave_acqui_info
    else
        disp(['Acquisition ' num2str(acquisition) ' invalid for 3D flow measurement'])
    end
end

function draw_top_projection(figure_handle,Speed_to_display,max_speed,recons_info,result)
load('doppler_color_map.mat')
figure(figure_handle)
% subplot(1,2,1)
FOV=recons_info.step.*recons_info.size;
imagesc([0 FOV(3)],[0 FOV(1)],Speed_to_display,max_speed*[-1 1]/2)
axis image
colormap(doppler_color_map);xlabel('Y (um)');ylabel('X (um)')
colorbar_handle=colorbar;
set(get(colorbar_handle,'ylabel'),'String', 'Z speed (mm/s)');

if isfield(result,'y_poly')
    h_line=line(result.y_poly,result.x_poly);set(h_line,'Color','k');...
        set(h_line,'LineWidth',2) %This will draw the roi that was selected
    xlabel('Y (um)');ylabel('X (um)')
end

if isfield(result,'diam_pos_y')
    h_diameter=line(result.diam_pos_y,result.diam_pos_x);
    set(h_diameter,'Color','k');set(h_diameter,'LineWidth',2);...
        set(h_diameter,'LineStyle',':')
end

function draw_side_projection(figure_handle,Doppler1_mean,recons_info,result)
figure(figure_handle)
[m n]=size(Doppler1_mean);
load('doppler_color_map.mat')
% keyboard
imagesc([0 recons_info.size(1)*recons_info.step(1)],...
    [0 recons_info.size(2)*recons_info.step(2)],Doppler1_mean',5000*[-1 1])
axis equal tight
colormap(doppler_color_map)

if isfield(result,'top')
    h(1)=line([1 m],result.top*[1 1]*recons_info.step(2));
    h(2)=line([1 m],result.bottom*[1 1]*recons_info.step(2));
    thickness=abs(result.bottom-result.top)*recons_info.step(2);
    text(0,(result.top+result.bottom)/2*recons_info.step(2),['Thickness ' num2str(round(thickness)) 'um'])
    set(h,'color','k','linestyle',':')
end
