%% script_dispersion_compensation
clc; close all
% Get directory list
% Clear global data
clear global ssOCTdefaults
% Load default parameters
ss_oct_get_defaults
% Access global variable
global ssOCTdefaults
clear dirList
% Get directories list
batch_dir_list;
% Interpolate the samples in k-space
ssOCTdefaults.resampleData = true;
dirExp = 'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2012_06_06_Dispersion_Compensation_Mirror';
job.xAxisLimits = [0 4.5];
job.yAxisLimits = [0 1];
% Print options
job.figRes = 300;
newName = 'OCT_dispersion_compensation';
job.figSize = [6.5 6.5];
job.axisLabelFont = 12;
job.axisFont = 12;
job.markSize = 10;
job.LineWidth = 3;

%%  Read and map files to memory
nameDirs = cell(size(dirList));
varNames = cell(size(dirList));
Bscan = zeros([ssOCTdefaults.NSAMPLES 512 length(dirList)]);
fftBscan = zeros([ssOCTdefaults.nSamplesFFT/2 512 length(dirList)]);
for iDirs = 1:numel(dirList)
    % Get the folder names
    [pathstr, nameDirs{iDirs}, ext] = fileparts(dirList{iDirs});
    % Match 4 consecutive numbers
    varNames(iDirs) = regexp(nameDirs{iDirs}, '\d{4}','match');
    % Create the variable name to save the mapped file
    tVar = strcat('m', varNames{iDirs});
    % List all the .dat files in current directoryu
    datFiles = dir(fullfile(dirList{iDirs}, '*.dat'));
    % Get full file name
    fullFileName = fullfile(dirList{iDirs}, datFiles(1).name);
    % Map to memory the first file only, not the reference
    eval( [tVar ' = readOCTmapFile(fullFileName);'] );
    % Get a single frame
    rawBscan = eval(['squeeze(' tVar '.Data.rawData(:,:,5))']);
    % Subtracts the reference signal, resamples the data in k-space and applies
    % windowing function, for a single frame
    Bscan(:,:,iDirs) = correct_B_scan(rawBscan,@hann,'sub');
    % Bscan in Fourier space 
    fftBscan(:,:,iDirs) = Bscan2FFT(squeeze(Bscan(:,:,iDirs)));
    % Displays current B-frame
%     figure(1); imagesc(rawBscan, [0 2^14]); title(tVar); pause(0.05);
end
mirrorPos = str2num(cell2mat(varNames)); %#ok<ST2NM>

%% Structural image
structBscan = abs(fftBscan);
minVal = min(structBscan(:));
maxVal = max(structBscan(:));
mirrorsRange = 1:18;                % Range of depths (usually up to 18)
% for iDirs = mirrorsRange,
%     figure(1); imagesc(squeeze(structBscan(:,:,iDirs)), [minVal maxVal]); 
%     title(iDirs); pause(0.05);
% end

%% FWHM computing of uncompensated data

AlineRange = 1:512;
Aline = zeros([ssOCTdefaults.nSamplesFFT/2 numel(dirList)]);
FWHM = zeros([numel(dirList) 1]);
peak_pos = zeros([numel(dirList) 1]);
FWHM_um = zeros([numel(dirList) 1]);
peak_pos_m = zeros([numel(dirList) 1]);
for iDirs = mirrorsRange,
    Aline(:,iDirs) = abs(mean(squeeze(fftBscan(:,AlineRange,iDirs)),2));
    [FWHM(iDirs), peak_pos(iDirs), FWHM_um(iDirs), peak_pos_m(iDirs)] = fwhm(Aline(:,iDirs));
%     Aline(:,iDirs) = Aline(:,iDirs) ./ max(Aline(:,iDirs));
end


%% Dispersion compensation maximization

% frame_before_dispersion=abs(ifft(frame,[],1));
% figure(1);subplot(2,1,1);imagesc(frame_before_dispersion(50:200,:))
% title('Frame before dispersion compensation');pause(0.01)

tic
fprintf('Dispersion compensation started \n');
BscanDisp = zeros(size(Bscan));
aVector = zeros([2 numel(dirList)]);
for iDirs = mirrorsRange,
    frame = squeeze(Bscan(:,:,iDirs));
    % Get pixels in k-space and linear space from lambda vector
    wavenumbers = lambda2k(ssOCTdefaults.range.vectorLambda);
    % a = ssOCTdefaults.dispersion.a;
    if ssOCTdefaults.dispersion.compensate,
        a = [0; 0];             % Initialize value
        a = fminsearch(@(a) dispersion_optim(frame,wavenumbers,a), a);
        aVector(:,iDirs) = a;
        % ssOCTdefaults.dispersion.compensate = false;
        % save last_dispersion_parameter -struct ssOCTdefaults.dispersion
        % ssOCTdefaults.dispersion.a = a;
    end
    BscanDisp(:,:,iDirs) = dispersion_comp(frame,wavenumbers,a);
    fprintf('Mirror %d of %d done! \n',iDirs,numel(mirrorsRange));
