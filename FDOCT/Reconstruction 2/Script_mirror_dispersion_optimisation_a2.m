% This script will use a data set taken on mirrors at different path
% differences and use them to evaluate different combinations of dispersion
% compensation factors to optimize resolution at a depth of interest
if exist('pathname')
else
clear
[pathname,filename]=prompt_acquisition...
    ('Select files containing acquisition on same mirror but different path lengths');
end

pathlength_difference=0:50:1500;
important_peaks=3:13;
for acquisition=1:numel(pathname)
    load([pathname{acquisition} filename{acquisition}]);
    [FrameData,acqui_info]=map_dat_file(acqui_info);
    Interference(:,acquisition)=FrameData.Data.frames(:,1,1)';
    Reference(:,acquisition)=acqui_info.reference;
end
keyboard

target_peak=7;
clear FWHM_matrix a
a(:,2)=[-100:1:0 0.35:0.1:1.17 (1.1785:0.0001:1.18) 1.18:0.1:2 3:1:10]*1e-5;
% a(:,3)=0;[1:10]*1e-8;

[number_of_combinations,dispersion_degree]=size(a);

for combination=1:number_of_combinations
    combination_name{combination}=[];
    for k=2:dispersion_degree
        combination_name{combination}=...
            [combination_name{combination} 'a_' num2str(k) '=' num2str(a(combination,k)) ', '];
    end
    combination_name{combination}=combination_name{combination}(1:end-1);
    
    Interference2=double(Interference)-Reference;
    Interference2=Interference2./Reference*max(max((Reference)));
    [wavenumbers]=wavelengths2wavenumbers(acqui_info.wavelengths);
    Interference3=interp1(wavenumbers.pixels,Interference2,wavenumbers.linear,'linear');
    Interference3=Interference3.*repmat(hann(1024),[1 31]);
    [Interference3]=dispersion_compensation(Interference3,wavenumbers,a(combination,:));
    
    reconstructed=fft(Interference3);
    signal=abs(reconstructed(1:end/2,:));
    
    %This is to remove the low frequency component that is sometimes stronger
    %then the actual signal
    signal(1:5,2:end)=0;
    
    [FWHM{combination},peak_pos(:,combination)]=calculate_FWHM(signal);
    FWHM_matrix(:,combination)=FWHM{combination};
    
    if combination==1
        P=polyfit(peak_pos(2:10,combination),pathlength_difference(2:10)',1);
        position=(1:512)*P(1)+P(2);
    end
    
    if 1
        % This will plot the resulting peaks from each dispersion
        % compensation combinations
        figure(combination);subplot(3,1,1);plot(position,signal);
        title(combination_name{combination});
        axis([0 max(pathlength_difference)+100 0 max(max(signal))])
        figure(combination);subplot(3,1,2);plot(position,signal./repmat(max(signal),[512 1]));
        title('Peaks normalisés');axis([0 max(pathlength_difference)+100 0 1])
        figure(combination);subplot(3,1,3);plot(pathlength_difference,FWHM{combination}*P(1));
        title('FWHM du peak');
        xlabel('Différence de marche (um)');
        ylabel('Largeur du peak (um)')
        axis([0 max(pathlength_difference)+100 0 max(FWHM{combination}*P(1))])
    end
    
    test_peak(combination,:)=signal(:,target_peak);
    lowest_FWHM(combination)=find(FWHM{combination}==min(FWHM{combination}(2:end)));
    mean_FWHM(combination)=mean(FWHM{combination}(2:end));
    %This is the mean FWHM of peaks that are in the important range defined
    %at the beginning.
    meaningful_mean_FWHM(combination)=mean(FWHM{combination}(important_peaks)); 
end
best_resolution_at_depth=pathlength_difference(lowest_FWHM);
figure(200);plot(a(:,2),best_resolution_at_depth)
title('Position of best FWHM depending on a_2 value')
xlabel('a_2 value')
ylabel('Depth with best axial resolution (um)')

figure(300);plot(a(:,2),mean_FWHM*P(1))
title('Mean FWHM of all peaks')
xlabel('a_2 value')
ylabel('Mean resolution (um)')

best_a2=a(find(meaningful_mean_FWHM==min(meaningful_mean_FWHM)),2);
figure(400);plot(a(:,2),meaningful_mean_FWHM*P(1))
title({['Mean FWHM of the peaks in the '...
    num2str(pathlength_difference(min(important_peaks)))...
    ' to ' num2str(pathlength_difference(max(important_peaks))) ' um range'];...
    ['Best a_2 value = ' num2str(best_a2)]})
xlabel('a_2 value')
ylabel('Mean resolution (um)')

peak_view_width=10; % In pixels
positions_to_view=peak_pos(target_peak,combination)-peak_view_width:peak_pos(target_peak,combination)+peak_view_width;
figure(100);plot(position(positions_to_view),...
    test_peak(:,positions_to_view)'./repmat(max(test_peak')',[1 2*peak_view_width+1])');
legend(combination_name)

title(['Comparaison de la largeur du ' num2str(target_peak)...
    'ième pic à ' num2str(pathlength_difference(target_peak)) ' um'])