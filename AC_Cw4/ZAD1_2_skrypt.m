%% LABORATORUM SA
% �WICZENIE C4 - Rekursywne metody identyfikacji parametrycznej dla system�w SISO/MISO
% ZADANIE 1.1, 1.2

%---- � MIEJSCE NA NOTATKI
% 
%%
close all; clc;

%% ZADANIE 1.1a
%---- � Plik ObiektARMAX.mdl zawiera blok reprezentuj�cy obiekt dynamiczny 
%----   zdefiniowany w dyskretnej dziedzinie czasu o strukturze ARX/ARMAX:
%----   (14), gdzie a10, a20, b20 i c10 reprezentuj� prawdziwe parametry dynamiki obiektu, a
%----   e(n) jest szumem bia�ym. Zaznaczmy, �e (14) nale�y do rodziny modeli ARMAX
%----   o postaci og�lnej: Ay = Bu + Ce ? y = Gu + He, G = B/A, H = C/A. Je�eli
%----   przyjmiemy c10 = 0 w�wczas otrzymamy szczeg�ln� posta� modelu, a mianowicie
%----   model ARX z szumem bia�ym po prawej stronie. Dla c10 6= 0 szum (1+c10q?1)e(n)
%----   jest ju� kolorowy z wszelkimi konsekwencjami tego faktu.

%% ZADANIE 1.1b - PARAMETRY PR�BKOWANIA
%---- � Zainicjowa� nast�puj�ce zmienne globalne: Tp=0.1, Tend=1000, Td=1500, kt�re
%----   oznaczaj� (w sekundach), odpowiednio, okres pr�bkowania, horyzont czasowy
%----   symulacji oraz czas, po kt�rym nast�pi zmiana warto�ci parametru b20 (tutaj
%----   Tend<Td, wi�c zmiana nie nast�pi wcale � obiekt o sta�ych parametrach).
Tend = 1000;
Tp = 0.1;
t = 0 :Tp: Tend;
N = size(t,2);
Td = 1500;

%% ZADANIE 1.1c
%---- �  Zainicjowa� jako zmienn� globaln� warto�� parametru c10 = 0 (zak�adamy zak��-
%----   canie szumem bia�ym). Przeprowadzi� identyfikacj� parametryczn� toru dynamiki
%----   u ? y obiektu (14) metod� RLS przyjmuj�c jako wej�cie pobudzaj�ce u(n) sygna�
%----   prostok�tny (symetryczny wzgl�dem zera) o amplitudzie jednostkowej i cz�stotliwo�ci fu = 0.2 Hz. 
%----   Przeanalizowa� przebiegi estymat p?(n) dla r�nych warto�ci parametru ? przy wyborze pocz�tkowej 
%----   macierzy P (0) (patrz w2). Sprawdzi� wp�yw warto�ci okresu pr�bkowania na jako�� identyfikacji 
%----   � sugerowany zestaw warto�ci (w [s]): Tp e {0.01; 0.1; 0.5; 1.0; 2.0}.
global c10 L
c10 = 0;
fu = 0.2;
uAmp = 1;
L = 1;          % wsp�czynnik zapominania

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
global PLS_1 phatLS_1
roLS = 100;
PLS_1 = roLS * eye(3);
phatLS_1 = [0; 0; 0];

%% ZADANIE 1.1e
%---- �  Sprawdzi� przebieg �ladu macierzy P (n) podczas identyfikacji (funkcja trace(P)).
global tracePLS
tracePLS = [];

%% ZADANIE 1.2a
%---- � Zainicjowa� warto�� parametru c10 = 0.7 (zak�adamy zak��canie szumem kolorowym). 
%----   Przeprowadzi� identyfikacj� parametryczn� toru dynamiki u 7? y obiektu
%----   (14) stosuj�c metod� RIV ze zmiennymi instrumentalnymi obliczanymi zgodnie z
%----   definicj� (12)-(13).

global PIV_1 phatIV_1 
c10 = 0.7;
roIV = 100;
PIV_1 = roIV * eye(3);
phatIV_1 = [0; 0; 0];

%% ZADANIE 1.2c
%---- �  Sprawdzi� przebieg �ladu macierzy P (n) podczas identyfikacji (funkcja trace(P)).
global tracePIV
tracePIV = [];
