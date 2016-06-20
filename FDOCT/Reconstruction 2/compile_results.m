function compile_results(pathname,filename)

if ~exist('pathname')
    [pathname,filename]=prompt_acquisition...
        ('Select file containing result of 3D reconstruction');
end

fprintf('Type Animal FOV Scan_type Flow Result Diameter Max_flow Speed_change Area_change\n')

for acquisition=1:numel(pathname)
    %This will load each acquisition
    clear acqui_info recons_info result
    
    load([pathname{acquisition} filename{acquisition}]);
    type=identifity_acquisition_type(filename{acquisition});
    
    if ~isfield(acqui_info,'animal_type')
        acqui_info.animal_type='';
    end
    
    fprintf('%s ',acqui_info.animal_type)
    results_compiled.animal_type{acquisition}=acqui_info.animal_type;
    
    if ~isfield(acqui_info,'animal_id')
        acqui_info.animal_id='';
    end
    fprintf('%s ',acqui_info.animal_id)
    results_compiled.animal_id{acquisition}=acqui_info.animal_id;
    
    if ~isfield(acqui_info,'FOV')
        acqui_info.FOV=0;
    end
    
    fprintf('%g ',acqui_info.FOV)
    results_compiled.FOV(acquisition)=acqui_info.FOV;
    
    fprintf('%s ',type)
    results_compiled.type{acquisition}=type;
    if ~isfield(acqui_info,'bpm')
        acqui_info.bpm=0;
    end
    results_compiled.bpm(acquisition)=acqui_info.bpm;
    if ~isfield(acqui_info,'weight');acqui_info.weight=0;end;results_compiled.weight(acquisition)=acqui_info.weight;
    if ~isfield(acqui_info,'dose');acqui_info.dose=0;end;results_compiled.dose(acquisition)=acqui_info.dose;
    
    
    if ~exist('result','var')
        result.flow='No';
    end
    
    if ~isfield(result,'flow')
        result.flow='Yes';
    end
    
    if result.flow==1
        result.flow='Yes';
    elseif result.flow==0
        result.flow='No';
    end
    
    if strcmp(result.flow,'No')
        result.valid=0;
    end
    results_compiled.flow{acquisition}=result.flow;
    
    if ~isfield(result,'valid')
        result.valid=-1;
    end
    results_compiled.valid(acquisition)=result.valid;
    
    if result.valid==0
        result.diameter=0;
        result.max_flow=0;
        result.systole_blood_speed_change=0;
        result.systole_Area_change=0;
    end
    
    if ~isfield(result,'diameter')
        result.diameter=0;
    end
    
    results_compiled.diameter(acquisition)=result.diameter;
    
    if ~isfield(result,'max_flow')
        result.max_flow=0;
    end
    results_compiled.max_flow(acquisition)=result.max_flow;
    
    if ~isfield(result,'systole_blood_speed_change')
        result.systole_blood_speed_change=0;
    end
    results_compiled.systole_blood_speed_change(acquisition)=result.systole_blood_speed_change;
    
    if ~isfield(result,'systole_Area_change')
        result.systole_Area_change=0;
    end
    results_compiled.systole_Area_change(acquisition)=result.systole_Area_change;
    
    if ~isfield(result,'speed_change_variability')
        result.speed_change_variability=0;
    end
    results_compiled.speed_change_variability(acquisition)=result.speed_change_variability;
        
    fprintf('%s %g %g %g %g %g ',result.flow,result.valid,result.diameter,...
        result.max_flow,result.systole_blood_speed_change,result.systole_Area_change)
        fprintf('\n')
end

save('Results','-struct','results_compiled')