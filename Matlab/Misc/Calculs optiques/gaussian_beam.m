function [w,R,q]=gaussian_beam(x,w_0,lambda)
w_squared=w_0^2*(1+(lambda*x/pi/w_0^2)^2);
w=sqrt(w_squared);

R=x*(1+(pi*w_0^2/lambda/x)^2);
q=1/(1/R-i*lambda/pi/w^2);