%Engineer: ield
%Company: ALTER-UPM

function [correlation] = correlateFPGA(filename1, filename2, pulse, m, fFPGA, fReal, n, c)
%% General Explanation
%Correlate returns the correlation between two signals as the FPGA would
%   do, using interpolation methods.

%For the moment this function makes no sense: the correlation pulse to
%pulse cannot be done if each pulse has a different number of points.
    
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
signal1 = textToSignal(filename1);

%% 2 
% The AC component is substracted.
meanS1 = mean(signal1);
meanS2 = mean(signal2);
signal1 = signal1 - meanS1;
signal2 = signal2 - meanS2;

%% 3
% The correlation is done multiplying point to point each signal.
%   The correlation at any given point is given by the scalar multiplicatio
%   of both signals (dot), a fixed one, and a shfted one.
% s1Shift is the signal 1 always shifted.

s1Shift = signal1;
correlation = zeros(m);

for i = 1:m
    correlation(i,1) = dot(s1Shift,signal2);
    
    s1Shift = circshift(s1Shift, pulse);
end

figure, plot(correlation);

corMax = max(correlation);
corMax = corMax(1);
pos = find(correlation == corMax);

if(correlation(pos+1,1) > correlation(pos-1,1))
    pos = pos + interpole(corMax, correlation(pos+1,1));   
else
    pos = pos - interpole(corMax, correlation(pos-1,1));
end

distance = pos*vt;

end

