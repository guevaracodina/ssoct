%% Plot PSFs before dispersion compensations
close all
% Optionally load saved data
load('D:\Edgar\ssoct\Matlab\Acquisition\DATA\2012_06_06_Dispersion_Compensation_Mirror\OCT_dispersion_compensation.mat')
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

%% AlazarTech
% Clear global data
clear global ssOCTdefaults
% Load default parameters
ss_oct_get_defaults
% Access global variable
global ssOCTdefaults
ssOCTdefaults.folders.dirCurrExp = 'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2013_07_26_AlazarMirror\AlazarMirror150';
% ssOCTdefaults.folders.dirCurrExp = 'D:\Edgar\ssoct\Matlab\Acquisition\DATA\2013_07_26_AlazarMirror\AlazarMirror050';
% Load reference
load(fullfile(ssOCTdefaults.folders.dirCurrExp,'Reference_Measurements.mat'))
% Load B-scan
load(fullfile(ssOCTdefaults.folders.dirCurrExp,'bScan.mat'))
rawBscanAlazar = dataOut; clear dataOut;
ssOCTdefaults.resampleData = false;
% Number of samples per A-line
ssOCTdefaults.NSAMPLES = 1152;
% Number of samples to perform FFT
ssOCTdefaults.nSamplesFFT               = 2^nextpow2(2*ssOCTdefaults.NSAMPLES);
% Number of A-lines per frame
ssOCTdefaults.nLinesPerFrame = 512;
%===============================================================================
% Maximum path difference (Scan Range of a FDOCT) (Penetration depth)
%===============================================================================
ssOCTdefaults.range.delta_Z_Nq          = ssOCTdefaults.axial.lambda0^2 * ...
    ssOCTdefaults.NSAMPLES / (4*ssOCTdefaults.axial.delta_lambda*ssOCTdefaults.axial.n);
% Index of refraction of air
ssOCTdefaults.range.n_air               = 1;
ssOCTdefaults.range.delta_Z_Nq_air      = ssOCTdefaults.axial.lambda0^2 * ...
    ssOCTdefaults.NSAMPLES / (4*ssOCTdefaults.axial.delta_lambda*ssOCTdefaults.range.n_air);
% Wavenumber range
ssOCTdefaults.range.minK                = 2*pi / ssOCTdefaults.axial.maxLambda;
ssOCTdefaults.range.maxK                = 2*pi / ssOCTdefaults.axial.minLambda;
% Wavenumbers column vector
ssOCTdefaults.range.vectorK             = linspace(ssOCTdefaults.range.maxK,...
    ssOCTdefaults.range.minK, ssOCTdefaults.NSAMPLES)';
% Lambda Column Vector (in m)
ssOCTdefaults.range.vectorLambda        = 2*pi ./ ssOCTdefaults.range.vectorK;
% z-axis in m (air)
ssOCTdefaults.range.zAxis_air           = linspace(ssOCTdefaults.range.delta_Z_Nq_air ./...
    ssOCTdefaults.nSamplesFFT,ssOCTdefaults.range.delta_Z_Nq_air,ssOCTdefaults.nSamplesFFT);
% z-axis in m (tissue)
ssOCTdefaults.range.zAxis               = linspace(ssOCTdefaults.range.delta_Z_Nq ./...
    ssOCTdefaults.nSamplesFFT,ssOCTdefaults.range.delta_Z_Nq,ssOCTdefaults.nSamplesFFT);
% Positive z-axis in m (air)
ssOCTdefaults.range.posZaxis_air        = linspace(ssOCTdefaults.range.delta_Z_Nq_air ./...
    ssOCTdefaults.nSamplesFFT,ssOCTdefaults.range.delta_Z_Nq_air,ssOCTdefaults.nSamplesFFT/2);
% Positive z-axis in m (tissue)
ssOCTdefaults.range.posZaxis            = linspace(ssOCTdefaults.range.delta_Z_Nq ./...
    ssOCTdefaults.nSamplesFFT,ssOCTdefaults.range.delta_Z_Nq,ssOCTdefaults.nSamplesFFT/2);

