function [FWHM,peak_pos]=calculate_FWHM(signal)
% This function will calculate the FWHM of a signal, if the signal is a
% matrix, it operates along it's columns, if the peak is at 0, it will
% estimate the FWHM as twice the position of the first 

[m,n]=size(signal);

if m==1;signal=signal';[m,n]=size(signal);end
[maximum,peak_pos]=max(signal);

for i=1:n;
    upcrossing=0;
    downcrossing=0;
    for j=1:m-1
        if (signal(j,i)<maximum(i)/2)&&(signal(j+1,i)>maximum(i)/2)
        upcrossing=[j+(maximum(i)/2-signal(j,i))/(signal(j+1,i)-signal(j,i))];
        end
        if (signal(j,i)>maximum(i)/2)&&(signal(j+1,i)<maximum(i)/2)
            
        downcrossing=[j+(maximum(i)/2-signal(j,i))/(signal(j+1,i)-signal(j,i))];
        end
    end
    
    if upcrossing==0;FWHM(i)=2*(downcrossing-peak_pos(i));
    else
    FWHM(i)=downcrossing-upcrossing;
    end
end