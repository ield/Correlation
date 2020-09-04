%Engineer: ield
%Company: ALTER-UPM

%% Descripcion del Script
% This program is made to create the graphs of the recived signal after
% travelling through the air. The reflection caused in the collimator is so
% big that it is necessary to find a strategy to delete that reflection.
% Therefore, several strategies are implemented.
%   #1. Substracting the signal with and without catadioptric
%   #2. Substracting the correlations.

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

filename1 = 'tx_new.txt';

filename2 = 'cat_5cm2.txt';
filename3 = 'nocat2.txt';


%% Strategy 1
% The signal sent is already the signal, so it is necessary to modify the
% function xcorr as explained below

% rxCat = textToSignal(filename2, pulse, m, fFPGA, fReal);
% rxNoCat = textToSignal(filename3, pulse, m, fFPGA, fReal);
% 
% idealRx = rxCat-rxNoCat;
% 
% % plot(idealRx);
% figure;

%IMPORTANT%
% It is necessary to change correlate Fourier: comment line 'signal2 =
% textToSignal(filename2, pulse, m, fFPGA, fReal);' and uncomment 'signal2
% = filename2;'
% Calculate distance of the reflection
% [~, ~, disNoCat, ~, ~, ~, ~] = correlateFourier(filename1, rxNoCat, pulse, m, fFPGA, fReal, n, c, 0);
% [xaxis, cor, dis, ~, ~, ~, ~] = correlateFourier(filename1, idealRx, pulse, m, fFPGA, fReal, n, c, 0);
% plot(xaxis, cor);
% dis
% (dis - disNoCat) / 2

%% Strategy 2
% Substract correlations. The function xcorr must not be modified (if it
% has been done strategy 1, the function must be set to its original
% configuration).
[~, corNoCat, ~, ~, ~, ~, ~] = correlateFourier(filename1, filename3, pulse, m, fFPGA, fReal, n, c, 0);
[xaxis, cor, dis, ~, ~, ~, ~] = correlateFourier(filename1, filename2, pulse, m, fFPGA, fReal, n, c, 0);
plot(xaxis, cor-corNoCat);

max(cor-corNoCat)




