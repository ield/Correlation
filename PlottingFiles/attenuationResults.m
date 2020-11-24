%Engineer: ield
%Company: ALTER-UPM

%% Descripcion del Script
% This program is made to plot the attenuation results. For this, there are
%   selected all the attenuated files and are cross-correlated

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

isAir = 0;

%%
filepath = '../Measurements/Atenuador/';

rx_av = dir([filepath, '*_av.txt']);
rx_noav = dir([filepath, '*_noav.txt']);

tx = [filepath, 'tx.txt'];

%% Plots non-averaged results
attenuation = [23 25 28 45];
corrSNR = [];
corrSup = [];

for i = 1:length(rx_noav) 
    rx = [filepath, rx_noav(i).name];
    [~,~,~,~,snr,~,sup] = correlateFourier(tx, rx, pulse, m, fFPGA, fReal, n, c, isAir);
    corrSNR = [corrSNR snr];
    corrSup = [corrSup sup];
end

corrSNR
corrSup


plotAttenuationResults(attenuation, [corrSNR; corrSup]);


%% Plots averaged results
attenuation = [23 25 28 45 48 55 58];
corrSNR = [];
corrSup = [];

for i = 1:length(rx_av) 
    rx = [filepath, rx_av(i).name];
    [~,~,~,~,snr,~,sup] = correlateFourier(tx, rx, pulse, m, fFPGA, fReal, n, c, isAir);
    corrSNR = [corrSNR snr];
    corrSup = [corrSup sup];
end

corrSNR
corrSup

plotAttenuationResults(attenuation, [corrSNR; corrSup]);
