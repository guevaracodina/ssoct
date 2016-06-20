function [viscosity]=get_viscosity(diameter,hematocrit)

if ~exist('hematocrit')
    hematocrit=diam2hema(diameter);
end

C=(0.8+exp(-0.075*diameter)).*(-1+1./(1+10^-11*diameter.^12))+1./(1+10^-11*diameter.^12);

viscosity45=220*exp(-1.3*diameter)+3.2-2.44*exp(-0.06*diameter.^0.645);
viscosity=1+(viscosity45-1).*((1-hematocrit).^C-1)./((1-0.45).^C-1);