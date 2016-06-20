function batch_rename_parser(parentDir, expression, replace)
for iDirs = 1:numel(parentDir)
    batch_rename(parentDir{iDirs}, expression, replace)
end
