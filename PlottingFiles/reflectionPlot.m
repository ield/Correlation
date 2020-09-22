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
isAir = 0;

%% Importing and conforming signals in time domain

filename1 = 'tx_new.txt';

filename2 = 'notel.txt';
filename3 = 'notel_nowall.txt';

% % Use this and only this for stretegy 2.1 (comment lines above)
% filepath = 'CorrelatorFiles&Measurements/EDFA/';
% tx = [filepath, 'tx_new.txt'];
% rx_nocat = [filepath, 'nowall.txt'];
% 
% rx = dir([filepath, '*cm.txt']);


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
[~, corNoCat, ~, disNoCat, ~, ~, ~] = correlateFourier(filename1, filename3, pulse, m, fFPGA, fReal, n, c, 0);
[xaxis, cor, ~, dis, ~, ~, ~] = correlateFourier(filename1, filename2, pulse, m, fFPGA, fReal, n, c, 0);

plotCorrDisShift(xaxis, cor);
plotCorrDisShift(xaxis, corNoCat);

plotCorrDisShift(xaxis, cor-corNoCat);

(dis - disNoCat) / 2

% %% Strategy 2.1
% % Same as before but all the files at the same time. Comment code in
% % 'Importing and conforming signals in time domain'
% 
% [xaxis, corNoCat, ~, disNoCat, ~, ~, ~] = correlateFourier(tx, rx_nocat, pulse, m, fFPGA, fReal, n, c, isAir);
% 
% 
% for i = 1:length(rx) 
%     rxDistance = [filepath, rx(i).name];
%     [~, cor, ~, dis, ~, ~, ~] = correlateFourier(tx, rxDistance, pulse, m, fFPGA, fReal, n, c, isAir);
%     plotCorrDisShift(xaxis, cor)
% end
% 

%% Strategy 2.2
% Same as before but combining all the plots at the same time. 
% The name of the plots must be:
%   No catadioptric: nocat_1 - nocat_5
%   Distance xcm_1 - xcm_5
%   Retrorreflector: rrNear_1 - rrNear_5 and rrFar_1 - rrFar_5
filepath = 'CorrelatorFiles&Measurements/EDFA/MultipleMeasures';

tx = [filepath, 'tx_new.txt'];

% All received files are grouped into a matrix. Normally, the result would
%   be a vector, but they are transposed so that they are an array. When
%   they are put all together in rx, each row corresponds to one kind of
%   reception (5cm, rr, etc.) and each column to one of the measures of
%   that reception
nocat = dir([filepath, 'nocat_*'])';
rx5cm = dir([filepath, '5cm_*'])';
rx15cm = dir([filepath, '15cm_*'])';
rx25cm = dir([filepath, '25cm_*'])';
rx45cm = dir([filepath, '45cm_*'])';
rrNear = dir([filepath, 'rrNear_*'])';
rrFar = dir([filepath, 'rrFar_*'])';

rx = [nocat; rx5cm; rx15cm; rx25cm; rx45cm; rrNear; rrFar];

% An array of different points is created so that it is known the color
dataTips = ['-k', '--k', ':k', '-.k', '-r', '--r', ':r'];

% All the correlations are done and it is stored the distance and the
%   maximum of the correlation in the variable results
maxima = zeros(length(rx(:, 1)), length(rx(1, :)));
correlations = [];
axis = [];

for ii = 1:length(rx(:, 1)) %For each row
    for jj = 1:length(rx(1, :)) %For each column of that row: each measure
        rxMeasure = [filepath, rx(ii, jj).name];
        [xaxis, cor, ~, dis, ~, ~, ~] = correlateFourier(tx, rxMeasure, pulse, m, fFPGA, fReal, n, c, isAir);
        axis = xaxis;
        
        maxima(ii, jj, 1) = dis;
        correlations =  [correlations; cor];
    end
end

%Up to this point it has been created a matrix with each maximum of the
%   correlation and distance of the target. Not it is necesary to subtract
%   the correlations. 

% First, it is done with the results with no wall. In this case, it is not
%   necessary to compare all the results, only the ones with different
%   measures. This means nocat_1 is compared with nocat_2-5 and later any
%   of nocat_2-5 are compared with nocat_1.
%   Each correlation is determined by ii and jj because they are the first
%   row

for ii = 1:length(rx(1, :))-1 %All the values except for 5 because it will have been compared
    for jj = ii+1:length(rx(1, :))
        plot(xaxis, correlations(ii)-correlations(jj), datatips(1));
        hold on;
    end
end

% Second, all the subtractions are done. In this case, each measure is
%   compared with all the nocat measures
for ii = 2:length(rx(:, 1)) % All the values except the ones with nocat (already taken care)
    for jj = 1:length(rx(1, :))
        corMeasured = correlations((ii-1)*length(rx(1, :))+jj); % Selects the correlation of this scennario.
        for kk = 1:length(rx(1, :)) %All the correlations in the first row
            plot(xaxis, corMeasured-correlations(kk), datatips(ii));
            hold on;
        end
    end
end


