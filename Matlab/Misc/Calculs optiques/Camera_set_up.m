
clear all
clc

% CMOS sensor
Camera_captor_size=[4.61 3.69];

% This is the 4X Olympus objective
M=4;
objective=180/M;
objective_clear_aperture=9.12;
objective_NA=0.1;
objective_FN=22;
objective_WD=18.5;

% This is the 

operations='tltlt';
values=[20 20 100 objective objective];

% These are the properties for the calculation
number_of_heights=5;
number_of_deflections=3;
max_deflection=10; %Maximum deflection in degrees

deflections=max_deflection/180*pi*linspace(-1,1,number_of_deflections);
for k=1:numel(Camera_captor_size)
    ray_exit_heights=Camera_captor_size(k)/2*linspace(-1,1,number_of_heights);
for i=1:numel(deflections)%This will loop through different deflections
    for j=1:numel(ray_exit_heights) %This will loop through different starting points
        ray{i,j}=[ray_exit_heights(j);deflections(i)];
        pos=0;
        [ray{i,j},pos]=travelray(ray{i,j},pos,operations,values);
        ray_height{i}(:,j)=ray{i,j}(1,:);
    end
    
    %Plotting
    figure(k)
    if i==1
        hold off
    else
        hold on
    end
    
    plot(pos,ray_height{i})
    pause(0.1)
end

for i=1:length(pos)
    plot([pos(i) pos(i)],[-12.7 12.7])
end

for i=2:2:length(pos)-1
text(pos(i),-12.7-1,[num2str(values(i)) 'mm'])
end

line([0 pos(end)],[12.7 12.7],'color','red')
line([0 pos(end)],[-12.7 -12.7],'color','red')

line([0 pos(end)],9*[1 1],'color','red')
line([0 pos(end)],-9*[1 1],'color','red')

%This will trace the line of the camera sensor
h(1)=line([pos(1)+values(2) pos(1)],Camera_captor_size(k)/2*[1 1],'color','k');
h(2)=line([pos(1)+values(2) pos(1)],Camera_captor_size(k)/2*[-1 -1],'color','k');
set(h,'Linewidth',2);set(h,'Linestyle',':')
FOV(k)=ray_height{1}(end,1)-ray_height{1}(end,end);
end
FOV
