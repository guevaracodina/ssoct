%%
t=linspace(-2*pi,2*pi,1128)';
y1 = sin(t);
y2 = sin(t-pi/4);
[C, lags] = xcorr(y1, y2);

[val, idx] = max(C);

y3 = circshift(y2, lags(idx) - 1);

figure; plot(t,y1,'k-',t,y2,'r-',t,y3,'b:'); legend({'\phi_1 = 0' '\phi_2 = \pi/4' '\phi_2 de-lagged'})
