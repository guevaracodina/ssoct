directory=

filename=[directory 'electro1.tdms'];

[ConvertedData,ConvertVer,ChanNames,GroupNames,ci]=convertTDMS(1,filename);
Data=ConvertedData.Data.MeasuredData;
dt= ConvertedData.Data.MeasuredData(4).Property(3).Value;

stim=Data(6).Data ;
[out1 temps1]=TDMS2ttl(ConvertedData);
camera=out1(:,1);
tempsCam=(camera==1)*.0001;
tempsStim=(stim>.001)*.0001;


[Imout frameout frameReadOut fileNo] = LectureImageMultiFast(directory,'image',-1);
 

