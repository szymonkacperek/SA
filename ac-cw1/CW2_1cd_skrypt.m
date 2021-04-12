%% LABORATORUM SA
% �WICZENIE C1 - Analiza sygna��w deterministycznych i losowych w dziedzinie czasu i cz�stotliwo�ci
% ZADANIE 2.1c, 2.1d
%%
close all; clear all; clc;

%% PARAMETRY PR�BKOWANIA
tend = 1;   % w�wczas N = 1000
Tp = 0.001;
t = 0 :Tp: (tend-Tp);
N = size(t,2);

%% DEFINICJE ANALIZOWANYCH SYGNA��W
Ve = 0.25;
Gf = tf([0.1], [1 -0.9], Tp);       
x = sin(2*pi*5*t) + 0.5*sin(2*pi*10*t) + 0.25*sin(2*pi*30*t);
e = sqrt(Ve)*randn(1,N);
v_primary = lsim(Gf,e,t);   
v = v_primary';

%% ZADANIE 2.1c
%---- � Przyjmuj�c N = 1000 obliczy� i wykre�li� g�sto�� widmow� mocy sygna�u e(n).
%----   Zinterpretowa� uzyskane wyniki pami�taj�c, �e sygna� e(n) jest szumem bia�ym.
%----   Sprawdzi� jaki wp�yw ma warto�� variancji ?2 szumu na g�sto�� widmow� mocy.

%% ZADANIE 2.1d
%---- � Przyjmuj�c N = 1000 obliczy� i wykre�li� g�sto�� widmow� mocy sygna�u v(n).
%----   Zinterpretowa� uzyskane wyniki wiedz�c, �e sygna� v(n) jest filtrowanym szumem
%----   bia�ym (czyli szumem kolorowym).


% Wyb�r sygna�u do analizy
selectedSignal = x;

% Funkcja autokorelacji
i = -(N-1):N-1;
for i=0 : numel(i)
    estymator_FA_selectedSignal(i+1) = Covar([selectedSignal' selectedSignal'], i);
end

% Parametry wykresu
m1 = N/5;
tc = estymator_FA_selectedSignal(m1 : (N-m1));
Ntc = size(tc, 2);
dO1 = 2*pi/Ntc;
Omega = 0:dO1:(pi-dO1);
omega = Omega./Tp;

% Wyznaczenie g�sto�ci widmowej mocy
fft_estymator_FA_selectedSignal = fft(estymator_FA_selectedSignal, Ntc);
abs_fft_estymator_FA_selectedSignal = abs(fft_estymator_FA_selectedSignal);

%% WYNIKI
% x
figure(1);
% subplot(311);
plot(t, selectedSignal, 'g');
grid on;
xlabel('czas t [s]');
ylabel('np. napi�cie [V]');
title("Sygna� {\itx(n)}");
legend('{\itx(n)}');

figure(2);
% subplot(312);
stem(omega, abs_fft_estymator_FA_selectedSignal(1:floor(0.5*Ntc)), 'm');
grid on;
xlabel('pulsacje \omega_k [rad/s]');
ylabel('moc sygna�u [-]');
title("G�sto�� widmowa mocy sygna�u");
legend('{\itx(n)}');