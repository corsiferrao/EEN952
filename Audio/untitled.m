%% leitura e peocessamento de audio
% Sistemas & Sinais  - Jun/2015
%   Rafael Corsi - rafael.corsi@maua.br

%% Carrega audio
% Descompacta e carrega um vetor com o audio
% vale lembrar que esse audio e' estereo, o vetor
% vai possuir o canal Esquerdo e Direito
[Y, FS] = audioread('som.wav');
tmp      = Y(:,1);       % Lado esquerdo
YR      = Y(:,2);       % Lado direito

YL = tmp(1:10*FS);

%% Var Auxiliares
TS = 1/FS;              % periodo
tf = size(YL,1)*TS;      % tempo total do audio
t  = (0:TS:(tf-TS))';   % vetor tempo em (s)

% Gera objeto para ser usado pelo simulink
% um unico canal 
audio_in.time = t;
audio_in.signals.values = YL;
audio_in.signals.dimensins = size(YL,1);

%% carrega modelo simulink
ruido

%% cria variáveis auxiliares
y_out = audio_out.data;
y_out_filtrado = audio_out_filtrado.data;

%%
%player = audioplayer(y_out,FS);
%play(player);

%% ÁUDIO não filtrado
L    = size(y_out,1);            % Length of signal
NFFT = 2^nextpow2(L);            % Next power of 2 from length of y
Yfft = fft(y_out,NFFT)/L;        % Calcula FFT
f = FS/2*linspace(0,1,NFFT/2+1); % Ajusta frequencia

stem(f,2*abs(Yfft(1:NFFT/2+1)))  % plota resutltado
%title(['Fourier Audio - ' name]);
xlabel('Hz'); ylabel('|A|');


%% ÁUDIO  filtrado High pass filter
figure;
clear L;
L    = size(y_out_filtrado,1);        % Length of signal
NFFT = 2^nextpow2(L);            % Next power of 2 from length of y
Yfft = fft(y_out_filtrado,NFFT)/L;               % Calcula FFT
f = FS/2*linspace(0,1,NFFT/2+1); % Ajusta frequencia

stem(f,2*abs(Yfft(1:NFFT/2+1)))     % plota resutltado
%title(['Fourier Audio - ' name]);
xlabel('Hz'); ylabel('|A|');

%% filtrado
player_filtrado = audioplayer(y_out_filtrado,FS);
play(player_filtrado);
