%% LABORATORUM SA
% �WICZENIE C1 - Analiza sygna��w deterministycznych i losowych w dziedzinie czasu i cz�stotliwo�ci
% ZADANIE 1.1

%%
clc;

%% Parametry pr�bkowania
% fpr = 1000; dt = 1/fp;      % cz�stotliwo�� pr�bkowania [Hz]; okres pr�bkowania
% t0 = 0.5;                   % czas obserwacji sygna�u [s]
Tp = 1;                     % okres probkowania
N = 1000;                   % liczba pr�bek [-]
% t = (0:N-1) * dt          % wektor czasu      

t = NoiseSig(:,1);
e = NoiseSig(:,2);
v = NoiseSig(:,3);

plot(t,e,'k');
xlabel('t');
hold on;
plot(t,v,'b');
legend('t','e');
grid on;

















%load StochasticProcess.mat;
%mean(StochasticProcess,1);
%var(StochasticProcess,1);

%mk = StochasticProcess(:,1);
%mw = StochasticProcess(:,1);

%plot(mk,'or');  % kropki czerwone
%hold on;        % wstrzymaj, zeby polaczyc oba wykresy
%plot(mw,'ob');  % kropki niebieskie
%grid on;
