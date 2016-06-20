%% Load binary raw data
pathName = 'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2012_04_23_NIOS\12_37_38_Internal Data\12_38_23_0000001.dat';
[mappedFile, pathName] = readOCTmapFile(pathName);
if exist(fullfile(pathName,'referenceFrame.dat'), 'file')
    [refB, pathName] = readOCTmapFile(fullfile(pathName,'referenceFrame.dat'));
    refB = squeeze(refB.Data.rawData(:,:,1));
else
    refB = load(fullfile(pathName,'Reference_Measurements.mat'));
    refB = refB.rawBscanRef;
end
acqParam = readCSVfile(fullfile(pathName,'acqParam.csv'));

%% Display raw interferogram
% figure;
% minVal = min(mappedFile.Data.rawData(:));
% maxVal = max(mappedFile.Data.rawData(:));
% colormap(get_colormaps('octgold'));
% for i=1:mappedFile.format{2}(3),
% %     imagesc(squeeze(mappedFile.Data.rawData(:,:,i)),[minVal maxVal]);
% %     colorbar
%     Bscan = squeeze(mappedFile.Data.rawData(:,:,i));
%     plot(Bscan(:),'k.');
%     ylim([minVal maxVal])
%     title(sprintf('Raw B-frame: %d / %d', i, mappedFile.format{2}(3)))
%     pause(0.01)
% end

%% Find differences between frames
% Differentiate along time axis
diffB = diff(mappedFile.Data.rawData, 1, 3);
allZeros = zeros(size(diffB, 3), 1);
for i=1:size(diffB, 3),
    allZeros(i) = any(any(squeeze(diffB(:,:,i))));
end

% Display 
figure; stem(allZeros);
title('Difference between B-frames')
ylim([-0.2 1.2])
set(gca,'Ytick', [0 1])
set(gca,'YtickLabel', {'No Diff' 'Diff Found'})
xlabel('B-frame index')
axis tight

%%  Find differences between A-lines
% First frame
Bscan = squeeze(mappedFile.Data.rawData(:,:,1));

% Calculate ramp in one B-scan
ramp = double(Bscan(1,:)) - double(Bscan(1,1));
rampMatrix = ramp(ones([1 mappedFile.format{2}(1)]), :);

% Transfer to RAM, not very efficient, but file attributes are read-only
Bscan = double(mappedFile.Data.rawData);

% Subtract ramp to all frames
for i=1:mappedFile.format{2}(3),
    Bscan(:,:,i) = double(squeeze(mappedFile.Data.rawData(:,:,i))) - rampMatrix;
end

% Pre-allocate
diffB = zeros([size(Bscan, 1), size(Bscan, 2) - 1, size(Bscan, 3)]);

for i=1:mappedFile.format{2}(3),
    % Differentiate along A-lines axis (512-1 A-lines)
    diffB(:,:,i) = diff( Bscan(:,:,i), 1, 2);
end

for i=1:size(diffB, 3),
    allZeros(i) = any(any(squeeze(diffB(:,:,i))));
end

% Display 
figure; stem(allZeros);
title('Difference between A-lines in each B-frame')
ylim([-0.2 1.2])
set(gca,'Ytick', [0 1])
set(gca,'YtickLabel', {'No Diff' 'Diff Found'})
xlabel('B-frame index')
axis tight
