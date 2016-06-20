function cont_acq
% Continuously acquires OCT data. Optionally save data to a .dat file. See
% scriptMirrorCharact to map .dat files to memory
% SYNTAX:
% cont_acq
% INPUTS:
% None
% OUTPUTS:
% None
%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara
% 2011/09/15

% Modifies values of global variable
global ssOCTdefaults

% ----------------------------- New figure -------------------------------------
hContAcq = figure; 

if ssOCTdefaults.GUI.blackBgd,
    % black background
    set(hContAcq,'color','k')
    % Complement figure colors
    set(hContAcq,'DefaultAxesColor','w',...
    'DefaultAxesXColor','w',...
    'DefaultAxesYColor','w',...
    'DefaultAxesZColor','w',...
    'DefaultTextColor','w',...
    'DefaultLineColor','w')
else
    % white background
    set(hContAcq,'color','w')
    % Complement figure colors
    set(hContAcq,'DefaultAxesColor','w',...
    'DefaultAxesXColor','k',...
    'DefaultAxesYColor','k',...
    'DefaultAxesZColor','k',...
    'DefaultTextColor','k',...
    'DefaultLineColor','k')
end

% Change figure name
set(hContAcq,'Name','Continuous Acquisition')
% Normalized units
set(0, 'Units', 'normalized')
set(hContAcq, 'Units', 'normalized');
% Maximize figure
set(hContAcq, 'OuterPosition', ssOCTdefaults.GUI.screenSize);

% ------ Transmit acquisition parameters ['A' nLinesPerFrame nFrames]-----------
pnet(ssOCTdefaults.tcpConn,'write',([uint8(65) ...
    typecast(uint32(ssOCTdefaults.nLinesPerFrame), 'uint8') ...
    typecast(uint32(ssOCTdefaults.nFramesPerVol), 'uint8')]));
pause(0.1)                              % Necessary to give time to NIOS

% --------------------- Take reference measurements ----------------------------
[~, ~] = reference_measure(hContAcq);


% Send command chain ('C') to the socket server
pnet(ssOCTdefaults.tcpConn,'write',uint8(67));
pause(0.1)
fprintf('Continuous acquisition...Press <Ctrl>+<C> to cancel\n')
% load('D:\Edgar\ssoct\Matlab\reference.mat')

% ------------------------------ Main Loop -------------------------------------
if ssOCTdefaults.GUI.save2file
    % Close all open files
    fclose('all');
    % Default file name
    fileName = fullfile(ssOCTdefaults.folders.dirCurrExp,[datestr(now,'HH_MM_SS') '.dat']);
    % Save file name of current experiment in global structure
    ssOCTdefaults.CurrExpFileName = fileName;
    % Create binary file
    fid = fopen(fileName, 'w');
    iFrames = 1;
    temps = tic;
    while ~exist(fullfile(ssOCTdefaults.folders.dirCurrExp,'tostop.txt'),'file')
        [~, rawBscan16, ~] = displayAcqOCT(iFrames,hContAcq);
        iFrames = iFrames + 1;
        % --------------------- Save a B-scan frame ----------------------------
        fwrite(fid, rawBscan16, 'uint16');
    end
    frameRate = iFrames/toc(temps);
    fprintf('Approximate Frame Rate = %.3f fps\n',frameRate)
    fclose(fid);
    disp(['File saved as: ' fileName])
    pause(0.5);
    % Delete file created by LabView
    delete(fullfile(ssOCTdefaults.folders.dirCurrExp,'tostop.txt'))
else
    %     Save data in a big variable
    %     ssOCTdefaults.OCTfullAcq = zeros([ssOCTdefaults.nFramesPerVol ssOCTdefaults.NSAMPLES ...
    %         ssOCTdefaults.nLinesPerFrame]);
    iFrames = 1;
    temps = tic;
    while ~exist(fullfile(ssOCTdefaults.folders.dirCurrExp,'tostop.txt'),'file')
        displayAcqOCT(iFrames,hContAcq);
        iFrames = iFrames + 1;
    end
    frameRate = iFrames/toc(temps);
    fprintf('Approximate Frame Rate = %.3f fps\n',frameRate)
    fprintf('%.3f Mbits/B-frame \n',16*ssOCTdefaults.nWordsPerAline*ssOCTdefaults.nLinesPerFrame/2^20);
    disp('Transfer done!')
    % Delete file created by LabView
    pause(0.5);
    delete(fullfile(ssOCTdefaults.folders.dirCurrExp,'tostop.txt'))
end
% Disconnect from socket server
disconnect_from_FPGA
% ==============================================================================
% [EOF]
