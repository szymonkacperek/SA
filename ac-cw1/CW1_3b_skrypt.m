%% LABORATORUM SA
% �WICZENIE C1 - Analiza sygna��w deterministycznych i losowych w dziedzinie czasu i cz�stotliwo�ci
% ZADANIE 1.3b
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

%% ZADANIE 1.3b
%---- � Korzystaj�c z w�asno�ci W1 (symetria wzgl�dem przesuni�cia zerowego) dla
%----   wszystkich sygna��w wykre�li� (na oddzielnych wykresach) przebieg estymaty
%----   funkcji autokorelacji dla i E [-(N - 1), N - 1]. Zinterpretowa� uzyskane wyniki i
%----   sprawdzi� w�asno�ci W1-W3 funkcji autokorelacji.

i=-N:N;
n=numel(i);
estymator_e=zeros(1,n);

for j=1 :1: numel(i)
    estymator_e(j) = Covar([e' e'] , j-1000);
    estymator_x(j) = Covar([x' x'] , j-1000);
    estymator_y(j) = Covar([y' y'] , j-1000);    
    estymator_v(j) = Covar([v v] , j-1000);
end

% e
figure(1);
subplot(411);
plot(i, estymator_e, 'r');
grid on;
xlabel('i [-]');
ylabel('e');
title("Wykres estymatora autokorelacji dla i \in  <-"+ N + ";" + N +">");
legend('e');

% x
subplot(412);
plot(i, estymator_x, '--r');
grid on;
xlabel('i [-]');
ylabel('e');
title("Wykres estymatora autokorelacji dla i \in  <-"+ N + ";" + N +">");
legend('x');

% y
subplot(413);
plot(i, estymator_y, '--r');
grid on;
xlabel('i [-]');
ylabel('e');
title("Wykres estymatora autokorelacji dla i \in  <-"+ N + ";" + N +">");
legend('y');

% v
subplot(414);
plot(i, estymator_v, '-r');
grid on;
xlabel('i [-]');
ylabel('e');
title("Wykres estymatora autokorelacji dla i \in  <-"+ N + ";" + N +">");
legend('v');