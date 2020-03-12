%Engineer: ield
%Company: ALTER-UPM

function [correlation] = perCorr(signal1,signal2)
%% General Explanation
% perCorr performs the correlation operation between two periodic
%   signals(signal1 and signal2).
% It is better than xcorr because in xcorr one signal enters to the other
%   and then exits. This approximation is only valid for very long signals
%   (view correlation theories are valid for n -> infinity), and is
%   pointless when considering periodic signals, since only with a period
%   suffices. With circshift, the periodic part exitting, does not exit
%   anymore. Instead, it reentes. Therefore, it is simpler to calculate the
%   correlation
% With dot, the scalar product of two arrays is calculated, ideal for the
%   correlation operation
% Finally, the absolute value of the correlation is considered, for only
%   this is important for snr considerations.

    correlation = signal1;
    
    for i = 1:length(correlation)
        correlation(i) = dot(signal1, signal2);
        signal1 = circshift(signal1, 1);
    end
    
    correlation = abs(correlation);
end

