function No_of_A_lines=place_frame(structure_extracted,doppler_extracted,...
    current_position,No_of_A_lines);
global Structure_global Doppler1_global


[m,n,o]=size(Structure_global);
valid_lateral=(current_position(:,1)>=1).*(current_position(:,1)<=m);
valid_third=(current_position(:,2)>=1).*(current_position(:,2)<=o);
valid_positions=find(valid_lateral.*valid_third);

current_position=current_position(valid_positions,:);
structure_extracted=structure_extracted(:,valid_positions);
doppler_extracted=doppler_extracted(:,valid_positions);

%This will eliminate the lines that are declared as outside of the final
%structure


[nn,mm]=size(structure_extracted);

if m*n*o>intmax('uint32')
    disp('Matrix larger then directly addressable through uint32')
    keyboard
end
% keyboard

%There was a problem with the indexes becoming larger then could be
%accurately indexed with single precision, double precision was necessary

linear_structure=structure_extracted(:);
linear_doppler1=doppler_extracted(:);%reshape(doppler_extracted,m*n,1);

current_position=double(current_position);

j=repmat((1:n)',[mm 1]);
i_0=repmat(current_position(:,1),[1 n])';
i_0=i_0(:);
k_0=repmat(current_position(:,2),[1 n])';
k_0=k_0(:);

% This will distribute each A-line of the reconstructed frame between the 4
% corners of the final 3D matrix where it is located using a weight
% function to determine the distribution
% Commentary example for an A-line at axial position 203.3 and time
% position 25.6

for corner=1:4
    switch corner
        case 1 
            % This is the lowest corner (example = 203 and 25)
            lateral_position_rounded=floor(current_position(:,1));
            third_position_rounded=floor(current_position(:,2));
        case 2
            lateral_position_rounded=ceil(current_position(:,1));
            % This will force the rounded position to be different then the
            % current_position if it is exactly on the same spot
            lateral_position_rounded(lateral_position_rounded==...
                floor(current_position(:,1)))=...
                lateral_position_rounded(lateral_position_rounded==...
                floor(current_position(:,1)))+1;
            %If the operation makes the rounded position exceed the
            %dimension of the matrix, it is brought back inside by using
            %the point on the other side
            lateral_position_rounded(lateral_position_rounded>m)=...
                lateral_position_rounded(lateral_position_rounded>m)-2;
            
            third_position_rounded=floor(current_position(:,2));
        case 3
            lateral_position_rounded=floor(current_position(:,1));
            
            third_position_rounded=ceil(current_position(:,2));
            
            third_position_rounded(third_position_rounded==...
                floor(current_position(:,2)))=...
                third_position_rounded(third_position_rounded==...
                floor(current_position(:,2)))+1;
            third_position_rounded(third_position_rounded>o)=...
                third_position_rounded(third_position_rounded>o)-2;
            
        case 4
            lateral_position_rounded=ceil(current_position(:,1));
            lateral_position_rounded(lateral_position_rounded==...
                floor(current_position(:,1)))=...
                lateral_position_rounded(lateral_position_rounded==...
                floor(current_position(:,1)))+1;
            lateral_position_rounded(lateral_position_rounded>m)=...
                lateral_position_rounded(lateral_position_rounded>m)-2;
            
            third_position_rounded=ceil(current_position(:,2));
            
            third_position_rounded(third_position_rounded==...
                floor(current_position(:,2)))=...
                third_position_rounded(third_position_rounded==...
                floor(current_position(:,2)))+1;
            third_position_rounded(third_position_rounded>o)=...
                third_position_rounded(third_position_rounded>o)-2;
    end
    
    i{corner}=repmat(lateral_position_rounded,[1 n])';
    i{corner}=i{corner}(:);
    
    k{corner}=repmat(third_position_rounded,[1 n])';
    k{corner}=k{corner}(:);
    
    if (k{corner}>o).*(i{corner}>m)
        disp('Index exceeds matrix dimensions')
        keyboard
    end
    %keyboard
    
    Index{corner}=sub2ind([m n o],i{corner},j,k{corner});
    
    Index_2D{corner}=sub2ind(uint32([m o]),i{corner}(1:n:end),k{corner}(1:n:end));
    
    % For the lowest corner this will give a weight of 0.7*0.4=0.28
    weight{corner}=(1-abs(i_0-i{corner})).*(1-abs(k_0-k{corner}));
% keyboard
    Structure_global(Index{corner})=linear_structure...
        .*weight{corner}+Structure_global(Index{corner});
    
    Doppler1_global(Index{corner})=linear_doppler1...
        .*weight{corner}+Doppler1_global(Index{corner});
    
    No_of_A_lines(Index_2D{corner})=weight{corner}(1:n:end)+No_of_A_lines(Index_2D{corner});
end
