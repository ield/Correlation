%Engineer: ield
%Company: ALTER-UPM

%% Descripcion del Script
% This program is made to compared the distances at which the rr is
% measured. It can be used to measure other targets
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

%% Script beginning

filepath = 'C:/Users/nacho/Documents/MATLAB/Correlation/Measurements/MeasuringDistances_20201001/';

tx = [filepath, 'tx.txt'];          % Tx file: used for correlation
nocat = [filepath, 'noCat.txt'];    
% The name of the plots must be:
%   Distance xcm_1 - xcm_5

% The distances are determined by an initial value and a step between
%   measures (all in cm)

ini = 15;
step = 10;
last = 105;
offset = 2;         % Offset in the measurements (in cm)

% All received files are grouped into a matrix. Normally, the result would
%   be a vector, but they are transposed so that they are an array. When
%   they are put all together in rx, each row corresponds to one kind of
%   reception (5cm, etc.) and each column to one of the measures of
%   that reception

positions = ini:step:last;      % All positions, used to search the name of the files
rx = [];

for ii = 1:length(positions)
    rx = [rx; dir([filepath, num2str(positions(ii)), 'cm_*'])'];   %It is added the new row for each distance with the columns corresponding to the measurements at that distance3
end


% All the correlations are done and it is stored the distance
[~, ~, disTel] = correlateFourierReduced(tx, nocat, pulse, m, fFPGA, fReal, n, c, isAir);
% All the correlations are done and it is stored the distance and the
%   maximum of the correlation in the variable results
maxima = zeros(length(rx(:, 1)), length(rx(1, :)));

for ii = 1:length(rx(:, 1)) %For each row
    for jj = 1:length(rx(1, :)) %For each column of that row: each measure
        rxMeasure = [filepath, rx(ii, jj).name];
        [~, ~, dis] = correlateFourierReduced(tx, rxMeasure, pulse, m, fFPGA, fReal, n, c, isAir);        
        maxima(ii, jj) = (dis-disTel)/2*100; % Now it is necesary to subtract the distance measured to the ones of the telescope
    end
end
"All correlations done"

% Now it is time to plot the results of the distances. In the x axis it is
%   plotted the ideal distance and in the y the measured distance.
figure('Color',[1 1 1]);
for ii = 1:length(maxima(:, 1)) %For each row
    for jj = 1:length(maxima(1, :)) %For each column of that row: each measure
        plot(positions(ii)+offset, maxima(ii, jj), '+k');
        hold on;
    end
end

% Calculating the error as the distance between the results expected and 
%   the results obtained
errorVector = (abs(mean(maxima')) - positions)./positions;
error = mean(errorVector)

plot(positions+offset, positions+offset);
xlabel('Separation collimator - retroreflector (cm)');
ylabel('Distance measured (cm)');
