%Engineer: ield
%Company: ALTER-UPM

function  snr = calculateSNR(sig, m, pulse)
%% General Explanation
%Given a signal calculates the SNR as the relation between the maximum and
%   the rms value of the rest of the peaks
%   In order to find the second maximum and not confuse it with any other
%       points of the triangle, a circshift is done of the length of the pulse,
%       so that the maximum is at the beginning, and the comparison is done
%       without considering the first and the last points.
%Older versions:
%   1.0:    Returned the ratio between the maximum and the second maximum
%   2.0:    Returned the ratio between the maximum and rms value of all the
%           points not involved in the peak of the maximum. This method was
%           discarded since the true snr should be calculated only
%           considering the peaks
%   2.1:    Returned the ratio between the maximum and rms value of all the
%           other peaks.
%
%sig is the correlation
%m is the length of the m sequence, used to calculate (approx) the number
%   of points per pulse so that some can be unconsidered

%% Locating the maximum
% Once the maximum is located a circshift is done so that the points near
% the maximum are not considered.

sigMax = max(sig);
pos = find(sig == sigMax);

sig = circshift(sig, -pos+1);

%% Comparison
%It is compared whether each point is a new second maximum. To calculate
%the power of noise the formula is Eq. 2.22 of pag 9 of T2 of "Apuntes de
%Teoria de la Comunicacion"
lastMax = 0;
noiseRMS = 0;

for i = 1:m-1
    for j = 0:pulse
        if(sig(i*pulse - pulse / 2 + j) > lastMax)
            lastMax = sig(i*pulse - pulse / 2 + j);
        end
    end
    noiseRMS = noiseRMS + lastMax;
    lastMax = 0;
end

noiseRMS = noiseRMS / (m - 1);

%% Calculating snr
% It is used 10log because the measures are powers. The correlation is the
% reult of multiplying v*v. 
snr = 10*log10(sigMax / noiseRMS);

end

