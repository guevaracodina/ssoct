% This script will resave the acqui_info structure into the filename that is
% declared within it, if recons_info and result are also present they will
% also be saved

if exist(acqui_info.filename,'file')
    save(acqui_info.filename,'acqui_info','-append')
else
    save(acqui_info.filename,'acqui_info')
end

assignin('base','acqui_info',acqui_info);

if exist('recons_info')
    save(acqui_info.filename,'recons_info','-append')
        assignin('base','recons_info',recons_info);
end

if exist('result')
    save(acqui_info.filename,'result','-append')
        assignin('base','result',result);
end