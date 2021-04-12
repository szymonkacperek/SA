%% LABORATORUM SA
% �WICZENIE C3 - Wsadowe metody identyfikacji parametrycznej
% ZADANIE 2.1

%---- � MIEJSCE NA NOTATKI
% 22/04 Zadanie 2.1b. Jest szansa, �e �le obliczy�em yhat. Powinienem
%       wykorzysta� model w kt�rym sk�adnikiem sumy jest r�wnie� sygna�
%       stochastyczny v. W�wczas m�g�bym te� obliczy� ym w inny spos�b -
%       chyba bardziej poprawny.
% 23/04 Mam z�e estymowane parametry k^ i T^. p^ te�. powinny by�: phatLS(W)^=[0.9 0.19]
%       powinny by� dla bia�ego (?). sigma2 dla C = . dla ci�g�ego 0.94. 
% 23/04 k^ i T^ poprawione
%
%%
close all; clc; clear all

%% Parametry pr�bkowania
% Dost�pne w pliku PDF.
tend = 100;
Tp = 0.05;
t = 0 :Tp: tend;
N = size(t,2);

%% ZADANIE 2.1a
%---- � Dana jest nast�puj�ca struktura obiektu dynamicznego pierwszego rz�du i jego
%----   aproksymacja dyskretna gdzie k0 i T0 s� nieznanymi prawdziwymi parametrami obiektu, natomiast
%----   aproksymacj� dyskretn� G(z) wyznaczono metod� �zoh� (transformacja skokowoinwariantna). 
%----   Na podstawie powy�szej transmitancji mo�emy zapisa� model dyskretny obiektu 
%----   z u�yciem operatora q = q?1 w postaci: y(n) = G(q, p)u(n)+ v(n),
%----   gdzie v(n) reprezentuje zak��cenie losowe.

% Obliczenia dost�pne w pliku DOCX.

%% ZADANIE 2.1c
%---- � Plik IdentWsadowaDyn.mat zawiera zbiory danych pomiarowych (pary
%----   (u(n), y(n))) zapisane w dw�ch macierzach DaneDynW, DaneDynC, przy czym
%----   pierwsza z nich zawiera pomiary zak��cone szumem bia�ym, a druga � szumem
%----   kolorowym. Wprowadzi� dane do przestrzeni roboczej Matlaba istrukcj� load
%----   IdentWsadowaDyn.mat. Podzieli� dane pomiarowe na dwa zbiory (np. w proporcji 50% do 50%): 
%----   Zest stanowi�ce dane estymuj�ce (u�ywane do estymacji
%----   parametr�w) oraz Zval stanowi�ce dane weryfikuj�ce (u�ywane do weryfikacji modelu).

load IdentWsadowaDyn.mat;

u_est = DaneDynW(1:1000, 1);
y_est = DaneDynW(1:1000, 2);
N_est = numel(u_est);
t_est = t(1:N_est);

u_val = DaneDynW(1001:end, 1);
y_val = DaneDynW(1001:end, 2);
N_val = numel(u_val);
t_val = t(N_val:end);

u = DaneDynW(1:end, 1);
y = DaneDynW(1:end, 2);
N = numel(u);

%% ZADANIE 2.1b
%---- � Zapisa� model obiektu (18) w postaci regresji liniowej i wyznaczy� regresor oraz
%----   wektor parametr�w zast�pczych modelu dyskretnego.

% Wyznaczenie n realizacji regresji liniowej dla {u_est(n), y_est(n)}
Fi = zeros(N_est, 2);
for i=2 : N_est
    Fi(i, 1:end) = [y_est(i-1) u_est(i-1)];
end

%% ZADANIE 2.1d
%---- � Przyjmuj�c struktur� modelu ARX przeprowadzi� identyfikacj� parametryczn� dla
%----   modelu (18) stosuj�c wz�r (10) oraz zbi�r danych estymuj�cych Zest. Obliczenia
%----   wykona� niezale�nie dla przypadku zak��cenia szumem bia�ym i kolorowym.

% Identyfikacja parametr�w modelu (18) wzorem (10) za pomoc� danych Z_est
phatLS = pinv(Fi) * y_est;  

%% ZADANIE 2.1e
%---- � Na podstawie wektora p_LS N wyznaczy� estymaty k^ oraz T^

% Wyznaczam warto�� estymaty k^ oraz T^ przekszta�caj�c wz�r na p2 oraz p1
That = -Tp / log(phatLS(1));
khat = phatLS(2) / (1-exp(-Tp/That));

