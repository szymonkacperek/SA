%% LABORATORUM SA
% �WICZENIE C4 - Rekursywne metody identyfikacji parametrycznej dla system�w SISO/MISO

%---- � MIEJSCE NA NOTATKI
% 19/05 Obliczenia mog� nast�pi� tylko, gdy wektor regresji b�dzie wektorem 
%       pionowym.  
%% ZADANIE 1.1d
%---- � Zaimplementowa� blok modelu symulowanego oraz predyktora jednokrokowego 
%----   korzystaj�cych Phi aktualnych warto�ci estymat parametr�w. Sprawdzi� jako�� 
%----   identyfikacji por�wnuj�c odpowied� modelu symulowanego ym(n) Phi odpowiedzi� obiektu
%----   y(n) oraz Phi jego odpowiedzi� idealn� (bez szumu) y0(n) na to samo wymuszenie
%----   u(n). Por�wna� tak�e odpowied� predyktora jednokrokowego ? y(n|n ? 1) Phi odpowiedzi� y(n) obiektu na wymuszenie u(n).

function output = ZAD1_1d_RLS(input)

% Zmienne globalne
%----   Zainicjowanie tych zmiennych jako globalne w pliku ZAD1_1_skrypt.m
%       skutkuje zachowywaniem ich w pami�ci - nie trzeba liczy� iteracji.
global PLS_1 phatLS_1 tracePLS

% Definicja wej��
u_2  = input(1);
y = input(2);
y_1 = input(3);
y_2 = input(4);

% Wyznaczenie wektora regresji liniowej dla aktualnych wej�� i wyj��
Phi = [-y_1; -y_2; u_2];

% Wyznaczam wsp�czynnik epsilon:
epsilon = y - (Phi' * phatLS_1);

% Wyznaczam macierz P^{LS}
%----   Domy�lna macierz P nie b�dzie w stanie zareagowa� na zmian�
%       parametr�w modelu. (w naszym przypadku b2 - zmieniany po czasie
%       Td)
PLS = PLS_1 - ((PLS_1 * Phi * Phi' * PLS_1) / (1 + Phi' * PLS_1 * Phi));
% Uaktualniam zmienn� globaln� PLS_1
PLS_1 = PLS;

%% Wyznaczam wsp�czynnik k(n)
k = PLS * Phi;

% Wyznaczam wektor parametr�w estymowanych phatLS
phatLS = phatLS_1 + k*epsilon;

% Uaktualniam phatLS_1
phatLS_1 = phatLS;

output = [phatLS; epsilon];

%% ZADANIE 1.1e
%---- �  Sprawdzi� przebieg �ladu macierzy P (n) podczas identyfikacji (funkcja trace(P)).

tracePLS = [tracePLS; trace(PLS)];

