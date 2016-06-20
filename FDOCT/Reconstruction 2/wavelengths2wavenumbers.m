function [wavenumbers]=wavelengths2wavenumbers(wavelengths)
wavenumbers.pixels=2*pi./(wavelengths*1e-9);
wavenumbers.linear=linspace(wavenumbers.pixels(1),wavenumbers.pixels(end),length(wavelengths))';