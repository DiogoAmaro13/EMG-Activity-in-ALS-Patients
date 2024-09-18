function [tempo_contract, tempo_relax] = algorithm2(Data_tratada, time)

Min=mink(Data_tratada(:,1),round(length(time)/1.5));
data1=Data_tratada(:,1);
threshold=mean(Min);

for i= 1:length(Data_tratada)
    if data1(i)<=threshold   %se o sinal naquele ponto não ultrapassar o threshold 
       data1(i)=0;   %o sinal é igual a 0 
    end
end

contraction=[];
relaxation=[];
tempo_relax=[];
tempo_contract=[];
setpoints=[];

for i= 2:length(Data_tratada)-1
    if data1(i)>0                                   %se o sinal for maior que o threshold há contração 
       contraction(end+1)=Data_tratada(i, 1);
    end
    if(data1(i)==0)                                 %se o sinal foi menor ou igual ao threshold não há contração 
       relaxation(end+1)=Data_tratada(i, 1);
    end
    if data1(i) == 0 && data1(i-1)>0                %se não há contração e imediatamente antes houve é porque estamos perante uma descontração 
       tempo_relax(end+1)=time(i);                  %adicona esse valor temporal ao vetor de relaxamento 
       setpoints(end+1)=Data_tratada(i, 1);
    end
    if data1(i) == 0 && data1(i+1)>0                %se naquele momento não há contração e no momento imediatamente a seguir há estamos perante o inicio de uma contração 
       tempo_contract(end+1)=time(i);               %adiciona ao vetor contração o valor temporal em que ela ocorre
       setpoints(end+1)=Data_tratada(i, 1);
    end
end


figure(5)
plot(time,Data_tratada(:,1))
xline(tempo_contract, '-g');
xline(tempo_relax, '-r');
xlabel("Tempo (s)");
ylabel("Amplitude (mV)");
hold off

%amplitude de contração 

amplitude_contracao = [];

for i = 1:length(tempo_contract)
    inicio_contracao = tempo_contract(i);
    [~, indice_inicio] = min(abs(time - inicio_contracao));
    
    if i <= length(tempo_relax)
        fim_contracao = tempo_relax(i);
    else
        fim_contracao = time(end); % Utiliza o último tempo disponível se não houver próximo final de contração
    end
    
    [~, indice_fim] = min(abs(time - fim_contracao));
    amplitude = max(Data_tratada(indice_inicio:indice_fim, 1));
    amplitude_contracao(end+1) = amplitude;
    display(amplitude_contracao)
end

figure(6)
plot(tempo_contract, amplitude_contracao, 'bo')
xlabel("Tempo (s)");
ylabel("Amplitude da Contração");
title("Amplitude das Contrações");

end
