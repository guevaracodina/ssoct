%myifft.m
% [result] = myifft(data)
function [result]   = myifft(data)
len                 = length(data);
re                  = real(data);
im                  = imag(data);
im1                 = -1/len * re;
re1                 = 1/len * im;
y2                  = fft(re1+1i*im1);
im2                 = imag(y2);
re2                 = real(y2);
re3                 = -im2;
im3                 = re2;
xnew                = re3+1i*im3;
xx(1)               = xnew(1);
for iData = 2:len
    xx(iData)       = xnew(len-iData+2); %--->swap order of address outputs
end;
result              = xx;
end

% ==============================================================================
% [EOF]
