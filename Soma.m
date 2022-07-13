%% Entra com dois vetores e sai a soma deles.
function Sum = Soma(A, B)
%  Sum = [];
% % 
%  A = Vmod{1,2};
%  B = Vmod{2,1};


% 
 [TamA w] = size(A); %Encontra o tamanho dos vetores e inverte caso eles estejam com dimensão errada
if TamA < w
      A=A';
      TamA = w;
end
% 
 [TamB w] = size(B); 
if TamB < w
      B=B';
      TamB = w;
end


DifAB=TamA-TamB; %Verifica se eles são do mesmo tamanho

if DifAB > 0     %Se houver diferença ajusta o tamanho dos vetores para a soma (Caso B menor)
   for i=1:1:DifAB; 
       B(TamB+i,1)=B(TamB,1);
   end
end

if DifAB < 0     %Mesmo caso anterior se A for menor
   for i=1:1:-DifAB; 
       A(TamA+i,1)=A(TamA,1);
   end
end

Sum = (A+B);       %Soma