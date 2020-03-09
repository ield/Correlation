%Engineer: ield
%Company: ALTER-UPM

function [power] = sigPower(signal1)
%% General Explanation
% Calculates the power of a given function.
% The formula of the power of a signal is in Santiago Zazo apuntes

power = 0;
for i = 1:length(signal1)
    power = power + signal1(i)^2;
end
power = power / length(signal1);

end

