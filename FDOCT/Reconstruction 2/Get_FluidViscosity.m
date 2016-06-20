function [fviscosity] = Get_FluidViscosity(Diameter,HctT)

% INPUT : Diameter est un vecteur contenant le diamètre en microns des
% segments vasculaires pour lesquels la viscosité du sang doit être
% calculée. HctT est un vecteur de même dimension qui donne la
% concentration par unité de volume de l'hématocrite dans le sang. Les
% valeurs d'hématocrite vont de 0 à 1.
% 
% OUTPUT : Viscosité du sang dans les segments visés
% 
% Les équations utilisés proviennent de l'article Pries1992
% 
% Auteur : Joël Lefebvre
% Dernière modification : 2011-03-03

% global PlasmaViscosity

% PlasmaViscosity = 2; % Viscosité du plasma en cP. Source : Boas 2008
% PlasmaViscosity = 1.6; % Viscosité du plasma en cP. Source : Haidekker et al. 2002
PlasmaViscosity = 1.9696; % Viscosité du plasma en CP. Source : Optimisation PlamaViscosity par least mean square

% On calcule d'abord la viscosité relative apparente pour un hématocrite de
% 0.45.

Nrel45 = 220*exp(-1.3*Diameter) + 3.2 - 2.44*exp(-0.06*Diameter.^0.645);

% On calcule ensuite la courbure de la courbe nrel, qui dépend du diamêtre

C = (0.8 + exp(-0.075*Diameter)).*(1./(1 + 10^(-11)*Diameter.^12) - 1) + 1./(1 + 10^(-11)*Diameter.^12);

% On doit ensuite tranformer HctT en HctD, soit le taux d'hématocrite
% entrant et quittant un certain volume. La transition de HctT à  HctD
% dépend du diamètre du segment vasculaire considéré.

X = 1 + 1.7*exp(-0.35*Diameter) - 0.6*exp(-0.01*Diameter);
Hematocrit = - X./(2 - 2*X) + ((X./(2-2*X)).^2 + HctT./(1-X)).^0.5;

% On calcule finalement la viscosité relative apparente du sang, et on
% trouve la viscosité du sang en multipliant la viscosité relative avec la
% viscosité du plasma.

relativeViscosity = 1 + (Nrel45 - 1).*((1-Hematocrit).^C - 1)./((1 - 0.45).^C -1);
fviscosity = relativeViscosity * PlasmaViscosity;
%fviscosity = fviscosity(:);