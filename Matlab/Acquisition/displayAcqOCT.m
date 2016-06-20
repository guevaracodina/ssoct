function [rawBscan rawBscan16 correctedBscan] = displayAcqOCT(iFrames,hContAcq)
% ------------- Acquires and displays a single B-scan (frame) ------------------
% SYNTAX:
% [rawBscan rawBscan16] = displayAcqOCT(iFrames)
% INPUTS:
% iFrames       Current B-scan
% hContAcq      Handle to the current figure
% OUTPUTS:
% rawBscan      Uncorrected B-scan
% rawBscan16    Uncorrected B-scan (uint16 format), this data are saved to file
%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara
% 2011/10/07

% Modifies values of global variable
global ssOCTdefaults

if rem(iFrames-1, ssOCTdefaults.nFramesPerVol) == 0,
    pause(ssOCTdefaults.pauseTime);         % Necessary pause before data transfer
end

% Acquire raw B-scan
if ssOCTdefaults.GUI.corrBscan
    [rawBscan rawBscan16 correctedBscan] = acq_Bscan(@myhann,true);
    limitY = [-2^13 2^13];
else
    [rawBscan rawBscan16] = acq_Bscan(@rectwin,false);
    correctedBscan = double(rawBscan);
     limitY = [0 2^14];
end

% Save data in a big variable
% ssOCTdefaults.OCTfullAcq(iFrames,:,:) = rawBscan;

if ssOCTdefaults.GUI.liveDisplay,
    % Negative and Positive envelope
    [posEnv negEnv] = detect_envelope(correctedBscan(:,2));

    % Go to specific figure
    figure(hContAcq)

    subplot(222);
    if ssOCTdefaults.GUI.displaySingleLine
        % -------------- Plot a single interferogram (A-line) ------------------
        plot(1e9*ssOCTdefaults.range.vectorLambda, correctedBscan(:,ssOCTdefaults.nLinesPerFrame/2), 'k-',...
            1e9*ssOCTdefaults.range.vectorLambda, posEnv,'r:',...
            1e9*ssOCTdefaults.range.vectorLambda, negEnv,'b:');
        title('Interferogram')
        xlabel('\lambda [nm]')
        ylabel('Intensity [ADC units]')
        xlim(1e9*[ssOCTdefaults.axial.minLambda ssOCTdefaults.axial.maxLambda])
        ylim(limitY)
    else
        % -------------- Plot interferogram (B-scan) ------------------
        imagesc(1:ssOCTdefaults.nLinesPerFrame, 1e9*ssOCTdefaults.range.vectorLambda, ...
            correctedBscan, limitY);
        title('Interferogram')
        xlabel('A-lines')
        ylabel('\lambda [nm]')
        if ssOCTdefaults.GUI.displayColorBar
            colorbar;
        else
            colorbar off;
        end
    end

    % ------------ Plot the phase of a single A-line -----------------------
    subplot(248)
    % 4096 Samples Lambda Column Vector (in m)
    % vectorLambdaNFFT = 2*pi ./ linspace(ssOCTdefaults.range.maxK,ssOCTdefaults.range.minK, ssOCTdefaults.nSamplesFFT)';
    % plot(1e9*vectorLambdaNFFT, unwrap(angle(hilbert...
    %     (correctedBscan(:,ssOCTdefaults.nLinesPerFrame/2),ssOCTdefaults.nSamplesFFT...
    %     ))),'-k')
    % Hilbert transform on NSAMPLES (1128)
    plot(1e9*ssOCTdefaults.range.vectorLambda, unwrap(angle(hilbert...
        (correctedBscan(:,ssOCTdefaults.nLinesPerFrame/2)))),'-k')
    title('Interferogram phase')
    xlabel('\lambda [nm]')
    xlim(1e9*[ssOCTdefaults.axial.minLambda ssOCTdefaults.axial.maxLambda])

    % --------------- Plot the a single A-line (FFT) -----------------------
    subplot(247)
    % limitX = [-0.1 5];
    limitX = [-0.1 1.2];
    singleAline = abs(Bscan2FFT(correctedBscan(:,ssOCTdefaults.nLinesPerFrame/2)));    % abs FFT
    % Take only left part of spectrum
    singleAline = singleAline(ssOCTdefaults.nSamplesFFT/2:-1:1);
    % LPF 
    singleAline(1:12) = 0;
    if ssOCTdefaults.GUI.displayLog                         % log scale display
        singleAline = log(singleAline + 1);
        plot(10^3*ssOCTdefaults.range.posZaxis_air, singleAline,'k-')
        ylabel('log(R) [a.u.]')
        title('Single A-line')
    else
        ylabel('Reflectivity [a.u.]')
        if ssOCTdefaults.GUI.showFWHM
            % Show FWHM in real time (only when linear display is enabled)
    %         [~, peak_pos, FWHMum, peak_pos_m] = fwhm(singleAline);
            [~, peak_pos, FWHMum, peak_pos_m] = fwhm(singleAline...
                (1:490));
            plot(1e3*peak_pos_m,singleAline(peak_pos),'ro')
            title([sprintf('FWHM = %.2f',FWHMum) ' \mum'])
            hold on
        else
            title('Single A-line')
        end
    %     plot(10^3*ssOCTdefaults.range.posZaxis_air, singleAline,'k-')
        % Display until 1.2mm
        plot(10^3*ssOCTdefaults.range.posZaxis_air(1:490), ...
            singleAline(1:490),...
            '-k')
        ylabel('(R) [a.u.]')
    end
    hold off
    xlabel('z [mm]')
    xlim(limitX)

    % --------------- Display a B-scan (single frame) ----------------------
    subplot(121)
    Bscan = abs(Bscan2FFT(correctedBscan));
    % LPF
    Bscan(ssOCTdefaults.nSamplesFFT/2:-1:ssOCTdefaults.nSamplesFFT/2-12+1) = 0;
    if ssOCTdefaults.GUI.displayLog
        % Display in log scale, single-sided FFT (left part of spectrum), with
        % z-axis in um
        imagesc(1:ssOCTdefaults.nLinesPerFrame, 1e3*ssOCTdefaults.range.posZaxis_air,...
            log(Bscan(ssOCTdefaults.nSamplesFFT/2:-1:1,:)+1));
        title(sprintf('log(R). Continuous Transfer. Frame %d',iFrames))
    else
        % Display in linear scale, single-sided FFT (left part of spectrum), with
        % z-axis in um
    %     imagesc(1:ssOCTdefaults.nLinesPerFrame, 1e3*ssOCTdefaults.range.posZaxis_air,...
    %         Bscan(ssOCTdefaults.nSamplesFFT/2:-1:1,:));
        % Display until 1.2mm
        imagesc(1:ssOCTdefaults.nLinesPerFrame, 1e3*ssOCTdefaults.range.posZaxis_air(1:490),...
            Bscan(ssOCTdefaults.nSamplesFFT/2:-1:ssOCTdefaults.nSamplesFFT/2-490-1,:));
        title(sprintf('Continuous Transfer. Frame %d',iFrames))
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
else
    % Do nothing
end % END live display
% ==============================================================================
% [EOF]
