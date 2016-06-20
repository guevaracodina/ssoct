function [info1 physio]=extraitInfoFast(info1,directory)
% extrait info.mat for the new IOI system
%directory='D:\Users\data\RCAL2\RC33\RC33E09\';
disp('Running : extraitInfoFast')
filename=[directory 'electro.tdms'];

[ConvertedData,ConvertVer,ChanNames,GroupNames,ci]=convertTDMS(1,filename);
Data=ConvertedData.Data.MeasuredData;
dt= ConvertedData.Data.MeasuredData(4).Property(3).Value;

stim=Data(6).Data ;
[out1 temps1]=TDMS2ttl(ConvertedData);
camera=out1(:,1);
time=(1:size(out1,1))*dt;
tempsCam=time(diff(camera)==1);



%%%%load('D:\Users\data\Epilepsie\IC\AA01E08\info.mat')


% find info1.Frame 
[Imout frameout frameReadOut fileNo] = LectureImageMultiFast(directory,'image',-1);
frameReadOut2=frameReadOut(frameReadOut(:,1)<=length(tempsCam),:);
info1.Frame(:,1)=frameReadOut2(:,1);
info1.Frame(:,3)=tempsCam(frameReadOut2(:,1));
info1.Frame(1,6)=0;

info1.FrameIndex=frameReadOut;
% find stim beginning
tempsStim=time(diff(stim)>100);
if isempty(tempsStim) % when there is no stim just to create something
   tempsStim=time(diff(stim)>7);
end 
ind=diff(tempsStim)>1;
tempsStim2=(tempsStim(ind));
freq=20;

  info1.stim1(:,1)=round(tempsStim2*freq);
info1.stim1(:,3)=tempsStim2;
info1.stim1(:,6)=1:size(info1.stim1,1);
info1.stim1(:,7)=1;

% couleur index
couleur='RVJL';
info1.FrameCouleur=couleur(rem(frameReadOut2(:,1),4)+1)';

% info1.stim3
info1.stim3=[1 0.014 .33 3 1];
info1.system='fast';
info1.Tacq=median(diff(info1.Frame(:,3)));
physio.stim=stim;
 
