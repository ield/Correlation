%Engineer: ield
%Company: ALTER-UPM

function [correlation] = correlate(filename1, filename2, pulse, m, fFPGA, fReal, n, c)
%% General Explanation
%Correlate returns the correlation between two signals using xcorr
%   #1: Extracts the signal from .txt files
%   #2: Deletes the continous compnent.
%   #3: correlates both signals usig xocrr
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
% xocrr return the correlation of two signals and the position of that
%   correlation. If the maximum was in the middle of the vector, both signals
%   would be equal.
[correlation, ~] = xcorr(signal1, signal2);

%% 4
% In this case, in stead of displaying the lags, the maximum of the
%   correlation is transformed to distance. In order to make this
%   conversion, several aspects are taken into account.
%   1.  The correlation is a periodic function, and the xcorr function only
%       displays the first two periods. If the result of the xcorr function
%       was plotted, the most reliable information remains between the
%       first and the third quarter of the values of the array. This is
%       because the xcorr multiplies values, and in these points of the
%       array, the functions are more superpossed. Therefore, these points
%       are the only ones considered
%   2.  The negative values of the correlation match with the first delays,
%       and since the function is periodic, the last values (of the
%       selected ones) from right to left match with the next delays. The
%       value closest to 0 on the right is the last delay measurable.
%       Therefore, a circhift is done to place the last values at the end
%       (since the function is periodic, nothing changes).
%   3.  Finally the function is inverted so that the first delays are
%       closest to 0
% Now that the shifts are ordered timely, an x axis is created considering
%   the transformation from delay to distance (each delay corresponds to a
%   given distance)


%Step 1
ini = (length(correlation)-1)/4;
fin = (length(correlation)-1)*3/4;
correlation = correlation(ini:fin);

%Step 2
correlation = circshift(correlation, (length(correlation)-1)/2-1);

%Step 3
correlation = flip(correlation);


correlation = abs(correlation);

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
plot(xaxis, correlation, 'b');

title(strcat('XCORR Correlation. Distance = ',num2str(distance) ,'m. SNR = ',num2str(snr),' dB.'));
xlim([xaxis(1) xaxis(length(xaxis))]);
xlabel('Distance [m]');
ylabel('Correlation');


end