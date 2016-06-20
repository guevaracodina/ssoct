function [q_out,R,w]=propagate_gaussian(q_in,matrix,lambda)

%Tiré de http://www.newport.com/servicesupport/Tutorials/default.aspx?id=112

q_out=(q_in*matrix(1,1)+matrix(1,2))/(q_in*matrix(2,1)+matrix(2,2));
inv_q_out=1/q_out;

R=1/(real(inv_q_out));
w=sqrt(-1/imag(inv_q_out)/pi*lambda);