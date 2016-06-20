% Some data about OCT resolution, data acquisition parameters, etc.
%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara
% 2011/03/07

%% OCT axial resolution
clc
lambda0 = 1310e-9;                      % Center wavelength
delta_lambda = 100e-9;                  % FWHM in wavelength
zr_air = (2/pi)*log(2)*lambda0^2/...    % Axial resolution in air
    delta_lambda;
n = 1.4;                                % Index of refraction of tissue
zr = zr_air / n;                        % Axial resolution in tissue
fprintf('Axial resolution = %.2f um\n',zr*1e6)

%% OCT transverse resolution
EP = [4e-3 4e-3 4e-3];                  % Entrance pupil diameter
beamWaist = [3.4 3.4 3.4]*1e-3;         % F280APC-C beam diameter
EFL = [18 36 54]*1e-3;                  % Effective Focal Length
% Numerical Aperture
NA = sqrt(1 ./ (1 + (2.*EFL./beamWaist).^2));  
rr = (2/pi)*lambda0./NA;                % Transverse (lateral) resolution
fprintf('Tranverse resolution = %.2f um\n',rr*1e6)

%% Maximum path difference (Field Of View of a FDOCT) (Penetration depth)
Ns = 1128;                              % Number of samples (Ns_max = 1286)
delta_Z_Nq = lambda0^2 * Ns / (4*delta_lambda*n);
n_air = 1;                              % Index of refraction of air
delta_Z_Nq_air = lambda0^2 * Ns / (4*delta_lambda*n_air);
fprintf('Maximum path difference (in air) = %.2f mm\n',delta_Z_Nq_air*1e3)
fprintf('Maximum path difference (in tissue) = %.2f mm\n',delta_Z_Nq*1e3)

%% Data acquisition parameters
nSamples = 1170;                        % Fixed by the swept source
nBits = 16;                             % ADC = 14 bits
freq = 50e3;                            % Sweep Trigger frequency
nBytes = nSamples*nBits/8;              % Bytes acquired every Sweep Trigger
nBytesPerSec = freq*nBytes;             % Bytes/sec
nKbytesPerSec = nBytesPerSec/1024;      % KBytes/sec
nMegsPerSec = nKbytesPerSec/1024;       % Mbytes/sec
nMbitsPerSec = nMegsPerSec*8;           % Mbits/sec < 1 Gbit/sec

%% Required Pathlength match (Axsun)
c = 299792458;                          % Speed of light in air (m/s)
nFiber = 1.4677;                        % effective index of refraction of fiber
                                        % SMF-28e
nLens = 1.55785;                        % index of refraction of N-BAK1/N-BK7 @1310nm
% Red Path in (in mm)
redPath = nFiber *(...
    1181 +   73 + 1180 + ...            % 50/50 coupler (source)
     895 +   60 +  943 + ...            % Circulator arms 1 & 2 (one-way)
     943 +   60 + 1055 + ...            % Circulator arms 2 & 3 (return)
    1184 +   73 + 1185)+ ...            % 50/50 coupler (detector)
    2*(22 + ...                         % Collimator length
    36 + 68 + ...                       % Collimator to Y-galvo
    10 + ...                            % Y-galvo to X-galvo
    200 -(2*5.3)+ 15 + ...              % Telescope distance (X-galvo to scan lens)
    (nLens * 2 * 5.3) + ...             % LA1131-C telescope lens (f = 50mm)
    (nLens * 38.5) +...                 % Telecentric scan lens LSM04 length
    42.3);                              % Working ditance (LWD)
% Orange Path (in mm)
orangePath = 1060;
% Green Path (in mm)
greenPath = 2620;
% Electrical delay (conversion from mm to m)
electricalDelay = (redPath + orangePath - greenPath) / 1000;
minElectricalDelay = 28.3e-9;           % Minimum electrical clock delay
stepSizeClockDelay = 0.575e-9;          % the step size of clock delay
timeDelay = electricalDelay / c;        % Time delay between the clock and signal
% Number to use in the "Set clock delay" window
setClockDelay = round((timeDelay - minElectricalDelay) / stepSizeClockDelay);
fprintf('Set Clock Delay = %d [0x%X]\n',setClockDelay,setClockDelay)

%% FOV computation


%% Axial resolution vs. source bandwidth
lambda0_1310        = 1310e-9;
lambda0_830         = 830e-9;
minLambda           = 1258e-9;
maxLambda           = 1361.2e-9;
delta_lambda        = linspace(10e-9, 1000e-9, 2^16);
zr_air_1310         = (2/pi)*log(2) .* lambda0_1310^2 ./ delta_lambda;
zr_air_830          = (2/pi)*log(2) .* lambda0_830^2 ./ delta_lambda;
dl                  = maxLambda - minLambda;
zr                  = (2/pi)*log(2) .* lambda0_1310^2 ./ dl;

figure; set(gcf,'color','w')
loglog(delta_lambda*1e9, zr_air_1310*1e6, ...
    'Color', 'k', 'LineStyle', '-', 'LineWidth', 3);
hold on
loglog(delta_lambda*1e9, zr_air_830*1e6,...
    'Color', 'k', 'LineStyle', '--', 'LineWidth', 3);
