% This will write the results of the Doppler reconstructions to jpg files
% for viewing in ImageJ

[Structure,Doppler1,acqui_info,recons_info]=map_3D_files;


% VI = INTERP3(X,Y,Z,V,XI,YI,ZI)

[pathname,name,ext]=fileparts(acqui_info.filename);

graph_range=double(intmax('int16'))*[-1 1];
load doppler_color_map


for i=1:400;
    Slice_struct=squeeze(Structure.Data.Data(:,:,i));
    Slice_struct=double(Slice_struct)./double(intmax('int16'));
    Slice_struct=Slice_struct';
    
    Slice_doppler=squeeze(Doppler1.Data.Data(:,:,i));
    Slice_doppler=log(abs(double(Slice_doppler)))./log(double(intmax('int16')));
    Slice_doppler(Slice_doppler<0.5)=0;
    Slice_doppler=Slice_doppler.*double(sign(squeeze(Doppler1.Data.Data(:,:,i))));
    Slice_doppler=Slice_doppler(:,1:300)';
    imagesc(Slice_doppler)
    
    Slice_doppler_positive=zeros(size(Slice_doppler));
    Slice_doppler_positive(Slice_doppler>0)=Slice_doppler(Slice_doppler>0);
        
    Slice_doppler_negative=zeros(size(Slice_doppler));
    Slice_doppler_negative(Slice_doppler<0)=-1*Slice_doppler(Slice_doppler<0);
        
    Slice_doppler_RGB=zeros([size(Slice_doppler) 3]);
    Slice_doppler_RGB(:,:,1)=Slice_doppler_positive;
    Slice_doppler_RGB(:,:,3)=Slice_doppler_negative;
    
    if 1
        imwrite(Slice_struct,['C:/OCT Slices/' name '-Structure Slice ' num2str(i) '.tif'],'tiff')
        imwrite(Slice_doppler_RGB,['C:/OCT Slices/' name '-Doppler Slice ' num2str(i) '.tif'],'tiff')
    end
    
    if 0
        figure(1);
        imagesc(Slice_struct,[0 1]);
        title(['Slice ' num2str(i) ' structure'])
        colormap gray;
        colorbar
        
        figure(2);
        imagesc(Slice_doppler,[-1 1]);
        title(['Doppler'])
        colormap(doppler_color_map);
        colorbar
        
        pause(0.05);
    end
end