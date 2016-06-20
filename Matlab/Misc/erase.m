function erase
% Clears workspace, closes windows, kills NIOS processes. 
% Use when connection is unexpectedly closed.
% SYNTAX:
% erase
% INPUTS:
% none
% OUTPUTS:
% none
%_______________________________________________________________________________
% Copyright (C) 2011 LIOM Laboratoire d'Imagerie Optique et Moléculaire
%                    École Polytechnique de Montréal
% Edgar Guevara
% 2011/10/05
fclose('all'); 
clear all; 
clear global; 
close all; 
[~,~] = system('taskkill /F /FI "IMAGENAME eq nios2-terminal.exe"'); 
[~,~] = system('taskkill /F /FI "IMAGENAME eq bash*"'); 
[~,~] = system('taskkill /F /FI "IMAGENAME eq quartus_pgm.exe"'); 
clc;
% ==============================================================================
% [EOF]
