%% LABORATORUM SA
% �WICZENIE C1 - Analiza sygna��w deterministycznych i losowych w dziedzinie czasu i cz�stotliwo�ci
% ZADANIE 1.3c
%%
close all; clear all; clc;

%% Parametry pr�bkowania
tend = 1;
Tp = 0.001;
t = 0 :Tp: (tend-Tp);
N = size(t,2);

%% DEFINICJE ANALIZOWANYCH SYGNALOW
Ve = 0.25;                          % wariancja szumu bialego
e = sqrt(Ve)*randn(1,N);            % Szum bia�y e(nTp). randn(1,N) to macierz 1xN o losowych wspolrzednych (rozklad normalny)
Gf = tf([0.1], [1 -0.9], Tp);       % Transmitancja H
x = sin(2*pi*5*t);                  % x(nTp)
y = sin(2*pi*5*t) + e;              % y(nTp)
v = lsim(Gf,e,t);                   % v(nTp) - odpowiedz transmitancji H na wymuszenie skokowe
% z = sin(2*pi*5*t) + 0.5*sin(2*pi*10*t) + 0.25*sin(2*pi*30*t);   % ??

%% ZADANIE 1.3c
%---- � Sprawdzi� przebieg funkcji autokorelacji sygna�u v(n) i por�wna� go z przebiegiem
%----   uzyskanym dla szumu bia�ego e(n).

for i=0 : N-1
    estymator_e(i+1) = Covar([e' e'], i);
    estymator_v(i+1) = Covar([v v], i);
end

% e,v
figure(1);
plot(estymator_e, 'r');
hold on;
plot(estymator_v, 'b');
grid on;
xlabel('i');
ylabel('e');
title('Przebieg funkcji autokorelacji sygna�u {\ite(n)} oraz {\itv(n)}');
legend('e(n)','v(n)');