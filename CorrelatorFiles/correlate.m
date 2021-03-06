%Engineer: ield
%Company: ALTER-UPM

function [xaxis, correlation, distance, distanceInter, snrCor, snrSig, supRatio] = correlate(filename1, filename2, pulse, m, fFPGA, fReal, n, c, isAir)
%% General Explanation
%Correlate returns the correlation between two signals using xcorr
%   #1: Extracts the signal from .txt files
%   #2: Deletes the continous compnent.
%   #3: correlates both signals usig perCorr
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
%   the speed of light in vacuum. timeofpulse is the duration of each
%   pulse.
%n stands for the refraction index of the fiber, corresponding to the value
%   of the OTDR
%c stands for the speed of light in vacuum.
%isAir reflects whether the correlation is done in air or not, so that the
%   xaxis and the distance are adjusted 



vt = (1/(fReal*1e6))*(c/n);

%% 1
signal1 = textToSignal(filename1, pulse, m, fFPGA, fReal);
signal2 = textToSignal(filename2, pulse, m, fFPGA, fReal);

%% 2 
% The AC component is substracted.
meanS1 = mean(signal1);
meanS2 = mean(signal2);
signal1 = signal1 - meanS1;
signal2 = signal2 - meanS2;

%% 3
% perCorr is a function used to correlate periodic discrete signals. It is
%   better for this signals than xcorr because in xocrr a signal "enters"
%   into another. Being periodic signals this makes no sense.
% xocrr return the correlation of two signals and the position of that
%   correlation. If the maximum was in the middle of the vector, both signals
%   would be equal.

correlation = perCorr(signal1, signal2);
length(correlation)

%% 4
% In this case, in stead of displaying the lags, the maximum of the
%   correlation is transformed to distance. 
% The x axis is created considering
%   the transformation from delay to distance (each delay corresponds to a
%   given distance). This is done considering the speed of light in the
%   medium given. If the signal travels through the air, the xaxis is
%   divided by 2

xaxis = 0 : vt / length(correlation) * m : (length(correlation)-1)/length(correlation)*m*vt;
if(isAir) 
    xaxis = xaxis / 2;
end
%% 5
% The maximum of the correlation is found and its xaxis position is the
% distance caused by the delay. 
% The SNR of the correlation is then calculated, which compares the peak of
% the correlation with the rms values of the rest of the fnction.

corMax = max(correlation);
pos = find(correlation == corMax);

distance = xaxis(pos);

distanceInter = interpole(xaxis(pos-1:pos+1), correlation(pos-1:pos+1));

snrCor = calculateSNR(correlation, m, pulse);

snrSig = signalSNR(signal1, signal2, correlation);

supRatio = calculateSupression(correlation, pulse);

%% 6
% The correlation is plotted
% 
% figure
% plot(xaxis, correlation, 'b');
% 
% title(strcat('XCORR Correlation. Distance = ',num2str(distance) ,'m. SNR = ',num2str(snr),' dB.'));
% xlim([xaxis(1) xaxis(length(xaxis))]);
% xlabel('Distance [m]');
% ylabel('Correlation');
% 
% txt = strcat('SNR received = ', num2str(signalSNR(signal1, signal2, correlation)), ' dB.');
% dim = [0.2 0.5 0.3 0.3];
% annotation('textbox',dim,'String',txt,'FitBoxToText','on');


end