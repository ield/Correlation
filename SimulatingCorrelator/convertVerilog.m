%Engineer: ield
%Company: ALTER-UPM

%% Descripcion del Script
% This program is made to simulate the inputs in the vivado program. It
%   generates a txt which contains what should be included in the test
%   bench because it represents how the values change.

%% Constant creation
clear;
n = 1.468;          %Fiber refraction index
c = 2.9979e8;       %Speed of light in vacuum

pulse = 1;         %Ideal number of points per pulse
m = 255;            %Length of the M-Sequence

fFPGA = 25;         %Ideal frequency of FPGA
fReal = 25.0134;    %Real frequency of FPGA
% fFPGA = 32;       %Ideal frequency of FPGA
% fReal = 31.978;   %Real frequency of FPGA
% fFPGA = 50;       %Ideal frequency of FPGA
% fReal = 50.25;    %Real frequency of FPGA

%% Import data
filename1 = "rx_1000m_1pts.txt";

signal1 = textToSignal(filename1, pulse, m, fFPGA, fReal);
signal1 = round(signal1*(2^16-1)/3.3);

fileID = fopen('verilogData.txt','w');



for i = 1:length(signal1) 
        
    % Prints time delay
    fprintf(fileID,'#2\n');
    
    % Prints the signal to enter
    fprintf(fileID,'vacIn_tb = 16''');
    
    % Converts the signal from decimal to binary
    signalBin = decToBin(signal1(i));
    
    for j = 1:length(signalBin)
        fprintf(fileID,'%u', signalBin(j));        
    end
    fprintf(fileID,'\n');
    end

fclose(fileID);