%Engineer: ield
%Company: ALTER-UPM

function [distanceInter] = interpole(xaxis, correlation)
%% General explanation: 
% Interpole Calculates the interpolation of two points
% xaxis is the xaxis in which the points are
% correlation is the y axis in which the points are.
% #1. Deciding which points interpole. The function receives 3 points from
%   which it has to interpole 2: the two highest. It is known that the
%   second point is the peak of the correlation, so it is the highest. It
%   should be decided whether the points that are interpoled are the first
%   two or the last two.
% #2. The interpolation is done.

%% 1
if(xaxis(3) >= xaxis(1))
    d2 = xaxis(3);
    d1 = xaxis(2);
    h2 = correlation(3);
    h1 = correlation(2);
else
    d2 = xaxis(2);
    d1 = xaxis(1);
    h2 = correlation(2);
    h1 = correlation(1);
end

%% 2
distanceInter = d1 + (d2-d1)*(h2 / (h1 + h2));

end

