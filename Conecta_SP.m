%% Função para módulos SP 
function [VStringF IStringF] = Conecta_SP(Vmod, Imod, DeltaV, DeltaI) 


MaxVmod = 0;
MaxImod = 0;

[Mp Ms] = size(Vmod);

%% Calcula os vetores V e I para cada String.
%Vetor V
VSomando{1} = 0;
k = 2;
for i = 1:Mp

    for j = 1:Ms
        VSomando{k} = Soma(VSomando{k-1},Vmod{i,j}');   %soma as tensoes em cada string;
        k=k+1;
        
    end
    VString(i)= VSomando(k-1)'; %salva o valor da soma da String 
    VSomando{1} = 0; %Reseta VSomando para uma nova soma;
    k=2;
end

%Vetor I

for i = 1:Mp
    Aux = cell2mat(VString(1,i)); 
    [TamString,w] = size(Aux);
    VectorI = 0:DeltaI:(TamString-1)*DeltaI;
    VectorI(TamString) = max(cell2mat(Imod(i,:))); %Encontra o valor máximo de corrente para cada String
    IString{i} = VectorI';
end

 VStringF = VString';
 IStringF = IString';

