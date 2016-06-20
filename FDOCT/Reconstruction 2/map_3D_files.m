function [Structure,Doppler1,acqui_info,recons_info]=map_3D_files(filename)
%This function will generate the memmapfile handle for .struct3D and
%.dop13D files it will also load the information on the acquisition and
%reconstruction of the target data set
if ~exist('filename')
    [pathname,filename]=prompt_acquisition('Select !1! file to map');
    filename=[pathname{1} filename{1}];
end

[pathname_temp,filename_temp,ext]=fileparts(filename);
filename=[pathname_temp '\' filename_temp];
load(filename)

if exist('recons_info')
    datasize=recons_info.size;
    if exist([filename '.struct3D'])
        D = dir([filename '.struct3D']);
        if prod(datasize)*2>D.bytes
            Structure=0;
        else
            Structure=memmapfile([filename '.struct3D'],...
                'Format',{'int16' datasize 'Data'});
        end
    else
        Structure=0;
    end
    
    if exist([filename '.dop13D'])
        D = dir([filename '.dop13D']);
        if prod(datasize)*2>D.bytes
            Doppler1=0;
        else
            Doppler1=memmapfile([filename '.dop13D'],...
                'Format',{'int16' datasize 'Data'});
        end
    else
        Doppler1=0;
    end
else
    Doppler1=0;Structure=0;
end

assignin('base','Structure',Structure)
assignin('base','Doppler1',Doppler1)
assignin('base','acqui_info',acqui_info)
assignin('base','recons_info',recons_info)