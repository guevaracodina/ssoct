function [rawBscanOut refBscan Bscan hFig] = browseVolume(varargin)
% Displays structural data from a volume (.dat file)
% SYNTAX:
% [rawBscanOut refBscan Bscan hFig] = browseVolume([frames], [filename])
% INPUTS:
% [frames]      Index of B-scans to show
% [fileName]    Optional input with the full file name (path+file.dat)
% OUTPUTS:
% rawBscanOut   Raw B-scans for the whole frames range
% refBscan      Raw reference B-scan
% Bscan         Processed B-scan structure
% hFig          Handle to current figure
%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara
% 2011/11/01

% Show reconstructed frames
showFrames = false;
% Show Reference Image
showRefScan = false;
% Pause time
pauseTime = 0.01;

% Modifies values of global variable
global ssOCTdefaults
% Load default parameters
ss_oct_get_defaults
% only want 1 optional inputs at most
numVarArgs = length(varargin);
if numVarArgs > 2
    error('browseVolume:TooManyInputs', ...
        'requires at most 2 optional input');
end

% set defaults for optional inputs (empty)
optArgs = {[] []};

% now put these defaults into the optArgs cell array,
% and overwrite the ones specified in varargin.
optArgs(1:numVarArgs) = varargin;
% or ...
% [optargs{1:numvarargs}] = varargin{:};

% Place optional args in memorable variable names
[framesRange fileName] = optArgs{:};

% Map acquisition file to memory
[mappedFile, pathName] = readOCTmapFile(fileName);

% ---------------------------- Display reference scan --------------------------
% Load reference values
% load(fullfile(pathName,'Reference_Measurements.mat'));
% Background signal from the reference arm (sample arm blocked)
% if isfield(ssOCTdefaults,'refArm')
%     refArm      = ssOCTdefaults.refArm;
% else
    % Read binary .DAT file
    if exist(fullfile(ssOCTdefaults.folders.dirCurrExp,'referenceFrame.dat'), 'file')
        rawBscanRef = readOCTmapFile(fullfile(ssOCTdefaults.folders.dirCurrExp,'referenceFrame.dat'));
        rawBscanRef = rawBscanRef.Data.rawData;
    else
        rawBscanRef = load(fullfile(ssOCTdefaults.folders.dirCurrExp,'Reference_Measurements.mat'));
        rawBscanRef = rawBscanRef.rawBscanRef;
        refArm = mean(double(refArm),2);
    end
%     refArm = mean(double(refArm),2);
    % Update global variable
%     ssOCTdefaults.refArm = refArm;
% end

if ssOCTdefaults.resampleData
    % Resample reference B-scan
    resampledRawBscanRef = resample_B_scan(rawBscanRef);
    % Update reference A-line
    ssOCTdefaults.refArm = mean(resampledRawBscanRef,2);
else
    % Do not resample
    resampledRawBscanRef = rawBscanRef;
    % Update reference A-line
    ssOCTdefaults.refArm = mean(resampledRawBscanRef,2);
end
% Get structure   
resampledStruct2D = abs(Bscan2FFT(resampledRawBscanRef));

if showRefScan
    % Reference scan figure
    hRef = figure; set(gcf,'color','w');
    % Change figure name
    set(hRef,'Name', 'Reference Scan');
    if ssOCTdefaults.GUI.displayLog
        % Display in log scale, single-sided FFT (left part of spectrum), with
        % z-axis in um
        resampledStruct2D = resampledStruct2D(ssOCTdefaults.NSAMPLES/2:-1:1,:);

        % noise_lower_fraction = 0.1
        noise_lower_fraction = 0.1;
        noise_floor = mean(...
            mean(resampledStruct2D(round((1-noise_lower_fraction)*end):end,:)));
        resampledStruct2D = 10*log10(resampledStruct2D / noise_floor);
        resampledStruct2D(resampledStruct2D < 0) = 0;
        
        if iFrames == framesRange(1),
            % Scale color to the first frame
            minColor = min(resampledStruct2D(:));
            maxColor = max(resampledStruct2D(:));
        end        
        
        imagesc(1:ssOCTdefaults.nLinesPerFrame, 1e3*ssOCTdefaults.range.zAxis_air,...
            resampledStruct2D,...
            [minColor maxColor]);
        title(sprintf('log(R). Frame %d of %d', iFrames, nFrames))
    else
        % Display in linear scale, single-sided FFT (left part of spectrum), with
        % z-axis in um
        imagesc(1:ssOCTdefaults.nLinesPerFrame, 1e3*ssOCTdefaults.range.zAxis_air,...
            resampledStruct2D(ssOCTdefaults.NSAMPLES/2:-1:1,:));
        title('Reference')
    end
    if ssOCTdefaults.GUI.displayColorBar
        colorbar;
    else
        colorbar off;
    end
    axis tight
    colormap(ssOCTdefaults.GUI.OCTcolorMap)
    ylabel('z [mm]')
    xlabel('A-lines')
