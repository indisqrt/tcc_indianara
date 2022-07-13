%% Sai A x B(uniforme) -> Entra vetores a(uniforme) x b e DeltaSaida. 
function [A, B] = Inverte(a, b, Delta)

% a = cell2mat(VSector(1));
% b = cell2mat(ISector(1));
% Delta = 0.01;


[Maxb posMaxb] = max(b); %Encontra o valor m�ximo do vetor b de entrada
B = (0:Delta:Maxb)'; %Cria o vetor de sa�da B 
[TamVetB w] = size(B); %w � uma variav�l auxiliar nao usada.

for i = 2:TamVetB
    
    k = find(b(:,1) < B(i),1,'first'); %Encontra k = posi��o do vetor com o valor mais pr�ximo 
    
    %%%% Interpola��o %%%% Y = Cx + D 
    if k == 1
       A(i) = max(a); 
    else
        C = (a(k) - a(k-1))/(b(k)-b(k-1));
        D = -C*b(k-1) + a(k-1);
        A(i) = C*(B(i))+D;
        
        
    end
end

A(1)=max(a);


A = A';
% 
%  hold on
%  plot(b,a)
%  plot(B,A)