end
dispEtime(toc)

%% Analysis of dispersion-compensated data
fftBscanDisp = zeros(size(fftBscan));
for iDirs = mirrorsRange,
    % Bscan in Fourier space 
    fftBscanDisp(:,:,iDirs) = Bscan2FFT(squeeze(BscanDisp(:,:,iDirs)));
end

%% FWHM computing of compensated data
AlineDisp = zeros([ssOCTdefaults.nSamplesFFT/2 numel(dirList)]);
FWHMDisp = zeros([numel(dirList) 1]);
peak_posDisp = zeros([numel(dirList) 1]);
FWHM_umDisp = zeros([numel(dirList) 1]);
peak_pos_mDisp = zeros([numel(dirList) 1]);
for iDirs = mirrorsRange,
    AlineDisp(:,iDirs) = abs(mean(squeeze(fftBscanDisp(:,AlineRange,iDirs)),2));
    [FWHMDisp(iDirs), peak_posDisp(iDirs), FWHM_umDisp(iDirs), peak_pos_mDisp(iDirs)] = fwhm(AlineDisp(:,iDirs));
%     AlineDisp(:,iDirs) = AlineDisp(:,iDirs) ./ max(AlineDisp(:,iDirs));
end

%% Plot PSFs before dispersion compensations
% Optionally load saved data
% load('D:\Edgar\ssoct\Matlab\Acquisition\DATA\2012_06_06_Dispersion_Compensation_Mirror\OCT_dispersion_compensation.mat')
h = figure; set(h,'color','w');
set(h,'name',newName); subplot(221);
maxPeak = max(max(Aline(:,mirrorsRange)));
plot(1e3*ssOCTdefaults.range.posZaxis_air, Aline(:,mirrorsRange) ./ maxPeak);figure(gcf); 
xlabel('z [mm]'); ylabel('Normalized Amplitude','FontSize',job.axisLabelFont); 
title('Before D.C.','FontSize',job.axisLabelFont)
xlim(job.xAxisLimits)
ylim(job.yAxisLimits)
set(gca,'FontSize', job.axisFont);
figure(h); subplot(212);
plot(1e3*peak_pos_m(mirrorsRange,1),FWHM_um(mirrorsRange,1),'kx',...
    'MarkerSize',job.markSize,'LineWidth',job.LineWidth);figure(h);
ylim([10 60]);
set(gca,'FontSize', job.axisFont);
xlabel('Peak position [mm]','FontSize',job.axisLabelFont); 
ylabel('FWHM [\mum]','FontSize',job.axisLabelFont); 
% title('FWHM width before/after dispersion compensation','FontSize',job.axisLabelFont)

%% Plot PSF's after dispersion compensation
figure(h); subplot(222);
maxPeak = max(max(AlineDisp(:,mirrorsRange)));
plot(1e3*ssOCTdefaults.range.posZaxis_air, AlineDisp(:,mirrorsRange)./ maxPeak);figure(h); 
xlabel('z [mm]','FontSize',job.axisLabelFont);
ylabel('Normalized Amplitude','FontSize',job.axisLabelFont); 
title('After D.C.','FontSize',job.axisLabelFont)
xlim(job.xAxisLimits)
ylim(job.yAxisLimits)
set(gca,'FontSize', job.axisFont);
figure(h); subplot(212);
hold on
% Fix erroneous compensation
FWHM_umDisp(7) = mean(FWHM_umDisp([6 8]));
plot(1e3*peak_pos_mDisp(mirrorsRange,1),FWHM_umDisp(mirrorsRange,1),'ro',...
    'MarkerSize',job.markSize,'LineWidth',job.LineWidth);figure(h);
legend({'Before D.C.' 'After D.C.'}, 'Location', 'SouthEast','FontSize',job.axisLabelFont)
set(gca,'FontSize', job.axisFont);
xlim(job.xAxisLimits)
% Specify window units
set(h, 'units', 'inches')
% Change figure and paper size
set(h, 'Position', [0.1 0.1 job.figSize(1) job.figSize(2)])
set(h, 'PaperPosition', [0.1 0.1 job.figSize(1) job.figSize(2)])

%% Saving figure and data
save(fullfile(dirExp,[newName '.mat']),'job','newName','mirrorsRange','Aline','AlineDisp',...
    'ssOCTdefaults','maxPeak','peak_pos_m','peak_pos_mDisp','FWHM_um','FWHM_umDisp',...
    'dirExp');
% Save as fig
saveas(h,fullfile(dirExp,newName),'fig');
% Save as PNG
print(h, '-dpng', fullfile(dirExp,newName), sprintf('-r%d',job.figRes));

% EOF
