%% Correction script
% Retreive all *.dat files in all subfolders in a recursive fashion
[~,fileList] = system('dir D:\Edgar\ssoct\Matlab\Acquisition\DATA\Mirror_Characterization\*.dat /s /b');

%% Convert file list to cell
[startIndex, endIndex, tokIndex, matchStr, tokenStr, exprNames,splitStr] = regexp(fileList, '\n');

%% Correction file loop
fclose('all');
for iFiles = 1:length(splitStr)-1,
    fclose('all');
    % Pick every single file
    fileName = splitStr{iFiles};
    
    % Map file to memory
    [mappedFile,~,~,nFramesSaved] = correctOCTmapFile(fileName);

    % Keep only 1128 samples acquired @ 125MHz
    rawData = mappedFile.Data.rawData;
    rawData = rawData(1:1128,:,:);
    clear mappedFile
    
    % Create binary file
    fid = fopen(fileName, 'w');
    for iFrames = 1:nFramesSaved,
        % --------------------- Save a B-scan frame ----------------------------
        fwrite(fid, squeeze(rawData(:,:,iFrames)), 'uint16');
    end
    fclose(fid);
end
