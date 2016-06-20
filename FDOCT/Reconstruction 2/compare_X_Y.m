function compare_X_Y(pathname,filename)
close all
if ~exist('pathname','var')
    [pathname,filename]=prompt_acquisition('Select files containing 2D slices to compare');
end

if isstr(filename{1})
    [pathname,filename]=pair_filenames(pathname,filename);
end


recheck_result=questdlg(['Do you want to be asked to recheck all the results'],...
    'Recheck results','Yes','No','Cancel','No');


for zone_number=1:numel(pathname)
    if isfield(filename{zone_number},'X')&&isfield(filename{zone_number},'Y')
        
        X_info=load([pathname{zone_number} filename{zone_number}.X]);
        Y_info=load([pathname{zone_number} filename{zone_number}.Y]);
        
        separators=findstr(pathname{zone_number},'\');
        zone_name=pathname{zone_number}(separators(end-1)+1:separators(end)-1);
        %         keyboard
        valid_data=0;
        keyboard
        
        if isfield(X_info,'result')&&isfield(Y_info,'result')
            if isfield(X_info.result,'flow')&&isfield(Y_info.result,'flow')
                if strcmp(X_info.result.flow,'Yes')&&strcmp(Y_info.result.flow,'Yes')
                    % When there is flow in the X and Y directions then
                    % they are compared to each other, otherwise it will do
                    % the single slice question
                    valid_data=1;
                elseif strcmp(X_info.result.flow,'Yes')&&strcmp(Y_info.result.flow,'No')&&strcmp(recheck_result,'Yes')
                        compare_Single_slice({pathname{zone_number}},{filename{zone_number}.X})
                elseif strcmp(X_info.result.flow,'No')&&strcmp(Y_info.result.flow,'Yes')&&strcmp(recheck_result,'Yes')
                    compare_Single_slice({pathname{zone_number}},{filename{zone_number}.Y})
                else
                    disp(['Zone ' num2str(zone_number) ' ' zone_name ' : No flow detected'])
                end
            end
        else
            disp(['Zone ' num2str(zone_number) ' ' zone_name ' : Result not calculated'])
        end
        
        if valid_data
            
            fullscreen = get(0,'ScreenSize');
            figure(1)
            set(1,'Position',[50 100 fullscreen(3)-100 fullscreen(4)-200])
            
            draw_2D_roi2([1 2 2 1],X_info.result.Structure_mean,...
                X_info.result.Doppler_mean,X_info.recons_info,X_info.result.ROI)
            h_title(1)=title('X Slice','Color','b');
            draw_2D_roi2([1 2 2 3],Y_info.result.Structure_mean,...
                Y_info.result.Doppler_mean,Y_info.recons_info,Y_info.result.ROI)
            h_title(2)=title('Y Slice','Color',[0 0.5 0]);
            set(h_title,'Fontsize',14)
            
            plot_comparison([1 1 2 2],X_info,Y_info,zone_name)
            
            if isfield(X_info.result,'valid')
                if X_info.result.valid
                    default_answer_X='Keep';
                else
                    default_answer_X='Reject';
                end
                recheck_X_now=recheck_result;
            else
                default_answer_X='Keep';
                recheck_X_now='Yes';
            end
            
            if isfield(Y_info.result,'valid')
                if Y_info.result.valid
                    default_answer_Y='Keep';
                else
                    default_answer_Y='Reject';
                end
                recheck_Y_now=recheck_result;
            else
                default_answer_Y='Keep';
                recheck_Y_now='Yes';
            end
            
            if strcmp(recheck_X_now,'Yes')
                answer_X=questdlg('Keep X data?','X flow','Keep','Reject','Cancel',default_answer_X);
            else
                answer_X='Cancel';
            end
            
            if strcmp(answer_X,'Keep')
                X_info.result.valid=1;
            elseif strcmp(answer_X,'Reject')
                X_info.result.valid=0;
            end
            
            if strcmp(recheck_Y_now,'Yes')
                answer_Y=questdlg('Keep Y data?','Y flow','Keep','Reject','Cancel',default_answer_Y);
            else
                answer_Y='Cancel';
            end
            
            
            if strcmp(answer_Y,'Keep')
                Y_info.result.valid=1;
            elseif strcmp(answer_Y,'Reject')
                Y_info.result.valid=0;
            end
            
            acqui_info=X_info.acqui_info;
            recons_info=X_info.recons_info;
            result=X_info.result;
            resave_acqui_info
            
            acqui_info=Y_info.acqui_info;
            recons_info=Y_info.recons_info;
            result=Y_info.result;
            resave_acqui_info
            
            plot_comparison(2,X_info,Y_info,zone_name)
            comparison_name=['Comparison_' zone_name '.pdf'];
            print('-dpdf',comparison_name)
            movefile(comparison_name,['Figures/Comparisons X-Y/' comparison_name])
            %             pause
        end
        
    else
    end
end

function plot_comparison(figure_handle,X_info,Y_info,zone_name)

time_step=mean([X_info.recons_info.step(3) Y_info.recons_info.step(3)]);
time_axis=(1:X_info.recons_info.size(3))*time_step;
figure(figure_handle(1))

if numel(figure_handle)==4
    subplot(figure_handle(2),figure_handle(3),figure_handle(4))
end

speed_X=abs(X_info.result.blood_speed/sum(sum(X_info.result.ROI.BW)));
speed_Y=abs(Y_info.result.blood_speed/sum(sum(Y_info.result.ROI.BW)));
ratio_Y_X=mean(speed_Y)/mean(speed_X);
speed_Y=speed_Y/mean(speed_Y)*mean(speed_X);
speed_X_filtered=X_info.result.blood_speed_filtered/sum(sum(X_info.result.ROI.BW));
speed_Y_filtered=Y_info.result.blood_speed_filtered/sum(sum(Y_info.result.ROI.BW));
speed_Y_filtered=speed_Y_filtered/mean(speed_Y_filtered)*mean(speed_X_filtered);

X_max_position=find(speed_X_filtered==max(speed_X_filtered));
Y_max_position=find(speed_Y_filtered==max(speed_Y_filtered));

plot(time_axis,[speed_X_filtered;speed_Y_filtered]','Linewidth',2);
title(['Comparison ' zone_name])
legend(['X flow, Max/Min = '...
    num2str(round(X_info.result.systole_blood_speed_change*100))...
    '%, Variability = ' num2str(round(X_info.result.speed_change_variability*100)) ' %'],...
    ['Norm Y flow, is ' num2str(round(100*ratio_Y_X))...
    '% of X flow, Max/Min = '...
    num2str(round(Y_info.result.systole_blood_speed_change*100)) ...
    '%, Variability = ' num2str(round(Y_info.result.speed_change_variability*100)) ' %'],'Location','Best')
xlabel('Time on cardiac Cycle (ms)')
ylabel('Blood speed X (mm/s)')

Yticks=get(gca,'Ytick');
% These are the lines that indicate the position of the flow minimum
% in each slice
line(time_step*X_info.result.baseline_shift*[1 1],...
    [Yticks(1) Yticks(end)],...
    'LineStyle',':','Linewidth',2)
line(time_step*Y_info.result.baseline_shift*[1 1],...
    [Yticks(1) Yticks(end)],...
    'LineStyle',':','Color',[0 .5 0],'Linewidth',2)

% These lines indicate the distance between the minimum and the
% maximum between each slice
line(time_step*[X_info.result.baseline_shift X_max_position X_max_position],...
    [speed_X_filtered(X_info.result.baseline_shift)...
    speed_X_filtered(X_info.result.baseline_shift)...
    speed_X_filtered(X_max_position)],...
    'LineStyle',':','Linewidth',3)
line(time_step*[Y_info.result.baseline_shift Y_max_position Y_max_position],...
    [speed_Y_filtered(Y_info.result.baseline_shift)...
    speed_Y_filtered(Y_info.result.baseline_shift)...
    speed_Y_filtered(Y_max_position)],...
    'LineStyle',':','Color',[0 .5 0],'Linewidth',3)

%These lines are the mean lines
line([time_axis(1) time_axis(end)],mean(speed_X_filtered)*[1 1])
line([time_axis(1) time_axis(end)],mean(speed_Y_filtered)*[1 1],...
    'Color',[0 .5 0])
line(time_axis(round(end/2))*[1 1]-10,mean(speed_X_filtered)+...
    [std(speed_X_filtered) -std(speed_X_filtered)])
line(time_axis(round(end/2))*[1 1]+10,mean(speed_Y_filtered)+...
    [std(speed_Y_filtered) -std(speed_Y_filtered)],'Color',[0 .5 0])
