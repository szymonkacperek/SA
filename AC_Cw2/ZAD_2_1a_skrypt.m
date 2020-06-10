%% LABORATORUM SA
% �WICZENIE C2 - Nieparametryczne metody identyfikacji
% ZADANIE 2.1a

% Program nale�y uruchomi� z wyczyszczonym Workspace, nastepnie uruchomi�
% model BlackBoxG, po czym zn�w uruchomi� program. Po ka�dorazowym
% uruchomieniu nale�y wyczy�ci� Workspace i post�powa� analogicznie.
% Ewentualnie, zmieni� okres pr�bkowania na inn� warto�� oraz zapisa� w
% folderze projektu. Aktualnie (19/04/2020) Tp = 0.2

%%
close all; clc;

%% Parametry pr�bkowania
tend = 30;
Tp = 0.2;
t = 0 :Tp: (tend-Tp);
N = size(t,2);

%% ZADANIE 2.1a
%---- � Wykorzystuj�c plik BlackBoxG.mdl zawieraj�cy blok dynamiki identyfikowanego
%----   procesu utworzy� schemat blokowy pozwalaj�cy na pobudzenie obiektu szumem
%----   bia�ym o wariancji ?u2 = 0.5 i akwizycj� danych pomiarowych do przestrzeni roboczej Matlaba;
%----   nale�y pami�ta� o odpowiednim umiejscowieniu blok�w pr�bkuj�copami�taj�cych 
%----   Zero-Order Hold (okres pr�bkowania r�wny Tp). Uwaga: przed
%----   uruchomieniem schematu nale�y zainicjowa� warto�ci zmiennych Tp oraz sigma2v,
%----   przy czym pierwsza z nich oznacza okres pr�bkowania, a druga wariancj� zak��cenia v(n).

% ZADANIE 2.1c
%---- � Sprawdzi� wp�yw warto�ci okresu pr�bkowania Tp na jako�� identyfikacji � przyj��
%----   warto�ci z nast�puj�cego zbioru: Tp ? {1.0; 0.5; 0.2} s. Uwaga: liczb� pr�bek M
%----   nale�y dobra� dla ka�dej warto�ci Tp.

% ZADANIE 2.1d
%---- � Sprawdzi� wp�yw warto�ci wariancji zak��cenia pomiarowego v(n) na 
%----   jako�� identyfikacji � przyj�� warto�ci zmiennej sigma2v ze zbioru: {0.0; 0.001; 0.01}

% load Signal_U_Y.mat;
% load Signal_V.mat;
sigma2v = 0.001;
sigma2u = 0.5;
u = Signal(:, 1);
y = Signal(:, 2);
R_u = zeros(N, N);
R_u_alt = zeros(2*N, 2*N);

%% ZADANIE 2.1b
%---- � Stosuj�c wzory (11) przeprowadzi� eksperyment identyfikacji obci�tej odpowiedzi impulsowej 
%----   metod� analizy korelacyjnej (funkcja pseudoinwersji w Matlabie:
%----   pinv()) � przyj�� wst�pnie M = 30 dla Tp = 1. Wyznaczy� przybli�on� odpowied� 
%----   skokow� obiektu stosuj�c zale�no�� (12). Na podstawie uzyskanych odpowiedzi czasowych 
%----   oszacowa� struktur� modelu oraz przybli�one warto�ci parametr�w
%----   charakterystycznych identyfikowanej dynamiki. Uwaga: do oblicze� mo�na wykorzysta� funkcj� Covar(D,tau).

% Wyznaczenie wektora funkcji autokorelacji sygna�u u ^r_u
for j=0 : N-1
    r_u(j+1) = Covar([u u], j);
end

% Wyznaczenie macierzy autokorelacji sygna�u u ^R_u
for j=0 : N-1
    R_u((j+1), (j+1):end) = r_u(1:N-j);
    R_u((j+1):end, (j+1)) = r_u(1:N-j);        
end

% Wyznaczenie wektora korelacji wzajemnej sygna�u y oraz u
for j=0 : N-1
    r_yu(j+1) = Covar([y u], j);
end

r_yu = r_yu';   % konwersja na wektor pionowy

%% Wyznaczenie M pr�bek odpowiedzi impulsowej gM_alt r�wnaniem (9)
for j=0 : 2*N-1
    r_u_alt(j+1) = Covar([u u], j);
end
for j=0 : 2*N-1
    R_u_alt((j+1), (j+1):end) = r_u_alt(1:2*N-j);
    R_u_alt((j+1):end, (j+1)) = r_u_alt(1:2*N-j);        
end
for j=0 : 2*N-1
    r_yu_alt(j+1) = Covar([y u], j);
end

r_yu_alt = r_yu_alt';   % konwersja na wektor pionowy
% gM_9 = (pinv(R_u_alt) * r_yu_alt) .* (1/Tp);

for i=N : numel(gM_9)
    gM_9(i) = 0;
end

%% Wyznaczenie M pr�bek odpowiedzi impulsowej gM r�wnaniem (10)
gM_10 = (r_yu ./ sigma2u) .*(1/Tp);

%% Wyznaczenie M pr�bek odpowiedzi skokowej hM
% R�wnaniem (9)
for j=1 : N-1
    hM_9(j) = Tp .* sum(gM_9(1:j));
end

% R�wnaniem (10)
for j=1 : N-1
    hM_10(j) = Tp .* sum(gM_10(1:j));
end

%% Transmitancja G - z modelu BlackBoxG
num = [0.5];
den = [5 11 7 1];
G = tf([num], [den]);

%% WYNIKI - wykresy
% Odpowiedzi impulsowe modelu
figure(1);
plot(t, gM_9(1:numel(t)), 'r');
hold on;
plot(t, gM_10);
hold on;
impulse(G, 'm');
% Opis wykresu
grid on;
xlabel('czas t [s]');
ylabel('amplituda');
title({
    ['ODPOWIED� IMPULSOWA MODELU'] 
    });
legend('{\itr�wnanie (9)}','{\itr�wnanie (10)}','{\ittransmitancja}');

% Odpowiedzi skokowe modelu
figure(2);
plot(t(2:end), hM_9);
hold on;
plot(t(2:end), hM_10, 'r');
hold on;
step(G, 'm');
% Opis wykresu
grid on;
xlabel('czas t [s]');
ylabel('amplituda');
title({
    ['ODPOWIED� SKOKOWA MODELU'] 
    });
legend('{\itr�wnanie (9)}','{\itr�wnanie (10)}','{\ittransmitancja}');

% Sygna�y wej�ciowe
figure(3);
plot(t, u);
hold on;
plot(t, y, 'r');
% Opis wykresu
grid on;
xlabel('czas t [s]');
ylabel('amplituda');
title({
    ['SYGNA� WEJ�CIOWY I WYJSCIOWY'] 
    });
legend('{\itu(t)}','{\ity(t)}');
