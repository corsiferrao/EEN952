%% Rafael Corsi 
% Núcleo de Sistemas Eletrônicos Embarcados - NSE^2
% Script de geração de ECG para tratamento de sinais em HIL
% com o Elvis USB
clear all;
close all;

%% Taxa de amostragem
Ts = 0.1E-3;
Fs = 1/Ts;

%% Carrega dados previamente gerados com script em ECG_api
load ecg_dados;

% Cria vetor de dados utilizado pelo simulink
dado.time = [];

% Interpola o dado linearmente para alteara a taxa de amostragem
x_interpolacao = Fs/(size(ecg_p.x,2)/max(ecg_p.x));
dado.signals.values = interp(ecg_p.y', x_interpolacao) ; 

%% Plota sinal
figure
    plot([dado.signals.values; dado.signals.values])
    title('ECG com taxa de amostragem de Ts = 1E-3')

%% FFT do ECG sem ruído
% implementar 


%% Executa simulação
ecg_modelo;

%% Plota gráfico do ECG
% implementar

figure
plot(ecg_noise(:,2),ecg_noise(:,1))
title('ECG com ruído')

%% FFT do ECG com ruído
% implementar 

%% Plota gráfico do ECG filtrado
% implementar


%% FFT do ECG com ruído filtrado
% implementar 

   
%% ------------------------------- parte 2
% Executa HIL
%-------------------------------
% Vamos usar uma placa de aquisição para gerar sinais
% de um vetor

% aqui carregamos a lista de placas e escolhermos dentre elas uma
devices = daq.getDevices                      
devices(1)

s = daq.createSession('ni')

% configuramos a saída análogica 0
addAnalogOutputChannel(s,'Dev3',0,'Voltage')

% Configura a taxa de amostragem
s.Rate = Fs;

%% Validando saida - parte 1
% coloca 1 V no D/A para verifcar se está ok
outputSingleScan(s, 2)

%% Validando saida com sin - parte 2
outputSignal = sin(linspace(0,pi*2,s.Rate)');
plot(outputSignal);
xlabel('Time');
ylabel('Voltage');

% aqui usamos outra função, colocamos um vetor no buffer
queueOutputData(s,outputSignal);

% inicializa o processo
s.startForeground;

%% HIL do ECG sem ruido
ecg = [dado.signals.values; dado.signals.values; dado.signals.values];
queueOutputData(s,ecg);
s.startForeground;

%% HIL do ECG com ru�do
queueOutputData(s,ecg_noise(:,1));
s.startForeground;
