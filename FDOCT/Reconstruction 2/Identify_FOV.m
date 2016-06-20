% This script will identify the FOV number

[pathname,filename]=prompt_acquisition(['Select acquisitions to identify FOV']);

number_of_acquisitions=numel(pathname);

for acquisition=1:number_of_acquisitions;
    clear acqui_info recons_info result
    load([pathname{acquisition} filename{acquisition}])
    
    start_FOVnumber=findstr(acqui_info.base_filename,'FOV')+3;
    if isempty(start_FOVnumber)
        start_FOVnumber=findstr(acqui_info.base_filename,'Zone')+4;
    end
    spaces=findstr(acqui_info.base_filename,' ');
    dashes=findstr(acqui_info.base_filename,'-');
    space_after_FOV=min(spaces(spaces>start_FOVnumber));
    dash_after_FOV=min(dashes(dashes>start_FOVnumber));
    end_of_FOV_number=min([space_after_FOV dash_after_FOV])-1;
    FOV_string=acqui_info.base_filename(start_FOVnumber:end_of_FOV_number);
%     str2num(FOV_string)
    disp([acqui_info.base_filename ' identified FOV ' FOV_string])
    
    acqui_info.FOV=str2num(FOV_string);
    resave_acqui_info
end
