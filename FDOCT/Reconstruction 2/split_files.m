prompt = {'Split files in how many parts ?'};
dlg_title = 'Splitting files';
num_lines = 1;

def = {num2str(2)};

answer = inputdlg(prompt,dlg_title,num_lines,def);

if ~isempty(answer)
    parts=str2num(answer{1});
    
    [filenames,path]=uigetfile('mat','Select files containing acquisition','Multiselect','on');
    
    if ~iscell(filenames)==1
        temp=filenames
        clear filenames
        filenames{1}=temp;
        clear temp
    end
    
    for i=1:length(filenames)
        disp(['Spliting file ' num2str(i) ' of ' num2str(length(filenames))])
        load([path filenames{i}])
        frames_per_file=acqui_info.nframes/parts;
        start_frame=acqui_info.framenumber(1);
        FrameData=map_dat_file(acqui_info);
        
        if rem(frames_per_file,1)~=0
            disp(['Cannot divide file in ' num2str(parts) ' parts'])
            break
        end
        
        acqui_info_split=acqui_info;
        acqui_info_split.dat_size(3)=frames_per_file;
        acqui_info_split.nframes=frames_per_file;
        
        for j=1:parts
            load([path filenames{i}])
            
            frames=1+(j-1)*frames_per_file:j*frames_per_file;
            acqui_info_parts{j}=acqui_info_split;
            acqui_info_parts{j}.framenumber=acqui_info.framenumber(frames);
            
            [pathname_temp,filename_temp,ext]=fileparts(acqui_info.filename);
            filename_temp=regexprep(filename_temp,num2str(start_frame),num2str(acqui_info_parts{j}.framenumber(1)));
            acqui_info_parts{j}.filename=[pathname_temp '\' filename_temp '-split'];
            acqui_info_parts{j}.ecg_signal=acqui_info.ecg_signal(:,frames);
            
            Hdat=fopen([acqui_info_parts{j}.filename '.dat'],'w');
            fwrite(Hdat,FrameData.data.frames(:,:,frames),'int16');
            fclose(Hdat);
            clear Hdat
            
            acqui_info_temp=acqui_info;
            acqui_info=acqui_info_parts{j};
            resave_acqui_info;
            acqui_info=acqui_info_temp;
        end
    end
end