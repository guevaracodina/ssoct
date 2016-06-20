function composite=surf_through_frames(filename,direction,range,surf_time,display_axes);
% This function will go through every frame of a reconstructed 3D volume,
% it is useful to find where the vessels are.
% direction = 1 will go through the x direction
% direction = 2 will go through the y direction (frames)
% direction = 3 will go through the z direction (depths)

if ~exist('filename')
    [pathname,filename]=prompt_acquisition('Select !1! file to surf through');
    filename=[pathname{1} filename{1}];
end

[Structure,Doppler1,acqui_info,recons_info]=map_3D_files(filename);

if ~exist('direction')
    switch acqui_info.ramp_type
        case 1; direction=3;
        case 4; direction=2;
        case 6; direction=2;
    end
end


composite_threshold=1/40;
doppler_display_threshold=1/5;

taille_filtre=10; %This is the size of the filter in pixels, this needs to be changed to um
display=1;

if ~exist('surf_time')
    surf_time=10; % Amount of time in seconds spent doing the scan
end

if ~(exist('range')==1)
    range=-1;
end

if ~exist('direction')
    direction=2;
end

load('doppler_color_map')
%This is the number of slices in the chosen direction
slices=recons_info.size(direction);
if direction==2;slices=300;end
second_dimension=direction+1;
if second_dimension>3;second_dimension=second_dimension-3;end
third_dimension=direction+2;
if third_dimension>3;third_dimension=third_dimension-3;end

x_title=[recons_info.type{second_dimension} ' (' recons_info.units{second_dimension} ')'];
x_range=[0 recons_info.size(second_dimension)*recons_info.step(second_dimension)];
y_title=[recons_info.type{third_dimension} ' (' recons_info.units{third_dimension} ')'];
y_range=[0 recons_info.size(third_dimension)*recons_info.step(third_dimension)];

if range==-1
    range=1:slices;
else
    range=range(1):range(end);
end

window=hann(taille_filtre);
filtre=window*window';
filtre=filtre/sum(sum(filtre));

first_iteration=1;
frame_max=double(max(max(max(abs(Doppler1.Data.Data)))));
for i=range;
    graph_title=...
        [num2str(i) ' ' recons_info.type{direction}...
        ' : ' num2str(round(i*recons_info.step(direction))) ' ' recons_info.units{direction}];
    switch direction
        case 1
            struct=squeeze(Structure.Data.Data(i,:,:));
            dop=squeeze(Doppler1.Data.Data(i,:,:));
        case 2
            struct=squeeze(Structure.Data.Data(:,i,:))';
            dop=squeeze(Doppler1.Data.Data(:,i,:))';
        case 3
            struct=squeeze(Structure.Data.Data(:,:,i));
            dop=squeeze(Doppler1.Data.Data(:,:,i));
    end
    
    %Filtering and determination of slice maximum
%     dop=imfilter(dop,filtre);
    
    frame_threshold=frame_max*composite_threshold*ones(size(dop));
    
    if first_iteration
        first_iteration=0;
        composite_positive=zeros(size(dop));
        composite_negative=zeros(size(dop));
    end
    
    frame_positive=zeros(size(dop));
    frame_negative=zeros(size(dop));
    
    frame_positive(dop>frame_threshold)=dop(dop>frame_threshold);
    frame_negative(dop<-1*frame_threshold)=dop(dop<-1*frame_threshold);
    
    composite_positive(frame_positive>composite_positive)=frame_positive(frame_positive>composite_positive);
    composite_negative(frame_negative<composite_negative)=frame_negative(frame_negative<composite_negative);
    
    composite=composite_positive+composite_negative;
    
    if display
        if exist('display_axes')
            axes(display_axes)
        else
            figure(1);
        end
        subplot(2,2,1);
          imagesc(x_range, y_range,struct,double(intmax('int16'))*[-1 1]/10);
        axis equal tight
        subplot(2,2,2);
        imagesc(x_range, y_range,dop,double(intmax('int16'))*[-1 1]*doppler_display_threshold);
        axis equal tight
        h(1)=title(graph_title);
        h(2)=xlabel(x_title);
        h(3)=ylabel(y_title);
        set(h,'Fontsize',32)
        colormap(doppler_color_map);
        pause(surf_time/length(range));
        
        subplot(2,2,3);
        imagesc(x_range,y_range,composite,double(intmax('int16'))*[-1 1]*doppler_display_threshold);
        colormap(doppler_color_map);
        
    end
end

[composite_speed,max_speed]=getspeed(composite,acqui_info.line_period_us,870e-6);

figure(3);
imagesc(x_range,y_range,composite_speed,max_speed*[-1 1]/2);
h(1)=title('Maximum intensity projection');
h(2)=xlabel(x_title);
h(3)=ylabel(y_title);
set(h,'Fontsize',32)
colormap(doppler_color_map);
axis equal tight
colorbar