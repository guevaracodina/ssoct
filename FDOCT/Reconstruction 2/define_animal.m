animals=[1:4];

%%
% This script will allow the user to select the acquisitions and identify
% an animal number for each acquisition

for animal_number=animals
    animal_id=['V' num2str(animal_number)];
    
    [pathname,filename]=prompt_acquisition(['Select acquisitions for animal ' animal_id]);
    
    number_of_acquisitions=numel(pathname);
    
    for acquisition=1:number_of_acquisitions;
        clear acqui_info recons_info result
        load([pathname{acquisition} filename{acquisition}])
        acqui_info.animal_id=animal_id;
        resave_acqui_info
    end
end

%%

for animal_number=animals
    animal_id=['V' num2str(animal_number)];
    
    [pathname,filename]=prompt_acquisition(['Select acquisitions for animal ' animal_id]);
    load([pathname{1} filename{1}])
    if isfield(acqui_info,'weight')
        default_weight=acqui_info.weight;
    else
        default_weight=30;
    end
    
    if isfield(acqui_info,'dose')
        default_dose=acqui_info.dose;
    else
        default_dose=600*0.75;
    end
    
    answer = inputdlg({'Weight (g)';'Total Dose (µL)'},['Animal ' animal_id ': weight and dose'],...
        [1;1],{num2str(default_weight);num2str(default_dose)});
    current_weight=str2num(answer{1});
    current_dose=str2num(answer{2});
    number_of_acquisitions=numel(pathname);
    
    for acquisition=1:number_of_acquisitions;
        clear acqui_info recons_info result
        load([pathname{acquisition} filename{acquisition}])
        acqui_info.weight=current_weight;
        acqui_info.dose=current_dose;
        resave_acqui_info
    end
end


%%
% This script will allow the user to select the acquisitions and identify
% a type for each acquisition


[pathname,filename]=prompt_acquisition('Select ATX acquisitions');
% [pathname,filename]=concatenate_acquisition(pathname,filename);

number_of_acquisitions=numel(pathname);


for acquisition=1:number_of_acquisitions;
    clear acqui_info recons_info result
    load([pathname{acquisition} filename{acquisition}])
    acqui_info.animal_type='ATX';
    resave_acqui_info
end

[pathname,filename]=prompt_acquisition('Select CAT acquisitions');
% [pathname,filename]=concatenate_acquisition(pathname,filename);

number_of_acquisitions=numel(pathname);
for acquisition=1:number_of_acquisitions;
    clear acqui_info recons_info result
    load([pathname{acquisition} filename{acquisition}])
    acqui_info.animal_type='CAT';
    resave_acqui_info
end

[pathname,filename]=prompt_acquisition('Select WT acquisitions');
% [pathname,filename]=concatenate_acquisition(pathname,filename);

number_of_acquisitions=numel(pathname);
for acquisition=1:number_of_acquisitions;
    clear acqui_info recons_info result
    load([pathname{acquisition} filename{acquisition}])
    acqui_info.animal_type='WT';
    resave_acqui_info
end