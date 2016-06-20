function [position_um]=voltage2um(voltage,f1,f2,f_obj)
% This function will take a voltage galvo control and transform it into a
% position in um

% voltage is in Volts
% f1 is the focal length of lens 1 in mm
% f2 is the focal length of lens 2 in mm
% f_obj is the focal length of the objective in mm

position_um=voltage*2*pi/180*f1*f_obj/f2*1000;