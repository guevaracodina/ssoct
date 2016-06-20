function [periods_after_qrs_peak,bpm]=Find_ECG_peaks(acqui_info,display_plots);
%this will find the peaks in the qrs complexes of an ecg signal
%it will also create a vector that describes the time after the qrs peak
%for all the a-lines

threshold=.5; %this is the fraction of the highest peak each peak must be to be detected
max_bpm=800; % this is the maximum bpm an animal can reach
time_between_peaks=1/max_bpm*60; %this is the minimum time between peaks in seconds

if iscell(acqui_info.ecg_signal)
    ecg_signal=[];
    for i=1:length(acqui_info.ecg_signal)
        ecg_signal=[ecg_signal acqui_info.ecg_signal{i}];
    end
else
    ecg_signal=acqui_info.ecg_signal;
end

[m n]=size(ecg_signal);

ecg=reshape(ecg_signal,m*n,1);

length_filter=round(1/2*acqui_info.ramp_length);

window=-1/(length_filter)*ones(length_filter,1);
window(round(end/2))=1;
% This filters the signal to remove the mean value to have a signal
% centered at 0
ecg=imfilter(ecg,window);

time=acqui_info.line_period_us*(1:length(ecg))*1e-6;

ecg_untangle_peaks=ecg;
threshold=threshold*max(ecg);
for i=2:length(ecg_untangle_peaks)
    if ecg_untangle_peaks(i)>threshold
        if ecg_untangle_peaks(i-1)==ecg_untangle_peaks(i)
            ecg_untangle_peaks(i)=ecg_untangle_peaks(i)+1;
        end
    end
end

mpd=round(time_between_peaks/acqui_info.line_period_us/1e-6);
[~,qrs_peak_pos]=findpeaks(ecg_untangle_peaks,'minpeakheight',threshold,'minpeakdistance',mpd);

dpeaks=qrs_peak_pos(2:end)-qrs_peak_pos(1:end-1);
average_dpeaks=mean(dpeaks);
% This will recalculate the average by rejecting bad peaks
max_dpeaks_variation=time_between_peaks/2/1e-6/acqui_info.line_period_us;
average_dpeaks=mean(dpeaks((average_dpeaks-max_dpeaks_variation<dpeaks)&...
    (dpeaks<average_dpeaks+max_dpeaks_variation)));

std_dpeaks=std(dpeaks);

max_dpeaks_variation=time_between_peaks/2/1e-6/acqui_info.line_period_us;

% This detects the peaks that are too close to each other
tooclose=find(dpeaks<average_dpeaks-max_dpeaks_variation);
for i=1:length(tooclose)-1
    if tooclose(i)+1==tooclose(i+1)
        qrs_peak_pos(tooclose(i)+1)=-1;
    end
end

% This detects the peaks that are too far from each other
toofar=find(dpeaks>average_dpeaks+max_dpeaks_variation);
for i=length(toofar):-1:1
    qrs_peak_pos=[qrs_peak_pos(1:toofar(i)) round(qrs_peak_pos(toofar(i))+average_dpeaks) ...
        qrs_peak_pos(toofar(i)+1:end)];
end
qrs_peak_pos=qrs_peak_pos(qrs_peak_pos>0);

% This will fit a polynome on the data to estimate where the missing peaks
% are
P=polyfit(1:numel(qrs_peak_pos),qrs_peak_pos,4);
points_before_first=-2:0;
peaks_before_first = polyval(P,points_before_first);
points_after_last=numel(qrs_peak_pos)+[1:3];
peaks_after_last = polyval(P,points_after_last);
qrs_peak_pos=[round(peaks_before_first(peaks_before_first>0)) qrs_peak_pos];
qrs_peak_pos=[qrs_peak_pos round(peaks_after_last(peaks_after_last<m*n))];
qrs_peak_pos_model=polyval(P,1:numel(qrs_peak_pos));

if display_plots
    figure(1)
    h=plot(1:numel(qrs_peak_pos)-1,...
        acqui_info.line_period_us*1e-3*[qrs_peak_pos_model(2:end)-qrs_peak_pos_model(1:end-1);...
        qrs_peak_pos(2:end)-qrs_peak_pos(1:end-1)]);
    set(h(1),'linewidth',2,'color','k')
    set(h(2),'marker','o','linestyle','none','color','k')
    title('Time between ECG peaks')
    legend('Fitted peaks','Detected Peaks','Location','Best')
    ylabel('Time between peaks (ms)')
    xlabel('Peak number')
end

ecg_frequency=((qrs_peak_pos(end)-qrs_peak_pos(1))...
    *acqui_info.line_period_us*1e-6/(length(qrs_peak_pos)-1))^-1;...
    %This is the heart rate frequency in hz
bpm=round(ecg_frequency*60);
time_after_qrs_peak=zeros(1,length(ecg));

for i=1:length(qrs_peak_pos)-1
    inter_qrs=qrs_peak_pos(i):qrs_peak_pos(i+1)-1;
    inter_qrs=round(inter_qrs);
    time_after_qrs_peak(inter_qrs)=0:length(inter_qrs)-1;
end

% This will add time_after_qrs_peak values for the points after the last
% ecg peak
time_after_qrs_peak(qrs_peak_pos(end):end)=0:length(time_after_qrs_peak(qrs_peak_pos(end):end-1));

% This will estimate the time after qrs peak for the peak
% that is right before the first frame
time_sample=time_after_qrs_peak(qrs_peak_pos(1):qrs_peak_pos(2));
if qrs_peak_pos(1)<length(time_sample) % This makes sure that the correction can be applied
    time_sample_cut=time_sample(end-qrs_peak_pos(1)+1:end);
    time_after_qrs_peak(1:qrs_peak_pos(1))=time_sample_cut;
else
    %If the time sample cannot fit then the first peak is estimated as
    %being exactly at the beginning of the first frame
    time_after_qrs_peak(1:qrs_peak_pos(1)-1)=0:qrs_peak_pos(1)-2;
end

if display_plots
    figure(10)
    hold on
    plot(time,time_after_qrs_peak/max(time_after_qrs_peak),':k')
    plot(time,double(ecg)/max(double(ecg)))
    plot(qrs_peak_pos*acqui_info.line_period_us*1e-6,double(ecg(qrs_peak_pos))/...
        max(double(ecg)),'o','color','r','MarkerFaceColor','r')
    hold off
    title({[num2str(length(qrs_peak_pos)) ' QRS peaks found'];...
        ['heartrate : ' num2str(round(ecg_frequency*100)/100) ' Hz (' num2str(bpm) ' bpm)']})
    xlabel('time (s)')
%     keyboard
    for i=0:size(ecg_signal,2)
        line(i*(size(ecg_signal,1))*acqui_info.line_period_us*1e-6*[1 1],[-1 1],'Color','g','LineStyle',':')
    end
end
periods_after_qrs_peak=reshape(time_after_qrs_peak,m,n);