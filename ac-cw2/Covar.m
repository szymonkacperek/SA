function C=Covar(D,tau)
%%oblicza warto�� funkcji kowariancji 'c(tau)' dla sygna��w zawartych w D i
%%przesuni�cia czasowego r�wnego 'tau'
%%parametry wej�ciowe: D - macierz sk�adaj�ca si� z 2 kolumn (y(n), u(n));
%% tau - ��dana warto�� przesuni�cia sygna��w (liczba pr�bek przesuni�cia);

Y = D(:,1);
U = D(:,2);

N = size(Y,1);
Yp = zeros(N,1);

MU = (1/N)*sum(U);
MY = (1/N)*sum(Y);

Ud = U;% - MU*ones(N,1);              %odj�cie warto�ci �rednich
Yd = Y;% - MY*ones(N,1);

if (tau>=0)
    Yp(1:(N-tau)) = Yd((1+tau):N);  
else
    Yp((1-tau):N) = Yd(1:(N+tau));  
end

CYU = (1/N)*(Ud'*Yp);                   %uwaga: normalizacja warto�ci� 'N'
% CYU = (1/(N-abs(tau)))*(Ud'*Yp);        %uwaga: normalizacja warto�ci� 'N-|tau|'

C = CYU;