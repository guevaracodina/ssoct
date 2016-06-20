function draw_2D_roi(figure_handle,data,ROI,graph_title,max_speed)
load('doppler_color_map.mat')
figure(figure_handle(1));

if length(figure_handle)>1
    subplot(figure_handle(2),figure_handle(3),figure_handle(4))
end

imagesc(data',max(max(abs(data)))*[-1 1]);
colormap(doppler_color_map);

if isstruct(ROI)
    if isfield(ROI,'x_poly')
        h_line(1)=line(ROI.x_poly,ROI.z_poly);set(h_line,'Color','k');
    end
    
    if isfield(ROI,'x_diam')
        h_line(2)=line(ROI.x_diam,ROI.z_diam);set(h_line,'Color','k','Linestyle',':');
    end
    set(h_line,'LineWidth',2)
end

h(1)=title(graph_title);
set(h,'Fontsize',14)

colorbar;
end