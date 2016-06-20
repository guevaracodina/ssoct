function ETA_text=get_ETA_text(time,currentstep,totalsteps)

timeperframe=time/currentstep;

ETA=(totalsteps-currentstep)*timeperframe;
ETA_hours=floor(ETA/3600);
ETA_minutes=floor((ETA/3600-ETA_hours)*60);
ETA_seconds=round((((ETA/3600-ETA_hours)*60)-ETA_minutes)*60);

if ETA_seconds==60
    ETA_minutes=ETA_minutes+1;
    ETA_seconds=0;
end

if ETA_minutes==60
    ETA_hours=ETA_hours+1;
    ETA_minutes=0;
end

if ETA_hours>0
    ETA_text=['ETA: ' num2str(ETA_hours) 'h ' num2str(ETA_minutes) 'min ' num2str(ETA_seconds) 's'];
elseif ETA_minutes>0
    ETA_text=['ETA: ' num2str(ETA_minutes) 'min ' num2str(ETA_seconds) 's'];
else
    ETA_text=['ETA: ' num2str(ETA_seconds) 's'];
end