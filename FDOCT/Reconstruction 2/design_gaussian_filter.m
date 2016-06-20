function filter3D=design_gaussian_filter(filter_FWHM,step);
%This will design a 3D gaussian filter with dimensions specified by FWHM
%that will apply to a matrix having defined step
for i=1:3
    c=filter_FWHM(i)/2/sqrt(2*log(2));
    start_index=round(1.5*floor(filter_FWHM(i)/step(i)));
    x=(-start_index:start_index)*step(i);
    filter{i}=exp(-x.^2/2/c^2);
    filter{i}=filter{i}/sum(filter{i});
end
filter2D=zeros(numel(filter{1}),numel(filter{2}));
filter2D=filter{1}'*filter{2};
filter3D=zeros(numel(filter{1}),numel(filter{2}),numel(filter{3}));

for k=1:length(filter{3})
    filter3D(:,:,k)=filter2D*filter{3}(k);
end