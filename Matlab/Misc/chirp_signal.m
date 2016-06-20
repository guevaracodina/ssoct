%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara
% 2011/03/24
fs  = 1e12;                             % Sampling frequency
Ts  = 1/fs;                             % Sampling period
T   = 1/10e6;                           % Sweep period
t   = 0:Ts:T-Ts;                        % time vector
f   = 130e6;                            % k-clock frequency
f0  = 0.8e-2*130e6;
t1  = T/2;
f1  = 2*130e6;
y   = chirp_sinus(t,f0,t1,f1,'linear');
subplot(211)
plot(t,y,'r-','LineWidth',3)
set(gcf,'color','w')
ylim([-1.1 1.1])
axis off
% export_fig(gcf,'G:\My Documents\OCT\chirp.png')

% ==============================================================================
% [EOF]
