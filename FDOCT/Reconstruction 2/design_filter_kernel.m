function [filter_kernel]=design_filter_kernel(sigma,lineperiod,display_figure);
%This function will design a filter_kernel for use with the doppler
%processor function.
% syntax : [filter_kernel]=design_filter_kernel(sigma,lineperiod)
%           - sigma is the width of the gaussian function used in the
%           kernel (in second).
%           - lineperiod is the time step for each a-line acquisition (in
%           seconds).

t=0:lineperiod:3*sigma;
t=[-t(end:-1:2) t];
fs=1/lineperiod;

f = fs/2*linspace(-1,1,length(t));

gaussian=exp(-t.^2/2/sigma^2);
a=1/sum(gaussian);
gaussian=gaussian*a;

middle_one=zeros(1,length(t));
middle_one(round(end/2))=1;

filter_kernel=middle_one-gaussian;

% keyboard
if exist('display_figure')
    if display_figure==1
        %% this will plot the filter kernel and the filter_response
        figure(1)
        
        subplot(1,2,1)
        plot(t*1e3,filter_kernel,'-o')
        axis tight
        title(['filter kernel, length of ' num2str(length(filter_kernel)) ' elements'])
        xlabel('time (ms)')
        ylabel('a.u.')
        
        
        filter_response=abs(fftshift(fft(filter_kernel)));
        
        subplot(1,2,2)
        plot(f/1000,filter_response)
        axis tight
        title('filter frequency response')
        xlabel('frequency (khz)')
        ylabel('a.u.')
    end
end