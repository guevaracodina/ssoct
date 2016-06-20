function [ray,pos]=travelray(ray,pos,operations,variable)
%This function will take an input a ray at a certain position and angle and
%make it perform an operation.
%Possible operations :
%   t : travel, will make the ray travel a certain distance
%   l : Is a lens
%   d : deflection by angle in rad


n_operations=length(operations);
for i=1:length(operations)
    switch operations(i)
        case 't'
            ray(:,end+1)=[1 variable(i);0 1]*ray(:,end);
            pos=addpos(pos,variable(i));
        case 'l'
            ray(:,end+1)=[1 0;-1/variable(i) 1]*ray(:,end);
            pos=addpos(pos,0);
        case 'd'
            ray(:,end+1)=ray(:,end)+[0;variable(i)];
            pos=addpos(pos,0);
        otherwise
            error(['Operation ''' operations(i) ''' undefined']);
    end
end
