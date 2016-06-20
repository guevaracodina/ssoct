%This script will load results from the scattering fantom and evaluate the
%autocorrelation FWHM for each result the acquisitions should already be 
clear
[pathname,filename]=prompt_acquisition('Select acquisitions containing fantom data');

number_of_acquisitions=numel(pathname);

for acquisition=1:number_of_acquisitions
    
    load([pathname{acquisition} filename{acquisition}])
    keyboard
    
    Hstruct3D=fopen([acqui_info.filename '.struct3D'],'r');
    Structure=fread(Hstruct3D,
    for j=1:400;
        [autocorrelated_frame,autocorrelated_line,FWHM(i,j)]=autocorrelate(Structure(:,:,i)',100,recons_info.step,100:250);
    end
end