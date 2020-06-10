%% LABORATORUM SA
% �WICZENIE C4 - Rekursywne metody identyfikacji parametrycznej dla system�w SISO/MISO

%---- � MIEJSCE NA NOTATKI
% 19/05 Obliczenia mog� nast�pi� tylko, gdy wektor regresji b�dzie wektorem 
%       pionowym.  
%% ZADANIE 1.1d
%---- � Zaimplementowa� blok modelu symulowanego oraz predyktora jednokrokowego 
%----   korzystaj�cych z aktualnych warto�ci estymat parametr�w. Sprawdzi� jako�� 
%----   identyfikacji por�wnuj�c odpowied� modelu symulowanego ym(n) z odpowiedzi� obiektu
%----   y(n) oraz z jego odpowiedzi� idealn� (bez szumu) y0(n) na to samo wymuszenie
%----   u(n). Por�wna� tak�e odpowied� predyktora jednokrokowego ? y(n|n ? 1) z odpowiedzi� y(n) obiektu na wymuszenie u(n).

function output = ZAD1_2a_RIV(input)

% Zmienne globalne
%----   Zainicjowanie tych zmiennych jako globalne w pliku ZAD1_1_skrypt.m
%       skutkuje zachowywaniem ich w pami�ci - nie trzeba liczy� iteracji.
global PIV_1 phatIV_1 tracePIV 

% Definicja wej��
u_2 = input(1);
y = input(2);
y_1 = input(3);
y_2 = input(4);
x_1 = input(5);
x_2 = input(6);

% Wyznaczenie wektora regresji liniowej dla aktualnych wej�� i wyj��
Phi = [-y_1; -y_2; u_2];

% Wyznaczam wektor z
z = [-x_1; -x_2; u_2];

% Wyznaczam wsp�czynnik epsilon:
epsilon = y - (Phi' * phatIV_1);

% Wyznaczam macierz P^{IV}
%----   Domy�lna macierz P nie b�dzie w stanie zareagowa� na zmian�
%       parametr�w modelu. (w naszym przypadku b2 - zmieniany po czasie
%       Td)
PIV = PIV_1 - ((PIV_1 * z * Phi' * PIV_1) / (1 + Phi' * PIV_1 * z));
% Uaktualniam zmienn� globaln� PIV_1
PIV_1 = PIV;

%% Wyznaczam wsp�czynnik k(n)
k = PIV * z;

% Wyznaczam wektor parametr�w estymowanych phatLS
phatIV = phatIV_1 + k*epsilon;

% Uaktualniam phatLS_1
phatIV_1 = phatIV;

output = [phatIV; epsilon];

%% ZADANIE 1.1e
%---- �  Sprawdzi� przebieg �ladu macierzy P (n) podczas identyfikacji (funkcja trace(P)).

tracePIV = [tracePIV; trace(PIV)];