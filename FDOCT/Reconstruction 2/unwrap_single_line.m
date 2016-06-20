function doppler_line=unwrap_single_line(doppler_line)

i=10; %This is the starting point where transitions will start to be detected
reached_end=1;
window_size=50;

while reached_end
    if abs(doppler_line(i+1)-doppler_line(i))>1.5*pi
        transition_sign=sign(doppler_line(i+1)-doppler_line(i));

        if i+window_size>=numel(doppler_line)
            last_index=numel(doppler_line);
        else
            last_index=i+window_size;
        end
        [minvalue,position_second_transition]=min(diff(doppler_line(i:last_index))*transition_sign);
        positions_to_unwrap=i+1:i+position_second_transition-1;
        doppler_line(positions_to_unwrap)=...
            doppler_line(positions_to_unwrap)-transition_sign*2*pi;
        i=i+position_second_transition-1;
    end
    i=i+1;
    if i>=numel(doppler_line)
        reached_end=0;
    end
end