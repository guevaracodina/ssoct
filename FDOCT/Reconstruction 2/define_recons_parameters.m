function recons_info=define_recons_parameters(acqui_info)
% This function will define the reconstruction parameters used to
% reconstruct the different types of acquisitions.

type_of_acquisition=acqui_info.ramp_type;

recons_info.A_line_position=single(zeros(acqui_info.resolution,...
    acqui_info.nframes*acqui_info.nfiles,2));

switch type_of_acquisition
    case 1 %In case of a 2Dt acquisition
        recons_info.dop1_prop.kernel_sigma=1e-3;
        
        if acqui_info.ecg==1 %If the ecg signal is valid and we want to reconstruct using it.
            recons_info.number_of_time_gates=100;
            %             keyboard
            [gate_position,recons_info.dt_us]=...
                segment_2Dtime(acqui_info,recons_info.number_of_time_gates);
            
            recons_info.A_line_position(:,:,2)=...
                gate_position(1:acqui_info.resolution,...
                1:acqui_info.nframes*acqui_info.nfiles);
            
        else % If there is no ECG signal then the frame is reconstructed as it was acquired.
            % If there is multiple files they will be added to one another.
            for i=1:acqui_info.nfiles
                recons_info.A_line_position(:,...
                    (i-1)*acqui_info.nframes+(1:acqui_info.nframes),2)=...
                    ones(acqui_info.resolution,1)*(1:acqui_info.nframes);
            end
        end
        
        for i=1:acqui_info.resolution
            recons_info.A_line_position(i,:,1)=i*ones(acqui_info.nframes*acqui_info.nfiles,1);
        end
        recons_info.filter_FWHM=[5 5 10];
        
    case 4 %In case of a 3D acquisition
        recons_info.dop1_prop.kernel_sigma=.4e-3; %This was augmented from 0.2 to 0.4 on 30 march 2011
        if isfield(acqui_info,'line_shift')
            line_shift=acqui_info.line_shift;
        else
            line_shift=0;
        end
        %keyboard
        position_dim_1(:,:,1)=(line_shift+(1:acqui_info.resolution))'*ones(1,acqui_info.nframes);
        overlapped=find((line_shift+(1:acqui_info.resolution))>acqui_info.ramp_length);
        position_dim_1(overlapped,:,1)=position_dim_1(overlapped,:,1)-acqui_info.ramp_length;
        
        position_dim_1(:,:,2)=((acqui_info.resolution:-1:1)-line_shift)'*ones(1,acqui_info.nframes);
        underlapped=find(((acqui_info.resolution:-1:1)-line_shift)<0);
        position_dim_1(underlapped,:,2)=position_dim_1(underlapped,:,2)+acqui_info.ramp_length;
        
        position_dim_3(:,:,1)=ones(1,acqui_info.resolution)'*(1:acqui_info.nframes);
        position_dim_3(:,:,2)=ones(1,acqui_info.resolution)'*(acqui_info.nframes:-1:1);
        
        for file=1:acqui_info.nfiles
            current_frames=(file-1)*acqui_info.nframes+(1:acqui_info.nframes);
            if acqui_info.rev_fast_axis;oddoreven=2-rem(file,2);else;oddoreven=1;end
            recons_info.A_line_position(:,current_frames,1)=position_dim_1(:,:,oddoreven);
            recons_info.A_line_position(:,current_frames,2)=position_dim_3(:,:,oddoreven);
        end
        recons_info.filter_FWHM=[5 5 5];
    case 6 %In case of a 3D HD acquisition
        recons_info.dop1_prop.kernel_sigma=10e-3;
        ramp=linspace(1,acqui_info.x_FOV_um,...
            (acqui_info.HD_info.framesperslice-1)*acqui_info.resolution);
        position_X=[(reshape(ramp,acqui_info.resolution,(acqui_info.HD_info.framesperslice-1))) -1*ones(acqui_info.resolution,1)];
        for slice=1:acqui_info.HD_info.slicesperfile*acqui_info.nfiles;
            current_frames=(slice-1)*acqui_info.HD_info.framesperslice+(1:acqui_info.HD_info.framesperslice);
            recons_info.A_line_position(:,current_frames,1)=position_X;
            recons_info.A_line_position(:,current_frames,2)=slice;
        end
        recons_info.filter_FWHM=[5 5 5];
        recons_info.mask_prop.surface=1;
        
end

dimensions=define_dimensions(acqui_info,recons_info);

recons_info.dat2cpx_prop.window=1;
recons_info.dat2cpx_prop.HP=0.05;
recons_info.struct_prop.remove_mean=0; %These are the properties of the structure

%These are the properties of the Doppler reconstruction
recons_info.dop1_prop.zwindow=15;
recons_info.dop1_prop.rwindow=15;

%These are the properties of the mask that is applied on the doppler reconstruction
recons_info.mask_prop.enable=1;
recons_info.mask_prop.noise_lower_fraction=0.1;
recons_info.mask_prop.threshold_db=17;
recons_info.mask_prop.blur_window=ones(10,10);

% This will define all the dimensions of the result matrix
recons_info.size=[dimensions{1}.size dimensions{2}.size dimensions{3}.size];
recons_info.step=[dimensions{1}.FOV/dimensions{1}.size...
    dimensions{2}.FOV/dimensions{2}.size...
    dimensions{3}.FOV/dimensions{3}.size];

recons_info.type={dimensions{1}.type dimensions{2}.type dimensions{3}.type};
recons_info.units={dimensions{1}.units dimensions{2}.units dimensions{3}.units};

% This is the dispersion compensation parameter
recons_info.dispersion.a=[0 0];
recons_info.dispersion.compensate=1;

recons_info.filter=design_gaussian_filter(recons_info.filter_FWHM,recons_info.step);