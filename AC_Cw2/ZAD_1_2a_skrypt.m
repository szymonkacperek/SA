%% LABORATORUM SA
% �WICZENIE C2 - Nieparametryczne metody identyfikacji
% ZADANIE 1.2a

close all; clear all; clc;

%% ZADANIE 1.2a
%---- � Stosuj�c wzory (2)-(5) okre�li� aproksymacj� dynamiki obiektu modelem Gm2(s).
%----   Por�wna� odpowied� skokow� i impulsow� obiektu oraz modelu Gm2(s).

load ProcessStepResponse.mat;
t = S(1:end, 1);
ans = S(1:end, 2);

%% Wyznaczenie wzmocnienia statycznego
% na podstawie danych z kursora
Au = 1;               % amplituda wymuszenia skokowego = 1
yUst = max(ans);      % czas wyst�pienia amplitudy

% wzmocnienie statyczne
K = yUst / Au;

%% Wyznaczenie zast�pczej czasowej
% na podstawie danych z kursora, tabeli 1.
T50 = 11.5;
T90 = 22.8;

% zast�pcza sta�a czasowa T
T = T90 / 5.32;

%% Wyznaczenie prostej stycznej do odpowiedzi skokowej
% Wyznaczenie punktu przegi�cia - warto�ci Tg
% Wyznaczenie pochodnej odpowiedzi skokowej
Tp = t(2)-t(1);
dans = diff(ans)./Tp;
Ag = max(dans);
indeks = find(dans == Ag);
Tg = t(indeks);

% Okre�lenie sta�ych T i T0
Yg = ans(indeks);       % punkt przegi�cia
T0 = (Ag*Tg-Yg)/Ag;
T = (Au*K)/Ag;

%% Wyznaczenie transmitancji Gm2
s = tf('s');
Gm2 = (K*exp(-s*T0)) / (T*s+1);

%% WYNIKI
% Odpowied� skokowa obiektu
figure(1);
plot(t, ans, 'm');

% Odpowied� skokowa modelu
hold on;
step(Gm2); 

% Odpowied� impulsowa obiektu
hold on;
plot(t(2:end), dans, 'r');

% Odpowied� impulsowa modelu
hold on;
impulse(Gm2);

% Opis wykresu
grid on;
xlabel('czas t [s]');
ylabel('amplituda');
title({
    ['ODPOWIED� OBIEKTU'] 
    });
legend('{\itskokowa obiektu}','{\itskokowa modelu}','{\itimpulsowa obiektu}','{\itimpulsowa modelu}');