loglog(dl.*ones([100 1])*1e9, linspace(1e-1,zr*1e6,100), ...
    'Color', 'r', 'LineStyle', ':', 'LineWidth', 2)
loglog(linspace(1e-1,dl*1e9,100), zr.*ones([100 1])*1e6,...
    'Color', 'r', 'LineStyle', ':', 'LineWidth', 2)


xlim([1e1 1e3])
ylim([1e-1 1e2])
xax = [1e1 1e2 1e3];
yax = [1e-1 1e0 1e1 1e2];
set(gca, 'YTick', yax)
set(gca, 'XTick', xax)
legend({'\lambda_0 = 1310 nm' '\lambda_0 = 830 nm'})
xlabel('\Delta\lambda [nm]', 'FontWeight', 'Bold', 'FontSize', 14)
ylabel('\Deltaz [\mum]', 'FontWeight', 'Bold',  'FontSize', 14)
set(gca, 'FontWeight', 'Bold', 'FontSize', 14)

% Exporting as png
% export_fig('D:\Edgar\Documents\Dropbox\Docs\OCT\axial_res.png', '-png', gcf);


%% Source characteristics
pathName = 'D:\Edgar\Documents\Dropbox\Docs\OCT\Screenshots';
fileName = 'SourceSpectrum.csv';
C = importdata(fullfile(pathName,fileName), ',', 2);
t = C.data(:,1);
sourceSpectrum = C.data(:,2);
sweepTrigger = C.data(:,3);

minLambda           = 1258e-9;
minK                = 2*pi/minLambda;
maxLambda           = 1361.2e-9;
maxK                = 2*pi/maxLambda;
delta = -47;
deltap = -525;
s1 = sourceSpectrum(47 - delta:998 + deltap);
s2 = sourceSpectrum(1048 - delta:1999 + deltap);
s3 = sourceSpectrum(2049 - delta:3000 + deltap);
t1 = sweepTrigger(47 - delta:998 + deltap);
t2 = sweepTrigger(1048 - delta:1999 + deltap);
t3 = sweepTrigger(2049 - delta:3000 + deltap);

winSize = 25;
sourceSpectrum = medfilt1(mean([s1 s2 s3],2), winSize);
% Scale to mW
% maxPower = 25;
% sourceSpectrum = sourceSpectrum .* (maxPower) ./ max(sourceSpectrum);
sourceSpectrum = sourceSpectrum - min(sourceSpectrum);
sourceSpectrum = sourceSpectrum / max(sourceSpectrum);
sweepTrigger = mean([t1 t2 t3],2);
% k = linspace(minK, maxK, numel(sourceSpectrum));
% lambda = 2*pi./k;
lambda = linspace(minLambda, maxLambda, numel(sourceSpectrum));
lambda0 = (maxLambda+minLambda)/2;

% Display
close all
figure; set(gcf,'color','w')
clf
% plot(t,sweepTrigger,'r-',t,sourceSpectrum,'k-')
plot(lambda*1e9, sourceSpectrum,'Color', 'k', 'LineStyle', '-', 'LineWidth', 3)
hold on
plot(1e9*[lambda0 lambda0], [0 1], 'Color', 'k', 'LineStyle', ':', 'LineWidth', 2)
xlabel('\lambda [nm]', 'FontWeight', 'Bold', 'FontSize', 14)
ylabel('Power [a.u.]', 'FontWeight', 'Bold',  'FontSize', 14)
set(gca, 'FontWeight', 'Bold', 'FontSize', 14)
xlim([minLambda maxLambda]*1e9)
ylim([0 1])
yax = [0 1];
set(gca, 'YTick', yax)

addpath(genpath('D:\Edgar\ssoct\Matlab'))
% Exporting as png
export_fig('D:\Edgar\Documents\Dropbox\Docs\OCT\source_spectrum.png', '-png', gcf);

% fprintf('Mean %0.2f mW\n',mean(sourceSpectrum))

% Cleanup
clear s1 s2 s3 t1 t2 t3

%% Single backscatterer at different depths
minLambda           = 1258e-9;
maxLambda           = 1361.2e-9;
delta_lambda        = linspace(minLambda, maxLambda, 2^18)';
% Sinus frequency
f                   = 10e8;
s1 = sin(2*pi*f .* delta_lambda);
f1 = fftshift(fft(s1.*hann(numel(s1))));
% figure(333); set(gcf,'color','w')
% plot(2*pi ./ delta_lambda,  s1.*hann(numel(s1)))
figure(334); set(gcf,'color','w')
index = 131146:131275;
indexr = index(end:-1:1);
subplot(211)
plot(abs(f1(index)), 'Color', 'k', 'LineStyle', '-', 'LineWidth', 3)
axis off
subplot(212)
plot(abs(f1(indexr)), 'Color', 'k', 'LineStyle', '-', 'LineWidth', 3)
axis off

% Exporting as png
export_fig('D:\Edgar\Documents\Dropbox\Docs\OCT\delay_backscatter.png', '-png', gcf);

% ==============================================================================
% [EOF]