end
% Output
refBscan = rawBscanRef;
% Clean up
clear refArm sampleArm rawBscanRef resampledRawBscanRef

% ---------------------------- Display volume ----------------------------------
if showFrames
    % Create new figure
    hFig = figure;
    set(hFig,'color','w')
    % Change figure name
    set(hFig,'Name',[ssOCTdefaults.acqParam{8,1} ': '...
        ssOCTdefaults.acqParam{8,2} '. ' ssOCTdefaults.acqParam{9,1} ': '...
        ssOCTdefaults.acqParam{9,2} '.'])
    tilefigs
end
% Number of transferred frames
nFrames = mappedFile.format{2}(3);

% Browse entire file
if isempty(framesRange)
    framesRange = 1:nFrames;
else
    % Keep only valid indices
    framesRange = framesRange(framesRange<=nFrames);
end

% Preallocate output
rawBscanOut = zeros([ssOCTdefaults.NSAMPLES ssOCTdefaults.nLinesPerFrame numel(framesRange)]);
Bscan = zeros([ssOCTdefaults.nSamplesFFT/2 ssOCTdefaults.nLinesPerFrame numel(framesRange)]);

% Display frames loop
for iFrames = framesRange,
    % Convert a single B-scan to double
    rawBscan = double(squeeze(mappedFile.Data.rawData(:,:,iFrames)));
    % Filling output array
    rawBscanOut(:,:,iFrames) = rawBscan;
    if ssOCTdefaults.resampleData
        % Resample/interpolate B-scan
        resampledRawBscan = resample_B_scan(rawBscan);
    else
        % Do not resample
        resampledRawBscan = rawBscan;
    end
    % Apply windowing function and subtract the reference
    resampledCorrectedBscan = correct_B_scan(resampledRawBscan,@hann,'sub');
    % Obtain structural data
    resampledStruct2D = FFT2struct(Bscan2FFT(resampledCorrectedBscan));
    % Output
    Bscan(:,:,iFrames) = resampledStruct2D;
    if showFrames
        figure(hFig)
    else
        hFig = false;
    end
    if ssOCTdefaults.GUI.displayLog
        % Display in log scale, single-sided FFT (left part of spectrum), with
        % z-axis in um
        resampledStruct2D = resampledStruct2D(ssOCTdefaults.NSAMPLES/2:-1:1,:);

        % noise_lower_fraction = 0.1
        noise_lower_fraction = 0.1;
        noise_floor = mean(...
            mean(resampledStruct2D(round((1-noise_lower_fraction)*end):end,:)));
        resampledStruct2D = 10*log10(resampledStruct2D / noise_floor);
        resampledStruct2D(resampledStruct2D < 0) = 0;
        
        if iFrames == framesRange(1),
            % Scale color to the first frame
            minColor = min(resampledStruct2D(:));
            maxColor = max(resampledStruct2D(:));
        end
        
        if showFrames
            imagesc(1:ssOCTdefaults.nLinesPerFrame, 1e3*ssOCTdefaults.range.zAxis_air,...
                resampledStruct2D,...
                [minColor maxColor]);
            title(sprintf('log(R). Frame %d of %d', iFrames, nFrames))
        end
    else
            if iFrames == framesRange(1),
                % Scale color to the first frame
                minColor = min(resampledStruct2D(:));
                maxColor = max(resampledStruct2D(:));
            end
        if showFrames
            % Display in linear scale, single-sided FFT (left part of spectrum), with
            % z-axis in um
            imagesc(1:ssOCTdefaults.nLinesPerFrame, 1e3*ssOCTdefaults.range.zAxis_air,...
                resampledStruct2D(ssOCTdefaults.NSAMPLES/2:-1:1,:),...
                [minColor maxColor]);
            title(sprintf('Frame %d of %d', iFrames, nFrames))
        end
    end
    if showFrames
        if ssOCTdefaults.GUI.displayColorBar
            colorbar;
        else
            colorbar off;
        end
        axis tight
        colormap(ssOCTdefaults.GUI.OCTcolorMap)
        ylabel('z [mm]')
        xlabel('A-lines')
        pause(pauseTime)
    end
end
% ==============================================================================
% [EOF]
