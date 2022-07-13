%% Função para módulos SP 
function [VsaidaF IsaidaF] = Conecta_TCT(Vmod, Imod, DeltaV, DeltaI) 

%Vmod = VTCT;
%Imod = ITCT;

MaxVmod = 0;
MaxImod = 0;

[Mp Ms] = size(Vmod);


MaxVmod = 0;
MaxImod = 0;

%% Calcula os vetores V e I para cada módulo.


VInv{1}=[];
IInv{1}=[];

for i = 1:Mp
    for j = 1:Ms
        [IInv{i,j}, VInv{i,j}] = Inverte(cell2mat(Imod(i,j))',cell2mat(Vmod(i,j))',DeltaV);
    end
end



%% Soma a corrente dos módulos em paralelo

ISomando{1} = 0;
k = 2;
for i = 1:Ms
    for j = 1:Mp
        ISomando{k} = Soma(ISomando{k-1}',IInv{j,i}');   %soma as correntes em cada string;
        k=k+1;
    end
    
    ISector(i)= ISomando(k-1); %salva o valor da soma da String 
    IArray = cell2mat(ISomando(k-1)); %salva o valor da soma das Strings;
    [TamString w] = size(IArray);
    VectorV = 0:DeltaV:(TamString)*DeltaV;
    ISector{i}(TamString+1)=0;
    VSector{i} = VectorV';
    
   
    ISomando{1} = 0; %Reseta VSomando para uma nova soma;
    k=2;
end

VSectorInv{1}=[];
ISectorInv{1}=[];

for j = 1:Ms
    [VSectorInv{j}, ISectorInv{j}] = Inverte(cell2mat(VSector(1,j)),cell2mat(ISector(1,j)),DeltaI);
end

VSomandoInv{1} = 0;
k=2;
for j = 1:Ms
    VSomandoInv{k} = Soma(VSomandoInv{k-1},VSectorInv{j}); %Somando o vetor de tensão
    k=k+1;
end

VSaida = VSomandoInv{k-1}; %Salva o valor da variável de tensao de saída (ainda precisa inverter este vetor)

[TamSaida w] = size(VSaida); 
ISaida = 0:DeltaI:(TamSaida-1)*DeltaI; %Cria o vetor Itct de saída para inverter
ISaida = ISaida';

IsaidaF = ISaida;
VsaidaF = VSaida;

%PSaida = VSaida.*ISaida;
%plot(VSaida,PSaida,'b');

