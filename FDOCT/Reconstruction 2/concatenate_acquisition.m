function [pathname,filename]=concatenate_acquisition(pathname,filename)
% This function will take the path to the first file of an acquisition and
% determine how many files are part of the acquisition and concatenate all
% the information into only one acqui_info file

% If there is only one file in the acquisition it will leave the starting
% frame number in it, if there are more then one, it will remove the number
% and indicate how many files are part of the acquisition

% This function will also clean up the filename specified in the acqui_info
% structure to match the current location of the file.

if ~exist('pathname')
    [pathname,filename]=prompt_acquisition('Select files to concatenate');
end

if ~iscell(pathname)
    pathname_cell{1}=pathname;
    filename_cell{1}=filename;
    clear pathname filename
    pathname=pathname_cell;filename=filename_cell;
end

for acquisition=1:numel(filename)
    pathname_first_file=pathname{acquisition};
    filename_first_file=filename{acquisition};
    clear recons_info result
    load([pathname_first_file filename_first_file])
    
    [pathname_temp,filename_temp,ext]=fileparts([pathname_first_file filename_first_file]);
    acqui_info.filename=[pathname_temp '\' filename_temp];
    
    % This will verify that the properties that are written in the
    % acqui_info structure correspond to the  actual properties of the
    % acquisition
    type=identifity_acquisition_type(filename_temp);
    if findstr(filename_temp,'Coupe selon');acqui_info.ramp_type=1;end
    if findstr(filename_temp,'3D rev fast axis');acqui_info.ramp_type=4;end
    if findstr(filename_temp,'3D HD');acqui_info.ramp_type=6;end
    if findstr(filename_temp,'Fantom');acqui_info.ecg=0;end
    
    if acqui_info.ecg==1&&~isfield(acqui_info,'bpm')&&isfield(acqui_info,'ecg_signal')
        [temp,acqui_info.bpm]=Find_ECG_peaks(acqui_info,0);
    end
    
    %This will clean up the FOV values to make sure everything is round to
    %the um
    
    acqui_info=check_FOV(acqui_info);
    
    switch acqui_info.ramp_type
        case 4
            if ~isfield(acqui_info,'rev_fast_axis')
                if findstr(filename_temp,'3D rev fast axis')
                    acqui_info.rev_fast_axis=1;
                else
                    acqui_info.rev_fast_axis=0;
                end
            end
        case 6
            if ~isfield(acqui_info,'HD_info')
                acqui_info.HD_info.slicesperfile=10;
                acqui_info.HD_info.framesperslice=40;
            end
    end
    resave_acqui_info;
    
    acqui_info_first=acqui_info;
    % nfiles is determined only once by running this script, if the script was
    % already run on an acquisition, it will not run again
    if ~isfield(acqui_info,'nfiles')
        
        % This will determine the base_filename that will be used to find the other
        % files of the acquisition
        first_frame=acqui_info.framenumber(1);
        base_filename=regexprep(filename_first_file,[num2str(first_frame) '.mat'],'');
        base_filename_clean=clean_base_filename(base_filename);
        
        % This declares a new acqui_info for the complete acquisition
        acqui_info_complete=acqui_info_first;
        acqui_info_complete.filename=[pathname_first_file base_filename_clean];
        acqui_info_complete.base_filename=base_filename;
        
        nfiles=0; %This is a counter to follow the number of files in the acquisition
        nextfileexists=1; %This indicates that the next file of the acquisition exists
        
        while nextfileexists
            nfiles=nfiles+1;
            start_frame=(nfiles-1)*acqui_info_first.nframes+first_frame;
            nextfileexists=exist([pathname{acquisition} base_filename num2str(start_frame+acqui_info.nframes) '.mat']);
            
            clear recons_info result
            load([pathname_first_file base_filename num2str(start_frame) '.mat']);
            acqui_info.filename=[pathname_first_file base_filename num2str(start_frame)];
            resave_acqui_info;
            
            if acqui_info.version>3
                if nfiles==1
                    if isfield(acqui_info_complete,'ecg_signal')
                        acqui_info_complete=rmfield(acqui_info_complete,'ecg_signal');
                    end
                end
                % We also concatenate all the ecg information into the
                % acqui_info_complete structure
                if isfield(acqui_info,'ecg_signal')
                    if ~iscell(acqui_info.ecg_signal)
                        acqui_info_complete.ecg_signal{nfiles}=acqui_info.ecg_signal;
                    end
                end
            end
            acqui_info_complete.nfiles=nfiles;
            if ~isdir([pathname_first_file 'Backup']);mkdir(pathname_first_file,'Backup');end
            movefile([pathname_first_file base_filename num2str(start_frame) '.mat'],[pathname_first_file '/Backup/' base_filename num2str(start_frame) '.mat'])
        end
        
        if nfiles==1
            acqui_info_complete.filename=acqui_info_first.filename;
        else
            filename{acquisition}=base_filename_clean;
        end
        
        if isfield(acqui_info_complete,'ecg_signal')
            acqui_info_temp=acqui_info;
            acqui_info=acqui_info_complete;
            clear recons_info result
            resave_acqui_info
        else
            error(['No ECG information found, file not saved, please check source files : ' acqui_info.filename])
        end
    else
        acqui_info_complete=acqui_info_first;
    end
    
end
end

function acqui_info=check_FOV(acqui_info);
%This function makes sure that the FOV in the x and y direction are
%correctly set, sometimes an error in labview would make a FOV of dimension
%0 or 3770 um to be written this allows the user to correct this error.

default_FOV_length=800;

acqui_info.x_FOV_um=round(acqui_info.x_FOV_um);
acqui_info.y_FOV_um=round(acqui_info.y_FOV_um);
acqui_info.z_FOV_um=round(acqui_info.z_FOV_um);

position=findstr(acqui_info.filename,'\');
filename=acqui_info.filename(position(end)+1:end);
direction='';
switch acqui_info.ramp_type
    case 1
        
        if ~isempty(findstr(filename,'Coupe selon X'))||~isempty(findstr(acqui_info.filename,'Coupe selon  X'))
            direction='X';
            default_x_FOV_um=default_FOV_length;
            default_y_FOV_um=0;
        elseif ~isempty(findstr(filename,'Coupe selon Y'))||~isempty(findstr(acqui_info.filename,'Coupe selon  Y'))
            direction='Y';
            default_x_FOV_um=0;
            default_y_FOV_um=default_FOV_length;
        elseif findstr(filename,'deg')
            direction='deg';
            angle=str2num(filename(findstr(filename,'selon')+5:findstr(filename,'deg')-1));
            default_x_FOV_um=round(default_FOV_length*cos(angle*pi/180));
            default_y_FOV_um=round(default_FOV_length*sin(angle*pi/180));
        end
    case 4
        default_x_FOV_um=default_FOV_length;
        default_y_FOV_um=default_FOV_length;
    case 6
        default_x_FOV_um=default_FOV_length;
        default_y_FOV_um=default_FOV_length;
end

if ~exist('default_x_FOV_um')
    disp('Unknown FOV correction')
    
end

invalid_FOV=0;

if acqui_info.ramp_type>1
    if acqui_info.x_FOV_um<1||acqui_info.y_FOV_um<1
        invalid_FOV=1;
    end
end
if acqui_info.x_FOV_um==3770||acqui_info.y_FOV_um==3770
    invalid_FOV=1;
end

if (strcmp(direction,'X')&&abs(acqui_info.x_FOV_um)<abs(acqui_info.y_FOV_um))||...
        (strcmp(direction,'Y')&&abs(acqui_info.y_FOV_um)<abs(acqui_info.x_FOV_um))
    invalid_FOV=1;
end

if invalid_FOV
    Message={filename;['FOV seems invalid : X=' num2str(acqui_info.x_FOV_um)...
        ', Y=' num2str(acqui_info.y_FOV_um) ' and Z=' num2str(acqui_info.z_FOV_um)];...
        ['Suggested change : X=' num2str(default_x_FOV_um)...
        ', Y=' num2str(default_y_FOV_um) ' and Z=' num2str(acqui_info.z_FOV_um)];...
        'Accept change ?'};
    button=questdlg(Message,'Invalid FOV','Yes','No','Custom','Yes');
    
    if strcmp(button,'Yes')
        acqui_info.x_FOV_um=default_x_FOV_um;
        acqui_info.y_FOV_um=default_y_FOV_um;
    elseif strcmp(button,'Custom')
        prompt={'X (um)';'Y (um)';'Z (um)'};
        answer= inputdlg(prompt,'New FOV',1,...
            {num2str(acqui_info.x_FOV_um);num2str(acqui_info.y_FOV_um);num2str(acqui_info.z_FOV_um)});
        acqui_info.x_FOV_um=str2num(answer{1});
        acqui_info.y_FOV_um=str2num(answer{2});
        acqui_info.z_FOV_um=str2num(answer{3});
    end
    
end
end