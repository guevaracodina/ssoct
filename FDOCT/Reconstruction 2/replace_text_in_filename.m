function replace_text_in_filename(original,replacement)
[filenames,pathname]=uigetfile('*.*','Select files to rename','Multiselect','on')

if ~iscell(filenames)
    temp=filenames;
    clear filenames
    filenames{1}=temp; clear temp
end

for i=1:length(filenames)
    new_filename=regexprep(filenames{i},original,replacement)
    movefile([pathname filenames{i}],[pathname new_filename])
end