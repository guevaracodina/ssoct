function No_of_Alines=calcAlines(A_line_position)

dimension=squeeze(max(max(A_line_position)))';
[~,total_frames,~]=size(A_line_position);

No_of_Alines=zeros(dimension);

for current_frame=1:total_frames;
    subscript=squeeze(A_line_position(:,current_frame,:));
    indexes=sub2ind(dimension,subscript(:,1),subscript(:,2));
    No_of_Alines(indexes)=No_of_Alines(indexes)+1;
end