function [gate_position,dt_us]=segment_2Dtime(acqui_info,number_of_time_gates);
% This function will take ECG data taken on a 2D slice and determine how
% many A-lines are averaged for each time frame on a certain position. The
% number of ecg time gates is set by the user. The more time gates we have
% the more chances there are of having no data for a certain position and
% time gate.

%This is an indicator of whether this function is run in manual mode
%(executing the function by itself) or in automatic mode where the
% displays wont come on.
manual_mode=0;

if ~exist('acqui_info')
    [filename,path]=uigetfile('mat',['Select file containing 2D+ECG information to segment']);
    load([path filename])
    [pathname_temp,filename_temp,ext]=fileparts([path filename]);
    acqui_info.filename=[pathname_temp '\' filename_temp];
    resave_acqui_info;
    manual_mode=1;
end

if ~exist('number_of_time_gates')
    number_of_time_gates=100; %This is the number of time gates to reconstruct the 2D frame in time.
end

[periods_after_QRS_peak]=Find_ECG_peaks(acqui_info,manual_mode);
peak_positions=find(periods_after_QRS_peak==0);
if peak_positions(1)==1;peak_positions(1)=2;end
final_values=periods_after_QRS_peak(peak_positions-1);

[m,n]=size(periods_after_QRS_peak);
straight_periods=reshape(periods_after_QRS_peak,m*n,1);

% first_ECG_peak=find(straight_periods>0);
% first_ECG_peak=first_ECG_peak(1)-1;
% first_ecg_frame=ceil(first_ECG_peak/acqui_info.ramp_length)+1;

delta_periods=straight_periods(1:end-1)-straight_periods(2:end);
average_delta_QRS=mean(delta_periods(delta_periods>0));

periods_in_time_gate=average_delta_QRS/number_of_time_gates;
dt_us=periods_in_time_gate*acqui_info.line_period_us;

%The gate position will be continous values between 1 and the number of
%time gates

gate_position=zeros(size(periods_after_QRS_peak));

if 0
gate_position=periods_after_QRS_peak/periods_in_time_gate+1;
end

%This new definition for the number of time gates indicates at which
%percentage of the cardiac cycle we are located.

gate_position(1:peak_positions(1)-1)=periods_after_QRS_peak(1:peak_positions(1)-1)/final_values(1)*(number_of_time_gates-1)+1;

gate_position(peak_positions(end):end)=periods_after_QRS_peak(peak_positions(end):end)/final_values(end)*(number_of_time_gates-1)+1;

for i=1:numel(peak_positions)-1
    range=peak_positions(i):peak_positions(i+1);
    gate_position(range)=(periods_after_QRS_peak(range))/final_values(i+1)*(number_of_time_gates-1)+1;
end

gate_position(isnan(gate_position))=1;