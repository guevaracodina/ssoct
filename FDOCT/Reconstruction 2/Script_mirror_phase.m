% This script will use a data set taken on mirrors at different path
% differences and evaluate the effect of using different dispersion
% compensation on the FWHM of their peaks.

clear

[pathname,filename]=prompt_acquisition('Select files containing acquisition on same mirror but different path lengths')
pathlength_difference=0:50:1500;

for acquisition=1:numel(pathname)
    load([pathname{acquisition} filename{acquisition}]);
    [FrameData,acqui_info]=map_dat_file(acqui_info);
    Interference(:,acquisition)=FrameData.Data.frames(:,1,1)';
    Reference(:,acquisition)=acqui_info.reference;
end
target_peak=7;
method_name={'1 : Reference removed';...
    '2 : 1 + Division';...
    '3 : 2 + Hanning Window'};
% a_3=10.^-[1:10];
a_2=[0:10:100];

clear FWHM_matrix
for i=1:length(a_2)
    method_name{3+i}=[num2str(3+i) ' : 3 + DC a_2=' num2str(a_2(i))];
end

for method=1:3+numel(a_2)
    
    Interference2=double(Interference)-Reference;
    if method>1; Interference2=Interference2./Reference*max(max((Reference)));
    end
    [wavenumbers]=wavelengths2wavenumbers(acqui_info.wavelengths);
    Interference3=interp1(wavenumbers.pixels,Interference2,wavenumbers.linear,'linear');
    if method>2;Interference3=Interference3.*repmat(hann(1024),[1 31]);end
    if method>3;
        [Interference3]=dispersion_compensation(Interference3,wavenumbers,a_2(method-3));
    end
    
    reconstructed=fft(Interference3);
    signal=abs(reconstructed(1:end/2,:));
    
    %This is to remove the low frequency component that is sometimes stronger
    %then the actual signal
    signal(1:5,2:end)=0;
    
    [FWHM{method},peak_pos]=calculate_FWHM(signal);
    FWHM_matrix(:,method)=FWHM{method};
    mean_FWHM(method)=mean(FWHM{method});
    
    if method==1
        P=polyfit(peak_pos(2:10),pathlength_difference(2:10),1);
        position=(1:512)*P(1)+P(2);
    end
    
    if 1
        figure(method);subplot(3,1,1);plot(position,signal);
        title(method_name{method});axis([0 max(pathlength_difference)+100 0 max(max(signal))])
        figure(method);subplot(3,1,2);plot(position,signal./repmat(max(signal),[512 1]));title('Peaks normalisés');axis([0 max(pathlength_difference)+100 0 1])
        figure(method);subplot(3,1,3);plot(pathlength_difference,FWHM{method}*P(1));
        title('FWHM du peak');
        xlabel('Différence de marche (um)');
        ylabel('Largeur du peak (um)')
        axis([0 max(pathlength_difference)+100 0 max(FWHM{method}*P(1))])
        print(['Peaks' num2str(method) '.pdf'],'-dpdf')
    end
    
    test_peak(method,:)=signal(:,target_peak);
end

peak_view_width=10; % In pixels
positions_to_view=peak_pos(target_peak)-peak_view_width:peak_pos(target_peak)+peak_view_width;
figure(100);plot(position(positions_to_view),...
    test_peak(:,positions_to_view)'./repmat(max(test_peak')',[1 2*peak_view_width+1])');
legend(method_name)

title(['Comparaison de la largeur du ' num2str(target_peak) 'ième peak à ' num2str(pathlength_difference(target_peak)) ' um'])