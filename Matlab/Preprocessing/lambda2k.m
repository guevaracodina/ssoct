function wavenumbers = lambda2k(wavelengths)
% Equivalent to wavelengths2wavenumbers in FDOCT
% Converts wavelength to k and linear space.
% SYNTAX:
% wavenumbers = lambda2k(wavelengths)
% INPUTS:
% wavelengths           Wavelength vector in meters
% OUTPUTS:
% wavenumbers.pixels	pixels in K-space
% wavenumbers.linear	pixels in linear space
%_______________________________________________________________________________
% Copyright (C) 2012 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edward Baraghis, Edgar Guevara
% 2012/06/08

% ssOCTdefaults.range.vectorLambda is already in meters, so no need to multiply
% by 1e-9, just arrange the wavelength vector in decreasing order
wavelengths = wavelengths(end:-1:1);
% pixels in K-space
wavenumbers.pixels = 2*pi ./ wavelengths;
% pixels in linear space
wavenumbers.linear = linspace(wavenumbers.pixels(1),wavenumbers.pixels(end),length(wavelengths))';
