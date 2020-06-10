%% LABORATORUM SA
% �WICZENIE C2 - Nieparametryczne metody identyfikacji
% ZADANIE 1.1a, 1.1b
%%
close all; clear all; clc;

%% ZADANIE 1.1a
%---- � W pliku ProcessStepResponse.mat zapisano zbi�r chwil czasu oraz odpowiadaj�cy 
%----   im zbi�r pr�bek odpowiedzi skokowej pewnego obiektu dynamicznego (pobudzano skokiem jednostkowym). 
%----   Dane zapisano w postaci dwukolumnowej macierzy
%----   S, kt�rej pierwsza kolumna odpowiada wektorowi chwil czasu wyra�onych w sekundach, a druga 
%----   wektorowi pr�bek zarejestrowanej odpowiedzi skokowej obiektu.

%% ZADANIE 1.1b
%---- � Za�adowa� zarejestrowane dane do przestrzeni roboczej Matlaba. 
%----   Wykre�li� odpowied� skokow� obiektu. Na podstawie odpowiedzi skokowej oszacowa� wzmocnienie
%----   statyczne obiektu. Stosuj�c warto�ci zawarte w tablicy 1 oszacowa� rz�d dynamiki
%----   oraz parametry zast�pcze modelu Gm1(s). Por�wna� odpowied� skokow� i impulsow� obiektu oraz modelu Gm1(s).

% wczytanie danych
load ProcessStepResponse.mat;
t = S(1:end, 1);
ans = S(1:end, 2);

%% Wyznaczenie wzmocnienia statycznego
% na podstawie danych z kursora
Au = 1;               % amplituda wymuszenia skokowego = 1
yUst = max(ans);      % czas wyst�pienia amplitudy

% wzmocnienie statyczne
K = yUst / Au;

%% Wyznaczenie rz�du dynamiki obiektu
% na podstawie danych z kursora, tabeli 1.
T50 = 11.5;
T90 = 22.8;

% zast�pcza sta�a czasowa T
T = T90 / 5.32;

% rz�d dynamiki obiektu - dobrano z tabeli
p = 3;          

%% Wyznaczenie odpowiedzi skokowej modelu Gm1
s = tf('s');
num = K;
den = (T*s+1)^p;
Gm1 = tf(num/den);

%% Wyznaczenie odpowiedzi impulsowej modelu Gm1
% Wyznaczenie pochodnej odpowiedzi skokowej
Tp = t(2)-t(1);
dans = diff(ans)./Tp;

%% WYNIKI - Odpowiedzi skokowe
% Odpowied� skokowa obiektu
figure(1);
plot(t, ans, 'm');

% Odpowied� skokowa modelu
hold on;
step(Gm1);

% Opis wykresu
grid on;
xlabel('czas t [s]');
ylabel('odpowied� uk�adu [-]');
title({
    ['ODPOWIED� UK�ADU NA WYMUSZENIE SKOKOWE'                        ] 
    ['K = ' num2str(K), ', T90/T50 = ' num2str(T90/T50) ', p = ' num2str(p)  ', T = ' num2str(T)  ]
    });
legend('{\itobiekt}','{\itmodel}');

%% Odpowiedzi impulsowe
% Odpowied� impulsowa obiektu
figure(2);
plot(t(2:end), dans, 'r');

% Odpowied� impulsowa modelu
hold on;
impulse(Gm1);

% Opis wykresu
grid on;
xlabel('czas t [s]');
ylabel('odpowied� uk�adu [-]');
title('ODPOWIED� UK�ADU NA WYMUSZENIE IMPULSOWE'); 
legend('{\itobiekt}','{\itmodel}');
