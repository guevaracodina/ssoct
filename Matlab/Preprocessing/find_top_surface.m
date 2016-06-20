function [frame_struct,surface]=find_top_surface(frame_struct)
% This function will use the structural image in order to find the surface
% of the imaged fantom or animal. It will remove the structure that is an
% artefact above the top of the structure.

%This is the maximum a surface will vary in pixels, it is about 300 um
max_surface_variation=100;

% keyboard
% view_line=40;

%This is the number of pixels to cut from the top to avoid hitting the DC
%component
beginning_to_cut=20;

smoothing=50;

%This is the amount of pixels to add to make sure to get the whole top
%layer
buffer=5;
% figure(1);imagesc(frame_struct)

frame_smoothed=imfilter(frame_struct,hann(smoothing)/sum(hann(smoothing)));
frame_derivative=diff(frame_smoothed);
frame_derivative=frame_derivative./max(max(frame_derivative))*max(max(frame_smoothed));
% figure(2);plot([frame_struct(1:511,view_line)...
%     frame_smoothed(1:511,view_line) frame_derivative(:,view_line)])
% legend({'Original Structure';'Smoothed Structure';'Derivative'})

for i=1:size(frame_struct,2)
    surface(i)=find(frame_derivative(beginning_to_cut:end,i)...
        ==max(frame_derivative(beginning_to_cut:end,i)))+beginning_to_cut-1;
end

X=1:size(frame_struct,2);
%This will fit a polynome on the right and left sides of the surface data
%and determin which polynome to use depending on their variances
Positions{1}=ceil(numel(X)/2):numel(X);
P{1}=polyfit(X(ceil(end/2):end),surface(ceil(end/2):end),2);
surface_models{1}=polyval(P{1},X)-buffer;

Positions{2}=1:floor(numel(X)/2);
P{2}=polyfit(X(1:floor(end/2)),surface(1:floor(end/2)),2);
surface_models{2}=polyval(P{2},X)-buffer;

P{3}=polyfit(X,surface,2);
surface_models{3}=polyval(P{3},X)-buffer;

for i=1:numel(surface_models)
variances(i)=var(surface_models{i});
end

best_model=find(variances==min(variances));
surface=surface_models{best_model};

% plot([surface;surface_models{1};surface_models{2};surface_models{3}]')
% legend('Original surface','Model 1 : left side','Model 2 : right side','Model 3 : center')
% title(['Selected model ' num2str(best_model)])

surface=round(surface);

for i=1:size(frame_struct,2)
    if surface(i)>5
        frame_struct(1:surface(i),i)=0;
    end
end

% figure(4);imagesc(frame2)
% figure(2);h=line([surface(view_line) surface(view_line)],[0 60]);
% set(h,'Color','k')
