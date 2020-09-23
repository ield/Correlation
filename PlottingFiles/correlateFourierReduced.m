%Engineer: ield
%Company: ALTER-UPM

function [xaxis, correlation] = correlateFourierReduced(filename1, filename2, pulse, m, fFPGA, fReal, n, c, isAir)
%% General Explanation
% Reduced version of correlate fourier with less functions and shorter
% responses in order to save memory.

vt = (1/(fReal*1e6))*(c/n);

%% 1
signal1 = textToSignal(filename1, pulse, m, fFPGA, fReal);
% length(signal1)
% figure, plot(signal1)
signal2 = textToSignal(filename2, pulse, m, fFPGA, fReal);
% length(signal2)
% signal2 = -signal2;
% hold on
% plot(signal2, 'r');

%OPTIONAL(when signal 2 is given)
% signal2 = filename2;


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
if(isAir) 
    xaxis = xaxis / 2;
end

%Only last 95% of the function is returned
k = 0.95;
xaxis = xaxis(round(length(xaxis)*k):end);
correlation = correlation(round(length(correlation)*k):end);
%% 5
% The maximum of the correlation is found and its xaxis position is the
% distance caused by the delay
corMax = max(correlation);
pos = find(correlation == corMax);

% distance = xaxis(pos);
% distanceInter = interpole(xaxis(pos-1:pos+1), correlation(pos-1:pos+1));
% distanceInter = 0;

% snrCor = calculateSNR(correlation, m, pulse);
% 
% snrSig = signalSNR(signal1, signal2, correlation);
% 
% supRatio = calculateSupression(correlation, pulse);

%% 6
% The correlation is plotted
% figure
% plot(xaxis, correlation, 'k');
% 
% title(strcat('Fourier Correlation. Distance = ',num2str(distance) ,'m. SNR = ',num2str(snr),' dB.'));
% xlim([xaxis(1) xaxis(length(xaxis))]);
% xlabel('Distance [m]');
% ylabel('Correlation');
% 
% txt = strcat('SNR received = ', num2str(signalSNR(signal1, signal2, correlation)), ' dB.');
% dim = [0.2 0.5 0.3 0.3];
% annotation('textbox',dim,'String',txt,'FitBoxToText','on');


end


