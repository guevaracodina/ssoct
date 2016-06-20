function get_microvasculature(pathname,filename)
% This function will load reconstructed 3DHD acquisitions and allow the
% user to select the position of the microvasculature and create a MIP
% microvasculature map in log scale

wavelength=870e-6; %Wavelength in mm

if ~exist('pathname')
    [pathname,filename]=prompt_acquisition...
        ('Select reconstructed 3D HD acquisitions');
end

reselect_ROI=questdlg(['Do you want to be asked to reselect '...
    'the ROI for each acquisition?'],'Reselect ROI','Yes','No','Cancel','No');

for acquisition=1:numel(pathname)
    close all
    %This will load each acquisition
    clear acqui_info recons_info result
    load([pathname{acquisition} filename{acquisition}])
    %This will verify that it is the correct acquisition type and that it
    %has been reconstructed
    
    acquisition_valid=0;
    if acqui_info.ramp_type==6&&exist('recons_info')
        acquisition_valid=1;
    end
    
    if acquisition_valid
        [Structure,Doppler1]=map_3D_files([pathname{acquisition} ...
            filename{acquisition}]);
        Doppler1_type=whos('Doppler1');
        if strcmp(Doppler1_type.class,'memmapfile')
            Doppler1_var=Doppler1.Data.Data;
            
            if ~isfield(recons_info,'doppler_normalization')
                recons_info.doppler_normalization=pi;
            end
            
            [doppler1,max_speed]=getspeed(Doppler1.Data.Data,acqui_info.line_period_us,...
                wavelength,recons_info.doppler_normalization);
            %             filter2=design_gaussian_filter([5 5 5],recons_info.step);
            %             doppler2=convn(doppler1,filter2);
            %             filter3=design_gaussian_filter([10 10 10],recons_info.step);
            %             doppler3=convn(doppler1,filter3);
            
            select_ROI=0;
            if strcmp(reselect_ROI,'No')
                if ~isfield(result,'abc_top')
                    select_ROI=1;
                end
            else
                select_ROI=1;
            end
            
            if select_ROI
                figure(1)
                load('doppler_color_map')
                
                completed=0;
                while completed==0
                    restart_loop=0;
                    paused_for_selection=0;
                    selection_step=1;
                    current_selection_string='Select 2 top points';
                    h.select_points = uicontrol('Position',[20 20 200 40],'String',current_selection_string,...
                        'Callback','assignin(''caller'',''paused_for_selection'',1)');
                    stop_loop=0;
                    h.stop = uicontrol('Position',[240 20 200 40],'String','Restart',...
                        'Callback','assignin(''caller'',''restart_loop'',1)');
                    for i=1:recons_info.size(2)
                        figure(1)
                        imagesc(squeeze(doppler1(:,i,:)),0.1*[-1 1])
                        colormap(doppler_color_map)
                        title(num2str(i))
                        pause(0.1)
                        if paused_for_selection
                            title(['Depth ' num2str(i) ' : ' current_selection_string])
                            switch selection_step
                                case 1
                                    [y_top,x_top]=ginput(2);
                                    z_top(1:2)=i;
                                    current_selection_string='Select last top point';
                                case 2
                                    [y_top(3),x_top(3)]=ginput(1);
                                    z_top(3)=i;
                                    current_selection_string='Select two bottom points';
                                case 3
                                    [y_bottom,x_bottom]=ginput(2);
                                    z_bottom(1:2)=i;
                                    current_selection_string='Select last bottom point';
                                case 4
                                    [y_bottom(3),x_bottom(3)]=ginput(1);
                                    z_bottom(3)=i;
                                    stop_loop=1;
                                    completed=1;
                            end
                            paused_for_selection=0;
                            selection_step=selection_step+1;
                            set(h.select_points,'String',current_selection_string)
                        end
                        if restart_loop==1
                            break
                        end
                        if stop_loop
                            close(1)
                            break
                        end
                    end
                end
                
                
                XY_top=[x_top y_top [1;1;1]];
                z_top=z_top(:);
                result.abc_top=XY_top\z_top;
                
                XY_bottom=[x_bottom y_bottom [1;1;1]];
                z_bottom=z_bottom(:);
                result.abc_bottom=XY_bottom\z_bottom;
                
            end
            
            x_step=1:100:recons_info.size(1);
            y_step=1:100:recons_info.size(3);
            top_surf_function=inline('result.abc_top(1)*x+result.abc_top(2)*y+result.abc_top(3)');
            bottom_surf_function=inline('result.abc_bottom(1)*x+result.abc_bottom(2)*y+result.abc_bottom(3)');
            
            z_top_surf=repmat((result.abc_top(1)*x_step)',[1 numel(y_step)])+...
                repmat((result.abc_top(2)*y_step),[numel(x_step) 1])+result.abc_top(3);
            z_bottom_surf=repmat((result.abc_bottom(1)*x_step)',[1 numel(y_step)])+...
                repmat((result.abc_bottom(2)*y_step),[numel(x_step) 1])+result.abc_bottom(3);
            
            figure(2)
            surf(z_top_surf)
            shading interp
            hold on
            surf(z_bottom_surf)
            shading interp
            hold off
            
            Test=Doppler1_var;
            
            x=[1 recons_info.size(1) recons_info.size(1) 1];
            for j=1:recons_info.size(3)
                z=round([top_surf_function(result,1,j) top_surf_function(result,recons_info.size(1),j)...
                    bottom_surf_function(result,recons_info.size(1),j) bottom_surf_function(result,1,j)]);
                BW=poly2mask(x,z,recons_info.size(2),recons_info.size(1));
                Current_slice=Test(:,:,j);
                Current_slice=double(Current_slice)'.*BW;
                Test(:,:,j)=Current_slice';
            end
            
            microvasculature_MIP=squeeze(max(log(double(abs(Test))),[],2));
            figure(3)
            imagesc([0 recons_info.size(1)*recons_info.step(1)],...
                [0 recons_info.size(3)*recons_info.step(3)],microvasculature_MIP,[4 8])
            axis equal tight
            colormap gray
            print(3,['Figures/3D Angio/' acqui_info.base_filename 'angio.pdf'],'-dpdf')
            
            result.microvasculature_MIP=microvasculature_MIP;
            
            resave_acqui_info;
        else
            disp(['Acq. ' num2str(acquisition) ': ' acqui_info.base_filename ' not reconstructed'])
            
        end
    else
        disp(['Acq. ' num2str(acquisition) ': ' acqui_info.base_filename...
            ' invalid for microvasculature detection'])
    end
    
end
end
