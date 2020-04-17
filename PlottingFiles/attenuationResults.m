%Engineer: ield
%Company: ALTER-UPM

%% Descripcion del Script
% This program is made to plot the attenuation results, which re defined in
% the arrays.

clear;

%%

attenuation = [23 25 28 45 48 55 58];
corrSNR = [18.15 18.28 16.70 10.4 10.88 7.89 7.30];
corrSup = [16.31 13.28 10.98 2.52 2.93 4.77 3.29];

plotAttenuationResults(attenuation, [corrSNR; corrSup]);
