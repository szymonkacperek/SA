%% LABORATORIUM SA
% �WICZENIE AcEx4 - Model-Identification Adaptive Control (MIAC)

% ZADANIE 3.1
clear all; close all; clc

%---- � NOTATKI
% 
%% 1    PARAMETRY
%  1.1  RSG
Yr = 0.15;           % amplituda [rad/s]
omega_r = 0.25;     % pulsacja [rad/s]

%  1.2  WARUNKI SYMULACJI
global Ta Tc TF p_hat P lambda alfa
% Sampling interval of the adaptation loop Ta
Ta = 0.005;

% Sampling interval of conventional loop Tc
Tc = 0.001;

% Variance of stochastic noise sigma2e
sigma2e = 0.00;

% Sta�a czasowa u�yta dla filtr�w SVF (bloki Transfer Fcn)
TF = 1.5*Ta;

%  1.3   BLOK RLS
p_hat = [1; 1];
alfa = 3.0;         % czas ustalania (?) [s]
lambda = 0.999;     % Wsp�czynnik zapominania
ro = 0.1;
P = ro*eye(2);
