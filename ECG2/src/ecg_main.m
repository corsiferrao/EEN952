%% Rafael Corsi 
% Núcleo de Sistemas Eletrônicos Embarcados - NSE^2
% 
% Sinais & Sistemas - Analise de Formantes

clear all;
close all;

%% Carrega arquivos de audio

% Varre pasta e cria variáveis
for i=1:3
    name_file    = ['A' num2str(i) '.mp3']
    [ya   Fsa]   = audioread(name_file);
    half         = size(ya,1)/2;
    ya           = ya(half-half/2:half+half/2);
    [y{i} Fs{i}] = [ya   Fsa];
end

% Usar somente o meio do dado, onde o sinal é mais estavel
half = size(y,1)/2;
a.y  = y(half-half/2:half+half/2);
a.Ts = Fs;

%% Plota o sinal temporal

figure;
    t = (1:size(a.y,1))/a.Ts;
    plot(t, a.y);
    title('Audio')
    xlabel('s'); ylabel('A');

%% Plotar o fft do sinal
figure
    Fs = a.Ts;              % Sampling frequency
    Ts = 1/Fs;              % Sample time
    L = size(a.y,1);        % Length of signal

    NFFT = 2^nextpow2(L);            % Next power of 2 from length of y
    Y = fft(a.y,NFFT)/L;             % Calcula FFT
    f = Fs/2*linspace(0,1,NFFT/2+1); % Ajusta frequencia

    stem(f,2*abs(Y(1:NFFT/2+1)))     % plota resutltado
    title('Fourier Audio');
    xlabel('Hz'); ylabel('|A|');