%Engineer: ield
%Company: ALTER-UPM

function [interpol] = interpole(m1, m2)
%Interpole Calculates the interpolation of two points
%   m1: first value of correlation
%   m2: second value of corrlation

interpol = m2 / (m1 + m2);
end

