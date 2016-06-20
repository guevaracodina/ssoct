%% load galvo ramps
% fid=fopen('D:\Edgar\Data\OCT_Data\2012-03-15 - Fantom Ballon\Vol 0.4 ml\Fantom Ballon - Vol 0.4ml - 3D rev fast axis-11200.bin');
% acqui_info = struct();
% [acqui_info]=read_bin_header(fid,acqui_info);
% fclose(fid);

%% load binary raw data
pathName = 'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2012_04_03_Phantom 2 tubes\17_51_56_Scan 3D\17_55_34_0000001.dat';
global ssOCTdefaults
ss_oct_get_defaults
[mappedFile, pathName] = readOCTmapFile();
if exist(fullfile(pathName,'referenceFrame.dat'), 'file')
    [refB, pathName] = readOCTmapFile(fullfile(pathName,'referenceFrame.dat'));
    refB = squeeze(refB.Data.rawData(:,:,1));
else
    refB = load(fullfile(pathName,'Reference_Measurements.mat'));
    refB = refB.rawBscanRef;
end
acqParam = readCSVfile(fullfile(pathName,'acqParam.csv'));

%% display raw interferogram
% figure;
% colormap(get_colormaps('octgold'));
% for i=1:10:mappedFile.format{2}(3),
% % for i=790:850,
%     imagesc(squeeze(mappedFile.Data.rawData(:,:,i)),[0 2^14]);
%     title(sprintf('Raw B-frame: %d / %d', i, mappedFile.format{2}(3)))
%     pause(0.05)
% end


%% display processed data
% figure;
% ssOCTdefaults.GUI.displayLog = true;
% for i=1:1:mappedFile.format{2}(3),
%     correctedBscan = correct_B_scan(squeeze(mappedFile.Data.rawData(:,:,i)),@myhann,'sub');
%     Bscan = abs(Bscan2FFT(correctedBscan));
%      % LPF
%     Bscan(ssOCTdefaults.nSamplesFFT/2:-1:ssOCTdefaults.nSamplesFFT/2-12+1) = 0;
%      if ssOCTdefaults.GUI.displayLog
%         % Display in log scale, single-sided FFT (left part of spectrum), with
%         % z-axis in um
%         imagesc(1:ssOCTdefaults.nLinesPerFrame, 1e3*ssOCTdefaults.range.posZaxis_air,...
%             log(Bscan(ssOCTdefaults.nSamplesFFT/2:-1:1,:)+1));
%     else
%         % Display in linear scale, single-sided FFT (left part of spectrum), with
%         % z-axis in um
%     %     imagesc(1:ssOCTdefaults.nLinesPerFrame, 1e3*ssOCTdefaults.range.posZaxis_air,...
%     %         Bscan(ssOCTdefaults.nSamplesFFT/2:-1:1,:));
%         % Display until 1.2mm
%         imagesc(1:ssOCTdefaults.nLinesPerFrame, 1e3*ssOCTdefaults.range.posZaxis_air(1:490),...
%             Bscan(ssOCTdefaults.nSamplesFFT/2:-1:ssOCTdefaults.nSamplesFFT/2-490-1,:));
%     end
%     if ssOCTdefaults.GUI.displayColorBar
%         colorbar;
%     else
%         colorbar off;
%     end
%     axis tight
%     colormap(get_colormaps('octgold'));
%     ylabel('z [mm]')
%     xlabel('A-lines')
%     title(sprintf('Reconstructed B-frame: %d / %d', i, mappedFile.format{2}(3)))
%     pause(0.001)
% end


%% Cross-correlation test
Bscan = squeeze(mappedFile.Data.rawData(:,:,2));
BscanCorr = zeros(size(Bscan));
refA = median(refB,2);
for iLines = 1:size(Bscan,2),
    [xC, lags] = xcorr(Bscan(:,iLines), refA);
    [val, idx] = max(xC);
    refAlag = circshift(refA, lags(idx) +1);
    BscanCorr(:,iLines) = double(Bscan(:,iLines)) - double(refAlag);
end

figure;
colormap(get_colormaps('octgold'));
subplot(221);
imagesc(Bscan);
subplot(222);
imagesc(BscanCorr);

% -- Normal reference
BscanWinNorm = correct_B_scan(Bscan,@myhann,'sub');
BscanStructNorm = FFT2struct(Bscan2FFT(BscanWinNorm));
% HPF
BscanStructNorm(1:12,:) = 0;

subplot(223);
imagesc(1:ssOCTdefaults.nLinesPerFrame, 1e3*ssOCTdefaults.range.posZaxis, BscanStructNorm);
colorbar
axis tight
ylabel('z [mm]')
xlabel('A-lines')


% -- cross-correlation
BscanWin = correct_B_scan(BscanCorr,@myhann,'none');
BscanStruct = FFT2struct(Bscan2FFT(BscanWin));
% HPF
BscanStruct(1:12,:) = 0;

subplot(224);
imagesc(1:ssOCTdefaults.nLinesPerFrame, 1e3*ssOCTdefaults.range.posZaxis, BscanStruct);
colorbar
axis tight
ylabel('z [mm]')
xlabel('A-lines')





