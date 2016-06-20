function calculate_compliance(pathname,filename)
% This is finally the function that will calculate the compliance in the
% data sets

load('doppler_color_map.mat')

if ~exist('pathname')
    [pathname,filename]=prompt_acquisition...
        ('Select files containing calculated results');
end

[pathname,filename]=pair_filenames(pathname,filename);

for zone=1:numel(pathname)
    clear diameter_um flow_nLps
    if isfield(filename{zone},'ThreeD_rfa')
        ThreeD_rfa=load([pathname{zone} filename{zone}.ThreeD_rfa]);
        if isfield(ThreeD_rfa,'recons_info')
            
            if ~isfield(ThreeD_rfa,'result')
                rerun_get_flow=1;
            elseif ~isfield(ThreeD_rfa.result,'valid')
                rerun_get_flow=1;
            else
                rerun_get_flow=0;
            end
            
            if rerun_get_flow
                %                 get_flow_3D({pathname{zone}}, {filename{zone}.ThreeD_rfa})
                %                 ThreeD_rfa=load([pathname{zone} filename{zone}.ThreeD_rfa]);
            end
            if isfield(ThreeD_rfa,'result')
                if isfield(ThreeD_rfa.result,'valid')
                    if ThreeD_rfa.result.valid
                        diameter_um=ThreeD_rfa.result.diameter;
                        max_flow_nLps=ThreeD_rfa.result.max_flow;
                    end
                end
            end
            
        else
            disp(['3D Data not reconstructed in ' filename{zone}.ThreeD_rfa])
        end
        
    else
        disp(['Missing valid 3D Data set in folder ' pathname{zone}])
    end
    
    
    slice={'X';'Y'};
    for i=1:numel(slice)
        if isfield(filename{zone},slice{i})
            Slice_info=load([pathname{zone} getfield(filename{zone},slice{i}) ]);
            if isfield(Slice_info,'recons_info')
                if ~isfield(Slice_info,'result')
                    rerun_get_flow=1;
                elseif ~isfield(Slice_info.result,'valid')
                    rerun_get_flow=1;
                else
                    rerun_get_flow=0;
                end
                
                if isfield(Slice_info,'result')
                    if isfield(Slice_info.result,'valid')
                        flow_change_percent=Slice_info.result.systole_blood_speed_change;
                        if Slice_info.result.valid
                            area_change_percent=Slice_info.result.systole_Area_change;
                            
                            if exist('diameter_um','var')
                                Slice_info.result.compliance=((diameter_um*1e-6/2)^2*pi)^3/...
                                    (max_flow_nLps*1e-12)*(1+area_change_percent)*area_change_percent/...
                                    (flow_change_percent-area_change_percent)*1e15;
                                
                                disp([Slice_info.acqui_info.base_filename...
                                    ', flow is ' num2str(max_flow_nLps)...
                                    ', diameter is ' num2str(diameter_um)...
                                    ', speed change is' num2str(flow_change_percent)...
                                    ' compliance is ' num2str(Slice_info.result.compliance)])
                                
                                acqui_info=Slice_info.acqui_info;
                                result=Slice_info.result;
                                recons_info=Slice_info.recons_info;
                                resave_acqui_info
                            else
                                disp([Slice_info.acqui_info.base_filename...
                                    ' , flow is ' num2str(max_flow_nLps)...
                                    ' , diameter is ' num2str(diameter_um)...
                                    ' , speed change is' num2str(flow_change_percent)])
                            end
                        else
                            disp([Slice_info.acqui_info.base_filename...
                                ' , flow is ' num2str(0)...
                                ' , diameter is ' num2str(0)...
                                ' , speed change is' num2str(flow_change_percent)])
                        end
                    end
                end
                
                
            else
                disp(['Slice not reconstructed in ' getfield(filename{zone},slice{i})])
            end
        else
            disp(['Missing valid ' slice{i} ' slice in ' pathname{zone}])
        end
    end
    
    
    
end
