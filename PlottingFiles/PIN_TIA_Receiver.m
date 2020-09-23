%% Constant creation
clear;
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

%% Measuring the PIN-TIA

files = ["Channel1_2dBm.txt"; "Channel2_2dBm.txt"];

signal1 = textToSignal(files(1), pulse, m, fFPGA, fReal);
signal2 = textToSignal(files(2), pulse, m, fFPGA, fReal);

% Plotting all outputs
figure('Color',[1 1 1]);


L = length(signal1);            % Axis definition for plotting
xaxis = 0 : 1/Fs : (L-1)/Fs;
xaxis = xaxis*1e6;

subplot(3, 1, 1)
plot(xaxis, signal1, 'k');
xlim([xaxis(1) xaxis(end)]);
xlabel('Time [\mus]');
ylabel ('Amplitude [V]');
title('Differential output +');

subplot(3, 1, 2)
plot(xaxis, signal2, 'k');
xlim([xaxis(1) xaxis(end)]);
xlabel('Time [\mus]');
ylabel ('Amplitude [V]');
title('Differential output -');

signal_2dBm = signal1 - signal2;
subplot(3, 1, 3)
plot(xaxis, signal_2dBm, 'k');
xlim([xaxis(1) xaxis(end)]);
xlabel('Time [\mus]');
ylabel ('Amplitude [V]');
title('Subtraction differential outputs');

%% Comparison of all photodetectors
filename1 = 'COPT_2dBm.txt';
copt_minus10dBm = textToSignal(filename1, pulse, m, fFPGA, fReal);      % COPT receiver at Pin = -10 dBm
amp12dB = 10^(24/20);
copt_2dBm = amp12dB*copt_minus10dBm;                                    % COPT receiver without saturation at Pin = 2 dBm

files = ["Channel1_-10dBm.txt"; "Channel2_-10dBm.txt"];

signal1 = textToSignal(files(1), pulse, m, fFPGA, fReal);
signal2 = textToSignal(files(2), pulse, m, fFPGA, fReal);
signal_minus10dBm = signal1 - signal2;

figure('Color',[1 1 1]);
subplot(2, 1, 1);
plot(xaxis, copt_2dBm, 'r');
hold on;
plot(xaxis, signal_2dBm, 'b');
xlim([xaxis(1) xaxis(end)]);
xlabel('Time [\mus]');
ylabel ('Amplitude [V]');
title('Pin = 2 dBm');

subplot(2, 1, 2)
plot(xaxis, copt_minus10dBm, 'r');
hold on;
plot(xaxis, signal_minus10dBm, 'b');
hold on;
xlim([xaxis(1) xaxis(end)]);
xlabel('Time [\mus]');
ylabel ('Amplitude [V]');
title('Pin = -10 dBm');


