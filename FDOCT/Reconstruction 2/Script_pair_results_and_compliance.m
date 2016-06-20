% This script will load all the results and will find all the valid 3D flow
% measurements and put their informatino
clear
% close all
load('Results')

diameter_bins=[80];

% This will create an ID cell that contains complete identification for
% each acquisition

for i=1:numel(animal_id)
    ID{i}=[animal_type{i} ' ' animal_id{i} '-' num2str(FOV(i)) '-' type{i} ];
end

animal_types=unique(animal_type);

ATX_animals=find(strcmp(animal_type,'ATX'));
CAT_animals=find(strcmp(animal_type,'CAT'));
WT_animals=find(strcmp(animal_type,'WT'));

for i=1:18
    current_acquisitions=find(strcmp(animal_id,['E' num2str(i)]));
    bpm_mean(i)=mean(bpm(current_acquisitions));
end

artery=zeros(size(diameter));
vein=zeros(size(diameter));
valid_3D_acquisitions=find(strcmp(type,'ThreeD_rfa').*valid);
keyboard
for acquisition=valid_3D_acquisitions
    current_animal_id=animal_id{acquisition};
    current_FOV=FOV(acquisition);
    %keyboard
    matching_slices=find(strcmp(animal_id,current_animal_id)...
        .*FOV==current_FOV);
    max_flow(matching_slices)=max_flow(acquisition);
    for current_acquisition=matching_slices
        diameter(current_acquisition)=sqrt(diameter(acquisition)*...
            diameter(current_acquisition));
    end
    if numel(matching_slices)>1
        if sum(valid(matching_slices(2:end)))
            artery(acquisition)=1;else
            vein(acquisition)=1;end
    end
end
valid(valid~=1)=0;
valid=valid.*strncmp(animal_id,'E',1);
valid=valid.*~strcmp(animal_type,'CAT');

[viscosity]=Get_FluidViscosity(diameter,0.45);
viscosity(diameter==0)=0;

compliance=((diameter*1e-6/2).^2*pi).^3./(max_flow*1e-12).*...
    (1+systole_Area_change).*systole_Area_change./...
    (systole_blood_speed_change-systole_Area_change)*1e15./viscosity;

compliance2=((diameter*1e-6/2).^2*pi).^3./(max_flow*1e-12).*...
    (1+systole_Area_change).^2.*systole_Area_change./...
    ((1+systole_blood_speed_change)-(1+systole_Area_change).^2)*1e15./viscosity;
keyboard

compliance(compliance<0)=0;
compliance(compliance>100)=0;
compliance(~isfinite(compliance))=0;

compliance2(compliance2<0)=0;
compliance2(compliance2>100)=0;
compliance2(~isfinite(compliance2))=0;


norm_BF_d_HR=max_flow./(diameter/2).^2/pi*60e3./bpm.*artery; %This is in units of mm per heart beat

blood_speed_change_compiled=create_bar_graph(1,diameter_bins,...
    animal_type,diameter,100*systole_blood_speed_change.*valid,'Blood Speed change',...
    'Change from baseline (%)');

BF_norm_d_HR_compiled=create_bar_graph(2,diameter_bins,...
    animal_type,diameter,norm_BF_d_HR.*valid,'Blood Speed',...
    'Blood speed normalized by heart rate (mm per heart beat)');

speed_change_variability_compiled=create_bar_graph(3,diameter_bins,...
    animal_type,diameter,100*speed_change_variability.*valid,'Blood Speed variability',...
    'Variability from mean (%)');

compliance_compiled=create_bar_graph(4,diameter_bins,...
    animal_type,diameter,compliance.*valid,'Compliance',...
    'Compliance Evaluator');

compliance2_compiled=create_bar_graph(6,diameter_bins,...
    animal_type,diameter,compliance2.*valid,'Compliance',...
    'Compliance Evaluator');

systole_Area_change_compiled=create_bar_graph(5,diameter_bins,...
    animal_type,diameter,systole_Area_change*100.*valid,'Systole Area Change',...
    'Change from baseline (%)');

Results_compiled=fopen('Results_compiled.txt','w');

fprintf(Results_compiled,'Type Animal FOV Scan_type Valid BPM Diameter Max_flow Speed_change Area_change Compliance\n');

for acquisition=1:numel(animal_id)
    %if valid(acquisition)&&compliance(acquisition)~=0
    fprintf(Results_compiled,'%s %s %g %s ',animal_type{acquisition},...
        animal_id{acquisition},FOV(acquisition),type{acquisition});
    
    fprintf(Results_compiled,'%g %g %g %g %g %g %g ',valid(acquisition),...
        bpm(acquisition),diameter(acquisition),max_flow(acquisition),...
        systole_blood_speed_change(acquisition),...
        systole_Area_change(acquisition),compliance(acquisition));
    
    fprintf(Results_compiled,'\n');
    %end
end