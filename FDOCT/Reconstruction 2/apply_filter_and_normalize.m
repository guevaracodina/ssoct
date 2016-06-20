function No_of_A_lines_filtered=apply_filter_and_normalize(filter,No_of_A_lines)
% This function will apply the filter defined by the 3D matrix filter onto
% the 3D global variable of the structure and the Doppler before they are
% normalized by the number of A-lines in each column. It will also
% filter the Number of A-lines by the filter defined by the sum along
% depths of the 3D filter. This new number of A-lines will then be used to
% normalize the 3D matrices

global Structure_global Doppler1_global
% keyboard

[m n o]=size(Structure_global);

filter_2D=squeeze(sum(filter,2));
No_of_A_lines_filtered=imfilter(No_of_A_lines,filter_2D);

%This will go through every depth and apply the filter along the 2
%dimensions and normalize
for j=1:n
    Structure_global(:,j,:)=imfilter(squeeze(Structure_global(:,j,:)),...
        filter_2D)./No_of_A_lines_filtered;
    Doppler1_global(:,j,:)=imfilter(squeeze(Doppler1_global(:,j,:)),...
        filter_2D)./No_of_A_lines_filtered;
end