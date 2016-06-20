function [Bscan, varargout]  = acq_Bscan(varargin)
% Acquires a single B-scan (frame) of nLinesPerFrame
% SYNTAX:
% Bscan = acq_Bscan(windowType, refCorr)
% INPUTS:
% [windowType]      Function handle to the window function to use:
%                   @barthannwin    @bartlett   @blackman   @blackmanharris
%                   @bohmanwin      @flattopwin @gausswin   @hamming
%                   @hann           @nuttallwin @parzenwin  @rectwin
%                   @taylorwin      @triang
% [refCorr]         if sub, subtracts reference signal from raw B-scan
%                   if subNdec, subtracts and deconvolves
% OUTPUTS:
% Bscan             raw set of A/lines
% [rawBscan16]      raw set of A/lines in uint16 format (to be saved to disk)  
% [correctedBscan]  B-scan windowed and corrected for background signal
%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara
% 2011/07/11

% Display transfer time
displayTransferTime = true;

% Modifies values of global variable
global ssOCTdefaults
% only want 2 optional inputs at most
numVarArgs = length(varargin);
if numVarArgs > 2
    error('correct_B_scan:TooManyInputs', ...
        'requires at most 2 optional inputs');
end

% set defaults for optional inputs (@hann window)
optArgs = {@hann 'sub'};

% now put these defaults into the optArgs cell array, 
% and overwrite the ones specified in varargin.
optArgs(1:numVarArgs) = varargin;
% or ...
% [optargs{1:numvarargs}] = varargin{:};

% Place optional args in memorable variable names
[winFunction refCorr] = optArgs{:};

% Preallocate
% Bscan = zeros([ssOCTdefaults.NSAMPLES ssOCTdefaults.nLinesPerFrame]);
% rawBscan16 = uint16(zeros([ssOCTdefaults.NSAMPLES ssOCTdefaults.nLinesPerFrame]));
if displayTransferTime
    % Initialize transfer time variable
    transferTime = 0;
end

% Get line by line
% for iLines = 1:ssOCTdefaults.nLinesPerFrame,
%     if displayTransferTime
%         tic
%     end
%     % Reads an array of nWordsPerAline elements from a connection
%     tempAline = pnet(ssOCTdefaults.tcpConn,'read',[ssOCTdefaults.nWordsPerAline 1],'uint16');
%     if displayTransferTime
%         transferTime = transferTime + toc;
%     end
%     % Only keep NSAMPLES from transmitted data array (transposed)
%     Bscan(:,iLines) = tempAline(1:ssOCTdefaults.NSAMPLES)';
%     % B-scan saved as uint16
%     rawBscan16(:,iLines) = tempAline(1:ssOCTdefaults.NSAMPLES)';
% end

% Get whole frame
if displayTransferTime
    timeTemp = tic;
end
tempFrame = pnet(ssOCTdefaults.tcpConn,'read',[ssOCTdefaults.nWordsPerAline*ssOCTdefaults.nLinesPerFrame 1],'uint16');
if displayTransferTime
        transferTime = transferTime + toc(timeTemp);
        % Average over nLinesPerFrame
        fprintf('Average transfer time = %03.2f Mbits/sec\n',...
        16*ssOCTdefaults.nWordsPerAline*ssOCTdefaults.nLinesPerFrame/(transferTime*2^20))
end

if isempty(tempFrame)
    % There was an error in the transmission
    Bscan = zeros([ssOCTdefaults.NSAMPLES ssOCTdefaults.nLinesPerFrame]);
    rawBscan16 = uint16(zeros([ssOCTdefaults.NSAMPLES ssOCTdefaults.nLinesPerFrame]));
else
    % Transmission OK
    tempFrame = reshape(tempFrame,[ssOCTdefaults.nWordsPerAline ssOCTdefaults.nLinesPerFrame]);
    Bscan = tempFrame(1:ssOCTdefaults.NSAMPLES,:);
    rawBscan16 = tempFrame(1:ssOCTdefaults.NSAMPLES,:);
end

% line by line
% if displayTransferTime
%     % Average over nLinesPerFrame
%     transferTime = transferTime / ssOCTdefaults.nLinesPerFrame;
%     fprintf('Average transfer time = %03.2f Mbits/sec\n',...
%         16*ssOCTdefaults.nWordsPerAline/(transferTime*2^20))
% end

% CORRECTION ALGORITHM HERE!!!!
varargout{2} = correct_B_scan(Bscan,winFunction,refCorr);

if nargout >= 2,
    varargout{1} = rawBscan16;
end
% ==============================================================================
% [EOF]
