%Engineer: ield
%Company: ALTER-UPM

function [xaxis, correlation] = corrInter(signal1, signal2, pulse, m, fFPGA, fReal, n, c)
%% General Explanation
% Correlation used for the purpose of the graph in DemonstrationInterpole.
% The general expllanation of this function is in
% CorrelatiorFiles/correlateFourier.

vt = (1/(fReal*1e6))*(c/n);

%% 2
% The AC component is substracted.
meanS1 = mean(signal1);
meanS2 = mean(signal2);
signal1 = signal1 - meanS1;
signal2 = signal2 - meanS2;


%% 3
correlation = FourierCorr(signal1, signal2);

%% 4
% In this case, in stead of displaying the lags, the maximum of the
%   correlation is transformed to distance. In order to make this
%   conversion, several aspects are taken into account.
%   1.  The correlation is a periodic function, and the FourierCorr
%       function displays only one period.
%   2.  The first values of the correlation correspond to the biggest
%       delays,while the last one correspond to the shortest (the
%       correlation is periodic, the last values would be as the negative
%       ones).
%   3.  Therefore, tunction is inverted so that the first delays are
%       closest to 0. Before, the 0 is put at the end of the array so
%       that when the shift is done,it stays at the beginning 
% Now that the shifts are ordered timely, an x axis is created considering
%   the transformation from delay to distance (each delay corresponds to a
%   given distance)
% length(correlation)
correlation = abs(correlation);

correlation = circshift(correlation, -1);
correlation = flip(correlation);

xaxis = 0 : vt / length(correlation) * m : (length(correlation)-1)/length(correlation)*m*vt;

