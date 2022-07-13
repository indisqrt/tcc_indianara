%% Par�metros de entrada (Entra P G T : Sai V(aleat�rio):I(uniforme))

function [V,I] = Calcula(P,G,Tp,DeltaI)

% % RS - RP - NS - Voc - Isc - a - n - Eg
% P=[0.005 7 54 32.9 8.21 3.18e-3 1.2 1.1];                         %Parametros
% % Radia��o
% G = [1];
% % Temperatura
% Tp = [20];                      %Temperatura
% DeltaI = 0.001;



%% 

Psun = 1000;
T = 25;


Vs = [];
Is = [];
Vn = 0;
z=0;        %Encontrar onde est� o maior valor de corrente
Ki=1;

%% Entra Parametros, SAI MATRIZ IxV 

        T = 273 + Tp;   %Temperatura da c�lula (em Kelvin)
        %====================================================
        Rs = P(1);      %Resist�ncia em s�rie da c�lula fotovoltaica
        Rp = P(2);      %Resist�ncia em paralelo da c�lula fotovoltaica
        Ns = P(3);      %N�mero de c�lulas fotovoltaicas interconectadas
        Voc = P(4)/Ns;  %Tens�o de circuito aberto
        Isc = P(5);     %Corrente de curto-circuito por c�lula
        a = P(6);       %Coeficiente de temperatura de Isc
        n = P(7);       %!!!!!%Fator de qualidade da jun��o p-n        
        Eg = P(8);      %Energia da banda proibida do s�licio (em eV)
        k = 1.38e-23;   %Constante de Boltzmann
        q = 1.60e-19;   %Carga do el�tron
        
        %====================================================
        
        Tr = 273 + 25; %Temperatura de refer�ncia: 25�C (em Kelvin)
        Iph = (Isc+a*(T-Tr))*Psun/1000*G; %Fotocorrente
        Vt = n*k*T/q; %Tens�o equivalente do diodo em fun��o da temperatura
        Irr = (Isc-Voc/Rp)/(exp(q*Voc/n/k/Tr)-1); %Corrente de satura��o reversa de refer�ncia
        Ir = Irr*(T/Tr)^3*exp(q*Eg/n/k*(1/Tr-1/T)); %Corrente de satura��o reversa da c�lula
        V=0;
        
        while (1),
            I(Ki) = (Ki-1)*DeltaI;
            if(Ki==1)
                 V(Ki)=0;                  %Condi��o incial 0
            else
                 V(Ki)= V(Ki-1);       %Condi��o inicial = Tens�o anterior 
            end
            for i=1:5,                         %METODO NEWTON
                 fx = Ns*Vt*log((I(Ki)-Iph+V(Ki)/(Rp*Ns)-Ir+Rs*I(Ki)/Rp)/(-Ir))-Rs*Ns*I(Ki)-V(Ki);
                 fxl = -1+(Vt/Rp)*(I(Ki)-Iph+V(Ki)/(Rp*Ns)-Ir+Rs*I(Ki)/Rp)^(-1);
                 V(Ki)= V(Ki) -fx/fxl; 
            end
            if(V(Ki)<0 || imag(V(Ki))~=0)    % Caso for negativo ou o ln ser numero complexo
                  break
            end
              Ki=Ki+1;    
        end
        V(Ki) = 0;
        for j=1:5, %Calcula corrente em um ramo de m�dulos em s�rie usando o m�todo de Newton
            I(Ki) = I(Ki)-(Iph-I(Ki)-Ir*(exp((I(Ki)*Rs)/Vt)-1)-(I(Ki)*Rs)/Rp)/(-1-Ir*exp((I(Ki)*Rs)/Vt)*Rs/Vt-Rs/Rp);
        end
        Ki=1;

        
% Plotar as curvas para cada c�lula
%plot(V(:),I(:),'b')
