%% LABORATORUM SA
% �WICZENIE C3 - Wsadowe metody identyfikacji parametrycznej
% ZADANIE 2.2

%---- � MIEJSCE NA NOTATKI
% 
%%
close all; clc; clear all

%% Parametry pr�bkowania
% Dost�pne w pliku PDF.
tend = 100;
Tp = 0.05;
t = 0 :Tp: tend;
N = size(t,2);

%% ZADANIE 2.2a
%---- � Wykorzystuj�c plik IdentWsadowaDyn.mat oraz dane pomiarowe zapisane 
%----   w macierzy DaneDynC przeprowadzi� identyfikacj� parametryczn� dla modelu (18) 
%----   metod� IV (zastosowa� wz�r (14)) dla danych ze zbioru Zest. W tym celu utworzy�
%----   wektor zmiennych instrumentalnych z(n) a nast�pnie macierz Z � do uzyskania
%----   zmiennych instrumentalnych wykorzysta� metod� wg wzor�w (16)-(17).

load IdentWsadowaDyn.mat;

uEst = DaneDynC(1:1000, 1);
yEst = DaneDynC(1:1000, 2);
NEst = numel(uEst);
tEst = t(1:NEst);

uVal = DaneDynC(1001:end, 1);
yVal = DaneDynC(1001:end, 2);
NVal = numel(uVal);
tVal = t(NVal:end);

u = DaneDynC(1:end, 1);
y = DaneDynC(1:end, 2);
N = numel(u);

% Wyznaczenie n realizacji regresji liniowej dla {u_est(n), y_est(n)} (11)
Phi = zeros(NEst, 2);
for i=2 : NEst
    Phi(i,:) = [yEst(i-1) uEst(i-1)];
end

% Wyznaczam wektor parametr�w uzyskanych metod� LS na podstawie wzoru (10)
phatLS = pinv(Phi) * yEst;

% Wyznaczam wektor x wed�ug r�wnania (16)
%----   W gruncie rzeczy wyznaczenie x jest identyczne jak odpowied� modelu
%       symulowanego ym.
x(1) = 0;
for i=2 : NEst
    x(i) = phatLS(1)*x(i-1) + phatLS(2)*u(i-1);
end

% Wyznaczenie macierzy zmiennych instrumentalnych Z
Z = zeros(NEst, 2);
for i=2 : NEst
    Z(i, 1:end) = [x(i-1) uEst(i-1)];
end

% Wyznaczam wektor parametr�w uzyskanych metod� IV na podstawie wzoru (14)
phatIV = pinv(Z'*Phi)*Z'*yEst;

%% ZADANIE 2.2b
%---- � Na podstawie oszacowanego wektora p?IV N wyznaczy� estymaty parametr�w k? oraz
%----   T? modelu czasu ci�g�ego.

% Wyznaczam warto�� estymaty k^ oraz T^ przekszta�caj�c wz�r na p2 oraz p1
ThatIV = -Tp / log(phatIV(1));
khatIV = phatIV(2) / (1-exp(-Tp/ThatIV));

%% ZADANIE 2.2c
%---- � Zilustrowa� na wsp�lnym wykresie (w dziedzinie czasu) odpowied� zmierzon� y(n)
%----   ze zbioru Zval oraz odpowied� zidentyfikowanego modelu symulowanego ym(n)
%----   na wymuszenie u(n) wzi�te z danych weryfikuj�cych Zval. Ilo�ciowo oceni� jako��
%----   identyfikacji obliczaj�c warto�� wska�nika (19) dla p? = p?IV N .

% Wyznaczam odpowied� predyktora jednokrokowego na podstawie wzoru (18) 
% oraz zidentyfikowanych parametr�w phatLS dla danych waliduj�cych Zval
%----   Wyznaczanie predyktora jednokrokowego dla modelu dyskretnego na
%       podstawie wyznaczonego wzoru (2) z dokumentu .DOCX (yhat) jest lepsze na
%       podstawie otrzymanego wzoru, poniewa� mo�na w�wczas zmienia� pakiet
%       danych wej�ciowych, dla kt�rego wyznaczona jest odpowied�.
for i=2 : NVal
    yhatIV(i, :) = phatIV(1)*yVal(i-1) + phatIV(2)*uVal(i-1);
    yhatLS(i, :) = phatLS(1)*yVal(i-1) + phatLS(2)*uVal(i-1);
end

% Wyznaczenie odpowiedzi zindentyfikowanego modelu symulowanego ym(n)
Gm = tf([khatIV], [ThatIV 1]);
ym = lsim(Gm, uVal, tVal);

% Wyznaczenie y0 (y bez zak��ce�) - wersja transmitancyjna
%----   Jest to wykres idealnego modelu, kt�rego nie mo�na uzyskac w
%       praktyce. Dost�pny jest dla nas tylko dlatego, �e prof. udost�pni�
%       dane, kt�re wykorzysta� do tworzenia zbioru danych (k0, T0).
                                        %----   ALTERNATYWA dla y0 - wersja dyskretna
k0 = 2;                                 % p = [exp(Tp/T0) k0*(1-exp(Tp/T0))];
T0 = 0.5;                               % for i=2 : N
G = tf([k0], [T0 1]);                   % y0(i-1) = p(1)*y(i-1) + p(2)*u(i-1);
y0 = lsim(G, uVal, tVal);             % end

% Wyznaczenie wska�nika (19)
E = yEst' - yhatIV;              % b��d r�wnania
V = (1/NEst) * sum(E.^2);   

%% SEKCJA WYKRES�W
% Wykres odpowiedzi modelu obiektu dynamicznego (y^IV)
figure(1);
plot(tVal, yhatIV);

% Wykres odpowiedzi modelu obiektu dynamicznego (y^LS)
hold on;
plot(tVal, yhatLS);

% Wykres odpowiedzi modelu symulowanego (ym)
hold on;
plot(tVal, ym);

% Wykres odpowiedzi na podstawie zmiennych waliduj�cych Zval (zak��conych szumem, z konsultacji - y)
hold on;
plot(tVal, yVal);

% Wykres odpowiedzi bez zak��ce� y0
hold on;
plot(tVal, y0, '--');

% Opis wykresu
grid on;
xlabel('u');
ylabel('y');
title({
    ['POR�WNANIE ODPOWIEDZI OBIEKTU I MODELU NA WYMUSZENIE {\itu(n)}']
    });
legend('{\ity_{hatIV}}','{\ity_{hatLS}}','{\ity_m}','{\ity}','{\ity_0}');