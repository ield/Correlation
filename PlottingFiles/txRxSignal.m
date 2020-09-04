%Engineer: ield
%Company: ALTER-UPM

%% Descripcion del Script
% This program is made to create the graphs of an M-Sequence both
% transmitted and received

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
% txMax = max(tx);
% txMin = min(tx);

filename2 = 'rx_55dB_av.txt';
rx = textToSignal(filename2, pulse, m, fFPGA, fReal);
% rxMax = max(rx);
% rxMin = min(rx);

L = length(tx);

%% Plotting

xaxis = 0 : 1/Fs : (L-1)/Fs;
xaxis = xaxis*1e6;

plotTxRx(xaxis, tx, rx);

% subplot(2,1,1);
% ylim([(txMin - 0.05) (txMax + 0.05)]);
% xlim([0 (xaxis(end)*zoom)]);
% 
% subplot(2,1,2)
% ylim([(rxMin - 0.01) (rxMax + 0.01)]);
% xlim([0 (xaxis(end)*zoom)]);