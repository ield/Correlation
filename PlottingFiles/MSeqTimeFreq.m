%Engineer: ield
%Company: ALTER-UPM

%% Descripcion del Script
% This program is made to create the graphs of an M-Sequence both in time
% domain and in frequency domain.
% It is done so that the signal plotted is perfectly conformed: only {-1,
% 1}. 

clear;

%% Constant creation
n = 1.468;          %Fiber refraction index
c = 2.9979e8;       %Speed of light in vacuum

pulse = 80;         %Ideal number of points per pulse
m = 255;            %Length of the M-Sequence

fFPGA = 25;         %Ideal frequency of FPGA
fReal = 25.0134;    %Real frequency of FPGA
% fFPGA = 32;       %Ideal frequency of FPGA
% fReal = 31.978;   %Real frequency of FPGA
% fFPGA = 50;       %Ideal frequency of FPGA
% fReal = 50.25;    %Real frequency of FPGA
Fs = 2e9;           % Sampling rate of the oscilloscope


%% Importing and conforming signals in time domain

filename1 = 'tx.txt';

tx = textToSignal(filename1, pulse, m, fFPGA, fReal);
meanTx = mean(tx);
tx = tx - meanTx;
L = length(tx);

for i = 1:L 
    if(tx(i) >= 0) 
        tx(i) = 1;
    else
        tx(i) = -1;
    end
end

%% Plot signal in Time domain

xaxis = 0 : 1/Fs : (L-1)/Fs;
xaxis = xaxis*1e6;

plotMSeqTime(xaxis, tx);
ylim([-1.25 1.25]);
xlim([0 xaxis(end)]);

%% Plot autocorrelation
L = length(tx);

correlation = FourierCorr(tx, tx);
correlation = circshift(correlation, round((length(correlation)-1)/2));
xaxis = -(L-1)/(2*Fs) : 1/Fs : (L-1)/(2*Fs);
xaxis = xaxis*1e6*40;
plotMSeqCorrelation(xaxis, correlation);

%% Conforming signal in Frequency domain

TX = fft(tx);

TX = TX(1:round(L/2)+1); %It is selected the second half f the spectre
TX(2:end-1) = 2*TX(2:end-1); % It is multiplied (only one half is shown so the power is doble)

% The y axis the power is divided by the length of the sequence
TX = abs(TX)/L;

%% Plot signal in Frequency domain
% create figure is a function with the values predefined for this case

%x axis conformation depends on the sampling rate. Otherwise, the frequency
%would be normalized. The sampling rate scales the frequency.
f = Fs*(0:round(L/2))/(L*1e6); 

plotMSeqFreq(f, TX);
% xlabel('Frecuency [MHz]');
% xlim([0 f(end)]);