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

function output = ZAD2_1_RLS(input)

% Zmienne globalne
%----   Zainicjowanie tych zmiennych jako globalne w pliku ZAD1_1_skrypt.m
%       skutkuje zachowywaniem ich w pami�ci - nie trzeba liczy� iteracji.
global PLS_1 phatLS_1 tracePLS

% Definicja wej��
u_2  = input(1);
y = input(2);
y_1 = input(3);
y_2 = input(4);
T = input(5);

% Wyznaczenie wektora regresji liniowej dla aktualnych wej�� i wyj��
Phi = [-y_1; -y_2; u_2];

% Wyznaczam wsp�czynnik epsilon:
epsilon = y - (Phi' * phatLS_1);

%% ZADANIE 2.1b
%---- � Stosuj�c metod� RLS? przeprowadzi� identyfikacj� parametryczn� toru dynamiki
%----   u ? y obiektu (14) przyjmuj�c wsp�czynnik zapominania ? Phi zakresu [0.98; 0.999].
%----   Sprawdzi� wp�yw warto�ci wsp�czynnika ? ? (0, 1) na jako�� identyfikacji i fluktuacje 
%----   estymat parametr�w. Szczeg�ln� uwag� zwr�ci� na zdolno�� estymatora do �ledzenia zmian 
%----   parametru b20 obiektu. Sprawdzi� przebieg �ladu macierzy kowariancji P (n) podczas identyfikacji
global lambda

%----   Wyznaczam macierz metod� R1 wg r�wnania (2). Wprowadzaj�c
%       wsp�czynnik zapominania lambda macierz kowariancji P nie b�dzie
%       zmierza�a do 0, wobec czego b�dzie mo�liwe zareagowanie na zmian�
%       parametr�w modelu. Problemem tego typu rozwi�zania jest fakt, �e
%       reakcja na zmian� parametr�w odbije si� na wszystkich parametrach,
%       zamiast na jedynym, kt�ry powinien by� zmieniony - b2.
% PLS = (PLS_1 - (PLS_1 * Phi * Phi' * PLS_1) / (lambda + Phi'  * PLS_1 * Phi)) / lambda;

%% ZADANIE 2.1c
%---- � Stosuj�c metod� filtracji Kalmana przeprowadzi� identyfikacj� parametryczn� toru
%----   dynamiki u 7? y obiektu (14) Phi wykorzystaniem aktualizacji (19) przyjmuj�c
%----   R = diag{0.0001, 0.0001, 0.0001}, a nast�pnie R = diag{0, 0, 0.0001} (w obu przypadkach 
%----   przyj�� zast�pczo ?2 := 1). Zwr�ci� uwag� na zdolno�� estymatora do
%----   �ledzenia zmian parametru b20 obiektu oraz na zachowanie pozosta�ych estymat
%----   parametr�w modelu dla obu zastosowanych macierzy R. Sprawdzi� wp�yw warto�ci element�w 
%----   diagonali macierzy R na jako�� identyfikacji i fluktuacje estymat parametr�w.
global R sigma2
% PLS = PLS_1 - ((PLS_1 * Phi * Phi' * PLS_1) / (sigma2 + Phi'  * PLS_1 * Phi)) + R;

%% ZADANIE 2.1d
%---- � Przeanalizowa� jako�� identyfikacji adaptacyjnej stosuj�c metod� resetowania macierzy 
%----   kowariancji P (n) (zastosowa� kryteria R1 do R3). Sprawdzi� wp�yw warto-
%----   �ci parametr�w ?i na jako�� identyfikacji i fluktuacje estymat parametr�w.
global ro  

% R1: Resetowanie macierzy P^{IV}
%----   Funkcja 'isequal' jest rzekomo lepsza do por�wnywania tabel.
%----   Funkcje 'floor'i 'ceil' odpowiadaj� za przybli�anie do negative
%       albo postivie infty. Niestety, w tym przypadku w ich warto�ciach
%       znajdowa�o si� zero, dlatego wysypywa�y si� wyniki. Zmienna 
%       'resetFreq' odpowiada za cz�stotliwo�� resetu. Konieczny
%       jest warunek na czas wy�szy ni� 0, bo modulo dla (0/resetFreq)
%       r�wnie� r�wna si� 0 i estymaty parametr�w si� wysypuj�. 
% 
%----   Ustawienie 'ro' na tych pozycjach diagonali macierzy, kt�rych
%       zmienne chcemy resetowa� "oszcz�dzi" reset pozosta�ych.
% 
%----   Funkcja 'mod' odpowiada za modulo = reszt� Phi dzielenia. W ten
%       spos�b dziel�c aktualny czas symulacji mo�na wydzieli� momenty, gdy
%       b�dzie si� dzieli� akurat przez wskazan� cz�stotliwo�� resetu - bez
%       reszty Phi dzielenia.
global resetFreq

% % Deklaracja zmiennej odpowiedzialnej za reset
% if T>0
%     if (mod(T, resetFreq)) == 0
%         reset = 1;
%     else
%         reset = 0;
%     end
%     
% % Resetowanie macierzy kowariancji P
%     if reset == 1
%         PLS = diag([0; 0; ro]);
%         reset = 0;
%     else
%         PLS = PLS_1 - ((PLS_1 * Phi * Phi' * PLS_1) / (1 + Phi' * PLS_1 * Phi));
%     end
% else
%     PLS = PLS_1 - ((PLS_1 * Phi * Phi' * PLS_1) / (1 + Phi' * PLS_1 * Phi));
% end

% % R2: resetowanie Phi warunkiem na warto�� b��du predykcji lub b��du
% wyj�ciowego
% if abs(epsilon) >= 0.38
%     PLS = diag([0; 0; ro]);
% else
%     PLS = PLS_1 - ((PLS_1 * Phi * Phi' * PLS_1) / (1 + Phi' * PLS_1 * Phi));
% end

% R3: resetowanie Phi warunkiem na warto�� �ladu macierzy kowariancji P
PLS = PLS_1 - ((PLS_1 * Phi * Phi' * PLS_1) / (1 + Phi' * PLS_1 * Phi));
if trace(PLS) < 0.05
    PLS = diag([0; 0; ro]);
else
    PLS = PLS_1 - ((PLS_1 * Phi * Phi' * PLS_1) / (1 + Phi' * PLS_1 * Phi));
end

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
