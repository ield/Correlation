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

snr = 0;

end

