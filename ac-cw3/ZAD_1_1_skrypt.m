%% LABORATORUM SA
% �WICZENIE C3 - Wsadowe metody identyfikacji parametrycznej
% ZADANIE 1.1a, b, c, d

%%
close all; clc; clear all;

%% Parametry pr�bkowania
tend = 100;
Tp = 0.05;
t = 0 :Tp: (tend-Tp);
N = size(t,2);
%% ZADANIE 1.1a
%---- � Plik IdentWsadowaStat.mat zawiera dwa zbiory danych pomiarowych (pary
%----   (u, y)) zebrane z obiektu statycznego i zapisane w macierzach DaneStatW,
%----   DaneStatC, przy czym pierwsza z nich zawiera pomiary zak��cone szumem bia�ym,
%----   a druga � szumem kolorowym. Wprowadzi� dane do przestrzeni roboczej Matlaba
%----   instrukcj� load IdentWsadowaStat.mat.

% ZADANIE 1.1d
%---- � Sprawdzi� wp�yw ilo�ci danych pomiarowych na jako�� identyfikacji (wybra� do
%----   oblicze� podzbi�r dost�pnych danych).

load IdentWsadowaStat.mat;
u = DaneStatW(1:end, 1);
y = DaneStatW(1:end, 2);
N = numel(u);

%% ZADANIE 1.1b
%---- � Przyjmuj�c nast�puj�c� struktur� modelu statycznego (model GrayBox):
%----   (6) przeprowadzi� identyfikacj� parametryczn� stosuj�c wz�r (3). Obliczenia wykona�
%----   niezale�nie dla przypadku zak��cenia szumem bia�ym i kolorowym.

% Wyznaczenie n realizacji regresji liniowej dla {u(n), y(n)}
fi_n = zeros(numel(u), 4);
for i=1 : numel(u)
    fi_n(i, 1:end) = [1 1/u(i) 1/u(i)^2  1/u(i)^3];
end

% Obliczenie estymatora LS identyfikacji parametrycznej
phatLS = pinv(fi_n) * y;

% Obliczenie zidentyfikowanej funkcji
for i=1 : numel(u)
    y_hat(i) = phatLS(1) + phatLS(2)/u(i) + phatLS(3)/u(i)^2 + phatLS(4)/u(i)^3;
end

% Alternatywne wyznaczenie zidentyfikowanej funkcji
yhat2 = fi_n*phatLS;
yhatPor = [y_hat' yhat2];   % por�wnanie warto�ci - s� takie same

%% ZADANIE 1.1e
%----� Oszacowa� macierz kowariancji (5) (tylko dla danych z zak��ceniem bia�ym) i okre-
%----  �li� na jej podstawie przedzia�y ufno�ci dla poszczeg�lnych estymat parametr�w
%----  (patrz Uwaga 1 na str. 6).

% Wyznaczenie b��du r�wnania
E = y' - y_hat;

% Wyznaczenie estymaty wariancji zak��cenia
sigma_hat2 = (1/(N-numel(phatLS)))*sum(E.^2);

% Wyznaczenie macierzy kowariancji
P_N =  sigma_hat2*inv((fi_n'*fi_n));
P_N_diag = diag(P_N);

% Wyznaczenie przedzia��w ufno�ci dla poszczeg�lnych estymat
PU95_p = zeros(numel(phatLS), 2);
for i=1 : numel(phatLS)
    PU95_p(i, 1:end) = [phatLS(i)-1.96*sqrt(P_N_diag(i)) phatLS(i)+1.96*sqrt(P_N_diag(i))];
end

%% WYNIKI
% ZADANIE 1.1c
%---- � Wykre�li� na wsp�lnym wykresie dane pomiarowe oraz zidentyfikowan� funkcj�
%----   (6) dla p = p?LS N . Oceni� jako�� identyfikacji.

% Obiekt statyczny
plot(u, y, 'or');
% Model parametryczny obiektu statycznego
hold on;
plot(u, y_hat, 'b');
% Opis wykresu
grid on;
xlabel('u');
ylabel('y');
title({
    ['ZALE�NO�� STATYCZNA']
    });
legend('{\itObiekt}','{\itModel}');