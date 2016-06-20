function clean_old_acqui_info(pathname,filename)
% This script will clean up the old files acqui_info structures of the
% variables that should not be in them anymore

delete_variable_names={'blood_speed';'structure_maximum';'Structure_normalize';...
    'Doppler1_normalize';'select_background';'blood_speed_change_shifted';...
    'baseline_shift';'QOF';'systole_blood_speed_change';'ROI';'Aire';...
    'Aire_filtered';'number_of_time_gates';'dt_us';'dat2cpx_prop';...
    'dop1_prop';'struct_prop';'mask_prop'};

if ~exist('pathname')
    [pathname,filename]=prompt_acquisition...
        ('Select files containing old acquisitions to clean up');
end


for acquisition=1:numel(pathname)
    close all
    %This will load each acquisition
    clear acqui_info recons_info result
    load([pathname{acquisition} filename{acquisition}])
%     keyboard
    for i=1:numel(delete_variable_names)
        if isfield(acqui_info,delete_variable_names{i})
            acqui_info=rmfield(acqui_info,delete_variable_names{i});
        end
    end
    resave_acqui_info
end