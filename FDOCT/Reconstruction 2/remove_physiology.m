function doppler_current=remove_physiology(doppler_current,frame_mask)

pix_below_surface=10:20;

[ii,jj]=find(frame_mask);
physiology=zeros(1,size(frame_mask,2));
% keyboard
for j=1:size(frame_mask,2)
    positions=ii(find(jj==j));
    if numel(positions)>=max(pix_below_surface)
    physiology(j)=mean(doppler_current(positions(pix_below_surface),j));
    end
end

doppler_current=doppler_current-repmat(physiology,[size(doppler_current,1) 1]);
doppler_current=doppler_current.*frame_mask;