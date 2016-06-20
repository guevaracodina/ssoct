function y = get_poly_return(VoltStart, VoltEnd, nAlinesperBframe)
% Returns polynomial for galvo ramp
%_______________________________________________________________________________
% Copyright (C) 2012 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
%_______________________________________________________________________________
fractionConstant = 1/9;
% Total number of samples 
totalSamples = round(nAlinesperBframe*(1 + fractionConstant));
% Polynomial equation left-side
aEqu = [1   nAlinesperBframe    nAlinesperBframe^2  nAlinesperBframe^3]';
bEqu = [1   totalSamples        totalSamples^2      totalSamples^3]';
cEqu = [0   1                   2*nAlinesperBframe  3*nAlinesperBframe^2]';
dEqu = [0   1                   2*totalSamples      3*totalSamples^2]';
% Polynomial equation right-side
polyEqu = [VoltEnd VoltStart (VoltEnd-VoltStart)/nAlinesperBframe (VoltEnd-VoltStart)/nAlinesperBframe];
% Solve poly equation
x = [aEqu bEqu cEqu dEqu]'\polyEqu';
yRampReturn = linspace(nAlinesperBframe, totalSamples, round(fractionConstant*nAlinesperBframe));
y = x(1) + x(2).*yRampReturn + x(3)*yRampReturn.^2 + x(4)*yRampReturn.^3;
end

% EOF
