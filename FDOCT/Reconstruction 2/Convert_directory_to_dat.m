% This function will convert all the .bin files in a directory to the .dat
% and .mat standard.
clear
fclose all

directory=uigetdir('.','Choose directory containing .bin files to convert to .dat');
folders=genpath(directory);

separators=findstr(folders,';');

for i=1:length(separators)
    if i==1
        beginning=1;
    else
        beginning=separators(i-1)+1;
    end
    ending=separators(i)-1;
    pathnames{i}=folders(beginning:ending);
end

%This will count to total amount of files to convert in the directory
n_files_total=0;
for i=1:length(pathnames)
    current_folder=dir(pathnames{i});
    clear filenames
    for j=1:length(current_folder)
        
        if strfind(current_folder(j).name,'.bin')
            
            n_files_total=n_files_total+1;
            end
        
    end
end
disp(['Converting ' num2str(n_files_total)...
    ' bin files in ' num2str(length(pathnames)) ' folders'])

%This will process the files one directory at a time
n_files_current=0;
for i=1:length(pathnames)
    
    current_folder=dir(pathnames{i});
    n_files=0;
    
    clear filenames
    for j=1:length(current_folder)
        
        if strfind(current_folder(j).name,'.bin')
            n_files=n_files+1;
            filenames{n_files}=current_folder(j).name;
        end
        
    end
    n_file_start=1+n_files_current;
    n_files_current=n_files+n_files_current;
    
    if n_files>0
    disp(['Folder ' num2str(i) ' of ' num2str(length(pathnames))...
        ', files ' num2str(n_file_start) ' to ' num2str(n_files_current) ' of '...
        num2str(n_files_total)])
    [acqui_info]=Process_bin2dat(filenames,[pathnames{i} '\']);
    end
end