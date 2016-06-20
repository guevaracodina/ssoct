function [frame_struct, varargout] = FFT2struct(fftBscan, varargin)
% This function will generate a structure out of complex data, it will
% also find the surface of the structure and cut out the points above it,
% finally it will create a frame_mask using a dB threshold
% The Structure returned is in values of dB above noise floor, the noise
% floor is the last 5% of the image.
% SYNTAX:
% [frame_struct, frame_mask] = FFT2struct(fftBscan, mask_prop)
% INPUTS:
% fftBscan      
% [mask_prop]   
% OUTPUTS:
% frame_struct  
% [frame_mask]  
%_______________________________________________________________________________
% Copyright (C) 2012 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edward Baraghis, Edgar Guevara
% 2012/04/09

% only want 1 optional input at most
numVarArgs = length(varargin);
if numVarArgs > 1
    error('FFT2struct:TooManyInputs', ...
        'requires at most 1 optional input');
end

% set defaults for optional inputs
mask_prop.noise_lower_fraction  = 0.05;
mask_prop.enable                = false;
mask_prop.threshold_db          = 0.1;
mask_prop.blur_window           = 3;

optArgs = {mask_prop};

% now put these defaults into the optArgs cell array, 
% and overwrite the ones specified in varargin.
optArgs(1:numVarArgs) = varargin;
% or ...
% [optargs{1:numvarargs}] = varargin{:};

% Place optional args in memorable variable names
[mask_prop] = optArgs{:};

% Modulus of the FFT
frame_struct = abs(fftBscan);

% Calculate noise floor

noise_floor = mean(...
    mean(frame_struct(round((1-mask_prop.noise_lower_fraction)*end):end,:)));

% noise_floor = frame_struct(round((1-mask_prop.noise_lower_fraction)*end):end,:);
% noise_floor = std(noise_floor(:));



% The structure value in dB was calculated as ten times the base-10 logarithm of
% the ratio of the B-scan amplitude to the mean of the noise floor 
frame_struct = 10*log10(frame_struct / noise_floor);
frame_struct(frame_struct<0) = 0;

if isfield(mask_prop,'surface')
    if mask_prop.surface
        [frame_struct, surface]=find_top_surface(frame_struct);
    end
end

if mask_prop.enable

    frame_mask = int8(frame_struct);
    
    if isfield(mask_prop,'threshold_db')
        frame_mask(frame_mask<mask_prop.threshold_db)=0;
    end
    
    if isfield(mask_prop,'blur_window')
        use_fft = 0;
        if use_fft %does not give same result due to int8, and int8 not
            %implemented in convnfft
            OPTIONS.GPU = 0;
            OPTIONS.Power2Flag = 0;
            frame_mask=convnfft(single(frame_mask),single(mask_prop.blur_window),'same',1:2,OPTIONS);
        else
            frame_mask=convn(frame_mask,int8(mask_prop.blur_window),'same');
        end
    end
    
    frame_mask(frame_mask>0) = 1;
    
    frame_struct = frame_mask .* frame_struct;
else
    frame_mask = ones(size(frame_struct));
end

% Output frame mask
if nargout >= 2,
    varargout{1} = frame_mask;
end

end

% ==============================================================================
% [EOF]