%% ZADANIE 2.1f
%---- � Zilustrowa� na wsp�lnym wykresie (w dziedzinie czasu) odpowied� zmierzon� y(n)
%----   ze zbioru Zval oraz odpowied� zidentyfikowanego modelu symulowanego ym(n) na
%----   wymuszenie u(n) wzi�te z danych weryfikuj�cych Zval. Oceni� ilo�ciowo jako��
%----   identyfikacji obliczaj�c wska�nik: (19)

% Wyznaczam odpowied� predyktora jednokrokowego na podstawie wzoru (18) 
% oraz zidentyfikowanych parametr�w phatLS dla danych waliduj�cych Zval
%----   Wyznaczanie predyktora jednokrokowego dla modelu dyskretnego na
%       podstawie wyznaczonego wzoru (2) z dokumentu .DOCX (yhat) jest lepsze na
%       podstawie otrzymanego wzoru, poniewa� mo�na w�wczas zmienia� pakiet
%       danych wej�ciowych, dla kt�rego wyznaczona jest odpowied�.
%----   Alternatywna metoda wyznaczenia predyktora jednokrokowego - na 
%       podstawie wzoru regresji liniowej r�nica wynika z danych dobranych 
%       do wyznaczenia fi_n: 
%       yhat = fi_n * phatLS;     
for i=2 : N_val
    yhat(i) = phatLS(1)*y_val(i-1) + phatLS(2)*u_val(i-1);
end
 
% Wyznaczenie zindentyfikowanego modelu symulowanego ym(n)
%----   Mo�na r�wnie� wykorzysta� wersj� transmitancyjn�:
%       Gm = tf([khat], [That 1]);
%       ym = lsim(Gm, u_val, t_val);
ym(1)=0;
for i=2 : N_val
    ym(i) = phatLS(1)*ym(i-1) + phatLS(2)*u_val(i-1);
end

% Wyznaczenie y0 (y bez zak��ce�) - wersja transmitancyjna
%----   Jest to wykres idealnego modelu, kt�rego nie mo�na uzyskac w
%       praktyce. Dost�pny jest dla nas tylko dlatego, �e prof. udost�pni�
%       dane, kt�re wykorzysta� do tworzenia zbioru danych (k0, T0).
                                        %----   ALTERNATYWA dla y0 - wersja dyskretna
k0 = 2;                                 % p = [exp(Tp/T0) k0*(1-exp(Tp/T0))];
T0 = 0.5;                               % for i=2 : N
G = tf([k0], [T0 1]);                   % y0(i-1) = p(1)*y(i-1) + p(2)*u(i-1);
y0 = lsim(G, u_val, t_val);             % end

% Wyznaczenie wska�nika (19)
E = y_val' - yhat;                      % b��d r�wnania
V = (1/N_val) * sum(E.^2);

%% SEKCJA WYKRES�W
% Wykres odpowiedzi modelu obiektu dynamicznego (y^)
figure(1);
plot(t_val, yhat);

% Wykres odpowiedzi modelu symulowanego (ym)
hold on;
plot(t_val, ym);

% Wykres odpowiedzi na podstawie zmiennych waliduj�cych Zval (zak��conych szumem, z konsultacji - y)
hold on;
plot(t_val, y_val);

% Wykres odpowiedzi bez zak��ce� y0
hold on;
plot(t_val, y0, '--');

% Opis wykresu
grid on;
xlabel('u');
ylabel('y');
title({
    ['POR�WNANIE ODPOWIEDZI OBIEKTU I MODELU NA WYMUSZENIE {\itu(n)}']
    });
legend('{\ity_{hat}}','{\ity_m}','{\ity}','{\ity_0}');

% Wykres wej�cia i wyj�cia
% figure(2);
% plot(t, y);

%% ZADANIE 2.1e
%---- � Dla przypadku danych z zak��ceniem bia�ym oszacowa� macierz kowariancji (12)
%----   oraz przedzia�y ufno�ci dla estymat p?LS N (patrz Uwaga 1 na str. 6)

% Wyznaczenie macierzy kowariancji P_N
sigma_hat2 = (1/(N_est-numel(phatLS))) * sum(E.^2);
P_N =  sigma_hat2*inv((Fi'*Fi));
P_N_diag = diag(P_N);

% Wyznaczenie przedzia��w ufno�ci dla poszczeg�lnych estymat
PU95_p = zeros(numel(phatLS), 2);
for i=1 : numel(phatLS)
    PU95_p(i, 1:end) = [phatLS(i)-1.96*sqrt(P_N_diag(i)/N_est) phatLS(i)+1.96*sqrt(P_N_diag(i)/N_est)];
end