%% Parâmetros de entrada (Entra P G T : Sai V(aleatório):I(uniforme))

function [V,I] = Calcula(P,G,Tp,DeltaI)

% % RS - RP - NS - Voc - Isc - a - n - Eg
% P=[0.005 7 54 32.9 8.21 3.18e-3 1.2 1.1];                         %Parametros
% % Radiação
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
z=0;        %Encontrar onde está o maior valor de corrente
Ki=1;

%% Entra Parametros, SAI MATRIZ IxV 

        T = 273 + Tp;   %Temperatura da célula (em Kelvin)
        %====================================================
        Rs = P(1);      %Resistência em série da célula fotovoltaica
        Rp = P(2);      %Resistência em paralelo da célula fotovoltaica
        Ns = P(3);      %Número de células fotovoltaicas interconectadas
        Voc = P(4)/Ns;  %Tensão de circuito aberto
        Isc = P(5);     %Corrente de curto-circuito por célula
        a = P(6);       %Coeficiente de temperatura de Isc
        n = P(7);       %!!!!!%Fator de qualidade da junção p-n        
        Eg = P(8);      %Energia da banda proibida do sílicio (em eV)
        k = 1.38e-23;   %Constante de Boltzmann
        q = 1.60e-19;   %Carga do elétron
        
        %====================================================
        
        Tr = 273 + 25; %Temperatura de referência: 25ºC (em Kelvin)
        Iph = (Isc+a*(T-Tr))*Psun/1000*G; %Fotocorrente
        Vt = n*k*T/q; %Tensão equivalente do diodo em função da temperatura
        Irr = (Isc-Voc/Rp)/(exp(q*Voc/n/k/Tr)-1); %Corrente de saturação reversa de referência
        Ir = Irr*(T/Tr)^3*exp(q*Eg/n/k*(1/Tr-1/T)); %Corrente de saturação reversa da célula
        V=0;
        
        while (1),
            I(Ki) = (Ki-1)*DeltaI;
            if(Ki==1)
                 V(Ki)=0;                  %Condição incial 0
            else
                 V(Ki)= V(Ki-1);       %Condição inicial = Tensão anterior 
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
        for j=1:5, %Calcula corrente em um ramo de módulos em série usando o método de Newton
            I(Ki) = I(Ki)-(Iph-I(Ki)-Ir*(exp((I(Ki)*Rs)/Vt)-1)-(I(Ki)*Rs)/Rp)/(-1-Ir*exp((I(Ki)*Rs)/Vt)*Rs/Vt-Rs/Rp);
        end
        Ki=1;

        
% Plotar as curvas para cada célula
%plot(V(:),I(:),'b')
