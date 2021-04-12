%% LABORATORUM SA
% �WICZENIE C4 - Rekursywne metody identyfikacji parametrycznej dla system�w SISO/MISO
% ZADANIE 1.1e, 1.2c
% Plik rysuj�cy wykresy macierzy kowariancji P={LS, IV}
close all; clc
%---- � MIEJSCE NA NOTATKI
% 
%% ZADANIE 1.1e
%---- �  Sprawdzi� przebieg �ladu macierzy P (n) podczas identyfikacji (funkcja trace(P)).
figure(1);
plot(t, tracePLS(1:end-1));

%% ZADANIE 1.2c
%---- �  Sprawdzi� przebieg �ladu macierzy P (n) podczas identyfikacji (funkcja trace(P)).
hold on;
plot(t, tracePIV(1:end-1),'--');
grid on;
title({
    ['Por�wnanie macierzy kowariancji {\itP} dla metod {\itRLS} oraz {\itRIV}']
    });
legend('{\itP^{LS}}','{\itP^{IV}}');
