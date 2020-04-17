%Engineer: ield
%Company: ALTER-UPM

%% Descripcion del Script
% This program is made to create the graph that demonstrates the usefulness
% of interpolation

clear;

%% Variable explaination
% x = distance from the beginning of the slope to the first sample
% h = total heigh of the triangle
% h1 = height of the first sample (x = 1)
% h2 = heigth of the second sample (x = 2)

x = 0.2;
h = 2;

% Applying Thales
h1 = x * h;
h2 = h *(1 - x);

xaxisSamples = 0:3;
xaxisCorr = [(xaxisSamples - x) 4];

samples = [0 h1 h2 0];
corr = [0 0 h 0 0];

%% Plotting

plotExInterpole(xaxisSamples, samples, xaxisCorr, corr, (2-x), 2);