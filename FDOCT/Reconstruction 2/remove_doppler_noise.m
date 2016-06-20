function Doppler1=remove_doppler_noise(Doppler1)
% This function will remove the doppler

[m,n,o]=size(Doppler1);
Doppler_clean=int16(zeros(m,n,o));

background_sample_unselected=1;
load('doppler_color_map')
start_depth=50
end_depth=150

while background_sample_unselected
    prompt={'Start depth';'End depth'};
    answer= inputdlg(prompt,'Doppler background selection',1,...
        {num2str(start_depth);num2str(end_depth)});
    start_depth=str2num(answer{1})
    end_depth=str2num(answer{2})
    figure(1);
    colormap(doppler_color_map)
    background=squeeze(mean(Doppler1(:,start_depth:end_depth,:),2));
    imagesc(background,1.5e4*[-1 1])
    button=questdlg('Background satisfactory','Accept background sample');
    if strcmp(button,'Yes')
        background_sample_unselected=0
        for i=1:m
            for k=1:o
                Doppler1(i,:,k)=Doppler1(i,:,k)-background(i,k);
            end
        end
    elseif strcmp(button,'Cancel')
        break
    end
end