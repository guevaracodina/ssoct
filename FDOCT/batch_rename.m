function batch_rename(folder, expression, replace)
fileList = dir(folder);
doBackup = false;

if doBackup
    mkdir(folder, 'BACKUP');
    backupFolder = fullfile(folder,'BACKUP', filesep);
    files2backup = fullfile(folder, '*.mat');
    [s,mess,messid]=copyfile(files2backup, backupFolder, 'f');
    files2backup = fullfile(folder, '*.dat');
    [s,mess,messid]=copyfile(files2backup, backupFolder, 'f');
end

for iFiles = 3:length(fileList),
    oldName = fileList(iFiles).name;
    newName = regexprep(oldName, expression, replace);
    if ~strcmp(oldName, newName)
%         movefile(fullfile(folder, oldName), fullfile(folder, newName)); % Slow! 
%         dos(['rename ' fullfile(folder, oldName) ' ' newName]); % Spaces!
        % Fast undocumented java syntax
        java.io.File(fullfile(folder, oldName)).renameTo(java.io.File(fullfile(folder, newName)));
    end
end
end