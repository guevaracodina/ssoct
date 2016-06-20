function draw_2D_roi2(figure_handle,Structure_mean,Doppler_mean,recons_info,ROI)
% This will draw the
load('doppler_color_map.mat')

figure(figure_handle(1));

if length(figure_handle)>1
    subplot(figure_handle(2),figure_handle(3),figure_handle(4))
end

FOV=recons_info.size.*recons_info.step;

Structure_grayscale=round((Structure_mean'-min(Structure_mean(:)))/...
    (max(Structure_mean(:))-min(Structure_mean(:)))*256);

color_img_structure = ind2rgb(Structure_grayscale,gray(256));
test=imagesc([0 recons_info.size(1)]*recons_info.step(1),...
    [0 recons_info.size(2)]*recons_info.step(2),color_img_structure);
axis image;
hold on
set(get(figure_handle(1),'CurrentAxes'),'Xtick',[],'Ytick',[])
Doppler_to_show=zeros(size(Doppler_mean'));
Doppler_to_show(Doppler_mean'>0)=1;
Doppler_to_show(Doppler_mean'<0)=-1;
Doppler_to_show=flipud(Doppler_to_show);

% Transparency map
alpha_img=abs(Doppler_mean)'/max(abs(Doppler_mean(:)))*.7;
alpha_img=flipud(alpha_img);
% keyboard
% Color activation map
color_img_doppler = ind2rgb(round(Doppler_to_show/...
    pi*5*128+128),...
    colormap(doppler_color_map));
keyboard
% Overlay map
h_image = imagesc([0:recons_info.size(1)]*recons_info.step(1),...
    [recons_info.size(2) 0]*recons_info.step(2),color_img_doppler);
% Establish transparency
set(h_image,'AlphaData',alpha_img);
if exist('ROI')
    if isstruct(ROI)
        if isfield(ROI,'x_poly')
            h_line(1)=line(recons_info.step(1)*ROI.x_poly,...
                recons_info.step(2)*ROI.z_poly);
        end
        
        if isfield(ROI,'x_diam')
            h_line(2)=line(recons_info.step(1)*ROI.x_diam,...
                recons_info.step(2)*ROI.z_diam);set(h_line(2),'Linestyle',':');
        end
        set(h_line,'LineWidth',2,'Color','w')
    end
end

%This will add a legend bar indicating the size of the image
length_of_legend=round(FOV(1)/500)*100;
legend_line_x_position=[FOV(1)*.9 FOV(1)*.9-length_of_legend];
legend_line_z_position=FOV(2)*.9*[1 1];
legend_line=line(legend_line_x_position,legend_line_z_position);
set(legend_line,'Color','w','LineWidth',2);
legend_text=text(mean(legend_line_x_position),...
    legend_line_z_position(2)-50,[num2str(length_of_legend) 'um']);
set(legend_text,'Color','w');
set(legend_text,'Fontsize',14);
set(legend_text,'HorizontalAlignment','center');
hold off
end