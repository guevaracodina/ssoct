% This is a brand new reconstruction script that is not based on
% anything done before, it will be independant of the acquisition type

if ~exist('pathname')
    select_new=1;
else
    if isempty(pathname)
        select_new=1;
    else
        select_new=0;
    end
end

if select_new
    clear all
    close all
    [pathname,filename]=prompt_acquisition...
        ('Select first file of the acquisition to reconstruct');
end
[pathname,filename]=concatenate_acquisition(pathname,filename);

number_of_acquisitions=numel(pathname);
wb=waitbar(0,'');
% keyboard
for acquisition=1:number_of_acquisitions;
    clear acqui_info recons_info result
    load([pathname{acquisition} filename{acquisition}])
    
    %FrameData is a cell with dimensions of number of files in the
    %acquisition
    [FrameData]=map_dat_file(acqui_info);
    type_of_acquisition=acqui_info.ramp_type;
    total_frames=acqui_info.nframes*acqui_info.nfiles;
    
    recons_info=define_recons_parameters(acqui_info);
    
    filter_kernel=design_filter_kernel(recons_info.dop1_prop.kernel_sigma,...
        acqui_info.line_period_us*1e-6);
    %This is the amount of frames necessary to fit the filter kernel in
    kernel_frame_overlap=floor(numel(filter_kernel)/acqui_info.dat_size(2));
    wavenumbers=wavelengths2wavenumbers(acqui_info.wavelengths);
    
    %     [ref_2D,wavenumbers,HPF,window_2D]=make_frame2gamma_vars(acqui_info,...
    %         recons_info.dat2cpx_prop);
    
    window=ones(recons_info.dop1_prop.zwindow,recons_info.dop1_prop.rwindow);
    
    %% Initialize final 3D variables, these are global variables to avoid
    %% having to pass them as inputs to different functions
    global Structure_global Doppler1_global
    Structure_global=zeros(recons_info.size);
    Doppler1_global=zeros(recons_info.size);
    No_of_A_lines=zeros(recons_info.size(1),recons_info.size(3));
    
    %This will mark where the structure begins and ends and will stretch if
    %certain frames go higher or lower.
    struct_min_max_depth=[recons_info.size(2) 1];
    
    %% This is the timer used for the waitbar time remaining estimation
    ETA_text='Compensating dispersion';
    
    for current_frame=1:total_frames;
        if current_frame>size(recons_info.A_line_position,2)
            warning('Requested frame number exceeds number of frames, please verify')
            keyboard
        end
        if current_frame==2
            tic
        end
        
        current_file=ceil(current_frame/acqui_info.nframes);
        local_frame_number=current_frame-(current_file-1)*acqui_info.nframes;
        
        waitbarmessage={['Acq. ' num2str(acquisition) ' of '...
            num2str(number_of_acquisitions) ' : ' acqui_info.base_filename...
            ' with ' num2str(acqui_info.nfiles) ' files'];...
            [ETA_text  ', Frame ' num2str(current_frame) ' of '...
            num2str(total_frames) ', ' num2str(round(100*current_frame/total_frames))...
            '%']};
        
        if ishandle(wb);waitbar(current_frame/total_frames,wb,waitbarmessage);
        else;disp(waitbarmessage);end
        
        switch acqui_info.ramp_type
            case 6
                slice_first_frame=1+acqui_info.HD_info.framesperslice*...
                    floor((local_frame_number-1)/acqui_info.HD_info.framesperslice);
                slice_last_frame=slice_first_frame-1+...
                    acqui_info.HD_info.framesperslice;
                frame_range=local_frame_number-kernel_frame_overlap:...
                    local_frame_number+kernel_frame_overlap;
                frame_range=frame_range(frame_range>=slice_first_frame);
                frame_range=frame_range(frame_range<=slice_last_frame);
                extract_range=(find(frame_range==local_frame_number)-1)*...
                    acqui_info.dat_size(2)+(1:acqui_info.resolution);
            otherwise
                frame_range=local_frame_number;
                extract_range=(1:acqui_info.dat_size(2));
        end
        
        if frame_range>0
            frame=squeeze(FrameData{current_file}.Data.frames(:,:,frame_range));
            [m,n,o]=size(frame);
            frame=reshape(frame,m,n*o);
            
            [gamma_real,gamma_imag,recons_info.dispersion]=...
                frame2gamma(frame,acqui_info.reference,wavenumbers,recons_info.dispersion);
            
            %This will give the structural frame in dB above noise floor
            [structure_current,frame_mask]=...
                get_frame_struct(gamma_real,gamma_imag,recons_info.mask_prop);
            
            structure_extracted=structure_current(:,extract_range);
            struct_depth=find(sum(frame_mask,2)>0);
            struct_depth2=find(sum(frame_mask,2)>size(frame_mask,2)/2);
            
            struct_min_max_depth=min([struct_min_max_depth(1) min(struct_depth)]):...
                max([struct_min_max_depth(end) max(struct_depth)]);
            
            doppler_current=doppler_processing(gamma_real,...
                gamma_imag,filter_kernel,window,frame_mask);
            if acqui_info.ramp_type==6
                doppler_current=remove_physiology(doppler_current,frame_mask);
            end
            doppler_extracted=doppler_current(:,extract_range);
            
            if 0
                if current_frame<10
                    doppler_test=doppler_extracted;
                    doppler_test(1:20,:)=0;
                    doppler_test(200:end,:)=0;
                    draw_2D_roi2(1,structure_extracted',doppler_test',recons_info)
                    print(['Figures/First Slices/' acqui_info.base_filename ' Slice_' num2str(current_frame) '.pdf'],'-f1','-dpdf')
                end
            end
            
            [npixels,total_frames_temp,depth_temp]=...
                size(recons_info.A_line_position);
            
            %This function will place the frames inside the Structure and
            %Doppler global variables based on their position declared in
            %the A_line_position variable
            current_position=squeeze(recons_info.A_line_position(:,current_frame,:));
            
            No_of_A_lines=place_frame(structure_extracted,...
                doppler_extracted,current_position,No_of_A_lines);
            
            if current_frame==1
                % The first frame takes longer to execute, therefore the
                % time it takes to complete is not used to estimate the
                % remaining time
                tic
            else
                time=toc;
                ETA_text=get_ETA_text(time,current_frame-1,total_frames-1);
            end
            
        end
    end
    
    % At this point all the frames have been reconstructed and added inside
    % 2 3D matrices, one for structure and one for Doppler1, operations
    % that require the complete data set can now be performed
    
    %The first step is to reduce the amount of data by using the
    %min_max_depth defined while calculating the frames
    recons_info.size(2)=length(struct_min_max_depth);
    recons_info.struct_min_max_depth=struct_min_max_depth;
    Doppler1_global=Doppler1_global(:,struct_min_max_depth,:);
    Structure_global=Structure_global(:,struct_min_max_depth,:);
    % keyboard
    
    [No_of_A_lines]=apply_filter_and_normalize(recons_info.filter,No_of_A_lines);
    
    recons_info.No_of_A_lines=No_of_A_lines;
    recons_info.doppler_normalization=max([pi*ceil(max(max(max(abs(Doppler1_global))))/pi) pi]);
    
    Doppler1_global=Doppler1_global/recons_info.doppler_normalization*double(intmax('int16'));
    
    %Saving to disk
    Hstruct3D=fopen([acqui_info.filename '.struct3D'],'w');
    fwrite(Hstruct3D,Structure_global,'int16');fclose(Hstruct3D);
    Hdop13D=fopen([acqui_info.filename '.dop13D'],'w');
    fwrite(Hdop13D,Doppler1_global,'int16');fclose(Hdop13D);
    
    %Whenever the acquisition is reconstructed again, the variable
    %indicating there is flow and the variable indicating the result is
    %valid are removed, this insures the get_flow functions and the result
    %checking functions ask the user to confirm the results again.
    
    if exist('result','var')
        if isfield(result,'flow')
            result=rmfield(result,'flow');
        end
        if isfield(result,'valid')
            result=rmfield(result,'valid');
        end
    end
    recons_info.date=date;
    resave_acqui_info
    
end
if ishandle(wb);close(wb);drawnow;end