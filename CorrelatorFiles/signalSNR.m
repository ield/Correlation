%Engineer: ield
%Company: ALTER-UPM


function [snr] = signalSNR(signal1, signal2, correlation)
%% General Explanation
% Calculates the snr of signal2 knowing signal1 has no noise and the
%   correlation between signal1 and signal2 (correlation).

%% 1. Calculates Power
% Caluclating power of signal1 and signal2.
% Tested and works
powS1 = sigPower(signal1);
powS2 = sigPower(signal2);

%% 2. Calculates k
% k stands for the attenuation caused to the signal

corMax = max(correlation);
k = corMax / (powS1 * length(signal1));

%% 3. Calculates s2 and n2
% s2 stands for only the signal component in signal2
% n2 stands for only the noise component in signal2

s2 = powS1 * (k^2);
n2 = powS2 - s2;

%% 4. Calculates snr in signal2
snr = 10*log10(s2/n2);

end

