%Engineer: ield
%Company: ALTER-UPM
%% Displays the outputs with different resistance

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
%% Optical trap and silver fiber
filepath = 'C:/Users/nacho/Documents/MATLAB/Correlation/Measurements/ChangingRes_COPT/';

coptRec = [filepath, 'copt.txt']; 
coptReceiver = textToSignal(coptRec, pulse, m, fFPGA, fReal);
coptReceiver = coptReceiver(1:end-1);
mean_50ohm = mean(coptReceiver);    %Mean of the receiver. Used to proportionally calculate the resistace.

figure('Color',[1 1 1]);

L = length(coptReceiver);
%Axis definition for plotting
xaxis = 0 : 1/Fs : (L-1)/Fs;
xaxis = xaxis*1e6;

plot(xaxis, coptReceiver);
hold on;

r_100 = [filepath, '100ohm.txt']; 
res_100 = textToSignal(r_100, pulse, m, fFPGA, fReal);
plot(xaxis, res_100);

% All the measures where the R is unknown
randomPos = [];
randomPos = [randomPos; dir([filepath, 'pos*'])'];
res_measured = zeros(1, length(randomPos));

for ii = 1:length(randomPos)
    measure = [filepath, randomPos(ii).name];
    signal = textToSignal(measure, pulse, m, fFPGA, fReal);
    
    plot(xaxis, signal);
    hold on;
    
    meanS = mean(signal);
    res_measured(ii) = meanS*50/mean_50ohm;
end

xlabel('Time (\mus)')
ylabel('Amplitude (V)')

res_measured
hold off