%Ler o ficheiro 
Data_Temp = readmatrix("Ct21_PV.txt");  % Ct21_PV.txt Ct_PT.txt Ct1_AB.txt Ct4_ClF.txt  Ct6_IA.txt  Ct8_JL.txt  Ct16_MN.txt
Fs = 1000; %Frequência de amostragem
Seconds = 40; %Intervalo de tempo que se pretende estudar
Data_Sec = Fs * Seconds; %Dados recolhidos no intervalo de tempo escolhido
time = 1/Fs:1/Fs:Seconds; %Percorre o sinal amostra por amostra desde a primeira até à que existe no segundo 40 
Data_Transformada = ((Data_Temp/2^12-0.5)*5);

%separação dos canais 
Mao_dir = Data_Transformada(:, 4);  %sinal da mao direita
Mao_esq = Data_Transformada(:,2);  %sinal da mao esquerda
Bra_dir = Data_Transformada(:,5);  %sinal do braço direito 
Bra_esq = Data_Transformada(:,3);  %sinal do braço esquerdo 


%juntamos os 4 sinais de interesse na matriz que antes se encontrava vazia
Data_base = [Mao_esq, Bra_esq, Mao_dir, Bra_dir]; %obtemos uma matriz só com os canais com informação desejada
Data = Data_base(1:Data_Sec, :);

%plot do sinal 
%figure(1)
% for i = 1:4
%  %   subplot(4,1,i)
%   %  plot(time, Data(:, i))
%     xlabel("Tempo (s)");
%     ylabel("Amplitude (mV)");
% 
%     hold on
% 
%     if (i==1)
%         title("Mão Esquerda");
%     elseif (i==2)
%         title("Braço Esquerdo");
%     elseif (i==3)
%         title("Mão Direita");
%     elseif (i==4)
%         title("Braço Direito");
%     end
%     hold off
% end 

%Tratar os dados
%passa banda
FN = Fs/2; %freq de nyquist
fpass = 50;
fstop =300;

[b,a] = butter(10,[fpass,fstop]/FN,'bandpass');
Data= filtfilt(b,a,Data);     


Media_data = mean(Data);   %fazemos a média da data
Data_sem_media = Data - Media_data;    %tiramos ao sinal a sua média para reduzir o offset a 0
Data_quadrada = Data_sem_media.^2;   %quadramos a Data sem a média para ter tudo positivo
%fazemos a media móvel desse sinal
% quadrado ponto a ponto exagera a parte de interesse do sinal
%end
%fazer plot de cada dado tratado


% figure(2)
% hold on
% for w = 1:4
%     subplot(4,1,w)
%     plot(time, Data_quadrada(:, w));
%     title("Data sem Ruido");
%     xlabel("Tempo(s)");
%     ylabel("Amplitude (mV)");
% 
%     if (w==1)
%         title("Mão esquerda");
%     elseif (w==2)
%         title("Braço Esquerdo");
%     elseif (w==3)
%         title("Mão Direita");
%     elseif (w==4)
%         title("Braço Direito");
%     end
% end 
% hold off

%envelope do sinal 

Data_tratada = movmean(Data_quadrada, [1000 0]);

figure(3)
for w = 1:4
    hold on 
    subplot(4,1,w)
    plot(time, Data_tratada(:,w))
    title("Data Final")
    xlabel("Tempo(s)");
    ylabel("Amplitude (mV)"); 

    if (w==1)
        title("Mão esquerda");
    elseif (w==2)
        title("Braço Esquerdo");
    elseif (w==3)
        title("Mão Direita");
    elseif (w==4)
        title("Braço Direito");
    end
end 
hold off

% Passar para frequencias 

Data_dim = length(Data_tratada);    %dimemsão da nossa matriz principal
F = Fs*(0:(Data_dim/2))/Data_dim;

figure(4)
for c = 1:4 %se o canal for de 1 até 4 
    Data_freq = fft(Data(:,c)); %converte o tempo em frequencia com o fft
    Data_freq = abs(Data_freq/Data_dim);  %devolve-nos o valor absoluto 
    %Adicionamos uma frequencia de corte 
    Data_freq = Data_freq(1:Data_dim/2+1); %queremos que a matriz vá só ate metade +1 do seu tamanho

    subplot(4, 1, c) % faz subplot de 4 elementos
    plot(F, Data_freq)

    if(c==1)
        title('Mão esquerda')
    elseif(c==2)
        title("Braço Esquerdo")
    elseif(c==3)
        title("Mão direita")
    elseif(c==4)
        title("Braço direito")
    end
    hold off
end


%o mesmo se verifica nos braços, a tensão observada no braço direito tem
%muito maior amplitudo(e ruido) que a aplicada pelo braço esquerdo

%Agora queremos o sinal em frequencia e não em tempo
%temos de construir um gráfico de potências

%mais uma vez conseguimos ver as diferenças nos gráficos de potencia entre
%a mão direita e esquerda e braço direito e esquerdo


%ESTUDO DO SINAL 


%Find peaks para achar os picos de amplitude
threshold = 0.000777; % provide the threshold for detecting contractions


[tempo_contract, tempo_relax] = algorithm_test(time, threshold, Data_tratada);

%[tempo_contract, tempo_relax] = algorithm2(Data_tratada, time);
 
%tempo de uma contração 

% %Para alrotimo 2 que só lê um canal de cada vez
% for t = 1:8
%     if tempo_relax(t) > tempo_contract(t)
%          duracao_contract_controlo_alg2(t) = tempo_relax(t)- tempo_contract(t); %se o relaxamento acontecer depois da contração faz a subtração normal 
%     else
%          for t = 1:7
%          duracao_contract_controlo_alg2(t)=tempo_relax(t+1)-tempo_contract(t); %se a contração em t for depois do relaxamento é porque o relaxamento que corresponde àquela contração está na célula seguinte
%          end
%     end
%     display(duracao_contract_controlo_alg2(t))
% end

% %algoritmo teste
for t=1:8
    if tempo_relax(1,t) > tempo_contract(1,t)
        dur_contract_controlo_alg_test(t) = tempo_relax(1,t)- tempo_contract(1,t); %se o relaxamento acontecer depois da contração faz a subtração normal 
    else
        for t = 1:7
        dur_contract_controlo_alg_test(t)=tempo_relax(1,t+1)-tempo_contract(1,t); %se a contração em t for depois do relaxamento é porque o relaxamento que corresponde àquela contração está na célula seguinte
        end
    end
    display(dur_contract_controlo_alg_test(t))
end
