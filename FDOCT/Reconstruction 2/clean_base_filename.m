function base_filename_clean=clean_base_filename(base_filename);
%This will take a base filename and clean up any spaces and dashes at the
%end of it

base_filename_clean=base_filename;
cleaning_base_filename=1;

while cleaning_base_filename
    if strmatch(base_filename_clean(end),'-','exact')|strmatch(base_filename_clean(end),' ','exact')
        base_filename_clean=base_filename_clean(1:end-1);
    else
        cleaning_base_filename=0;
    end
end