%Engineer: ield
%Company: ALTER-UPM

%% Descripcion del Script
% This program is made to simulate the inputs in the vivado program. It
%   generates a txt which contains what should be included in the test
%   bench because it represents how the values change.
%   It generates an input; it is not based on anything previous. The
%   attenuation is set as well as the noise power to test the snr of the
%   received signal.

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



% Information necessry to add noise: the power of the signal. It is
% important to consider only the ac component of the signal so that it is
% done correctly. Otherwise the noise add in power to the dc component as
% well, so the signal is more disturbed than it should
meanS1 = mean(signal);
powS1 = 10*log10(sigPower(signal - meanS1));

for i = 1:avg
    % #3. Adds noise to the signal
    rcv = awgn(signal,rxSNR,powS1);
    
    % Prints the signal in the document
    
    for j = 1:length(rcv)
        val = round(rcv(j)*(2^16-1)/3.3);
        fprintf(fileID,'#2\n');
        
        % Prints the signal to enter
        fprintf(fileID,'vacIn_tb = 16''b');
        
        % Converts the signal from decimal to binary
        signalBin = decToBin(val);
        
        for k = 1:length(signalBin)
            fprintf(fileID,'%u', signalBin(k));
        end
        fprintf(fileID,';\n');
    end
end

text = 'all is ok'

% 
% 
% plot(signal);
% hold on;
% 
% 
% %% Test to check the noise factor
% meanS1 = mean(signal);
% powS1 = 10*log10(sigPower(signal - meanS1));
% rcv = awgn(signal,-20,powS1);
% plot(rcv);
%  
% figure;
% [corr, xaxis] = corrInter(signal, rcv, pulse, m, fFPGA, fReal, n, c);
% plot(corr, xaxis)


% for i = 1:length(signal1) 
%         
%     % Prints time delay
%     fprintf(fileID,'#2\n');
%     
%     % Prints the signal to enter
%     fprintf(fileID,'vacIn_tb = 16''b');
%     
%     % Converts the signal from decimal to binary
%     signalBin = decToBin(signal1(i));
%     
%     for j = 1:length(signalBin)
%         fprintf(fileID,'%u', signalBin(j));        
%     end
%     fprintf(fileID,';\n');
% end

fclose(fileID);