function k = optimK()
% dbstop if error
clear global resIter
load (fullfile('D:\Edgar\ssoct\Matlab\Misc','phase.mat'))

% Data range
rge = 215:296;

k0 = data.k;
k = fminsearch(@(k) residual(k, data, rge), k0);
% disp(residual(data))
end

function residu = residual(k, data, rge)
global resIter
if isempty(resIter)
    resIter = 0;
end

% Reference subtraction
Aline = (data.Aline - data.refB);

% K-clock resampling of a B-scan
% Position when sampling at a fixed frequency (125 MHz)
fixedSampling = linspace(0,1128 - 1,1128)';

% Resampling (Interpolation/Decimation) along columns (A-lines)
Aline = interp1(k, Aline, fixedSampling, 'linear');

% window (after or before resampling???)
tmpCorrArray = myhann(numel(Aline));
Aline = Aline.*tmpCorrArray;

% Hilbert transform of the interferogram
phase = unwrap(angle(hilbert(Aline)));

% Aline = Aline(rge);
% phase = phase(rge);
% fixedSampling = fixedSampling(rge);
% k = k(rge);

% Linear fit
[p,S] = polyfit(fixedSampling, phase, 1);

figure(99);
subplot(211)
cla
hold on
plot(phase);
xlabel('Samples')
ylabel('Unwrapped Phase')
plot(p(2)+p(1)*(1:numel(Aline)),'r')

residu=S.normr;
subplot(212)
xlabel('Iteration')
ylabel('Fit residual')
hold on
plot(resIter, residu, 'k.')

resIter = resIter + 1;
end
