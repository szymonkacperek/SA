%% LABORATORUM SA
% �WICZENIE C1 - Analiza sygna��w deterministycznych i losowych w dziedzinie czasu i cz�stotliwo�ci
% ZADANIE 2.1a
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

%% ZADANIE 2.1a
%---- � Przyjmuj�c Tp = 0.001 s oraz N = 1000 obliczy� i wykre�li� widmo amplitudowe
%----   |XN(?k)| sygna�u x(nTp) oraz jego periodogram. Zinterpretowa� uzyskane wyniki.
%----   Sprawdzi� twierdzenie Parsevala.
%----   Uwaga: do oblicze� mo�+na wykorzysta� funkcj� fft() Matlaba, kt�ra realizuje
%----   szybk� wersj� transformaty DFT z r�wnania (12).

%% 
select = x;

% Parametry wykresu
dO = 2*pi/N;
Omega = 0:dO:(pi-dO);
omega = Omega./Tp;

% Transformata Fouriera sygna��w
fft_select = fft(select, N);
abs_fft_select = abs(fft_select);
widmo_amp_select = 2*abs_fft_select./N;

% Periodogram (widmo mocy sygna�u)
conj_fft_select = conj(fft_select);
pSelect = fft_select.*conj(fft_select)./N;

% Sprawdzenie twierdzenia Parsevala
parseval_pSelect = sum(pSelect);
parseval_Select = sum(select.*select);

%% WYNIKI
% x
figure(1);
% subplot(311);
plot(t, select, 'g');
grid on;
xlabel('czas t [s]');
ylabel('np. napi�cie [V]');
title("Sygna� {\itx(n)}");
legend('{\itx(n)}');

figure(2);
% subplot(312);
stem(omega, widmo_amp_select(1:floor(N/2)), 'r');
grid on;
xlabel('pulsacje \omega_k [rad/s]');
ylabel('pr��ki [-]');
title("Widmo amplitudowe sygna�u {\itx(n)}");
legend('{\itx(n)}');

figure(3);
% subplot(313);
stem(omega, pSelect(1:floor(N/2)), 'b');
grid on;
xlabel('pulsacje \omega_k [rad/s]');
ylabel('pr��ki [-]');
title("Periodogram sygna�u {\itx(n)}");
legend('{\itx(n)}');