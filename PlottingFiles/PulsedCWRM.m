%Engineer: ield
%Company: ALTER-UPM

%% General Explaination
% This Script plots a pulsed signal and cw-rm signal

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
Fs = 2e9;


%% Creating cw-rm signal
% The Continuos component is retired and the noise is filtered. The signal
% is digital '0', '1', 100%

filename1 = 'tx.txt';

cwrm = textToSignal(filename1, pulse, m, fFPGA, fReal);
meanTx = mean(cwrm);
cwrm = cwrm - meanTx;
L = length(cwrm);
for(i = 1:L)
    if(cwrm(i) >= 0) 
        cwrm(i) = 1;
    else
        cwrm(i) = -1;
    end
end

%% Creating pulsed signal

ps = cwrm;

cte  =10000; % Length of the pulsed signal
duty = 0.05; %Duty cycle

for(i = 1:L)
    if (mod(i, cte) > 1 && mod(i, cte) < round (cte*duty))
        ps(i) = 1;
    else ps(i) = -1;
    end
end

%% Plotting

figure;

xaxis = 0 : 1/Fs : (L-1)/Fs;
xaxis = xaxis*1e6;

subplot(2,1,1);
plot(xaxis, cwrm, 'k', 'LineWidth', 3);
ylim([-1.25 1.25]);
xlim([0 xaxis(end)]);

subplot(2,1,2)
plot(xaxis, ps, 'k', 'LineWidth', 3);
ylim([-1.25 1.25]);
xlim([0 xaxis(end)]);
