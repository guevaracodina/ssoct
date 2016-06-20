function [pathname,filename]=prompt_acquisition(prompt_text,pathname,filename);
% This will ask the user to load multiple acquisitions. It will continue
% taking selections until cancel is pressed. A maximal number of
% acquisitions can be set by writing it in the prompt_text surrounded by !.
% For example prompt_text='Select !12! files' will stop asking for files
% after the 12th file or if the user pressed cancel.
%
% pathname and filename are optional input cells that contain a list of previous
% acquisitions to which the current acquisitions will be added. If they are
% specified the loading window will default in the path of the last
% acquisition of the list.

if ~exist('prompt_text')
    prompt_text='Select acquisition files';
end

if exist('pathname')
    if iscell(pathname)
        number_of_acquisitions=numel(pathname);
        pathname_current=pathname{end};
    else
        error('The preloaded pathname is not valid')
    end
else
    number_of_acquisitions=0;
    pathname_current=[pwd '\Path_shortcuts\'];
    filename=cell(1,1);
    pathname=cell(1,1);
end

done_selecting=1;

if strfind(prompt_text,'!')
    position=strfind(prompt_text,'!');
    no_of_files_max=str2num(prompt_text(position(1)+1:position(2)-1));
    prompt_text=regexprep(prompt_text,'!','');
else
    no_of_files_max=inf;
end

additional_acquisitions=0;

while done_selecting
    
    [filename_current,pathname_current]=...
        uigetfile('mat',['File ' num2str(number_of_acquisitions) ...
        ' : ' prompt_text],pathname_current,'Multiselect','on');
    
    if ~iscell(filename_current)
        filename_current_temp=filename_current;
        clear filename_current
        filename_current{1}=filename_current_temp;
    end
    
    if filename_current{1}==0;
        done_selecting=0;
    else
        number_of_files_current_selection=numel(filename_current);
        additional_acquisitions=additional_acquisitions+...
            number_of_files_current_selection;
        number_of_acquisitions=number_of_acquisitions+...
            number_of_files_current_selection;
        
        if additional_acquisitions>=no_of_files_max;
            done_selecting=0;
        end
        
        for i=number_of_acquisitions-number_of_files_current_selection+1:number_of_acquisitions
            filename{i}=filename_current{i+number_of_files_current_selection-number_of_acquisitions};
            pathname{i}=pathname_current;
            disp(['File ' num2str(i)...
                ' : ' filename{i}])
        end
    end
    
end
%By default, prompt_acquisition will offer to save the new selected list
offer_to_save=1;

if number_of_acquisitions==1
    offer_to_save=0;
end

if number_of_acquisitions==0;pathname=[];filename=[];
    offer_to_save=0;
else
    %This will verify the selected files, if a file contains the references
    %to other files, it will be removed from the list and it's references
    %added in it's place
    pathname_extended={};
    filename_extended={};
    total_number_of_files=0;
    for i=1:numel(filename)
        variable_names=whos('-file',[pathname{i} filename{i}]);
        
        if strcmp(variable_names(1).name,'filename')...
                ||strcmp(variable_names(1).name,'pathname')
            new_list=load([pathname{i} filename{i}]);
            %If at least one of the selected files is a list,
            %prompt_acquisition will not offer to save the new selection
            offer_to_save=0;
            for k=1:numel(new_list.pathname)
                pathname_extended{total_number_of_files+k}=new_list.pathname{k};
                filename_extended{total_number_of_files+k}=new_list.filename{k};
            end
            total_number_of_files=total_number_of_files+numel(new_list.pathname);
        else
            pathname_extended{total_number_of_files+1}=pathname{i};
            filename_extended{total_number_of_files+1}=filename{i};
            total_number_of_files=total_number_of_files+1;
        end
    end
    pathname=pathname_extended;
    filename=filename_extended;
        
    %This will go through the list of files and eliminate the ones that dont
    %exist
    for i=1:numel(filename)
        if ~exist([pathname{i} filename{i}],'file')
            disp(['Eliminated file ' filename{i}]);
            pathname{i}='';
            filename{i}='';
        end
    end
    pathname={pathname{~strcmp(pathname,'')}};
    filename={filename{~strcmp(filename,'')}};
    
end

if offer_to_save
    button=questdlg('Would you like to save this new list?','Save list');
    if strcmp(button,'Yes')
        [filename_save,pathname_save]=uiputfile('*.mat','Save New List As: ',[pwd '\Path_shortcuts\']);
        if filename_save~=0
            save([pathname_save filename_save],'filename','pathname')
        end
    end
end

disp(['Total of ' num2str(numel(pathname)) ' acquisitions selected'])