%% LABORATORUM SA
% �WICZENIE C1 - Analiza sygna��w deterministycznych i losowych w dziedzinie czasu i cz�stotliwo�ci
% ZADANIE 1.2

%%
clear all; close all; clc;

%% Parametry
load StochasticProcess.mat;

t = StochasticProcess(1,:);                 % pierwszy wiersz zawiera chwile czasu dyskretnego

%% ZADANIE 1.2a 
%---- � Wczyta� zbi�r danych z pliku StochasticProcess.mat i wykre�li� kilka wybranych 
%----   realizacji procesu losowego w funkcji czasu dyskretnego.

% % realizacja_1 = StochasticProcess(2,:);
% figure(1);
% subplot(2,2,1);
% plot(t, StochasticProcess(2,:));
% subplot(2,2,2);
% plot(t, StochasticProcess(3,:));
% subplot(2,2,[3 4]);
% plot(t, StochasticProcess(4,:), 'r', t, StochasticProcess(5,:), 'b');

%% ZADANIE 1.2b 
%---- � Obliczy� estymaty ? mi oraz ? ?i2 obliczone po realizacjach oraz estymaty ? m oraz ? ?2
%----   obliczone po czasie dla wszystkich dost�pnych realizacji procesu losowego

StochasticProcess([1], :) = [];     % usuni�cie pierwszego wiersza macierzy

estymata_mi = mean(StochasticProcess, 1);
estymata_m = mean(StochasticProcess, 2);


estymata_sig_i = var(StochasticProcess, 0, 1);    
estymata_sig = var(StochasticProcess, 0, 2);

%% ZADANIE 1.2c 
%---- � Przedstawi� na wsp�lnym wykresie ? mi i ? m oraz ? ?i2 i ? ?2. Por�wna� i zinterpretowa�
%----   otrzymane wyniki (nale�y pami�ta�, �e estymaty s� zmiennymi losowymi).

figure(1);
subplot(211);
plot(estymata_mi', 'or');
hold on;
plot(estymata_m, 'ob')
legend('estymata m_i','estymata m');
title('Por�wnanie estymat m oraz m_i');
grid on;

subplot(212);
plot(estymata_sig_i, 'ok');
hold on;
plot(estymata_sig, 'om');
legend('estymata \sigma_i','estymata \sigma');
title('Por�wnanie estymat \sigma_i oraz \sigma');
grid on;