%Engineer: ield
%Company: ALTER-UPM

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

%% Importing signals

filename1 = 'tx.txt';

filename2 = '1000mrx.txt';

%% For correlations

[xaxis, norCor] = correlate(filename1, filename2, pulse, m, fFPGA, fReal, n, c);
% fouCor = correlateFourier(filename1, filename2, pulse, m, fFPGA, fReal, n, c);

%% Calulate the error between both functions as the minimum distance
% error = (norCor - fouCor).^2;
% figure
% plot(error);
% title('Distance between correlations');

%% For signal snr
% testSignalSNR(filename1, filename2, pulse, m, fFPGA, fReal, n, c);
