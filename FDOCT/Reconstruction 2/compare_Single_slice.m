function compare_Single_slice(pathname,filename)

close all
if ~exist('pathname','var')
    [pathname,filename]=prompt_acquisition('Select files containing 2D slices to compare');
end

if isstr(filename{1})
    [pathname,filename]=pair_filenames(pathname,filename);
end

for zone_number=1:numel(pathname)
    separators=findstr(pathname{zone_number},'\');
        zone_name=pathname{zone_number}(separators(end-1)+1:separators(end)-1);
    orphan_slice=0;
    
    if isfield(filename{zone_number},'X')&&isfield(filename{zone_number},'Y')
        if isfield(filename{zone_number},'Slice')
            orphan_slice=1;
        end
    else
        orphan_slice=1;
    end
    
    if orphan_slice
        
        if isfield(filename{zone_number},'X')&&~isfield(filename{zone_number},'Y')
            current_filename=filename{zone_number}.X;
            Slice_info=load([pathname{zone_number} filename{zone_number}.X]);
        elseif ~isfield(filename{zone_number},'X')&&isfield(filename{zone_number},'Y')
            current_filename=filename{zone_number}.Y;
            Slice_info=load([pathname{zone_number} filename{zone_number}.Y]);
        else
            current_filename=filename{zone_number}.Slice;
            Slice_info=load([pathname{zone_number} filename{zone_number}.Slice]);
        end
        
        valid_data=0;
        if isfield(Slice_info,'result')
            if isfield(Slice_info.result,'flow')
                if strcmp(Slice_info.result.flow,'Yes')
                    valid_data=1;
                else
                    disp(['No flow detected'])
                end
            end
        else
            disp(['Zone ' num2str(zone_number) ' ' zone_name ' : Result not calculated'])
        end
        
        if valid_data
            
            speed=abs(Slice_info.result.blood_speed/1e3/sum(sum(Slice_info.result.ROI.BW)));
            speed_filtered=Slice_info.result.blood_speed_filtered/1e3/sum(sum(Slice_info.result.ROI.BW));
            max_position=find(speed_filtered==max(speed_filtered));
            
            draw_2D_roi2([1 1 2 1],Slice_info.result.Structure_mean,...
                Slice_info.result.Doppler_mean,Slice_info.recons_info,Slice_info.result.ROI)
            h_title=title(['Slice' current_filename],'Color','b');
            set(h_title,'Fontsize',14)
            
            fullscreen = get(0,'ScreenSize');
            figure(1)
            set(1,'Position',[50 100 fullscreen(3)-100 fullscreen(4)-200])
            
            subplot(1,2,2)
            plot(speed)
            hold on
            plot(speed_filtered,'LineStyle','-.','Linewidth',2);
           
            
            legend(['Flow speed Slice, mean = ' num2str(mean(speed))...
                ', Variation = ' num2str(round(Slice_info.result.systole_blood_speed_change*100)) '%'],...
                'Location','Best')
            
            
            Yticks=get(gca,'Ytick');
            line(Slice_info.result.baseline_shift*[1 1],...
                [Yticks(1) Yticks(end)],...
                'LineStyle',':','Linewidth',2)
            line([Slice_info.result.baseline_shift max_position max_position],...
                [speed_filtered(Slice_info.result.baseline_shift)...
                speed_filtered(Slice_info.result.baseline_shift)...
                speed_filtered(max_position)],...
                'LineStyle',':','Linewidth',3)
             hold off
             
            if isfield(Slice_info.result,'valid')
                if Slice_info.result.valid
                    default_answer='Keep';
                else
                    default_answer='Reject';
                end
            else
                default_answer='Keep';
            end
            
            answer=questdlg('Keep data?','Slice flow','Keep','Reject','Cancel',default_answer);
            if strcmp(answer,'Keep')
                Slice_info.result.valid=1;
            elseif strcmp(answer,'Reject')
                Slice_info.result.valid=0;
            end
            
            acqui_info=Slice_info.acqui_info;
            recons_info=Slice_info.recons_info;
            result=Slice_info.result;
            resave_acqui_info
            
        end
    end
end