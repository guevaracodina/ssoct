function [out temps]=TDMS2ttl(in)
% convert the TDMS to ttl for led camera and 
% same thing as num2bin, but go around user license problem
ttl1=rem(in.Data.MeasuredData(7).Data/1,2)>=1;  % trig ca mera
ttl2=rem(in.Data.MeasuredData(7).Data/2,2)>=1;  % trig light
ttl3=rem(in.Data.MeasuredData(7).Data/4,2)>=1;  % void
out=[ttl1 ttl2 ttl3]==1;
dt=in.Data.MeasuredData(7).Property(3).Value;
temps=[1:length(ttl1)]*dt;
%plot([ttl1 ttl2 ttl3])
