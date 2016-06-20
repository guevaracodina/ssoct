%% Compare hardwired data from signaltap to TCP transferred data
% load data
load('D:\Edgar\ssoct\Matlab\Acquisition\DATA\2012_02_17_Ramp\17_30_27_Test_ADA_DCO\Bframe_ramp_ADA_DCO.mat')
load('D:\Edgar\ssoct\Matlab\Acquisition\DATA\2012_02_17_Ramp\17_30_27_Test_ADA_DCO\signalTapRamp_ADA_DCO.mat')
load('D:\Edgar\ssoct\Matlab\Acquisition\DATA\2012_02_21_Ramp\12_05_25_Test125MHz\Bframe_ramp_125MHz.mat')
load('D:\Edgar\ssoct\Matlab\Acquisition\DATA\2012_02_21_Ramp\12_05_25_Test125MHz\signalTapRamp125MHz.mat')

%% Plot data
Aline = 200;
figure;
subplot(221); plot(Bframe_ramp_125(:,Aline))
title('@125MHz, TCP')
subplot(222); plot(t_125, address_125, t_125, 2000*trigger50_125, 'r:')
legend({'address' '50kHz Trig'})
title('@125MHz, SignalTap')
subplot(223); plot(Bframe_ramp_ADA_DCO(:,Aline))
title('@ADA-DCO, TCP')
subplot(224); plot(t_ADA_DCO, address_ADA_DCO, t_ADA_DCO, 2000*trigger50_ADA_DCO, 'r:')
title('@ADA-DCO, SignalTap')
