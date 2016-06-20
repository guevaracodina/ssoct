function [autocorrelated_frame,autocorrelated_line,FWHM]=autocorrelate(frame,range_corr,step_FOV,depth_range)
% This function will autocorrelate a frame along the second dimension a
% number of pixels defined by + and - range_corr.
% step_FOV is a minimum 2 element vector that contains the pixel size in um

display=0;

[m,n]=size(frame);
if ~exist('depth_range')
    figure(1);imagesc(frame)
    [x,y]=ginput(2);
    depth_range=round(min(y)):round(max(y));
end

frame=frame-mean(mean(frame));
autocorrelated_frame=zeros(m,range_corr);

i=0;
for position=0:range_corr
    i=i+1;
    autocorrelated_frame(:,i)=sum(([frame zeros(m,position)].*...
        [zeros(m,position) frame]),2);
end

background_correlation=mean(autocorrelated_frame(512-100:512,:),1);
autocorrelated_line=mean(autocorrelated_frame(depth_range,:),1)-background_correlation;
autocorrelated_line=autocorrelated_line-min(autocorrelated_line);
autocorrelated_line=autocorrelated_line/max(autocorrelated_line);

[sigma,mu,A]=mygaussfit((-range_corr:range_corr)*step_FOV(1),[autocorrelated_line(end:-1:2) autocorrelated_line]);
autocorrelated_line_fit=A * exp( -((-range_corr:range_corr).*step_FOV(1)-mu).^2 /(2*sigma^2));
FWHM=2*sqrt(2*log(2))*sigma;

for depth=1:length(depth_range)
    autocorrelated_frame(depth,:)=...
        autocorrelated_frame(depth,:)/max(autocorrelated_frame(depth,:));
end

if display
    
    figure(1);plot((-range_corr:range_corr)*step_FOV(1),[autocorrelated_line(end:-1:2) autocorrelated_line],(-range_corr:range_corr)*step_FOV(1),autocorrelated_line_fit)
    axis([[-range_corr range_corr]*step_FOV(1) 0 1])
    
    figure(2);imagesc([-range_corr range_corr]*step_FOV(1),[0 step_FOV(2)]*m,...
        [autocorrelated_frame(:,end:-1:2) autocorrelated_frame])
    xlabel('x (um)')
    ylabel('Depth (um)')
    figure(3);contour([-range_corr:1:range_corr]*step_FOV(1),[depth_range]*step_FOV(2),...
        [autocorrelated_frame(:,end:-1:2) autocorrelated_frame])%,[exp(-2)])
    
end