function corrected_image = correct_sinus(image)
% The assumption is that the image is from a full sinus (no truncation) The x
% position is then proportional to the half period corrected image is normalized
% over -1:1 (does not matter).
% SYNTAX:
% corrected_image = spm_lot_sinus(image)
% INPUTS:
% image: 2D image from a single detector
% OUTPUTS:
% corrected_image: non-linear sampling corrected along x-axis (fast axis)
%_______________________________________________________________________________
% Copyright (C) 2010 Laboratoire d'Imagerie Optique et Moleculaire
% Frederic Lesage, Edgar Guevara
% 2010/03/20

if isinteger(image)                     % Checking if image is int16
    image = double(image);
    FLAG_int = true;
else
    FLAG_int = false;
end
% No need to preallocate memory becauuse of vectorized code //EGC
% corrected_image = zeros(size(image));   % Preallocate memory
npts = size(image,2);                   % Number of sampled points(columns)
real_posx = cos(-pi+pi*(1:npts)/npts);  % Real sampling position
wanted_posx = (-npts+1:2:npts-1)/npts;  % Desired position
% The following loop has been vectorized // EGC
% for iRow=1:size(image,1)                % For every row
%     corrected_image(iRow,:)=interp1(real_posx,image(iRow,:),wanted_posx);
% end
corrected_image = interp1(real_posx',image',wanted_posx')';
if FLAG_int                             % Output image is also an integer
    corrected_image = int16(corrected_image);
end

%_______________________________________________________________________________
% EGC 2010/04/21
% OLD VERISON STARTS HERE
% function corrected_image=correct_sinus(image)
% % The assumption is that the image is from a full sinus (no truncation)
% % The x position is then proportional to the half period
% % corrected image is normalized over -1:1 (does not matter).
% % Syntax: 
% % corrected_image = correct_sinus(image)
% % -------------------------------------------------------------------------
% if isinteger(image)
% image = double(image);
% FLAG_int = true;
% else
% FLAG_int = false;
% end
% corrected_image = zeros(size(image));   % Preallocate
% npts = size(image,2);                   % Number of sampled points
% real_posx = cos(-pi+pi*(1:npts)/npts);  % Real sampling position
% wanted_posx = (-npts+1:2:npts-1)/npts;  % Desired position
% for index=1:size(image,1)               % For every row
% corrected_image(index,:)=interp1(real_posx,image(index,:),wanted_posx);
% end
% if FLAG_int
% corrected_image = int16(corrected_image);
% end
