%Engineer: ield
%Company: ALTER-UPM

%% Descripcion del Script
% This program is to plot the imput with no noise and with a given snr

%% Constant creation
clear;
n = 1.468;          %Fiber refraction index
c = 2.9979e8;       %Speed of light in vacuum

pulse = 4;         %Ideal number of points per pulse
m = 255;            %Length of the M-Sequence

fFPGA = 25;         %Ideal frequency of FPGA
fReal = 25.0134;    %Real frequency of FPGA
% fFPGA = 32;       %Ideal frequency of FPGA
% fReal = 31.978;   %Real frequency of FPGA
% fFPGA = 50;       %Ideal frequency of FPGA
% fReal = 50.25;    %Real frequency of FPGA

Fs = 100e6;

%% Import data

% Where the outpul will be saved
fileID = fopen('verilogNewData.txt','w');

% Variables relative to the M-Sequence
reg = [1 1 1 1 1 1 1 1];
mseq = [];

% Variables relative to the attenuation and signal forming
% Attenuation (suffered in the air) in dB
% att = 50 dB wanted to be handled + 3dB: shift from 1V (the output in this
% scennario) to 0.7V (the real output in the tests)
att = 53;
% DC component added to the signal (the signal received is always dc)
dcComp = 5e-2;
signal = [];
% Number of m-sequences geenrated
avg = 64; %Number of averages
iterations = m*avg;

rxSNR = -14;




for i = 1:255   
    % #1. Generates M-Sequence (tested correctly)
    output = reg(8);
    feedback = xor(xor(reg(8), reg(7)), xor(reg(2), reg(1)));
    reg = [feedback reg(1:7)];
    
    % #2. Conforms the signal
    output = output * 10^(-att/20);
    output = output + dcComp;
    
    for j = 1:4
        signal = [signal output];
    end
end
% Up to here we already have the M-Sequence sampling 4 times with no noise





%% Test to check the noise factor
xaxis = 0 : 1/Fs : (length(signal)-1)/Fs;
xaxis = xaxis*1e6;

% plot(xaxis, signal);
% hold on;

meanS1 = mean(signal);
powS1 = 10*log10(sigPower(signal - meanS1));
rcv = awgn(signal,-20,powS1);
% plot(xaxis, rcv);

plotIdealNoisy(xaxis, [rcv; signal]);



