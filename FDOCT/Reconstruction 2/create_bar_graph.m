function data_compiled=create_bar_graph(figure_handle,diameter_criteria,...
    animal_type,diameter,data,graph_title,y_label)


animal_types=unique(animal_type);
animal_type_title=animal_types;

for diameter_index=1:numel(diameter_criteria)+1
    if numel(diameter_criteria)==0
        min_diameter=1;
        max_diameter=inf;
        diameter_labels=animal_type_title;
        animal_type_title=[];
    else
        if diameter_index==1;
            min_diameter=1;
            max_diameter=diameter_criteria(diameter_index);
            diameter_labels{diameter_index}=['<=' num2str(max_diameter)];
        else
            if diameter_index==numel(diameter_criteria)+1
                min_diameter=diameter_criteria(diameter_index-1);
                max_diameter=inf;
                diameter_labels{diameter_index}=['>' num2str(min_diameter)];
            else
                min_diameter=diameter_criteria(diameter_index-1);
                max_diameter=diameter_criteria(diameter_index);
                diameter_labels{diameter_index}=[num2str(min_diameter) '<d<=' num2str(max_diameter)];
            end
        end
    end

    for current_type=1:numel(animal_types)
        current_data=data.*strcmp(animal_type,animal_types{current_type}).*...
            (diameter>=min_diameter).*(diameter<max_diameter);
        current_data(~isfinite(current_data))=0;
        current_data=nonzeros(current_data);
        
        data_compiled.data{current_type,diameter_index}=current_data;
        data_compiled.bars(current_type,diameter_index)=mean(current_data);
        data_compiled.n(current_type,diameter_index)=numel(current_data);
        data_compiled.errors(current_type,diameter_index)=std(current_data)./...
            sqrt(data_compiled.n(current_type,diameter_index));

    end
end

graph_color=[1 1 1];
figure(figure_handle)

handles=barweb(data_compiled.bars, data_compiled.errors,0.8,animal_type_title,...
    graph_title, [], y_label,graph_color,'y',diameter_labels,[],'axis');

Ytick=get(handles.ax,'Ytick');
y_position=(Ytick(2)+Ytick(1))/2;


for diameter_index=1:numel(diameter_criteria)+1
    H=ttest2(data_compiled.data{1,diameter_index},data_compiled.data{3,diameter_index});
    x_positions=mean(get(get(handles.bars(diameter_index),'Children'),'XData'),1);
    for current_type=1:numel(animal_types)
        if numel(diameter_criteria)==0
        x_positions=mean(get(get(handles.bars(current_type),'Children'),'XData'),1);
        end

        value=data_compiled.n(current_type,diameter_index);
        if numel(diameter_criteria)==0
            current_x_position=x_positions(1);
        else
            current_x_position=x_positions(current_type);
        end
        
        text_to_write=['n=' num2str(value)];
        
        if H
            text_to_write=[text_to_write ' *'];
        end
        text(current_x_position,y_position,...
            text_to_write,...
            'HorizontalAlignment','Center');
    end
end

savename=regexprep(graph_title,' ','_');

print('-dpdf',[savename '.pdf'])
movefile([savename '.pdf'],['Figures/' savename '.pdf'])

