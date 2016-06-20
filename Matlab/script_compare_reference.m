%% Reference measurements comparison
%% Complete setup with circulators before cleaning
D:\Edgar\
refBeforeClean = load(fullfile(pathName,'Reference_Measurements.mat'));
refBeforeClean = refBeforeClean.rawBscanRef;
refH = figure;
set(refH,'Name','Reference Measurement Comparison')
set(refH,'Color','w')
plot(mean(refBeforeClean,2),'b-')
hold on
ylim([0 2^14])

%% Setup using only the 50/50 coupler
% [mappedFile, ~] = readOCTmapFile('D:\Edgar\ssoct\Matlab\Acquisition\DATA\2012_03_30_Phantom 2 tubes\14_26_42_Test 2D\referenceFrame.dat');
% ref50_50 = squeeze(mappedFile.Data.rawData(:,:,1));
ref50_50 = load('D:\Edgar\ssoct\Matlab\Acquisition\DATA\2012_02_10_50_50\16_39_30_Test\Coupler_50_50.mat');
ref50_50 = ref50_50.Bframe_50_50_ref;
figure(refH)
plot(mean(ref50_50,2),'k-')

%% Complete setup with circulators after cleaning
[mappedFile, pathName] = readOCTmapFile('D:\Edgar\ssoct\Matlab\Acquisition\DATA\2012_04_02_Phantom 2 tubes\15_34_07_Fibers (circulators) cleaned\referenceFrame.dat');
ref50_50 = squeeze(mappedFile.Data.rawData(:,:,1));
figure(refH)
plot(mean(ref50_50,2),'r-')
xlim([0 1128])
legend({'Circulators before cleaning' 'Coupler 50/50' 'Circulators after cleaning'})
xlabel('Samples')
ylabel('ADC values')
title('Reference Measurement Comparison')
% Clean-up
clear mappedFile pathName refH
% export_fig('D:\Edgar\Documents\Dropbox\Docs\OCT\Screenshots\RefCompare.png', '-png', refH)
