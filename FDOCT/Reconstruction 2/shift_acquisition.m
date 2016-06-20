[filenames,path]=uigetfile('mat','Select files containing 1 acquisition to shift','Multiselect','on');

if ~iscell(filenames)==1
    temp=filenames
    clear filenames
    filenames{1}=temp;
    clear temp
end

for i=1:length(filenames)
    disp(['Shifting file ' num2str(i) ' of ' num2str(length(filenames))])
    load([path filenames{i}])
    acqui_info_current=acqui_info;
    
    [pathname_temp,filename_temp,ext]=fileparts([path filenames{i}]);
    acqui_info_current.filename=[pathname_temp '\' filename_temp];
    
    if i==1
        frames_to_delete=400-acqui_info.framenumber(1);
        
        
    prompt = {'Confirm number of frames to shift'};
    dlg_title = 'Frames to shift';
    num_lines = 1;
    
    def = {num2str(frames_to_delete)};
    
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    
        frames_to_delete=str2num(answer{1});
    end
    
    disp(['Shifting ' num2str(frames_to_delete) ' frames'])
    FrameData_current=map_dat_file(acqui_info_current);
    start_frame=acqui_info_current.framenumber(1);
    
    % This initiliazes the new acqui_info structure that contains the
    % information for the new files
    acqui_info_shifted=acqui_info_current;
    acqui_info_shifted.framenumber=acqui_info_shifted.framenumber+frames_to_delete;
    acqui_info_shifted.filename=regexprep(acqui_info_shifted.filename,...
        num2str(start_frame),num2str(start_frame+frames_to_delete));
    
    start_frame_next=acqui_info_current.framenumber(end)+1;
    full_filename_next=[path regexprep(filenames{i},num2str(start_frame),num2str(start_frame_next))];
    
%     keyboard
    
    [pathname_temp,filename_temp,ext]=fileparts(full_filename_next);
    full_filename_next=[pathname_temp '\' filename_temp]
        
    if exist(full_filename_next)
        load(full_filename_next)
        acqui_info_next=acqui_info;
        acqui_info_next.filename=full_filename_next;
        FrameData_next=map_dat_file(acqui_info_next);
        ecg_signal_2files=[acqui_info_current.ecg_signal acqui_info_next.ecg_signal];
        acqui_info_shifted.ecg_signal=ecg_signal_2files(:,frames_to_delete+(1:length(acqui_info_shifted.framenumber)));
    else
        acqui_info_shifted.framenumber=acqui_info_shifted.framenumber(1:end-frames_to_delete);
        acqui_info_shifted.dat_size(3)=length(acqui_info_shifted.framenumber);
        acqui_info_shifted.ecg_signal=acqui_info_current.ecg_signal(:,frames_to_delete+1:end);
        acqui_info.nframes=length(acqui_info_shifted.framenumber);
    end
    
    Hdat=fopen([acqui_info_shifted.filename '.dat'],'w');
    
    for k=frames_to_delete+1:acqui_info_current.nframes
        fwrite(Hdat,FrameData_current.data.frames(:,:,k),'int16');
    end
    if exist(full_filename_next)
        for k=1:frames_to_delete
            fwrite(Hdat,FrameData_next.data.frames(:,:,k),'int16');
        end
    end
    fclose(Hdat);
    acqui_info=acqui_info_shifted;
    resave_acqui_info;
end