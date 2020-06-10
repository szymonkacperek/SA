%% LABORATORUM SA
% �WICZENIE C4 - Rekursywne metody identyfikacji parametrycznej dla system�w SISO/MISO
% ZADANIE 2.1

%---- � MIEJSCE NA NOTATKI
% 
%%
close all; clc;

%% ZADANIE 2.1a - PARAMETRY PR�BKOWANIA
%---- � Zainicjowa� nast�puj�ce zmienne globalne: Tp=0.1, Tend=1000, Td=1500, kt�re
%----   oznaczaj� (w sekundach), odpowiednio, okres pr�bkowania, horyzont czasowy
%----   symulacji oraz czas, po kt�rym nast�pi zmiana warto�ci parametru b20 (tutaj
%----   Tend<Td, wi�c zmiana nie nast�pi wcale � obiekt o sta�ych parametrach).
global Tp
Tend = 1000;
Tp = 0.1;
t = 0 :Tp: Tend;
N = size(t,2);
Td = 300;
c10 = 0;

%% ZADANIE 1.1c
%---- �  Zainicjowa� jako zmienn� globaln� warto�� parametru c10 = 0 (zak�adamy zak��-
%----   canie szumem bia�ym). Przeprowadzi� identyfikacj� parametryczn� toru dynamiki
%----   u ? y obiektu (14) metod� RLS przyjmuj�c jako wej�cie pobudzaj�ce u(n) sygna�
%----   prostok�tny (symetryczny wzgl�dem zera) o amplitudzie jednostkowej i cz�stotliwo�ci fu = 0.2 Hz. 
%----   Przeanalizowa� przebiegi estymat p?(n) dla r�nych warto�ci parametru ? przy wyborze pocz�tkowej 
%----   macierzy P (0) (patrz w2). Sprawdzi� wp�yw warto�ci okresu pr�bkowania na jako�� identyfikacji 
%----   � sugerowany zestaw warto�ci (w [s]): Tp e {0.01; 0.1; 0.5; 1.0; 2.0}.
fu = 0.2;
uAmp = 1;

%% ZADANIE 1.1d
%---- �  Zaimplementowa� blok modelu symulowanego oraz predyktora jednokrokowego korzystaj�cych 
%----   z aktualnych warto�ci estymat parametr�w. Sprawdzi� jako�� identyfikacji por�wnuj�c odpowied� 
%----   modelu symulowanego ym(n) z odpowiedzi� obiektu y(n) oraz z jego odpowiedzi� idealn� (bez szumu) 
%----   y0(n) na to samo wymuszenie u(n). Por�wna� tak�e odpowied� predyktora jednokrokowego ? y(n|n ? 1) z 
%----   odpowiedzi� y(n) obiektu na wymuszenie u(n).

% zobacz plik ZAD1_ObiektARMAX.slx

% Warunki pocz�tkowe
%----   Wsp�czynnik ro decyduje jak dynamicznie zmienia� si� b�d� warto�ci
%       estymaty phatLS. Je�li wst�pnie wiemy w jakich okolicach mo�na
%       przyj�� phatLS warto zostawi� ro ma�e, jednak�e przy zerowej wiedzy
%       a priori warto wybra� du�� liczb�.

global phatLS_1 PLS_1
phatLS_1 = [0; 0; 0];
roLS = 100;
PLS_1 = roLS * eye(3);

%% ZADANIE 1.1e
%---- �  Sprawdzi� przebieg �ladu macierzy P (n) podczas identyfikacji (funkcja trace(P)).
global tracePLS
tracePLS = [];

%% ZADANIE 1.2a
%---- � Zainicjowa� warto�� parametru c10 = 0.7 (zak�adamy zak��canie szumem kolorowym). 
%----   Przeprowadzi� identyfikacj� parametryczn� toru dynamiki u 7? y obiektu
%----   (14) stosuj�c metod� RIV ze zmiennymi instrumentalnymi obliczanymi zgodnie z
%----   definicj� (12)-(13).

global phatIV_1 PIV_1
phatIV_1 = [0; 0; 0];
roIV = 100;
PIV_1 = roIV * eye(3);

%% ZADANIE 1.2c
%---- � Sprawdzi� przebieg �ladu macierzy P (n) podczas identyfikacji (funkcja trace(P)).
global tracePIV
tracePIV = [];

%% ZADANIE 2.1b
%---- � Stosuj�c metod� RLS? przeprowadzi� identyfikacj� parametryczn� toru dynamiki
%----   u ? y obiektu (14) przyjmuj�c wsp�czynnik zapominania ? z zakresu [0.98; 0.999].
%----   Sprawdzi� wp�yw warto�ci wsp�czynnika ? ? (0, 1) na jako�� identyfikacji i fluktuacje 
%----   estymat parametr�w. Szczeg�ln� uwag� zwr�ci� na zdolno�� estymatora do �ledzenia zmian 
%----   parametru b20 obiektu. Sprawdzi� przebieg �ladu macierzy kowariancji P (n) podczas identyfikacji
global lambda 
lambda = 0.98;

%% ZADANIE 2.1c
%---- � Stosuj�c metod� filtracji Kalmana przeprowadzi� identyfikacj� parametryczn� toru
%----   dynamiki u 7? y obiektu (14) z wykorzystaniem aktualizacji (19) przyjmuj�c
%----   R = diag{0.0001, 0.0001, 0.0001}, a nast�pnie R = diag{0, 0, 0.0001} (w obu przypadkach 
%----   przyj�� zast�pczo ?2 := 1). Zwr�ci� uwag� na zdolno�� estymatora do
%----   �ledzenia zmian parametru b20 obiektu oraz na zachowanie pozosta�ych estymat
%----   parametr�w modelu dla obu zastosowanych macierzy R. Sprawdzi� wp�yw warto�ci element�w 
%----   diagonali macierzy R na jako�� identyfikacji i fluktuacje estymat parametr�w.
global sigma2 R
sigma2 = 1;  
R = diag([0; 0; 0.001]);

%% ZADANIE 2.1d
%---- � Przeanalizowa� jako�� identyfikacji adaptacyjnej stosuj�c metod� resetowania macierzy 
%----   kowariancji P (n) (zastosowa� kryteria R1 do R3). Sprawdzi� wp�yw warto-
%----   �ci parametr�w ro_i na jako�� identyfikacji i fluktuacje estymat parametr�w.
global ro 
ro = 0.05;
resetFreq = 33.0;            % ms               

%% ZADANIE 2.1e
%---- � Sprawdzi� jako�� identyfikacji stosuj�c metod� RIV?, RIV z filtracji Kalmana oraz
%----   RIV z resetowaniem macierzy kowariancji dla przypadku, gdy zak��cenie b�dzie
%----   szumem kolorowym (w tym celu zainicjowa� c10 = 0.7).
c10 = 0.7;

%----   Wyniki:
%       idealne(a1, a2, b2) = {0.8; 0.1; 0.3394}
% 
%       R3_LS(a1, a2, b2) = {-0.96; 0.06; 0.29}
%       R3_IV(a1, a2, b2) = {-0.79; -0.1; 0.34}
% 