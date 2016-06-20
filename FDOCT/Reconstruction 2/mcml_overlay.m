function h_image = mcml_overlay(anatomy, img, varargin)
% Parser to overlay functional image onto an anatomic template
% SYNTAX:
% h_image =
% mcml_overlay(anatomy,img,[transpThreshold],opacity,logscale,[imgThreshold])
% INPUT:
% anatomy:          Image used as anatomical template
% img:              Color image to be superimposed
% [transpThreshold]:2 element vector with ransparency thresholds as fraction of
%                   maximum value (0-1)
% opacity:          Opacity percentage: 0 = transparent, 1 = opaque
% logscale:         Display on log-scale: 0 = linear, 1 = logarithmic
% colormap:         Colormap to be used
% [imgThreshold]:   2 element vector with lower and upper limits for scaling the
%                   display colormap
% OUTPUT:
% h_image:          Handle to current figure
%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara, Frédéric Lesage
% 2011/02/13

% Only want 1 optional input at most
numVarArgs = length(varargin);
if numVarArgs > 4
    error('myfuns:mcml_overlay:TooManyInputs','Requires at most 4 optional inputs');
end
% Set defaults for optional inputs
optArgs = {[0 0.879] 0.7 0 'jet(256)' [min(img(:)) max(img(:))]};
% now put these defaults into the optArgs cell array, and overwrite the ones
% specified in varargin.
optArgs(1:numVarArgs) = varargin;
% Place optional args in memorable variable names
[dataStruct.transpThreshold dataStruct.opacity logscale dataStruct.colormap...
    dataStruct.imgThreshold] = optArgs{:};

% Anatomic background (grayscale)
dataStruct.anatomy = double(anatomy - min(anatomy(:)));
% Normalize anatomical image values between 0 and 1
dataStruct.anatomy = double(dataStruct.anatomy ./ max(dataStruct.anatomy(:)));
% Overlay Image (colors)
dataStruct.img = img;
if logscale                             % Superimpose image on log-scale
    dataStruct.img = log(1 + dataStruct.img);
    dataStruct.imgThreshold = [min(dataStruct.img(:)) max(dataStruct.img(:))];
end
% New figure on white background
figure; set(gcf,'color','w')
h_image = spm_lot_overlay(dataStruct);
% ------------------------- END of mcml_overlay --------------------------------

function h_image = spm_lot_overlay(dataStruct)
% Overlay activation map on anatomical template
% SYNTAX:
% h_image = spm_lot_overlay(dataStruct)
% INPUT:
% dataStruct:       Structure with the following fields (in the specific order):
% anatomy:          Image used as anatomical template(1st frame of 1st detector)
%                   see spm_lot_get_anatomy
% [transpThreshold]:2 element vector with ransparency thresholds as fraction of
%                   maximum value (0-1)
% opacity:          Opacity percentage: 0 = transparent, 1 = opaque
% [imgThreshold]:   2 element vector with lower and upper limits for scaling the
%                   display colormap
% img:              Color image to be superimposed
% OUTPUT:
% h_image:          Handle to current figure
%_______________________________________________________________________________
% Copyright (C) 2010 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Simon Dubeau, Edgar Guevara
% 2010/09/01
tempCell = struct2cell(dataStruct);     % Temporary cell
% Sanity check
if ~isfield(dataStruct,'anatomy')
    dataStruct.anatomy = tempCell{1};
end
if ~isfield(dataStruct,'transpThreshold')
    dataStruct.transpThreshold = tempCell{2};
end
if ~isfield(dataStruct,'opacity')
    dataStruct.opacity = tempCell{3};
end
if ~isfield(dataStruct,'imgThreshold')
    dataStruct.imgThreshold = tempCell{4};
end
if ~isfield(dataStruct,'img')
    dataStruct.img = tempCell{5};
end
clear tempCell                          % Cleanup
% Activation image to have the same size as the anatomical template
dataStruct.img = imresize (dataStruct.img,size(dataStruct.anatomy),'lanczos3');
% Lower transparency threshold set at a percentage of maximum value
alphaThreshold(1) = dataStruct.imgThreshold(1) + (dataStruct.transpThreshold(1))...
    *(dataStruct.imgThreshold(2) - dataStruct.imgThreshold(1));
% Upper transparency threshold set at a percentage of maximum value
alphaThreshold(2) = dataStruct.imgThreshold(1) + (dataStruct.transpThreshold(2))...
    *(dataStruct.imgThreshold(2) - dataStruct.imgThreshold(1));
% Grayscale limits
lowAnatomic = min(dataStruct.anatomy(:));
highAnatomic = max(dataStruct.anatomy(:));
% Grayscale phantom image
imagesc(dataStruct.anatomy);
axis image;
hold on
% Grayscale anatomic map
color_img = ind2rgb(round((dataStruct.anatomy-lowAnatomic)/...
    (highAnatomic-lowAnatomic)*256),gray(256));
imagesc(color_img);
axis image;
% Color activation map
color_img = ind2rgb(round((dataStruct.img-dataStruct.imgThreshold(1))/...
    (dataStruct.imgThreshold(2)-dataStruct.imgThreshold(1))*256),...
    colormap(dataStruct.colormap));
% Transparency map
alpha_img = ones(size(dataStruct.img));
alpha_img = alpha_img*dataStruct.opacity;
alpha_img = min(max(alpha_img,0),1);
% Transparency limits
alpha_img = (dataStruct.img < alphaThreshold(1) | dataStruct.img > ...
    alphaThreshold(2)) .* alpha_img;
% Overlay map
h_image = imagesc(color_img);
% Establish transparency
set(h_image,'AlphaData',alpha_img);
% ------------------------ END of spm_lot_overlay ------------------------------