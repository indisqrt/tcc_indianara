%% Função para módulos qualquer 
for num3= 1:5
for num2= 1:5
for num1=1:5
for num=1:5

clear all;
clc

%% Parâmetros a serem modificados
 
 M = [1 1 1 1;1 1 1 1;1 1 1 1;1 1 1 1];                         %Tipo do módulo
%M= [1 1; 1 1];
%C = [1 1 1 1 1];
% RS - RP - NS - Voc - Isc - a - n - Eg
P=[0.005 7 54 32.9 8.21 3.18e-3 1.2 1.1];   %Parametros
%% G = [1 1 1; 1 1 1;1 1 1];
% G = [7    6     5     4;...
%      6    5     4     3;...
%      5    4     3     2;...
%      4    3     2     1]*(1/7);
% G = [7    6     5     4;...
%      7    6     5     4;...
%      7    6     5     4;...
%      7    6     5     4]*(1/7);
% G = [7    7     7     7;...
%      6    6     6     6;...
%      5    5     5     5;...
%      4    4     4     4]*(1/7);

%% 10001
% G = [1    1     1     1;...
%      1    1     1     1;...
%      1    1     1     0.2;...
%      1    1     1     0.2];

%% 10011
% G = [1    1     1     1;...
%      1    1     1     1;...
%      1    1     1     1;...
%      1    1     1     0.2];

%% 10101

%% 10111
% G = [1    1     1     1;...
%      1    1     1     1;...
%      1    1     1     0.2;...
%      1    1     0.2     0.2];


%% 11001
% G = [1    1     1     1;...
%      1    1     1     1;...
%      1    1     1     1;...
%      0.2    1     1     1];

%% 11011
% G = [1    1     1     1;...
%      1    1     1     1;...
%      1    1     1     1;...
%      0.2    1     1     0.2];

%% 11101
% G = [1    1     1     1;...
%      1    1     1     1;...
%      0.2    1     1     1;...
%      0.2    0.2     1     1];


%% 11111
% G = [1    1     1     1;...
%      1    1     1     1;...
%      1    1     1     0.2;...
%      1    0.2     1     0.2];

%% 10101
%  G = [0    1     1     1;...
%       1    0     1     1;...
%       1    1     0     1;...
%       1    1     1     0];

%% 10101
%   G = [ 0    1       0      0;...
%         1    1       0      0;...
%         0    0       0      0;...
%         0    0       0      0];

%% teste
% G= [1 0; 1 1];

%% 
G = rand(4);

%G = [1 1 1 1; 1 1 1 1; 1 1 1 1; 1 1 1 1];
%Tp = rand(4);                   %Temperatura
Tp = [0.25  0.25 0.25 0.25; 0.25 0.25 0.25 0.25; 0.25 0.25 0.25 0.25; 0.25 0.25 0.25 0.25];
DeltaI = 0.001;
DeltaV = 0.01;

[Mp Ms] = size(M);

MaxVmod = 0;
MaxImod = 0;

%% Calcula os vetores V e I para cada módulo.

for i = 1:Mp
   for j = 1:Ms
       
       [V,I] = Calcula( P(M(i,j),:) , G(i,j) , Tp(i,j) ,DeltaI );
       
       Vmod{i,j} = V;
       Imod{i,j} = I;

       MaxV = max(V);
       MaxI = max(I);
       
       if MaxVmod < MaxV          %Salvar o valor máximo de tensão
            MaxVmod = MaxV;
       end
       
       if MaxImod < MaxI          %Salvar o valor máximo de corrente
            MaxImod = MaxI;
       end
   end
end

F = [1 0 0 0 1;1 0 0 1 1;1 0 1 0 1;1 0 1 1 1;1 1 0 0 1;1 1 0 1 1;1 1 1 0 1;1 1 1 1 1]';
% F= [1 1 1];
Verif = 0;
%F = [1 0 0 0 1;1 1 1 1 1]';
for C=F
    Verif = Verif+1;
    clear aux1 aux2 F Iaux Iout H Ipar Iserie ITCT k p Pout quant SerieI SerieV T TamV Vaux Vout Vpar Vserie VTCT
    C = C';
    TamV = length(C);
    VTCT=[];
    ITCT=[];
    p=0;
    for k=1:Mp
    p=0;
    Vaux=[];
    Iaux=[];

        for j=1:TamV-1
            if C(j)==1 & C(j+1)==1
                Vaux = [Vaux Vmod(k,j)];
                Iaux = [Iaux Imod(k,j)];
                p=1;
            end
        end    
        if p==1
            Vpar(k,:) = Vaux;
            Ipar(k,:) = Iaux;
        end
    
    end

    if p==1
        VTCT = Vpar;
        ITCT = Ipar;
    end

    for k=1:Mp 
        i=1;
    
        H=0;
        while i < TamV

            if C(i)==0
                H=H+1;
                SerieV = Vmod(k,i-1);
                SerieV = [SerieV Vmod(k,i)];
                SerieI = Imod(k,i-1);
                SerieI = [SerieI Imod(k,i)];
                i=i+1;
                while C(i)==0
                    SerieV = [SerieV Vmod(k,i)];
                    SerieI = [SerieI Imod(k,i)];
                    i=i+1;
                end
            Vserie(k,:,H)=SerieV;
            Iserie(k,:,H)=SerieI;
            end
            i=i+1;
        end
    end

    if H>0
        [aux1 aux2 quant]=size(Vserie);

        for i=1:quant
    
            [V I] = Conecta_SP(Vserie(:,:,i), Iserie(:,:,i), DeltaV, DeltaI);
       
            for i = 1:length(V)
                V{i,1}=V{i,1}';
                I{i,1}=I{i,1}';
            end
    
            VTCT=[VTCT V];
            ITCT=[ITCT I];   
        end
    end

        [Vout Iout] = Conecta_TCT(VTCT, ITCT, DeltaV, DeltaI);
        Pout=Vout.*Iout;
        MaxP(Verif) = max(Pout);
        CVerif{Verif} = C;
%         plot(Vout,Pout);
%         hold on;
        
end
        [MaxEstrut pos] = max(MaxP);
        CEstr = CVerif{pos};
        Calc = struct('G',G,'Max', MaxEstrut,'C',CEstr,'SP',MaxP(1),'TCT',MaxP(8));
        load('Resposta.mat','Dados');
        Dados = [Dados Calc];
        save('Resposta.mat', 'Dados');

end
end
end
end