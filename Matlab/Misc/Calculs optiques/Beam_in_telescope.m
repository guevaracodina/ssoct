clear all
clc

laser_beam_width=0.5; %This is the beam width at the exit of the laser

%% This part calculates from the galvos to the Field of View
max_galvo_deflection=10; %max_galvo_deflection=0.0008;
double_lens=1;
lens_1=50;
lens_2=100;

% This is the 4X Olympus objective
M=4;
objective=180/M;
objective_clear_aperture=9.12;
objective_NA=0.1;
objective_FN=22;
objective_WD=18.5;

deflections=max_galvo_deflection*pi/180*linspace(-1,1,5);
deflections_legend=[num2str(deflections'*180/pi)];
delta=0;

for j=1:3 %Different beam height
    for i=1:length(deflections) %Different beam deflections
        ray{i,j}=[laser_beam_width/2*(j-2);0];
        pos=0;
        %Mirror deflection
        operations='d';
        values=deflections(i);
        
        if double_lens
            operations=[operations 'tltlt'];
            values=[values lens_1+delta lens_1 lens_1+lens_2-delta lens_2 lens_2];
        else
            operations=[operations 'tlt'];
            values=[values 2*lens_1 lens_1 2*lens_1];
        end
        
        %Objective
        operations=[operations 'lt'];
        values=[values objective objective];
        objective_location=length(operations)-1;
        
        [ray{i,j},pos]=travelray(ray{i,j},pos,operations,values);
        
        line(pos(objective_location)*[1 1],[12.7 objective_clear_aperture/2],'LineStyle',':','color','r');
        line(pos(objective_location)*[1 1],[-12.7 -objective_clear_aperture/2],'LineStyle',':','color','r');
        objective_filling=2*abs(ray{i,j}(1,objective_location));
        Effective_NA=sin(atan(objective_filling/objective_clear_aperture*tan(asin(objective_NA))));
        
        ray_height{j}(i,:)=ray{i,j}(1,:);
    end
    
    %Plotting
    figure(1)
    subplot(1,2,1)
    if j==1
        hold off
    else
        hold on
    end
    plot(pos,ray_height{j})
    pause(0.1)
    if j==3
        legend(deflections_legend)
    end
end

FOV_mm=abs(2*ray_height{end}(end))
resolution_um=FOV_mm/512*1e3

line([0 pos(end)],[12.7 12.7],'color','red')
line([0 pos(end)],[-12.7 -12.7],'color','red')

line(lens_1*[1 1],[-12.7 12.7],'color','blue')
line((lens_1+lens_1+lens_2)*[1 1],[-12.7 12.7],'color','blue')

line([204 204],[12.7 22.4/2],'color','red')
line([204 204],-1*[12.7 22.4/2],'color','red')

line(pos(end)+[-.25 -.25 .25 .25 -.25],FOV_mm/2*[-1 1 1 -1 -1],'color','red')

if double_lens
    title(['Double lens f_1 = ' num2str(lens_1) ' mm and f_2 = ' num2str(lens_2) ' mm, FOV : ' num2str(round(FOV_mm*1000)) ' um'])
else
    title(['Single lens f = ' num2str(lens_1) ' mm'])
end
xlabel('z (mm)')
ylabel('r (mm)')

%% This part calculates the Beam focus in the Field of View

lambda=473e-9;

waist0=lambda/pi/asin(Effective_NA);
zr=pi*waist0^2/lambda;

FOVz_um=250;

z=FOVz_um/1000*(-500:1:500)*1e-6;
waist=waist0.*sqrt(1+(z./zr).^2);

figure(1)
subplot(1,2,2)
plot(z*1e3,waist*1e6,z*1e3,-waist*1e6)
line(FOVz_um/2*1e-3*[-1 -1 1 1 -1],FOV_mm/2*[-1 1 1 -1 -1],'color','red')
%line(1.6*[-1 -1],FOV_mm/2*[-1 1])
ylabel({['Field of View (mm), FOV_x = ' num2str(FOV_mm) ' mm,'];[' Resolution (512 pixels) = ' num2str(FOV_mm/512*1e3) ' um']})
xlabel(['Depth (mm), FOV_z = ' num2str(FOVz_um*1e-3) ' mm'])

worst_lateral_resolution_um=max(waist)*2*1e6
best_lateral_resolution_um=min(waist)*2*1e6
title(['Beam waist from ' num2str(round(best_lateral_resolution_um)) ' to ' num2str(round(worst_lateral_resolution_um)) ' um'])