%%  LABORATORIUM SA
%   �WICZENIE AcEx4 - Model-Identification Adaptive Control (MIAC)
%   Identyfikacja parametr�w metod� RLS

%---- � NOTATKI
% 
%%
function [p] = SA_ACex4_RLS(in)
global p_hat
global P
global cov
global k
global T_reset
global ro

% Definicja sygna��w wej�ciowych
yp=in(1);
y=in(2);
u=in(3);

phi = [-yp u]';
[p_hat, P, epsilon] = RLS(phi, y, p_hat, P);

cov = trace(P);

p = [p_hat];

end