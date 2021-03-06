%Engineer: ield
%Company: ALTER-UPM

function [supRatio] = calculateSupression(correlation, pulse)
%% General Explanation
% This function calculates the suppression ratio of the correlation: the
%   relationship between the first two maxima.
% For this, it finds the maximum of the function and isolates it (at the
%   beginning. Then it looks for the second maximum one pulse after the
%   beginning (where the end maximum is) and one pulse before the end (where the
%   maximum also is because the correlation is periodic)
% pulse stands for the ideal number of points of a pulse. It is ideal
%   because the real frequency does not match the desired one. Therefore,
%   not every pulse has the same amount of points.

%% Calulate and isolate the maximum

corMax = max(correlation);
pos = find(correlation == corMax);

correlation = circshift(correlation, -pos+1);

%% Find the second maximum
secMax = 0;

if(pulse == 1)
    for i = 3:(length(correlation)-pulse)
        if(correlation(i)> secMax)
            secMax = correlation(i);
        end
    end
else
    for i = 2*pulse:(length(correlation)-2*pulse)
        if(correlation(i)> secMax)
            secMax = correlation(i);
            iMax = i;
        end
    end
end

%% Calculate the ratio
supRatio = 10*log10(corMax / secMax);

end

