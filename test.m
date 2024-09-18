function [tempo_contract, tempo_relax] = algorithm_test(time, threshold, Data_tratada)
% Algorithm for detecting muscular contractions and relaxations in an EMG signal.
% Number of data points in the EMG signal
tempo_contract = zeros(4,20);
tempo_relax = zeros(4,20);
c = 0;  % Flag variable for contraction detection

for t = 1:4
    data1 = Data_tratada(:,t);
    figure;  % Create a new figure
    plot(time, data1);  % Plot the EMG signal

    if(t==1)
        title('Mão esquerda')
    elseif(t==2)
        title("Braço Esquerdo")
    elseif(t==3)
        title("Mão direita")
    elseif(t==4)
        title("Braço direito")
    end

hold on;
    beginning_index(t)=0;
    end_index(t)=0;

    for i = 2 : 40000
        if data1(i) >= threshold && data1(i-1) < threshold && c == 0
           plot(time(i), data1(i), 'og');  % Plot a green circle around the beginning of a contraction
           beginning_index(t) = beginning_index(t) + 1;
           tempo_contract(t, beginning_index(t)) = time(i);
           c = 1;  % Indicates the start of a contraction
        elseif data1(i) <= threshold && data1(i-1) > threshold && c == 1
           plot(time(i), data1(i), 'or');  % Plot a red circle around the beginning of a relaxation
           end_index(t) = end_index(t) + 1;
           c = 0;  % Indicates the start of a relaxation phase
           tempo_relax(t, end_index(t)) = time(i);
        end
    end 
end 
hold off;
end
