% This script will allow to select multiple 2Dt reconstructed files and
% calculate blood flow change diameter change on previously defined ROI

[pathname,filename]=prompt_acquisition('Select file containing reconstructed 2Dt data');

for acquisition=1:numel(filename)
    load([pathname{acquisition} filename{acquisition}]);
    [acqui_info]=get_flow_2Dt(acqui_info,0);
end