%% Get structural B-frame
% Subtracts the reference signal, resamples the data in k-space and applies
% windowing function, for a single frame
BscanAlazar = correct_B_scan(rawBscanAlazar,@rectwin,'sub');
% Bscan in Fourier space
fftBscanAlazar = Bscan2FFT(BscanAlazar);
% Structural image
structBscanAlazar = abs(fftBscanAlazar);
ylimits = [0 0.2];
h1 = figure; set(h1,'color','w')
set(gca,'color','w')
imagesc(1:ssOCTdefaults.nLinesPerFrame,1e3*ssOCTdefaults.range.posZaxis_air,structBscanAlazar)
ylim(ylimits)
% gold colormap
colormap(get_colormaps('octgold'))
% FWHM computation
for iLines = 1:ssOCTdefaults.nLinesPerFrame,
    [FWHMAlazar(iLines), peak_posAlazar(iLines), FWHM_umAlazar(iLines), peak_pos_mAlazar(iLines)] = fwhm(structBscanAlazar(:,iLines));
end

%% Compensate dispersion
% Get pixels in k-space and linear space from lambda vector
wavenumbers = lambda2k(ssOCTdefaults.range.vectorLambda);
% a = ssOCTdefaults.dispersion.a;
if ssOCTdefaults.dispersion.compensate,
    a = [0; 0];             % Initialize value
    a = fminsearch(@(a) dispersion_optim(BscanAlazar,wavenumbers,a), a);
    % ssOCTdefaults.dispersion.compensate = false;
    % save last_dispersion_parameter -struct ssOCTdefaults.dispersion
    % ssOCTdefaults.dispersion.a = a;
end
% Compensate dispersion
BscanDispAlazar = dispersion_comp(BscanAlazar,wavenumbers,a);
% FFT of compensated data
fftBscanAlazarDisp = Bscan2FFT(BscanDispAlazar);
% Structural image
structBscanAlazarDisp = abs(fftBscanAlazarDisp);
    
% FWHM computation
for iLines = 1:ssOCTdefaults.nLinesPerFrame,
    [FWHMAlazarDisp(iLines), peak_posAlazarDisp(iLines), FWHM_umAlazarDisp(iLines), peak_pos_mAlazarDisp(iLines)] = fwhm(structBscanAlazarDisp (:,iLines));
end

h2 = figure; set(h2,'color','w')
set(gca,'color','w')
imagesc(1:ssOCTdefaults.nLinesPerFrame,1e3*ssOCTdefaults.range.posZaxis_air,structBscanAlazarDisp)
ylim(ylimits)
% gold colormap
colormap(get_colormaps('octgold'))
[Y,I] = min(FWHM_umAlazarDisp);
fprintf('FWHM = %0.4f um\n',Y);

%% Display A-lines
h = figure; set(gcf,'color','w')
linewidth = 2.5;
ylimits = [0 0.28];
job.figSize = [3 3];
job.optFig.figRes = 300;
job.parent_results_dir{1} = 'D:\Edgar\Documents\Dropbox\Docs\OCT\AlazarTech';
plot(1e3*ssOCTdefaults.range.posZaxis_air, ...
    AlineDisp(:,1) ./ max(AlineDisp(:,1)),'b-','LineWidth',linewidth);
xlim(ylimits)
hold on
plot(1e3*ssOCTdefaults.range.posZaxis_air, ...
    structBscanAlazarDisp(:,I) ./ max(structBscanAlazarDisp(:,I)),'r-','LineWidth',linewidth);
xlim(ylimits)
% legend({'FPGA' 'AlazarTech'},'FontSize',job.axisLabelFont,'Location','NorthEast')
xlabel('[mm]','FontSize',job.axisLabelFont)
ylabel('[mm]','FontSize',job.axisLabelFont)
ylabel('Normalized Amplitude','FontSize',job.axisLabelFont);
set(gca,'FontSize', job.axisFont);
% Specify window units
set(h, 'units', 'inches')
% Change figure and paper size
set(h, 'Position', [0.1 0.1 job.figSize(1) job.figSize(2)])
set(h, 'PaperPosition', [0.1 0.1 job.figSize(1) job.figSize(2)])
print(h, '-dpng', fullfile(job.parent_results_dir{1},'PSF_comparison'), sprintf('-r%d',job.optFig.figRes));


%% Saving figure and data
% save(fullfile(dirExp,[newName '.mat']),'job','newName','mirrorsRange','Aline','AlineDisp',...
%     'ssOCTdefaults','maxPeak','peak_pos_m','peak_pos_mDisp','FWHM_um','FWHM_umDisp',...
%     'dirExp');
% % Save as fig
% saveas(h,fullfile(dirExp,newName),'fig');
% % Save as PNG
% print(h, '-dpng', fullfile(dirExp,newName), sprintf('-r%d',job.figRes));

% EOF
