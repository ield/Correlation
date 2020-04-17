%Engineer: ield
%Company: ALTER-UPM

%% Descripcion del Script
% This program is made to create the focus on the graph of two
% correlations: when the peak is perfect and when the peak is not

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


filename2 = '1000mrx.TXT';
rx = textToSignal(filename2, pulse, m, fFPGA, fReal);


%% Plotting

[~, corrPerf] = corrInter(tx, circshift(tx, 2000), pulse, m, fFPGA, fReal, n, c);
[xaxis, corrNor] = corrInter(tx, rx, pulse, m, fFPGA, fReal, n, c);

plotDemInter(xaxis, corrPerf, corrNor);