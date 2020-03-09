    %Engineer: ield
%Company: ALTER-UPM

function [correlation] = correlateFourier(filename1, filename2, pulse, m, fFPGA, fReal, n, c)
%% General Explanation
%Correlate returns the distance between two signals
%   #1: Extracts the signal from .txt files
%   #2: Deletes the continous compnent.
%   #3: Correlates both signals usig FouierCorr
%   #4: Shifts the lags of the xaxis into distance
%   #5: Detects the peak in the correlation and the snr
%   #6: Plots the correlation

%pulse stands for the ideal number of points of a pulse. It is ideal
%   because the real frequency does not match the desired one. Therefore,
%   not every pulse has the same amount of points.
%   m stands for the length of an m-sequence
%fFPGA stands for the ideal frequency of the FPGA
%fReal stands for the real frequency
%vt stands for the factor velocity*timeofpulse. Velocity is the speed of
%   light in the fiber, obtained by the refraction index of the fiber and
%   the speed of light in vacuum. timeofpulse is the duration of each pulse
%n stands for the refraction index of the fiber, corresponding to the value
%   of the OTDR
%c stands for the speed of light in vacuum.

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

%% 5
% The maximum of the correlation is found and its xaxis position is the
% distance caused by the delay
corMax = max(correlation);
pos = find(correlation == corMax);

distance = xaxis(pos);

snr = calculateSNR(correlation, m, pulse);

%% 6
% The correlation is plotted
figure
plot(xaxis, correlation, 'k');

title(strcat('Fourier Correlation. Distance = ',num2str(distance) ,'m. SNR = ',num2str(snr),' dB.'));
xlim([xaxis(1) xaxis(length(xaxis))]);
xlabel('Distance [m]');
ylabel('Correlation');

txt = strcat('SNR received = ', num2str(signalSNR(signal1, signal2, correlation)), ' dB.');
dim = [0.2 0.5 0.3 0.3];
annotation('textbox',dim,'String',txt,'FitBoxToText','on');


end


