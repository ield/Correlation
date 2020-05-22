%Engineer: ield
%Company: ALTER-UPM

%% Descripcion del Script
% This program is made to plot the sampling results. It is divided into two
% steps:
% 1. Precision in calculating distance.
% 2. Quality of the signal with attenuation.

clear;


%% Constant creation
n = 1.468;          %Fiber refraction index
c = 2.9979e8;       %Speed of light in vacuum

m = 255;            %Length of the M-Sequence

fFPGA = 25;         %Ideal frequency of FPGA
fReal = 25.0134;    %Real frequency of FPGA
% fFPGA = 32;       %Ideal frequency of FPGA
% fReal = 31.978;   %Real frequency of FPGA
% fFPGA = 50;       %Ideal frequency of FPGA
% fReal = 50.25;    %Real frequency of FPGA
Fs = 2e9;           % Sampling rate of the oscilloscope

isAir = 0;

%% Getting files
filepath = 'CorrelatorFiles&Measurements/Muestreando menos/';

samples = [10 1 2 4];
samples = circshift(samples, -1);

rx_dis = dir([filepath, 'rx_1000m_*']);
rx_dis = circshift(rx_dis, -1);

rx_att = dir([filepath, '*_53dB.txt']);
rx_att = circshift(rx_att, -1)

tx_files = dir([filepath, 'tx_*']);
tx_files = circshift(tx_files, -1);

%% Plots distances

distance = [];
distanceInter = [];
distanceError = [];
error = [];
snrCorrDis = [];
snrSigDis = [];

% Here it correlates and updates the vectors which contain the values.
for i = 1:length(rx_dis) 
    
    tx = [filepath, tx_files(i).name];
    rx = [filepath, rx_dis(i).name];
    pulse = samples(i);
    
    [xaxis,~,dis,disInter,snrCor,snrSig,~] = correlateFourier(tx, rx, pulse, m, fFPGA, fReal, n, c, isAir);
    
    disError = [(dis-xaxis(2)) dis (dis+xaxis(2))];
    
    distance = [distance dis];
    distanceInter = [distanceInter disInter];
    error = [error xaxis(2)];
    distanceError = [distanceError; disError];
    snrCorrDis = [snrCorrDis snrCor];
    snrSigDis = [snrSigDis snrSig];
end

% Here it prints the values which will be used in the word table
distance
distanceInter
error
snrSigDis
snrCorrDis


% Here it plots
xax = [];
yax = [];

for i = 1:length(tx_files)
    y = [];
    for j = 1:3
        y = [y distanceError(i,j)];
    end
    x = [samples(i) samples(i) samples(i)];
    xax = [xax;x];
    yax = [yax;y];
end


plotSamplingResultsDistance(samples, [distance; distanceInter]', xax(1,:), yax(1,:), xax(2,:), yax(2,:),xax(3,:), yax(3,:),xax(4,:), yax(4,:));


%% Calculating the quality of the signal
snrCorrAtt = [];
snrSigAtt = [];

for i = 1:length(rx_att) 
    
    tx = [filepath, tx_files(i).name];
    rx = [filepath, rx_att(i).name]
    pulse = samples(i);
    
    [~,~,~,~,snrCor,snrSig,~] = correlateFourier(tx, rx, pulse, m, fFPGA, fReal, n, c, isAir);
    
    snrCorrAtt = [snrCorrAtt snrCor];
    snrSigAtt = [snrSigAtt snrSig];
end
snrSigAtt
snrCorrAtt

y = [snrSigDis; snrSigAtt; snrCorrDis; snrCorrAtt].';

plotSamplingResultsQuality(samples, y);

%% Plot signal received with 100MSa/s
filename1 = 'rx_4pts_53dB.txt';

tx = textToSignal(filename1, 4, m, fFPGA, fReal);
L = length(tx);

Fs = 100e6;

xaxis = 0 : 1/Fs : (L-1)/Fs;
xaxis = xaxis*1e6;

plotMSeqTime(xaxis, tx);
ylim([-1.25 1.25]);
xlim([0 xaxis(end)]);

% Here it plots
% figure;
% plot(samples, snrSigDis);
% hold on;
% plot(samples, snrSigAtt);
% hold on;
% plot(samples, snrCorrDis);
% hold on;
% plot(samples, snrCorrAtt);

