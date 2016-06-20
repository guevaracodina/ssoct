% Script to analyze magnetomotive OCT files using Edward's code
%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara
% 2011/07/20
%% Preprocess .bin files to .mat +.dat
cd('D:\Edgar\FDOCT\Reconstruction 2')
addpath(genpath('D:\Edgar\FDOCT\'))
OCT_processor

%% Reconstruction of .dat files to .dop3D .struct3D
main_reconstruction

%% Map files to memory
clear
map_3D_files

%% 
load('D:\Edgar\FDOCT\Reconstruction 2\doppler_color_map.mat')
% Minimum & maximum values to display structureal data
minVal = min(Structure.Data.Data(:));
maxVal = max(Structure.Data.Data(:));

%%
xTicks = recons_info.step(1)*[1:recons_info.size(1)];
zTicks = recons_info.step(2)*[1:recons_info.size(2)];
figure;
for iFrames=1:acqui_info.nframes,
    imagesc(xTicks,zTicks,squeeze(Structure.Data.Data(:,:,iFrames))',[minVal maxVal]); colormap(gray(255));
    xlabel([recons_info.type(1) ' [um]'])
    ylabel([recons_info.type(2) ' [um]'])
    colorbar
    title(sprintf('Frame %d.',iFrames))
    pause(0.05)
end

%% Structural data
% If acquisition was made in M-mode (0 scanning)
if any(recons_info.step == 0.1),
    ecg_period = acqui_info.line_period_us*acqui_info.dat_size(2) / size(acqui_info.ecg_signal{1,1},1);
    mMode = permute(Structure.Data.Data,[2 1 3]);
    mMode = reshape(mMode,[recons_info.size(2) ...
        recons_info.size(1)*recons_info.size(3)]);
    figure;
    subplot(211)
    imagesc(acqui_info.line_period_us*(0:size(mMode,2)-1),...
        zTicks*recons_info.size(3),mMode); colormap(gray(255)); colorbar
% imagesc(mMode(:,1:2000)); colormap(gray(255)); colorbar
    title(sprintf('Structural M-mode scan'))
    xlabel('Time [us]')
    ylabel([recons_info.type(2) ' [um]'])
    xlim([1 20000*acqui_info.line_period_us])
    subplot(212)
    plot(ecg_period*(0:numel(acqui_info.ecg_signal{1,1})-1),acqui_info.ecg_signal{1,1}(:))
    xlabel('Time [us]')
    xlim([1 20000*acqui_info.line_period_us])
else
mMode = zeros(recons_info.size(2),recons_info.size(3));
% We choose the x-slice
sliceNo = 500;
for iFrames=1:acqui_info.nframes,
    mMode(:,iFrames) = Structure.Data.Data(sliceNo,:,iFrames);
end
figure;
imagesc(acqui_info.framenumber,zTicks,mMode); colormap(gray(255)); colorbar
title(sprintf('x-slice No: %d',sliceNo))
xlabel('Frames')
ylabel([recons_info.type(2) ' [um]'])
end

%% Doppler data
% If acquisition was made in M-mode (0 scanning)
if any(recons_info.step == 0.1),
    mMode = permute(Doppler1.Data.Data,[2 1 3]);
    mMode = reshape(mMode,[recons_info.size(2) ...
        recons_info.size(1)*recons_info.size(3)]);
    figure;
    imagesc(acqui_info.line_period_us*recons_info.size(1),...
        zTicks*recons_info.size(3),mMode); colormap(doppler_color_map); colorbar
    title(sprintf('Doppler M-mode scan'))
    xlabel('Time [us]')
    ylabel([recons_info.type(2) ' [um]'])
else
    mMode = zeros(recons_info.size(2),recons_info.size(3));
    % We choose the x-slice
    sliceNo = 550;
    for iFrames=1:acqui_info.nframes,
        mMode(:,iFrames) = Doppler1.Data.Data(sliceNo,:,iFrames);
    end
    figure;
    imagesc(acqui_info.framenumber,zTicks,mMode); colormap(doppler_color_map); colorbar
    title(sprintf('Doppler x-slice No: %d',sliceNo))
    xlabel('Frames')
    ylabel([recons_info.type(2) ' [um]'])

end



%% ECG signal (control signal applied to the coil)
figure;
plot(acqui_info.ecg_signal{1,1}(:))

%% Frame rate (in sec)
frameRate = acqui_info.dat_size(2)*acqui_info.line_period_us*1e-6;

%% FFT of M-mode image
% fftmMode


% ==============================================================================
% [EOF]
