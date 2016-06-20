function [pathname,filename]=pair_filenames(pathname,filename)

if ~exist('pathname','var') 
    [pathname,filename]=prompt_acquisition...
        ('Select files to automatically pair');
end

file_number=1;
current_zone=1;
more_files=1;
while more_files
    current_parent_pathname=pathname{file_number};
    pathname_new{current_zone}=current_parent_pathname;
    for i=file_number:numel(pathname)
        if strcmp(current_parent_pathname,pathname{i});
        type=identifity_acquisition_type(filename{i});
        eval(['filename_paired{current_zone}.' type '=filename{i};']);
        file_number=i+1;
        end
    end
current_zone=current_zone+1;

if file_number>=numel(pathname)
    more_files=0;
end
end
filename=filename_paired;
pathname=pathname_new;
end
