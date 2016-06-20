function winOut = myhann(N)
% Returns the N-point, wider version of the symmetric Hann window in a column vector.
% SYNTAX:
% winOut = myhann(N,percent)
% INPUTS:
% N         
% OUTPUTS: 
% winOut    Window in a column vector form
% 
%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara
% 2011/12/16

% Percent size of the original hann window (default = 200%)
percent = 200;
% Optionally plot outputs
plotOutput = false;

% Check odd/even length
if rem(N,2)
    % window of odd length
    newN = round(percent/100)*N-1;
else
    % window of even length
    newN = round(percent/100)*N;
end
% Enlarged hann window
win = hann(newN);
% Central portion of this enlarged window
winOut = win(newN/2+1 - N/2 : newN/2 + N/2);

% ------------------------- Plot Outputs ---------------------------------------
if plotOutput
    figure; 
    subplot(131);   plot(win);        title('Enlarged window')
    subplot(132);   plot(hann(N));    title('regular window')
    subplot(133);   plot(winOut);     title('output window')
end
% ==============================================================================
% [EOF]
