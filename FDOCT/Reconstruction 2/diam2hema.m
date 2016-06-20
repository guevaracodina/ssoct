function hematocrit=diam2hema(diameter)
diameter=double(diameter);

method=2;

hematocritstd=0.45;

switch method
    case 1
        %From Pries 1992 Blood viscosity in tube flow : dependence on diameter and
        %hematocrit
        hematocrit=hematocritstd*(hematocritstd+(1-hematocritstd)*(1+1.7*exp(-0.35*diameter)-0.6*exp(-0.01*diameter)));
    case 2
        %From Pries 1992 Blood viscosity in tube flow : dependence on diameter and
        %hematocrit
        X=1+1.7*exp(-0.35*diameter)-0.6*exp(-0.01*diameter);
        hematocrit=-X./2./(1-X)+((X./2./(1-X)).^2+hematocritstd./(1-X)).^0.5;

    case 3
        %From Lipowski 1980
        Hemavsmut=load('HvsDiamLipowski1980.txt');
        hematocrit = interp1(Hemavsmut(:,1),Hemavsmut(:,2),diameter);
        hematocrit=hematocrit/100;
end