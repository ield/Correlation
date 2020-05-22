clear all;
%% Perfect shift
%snr of received signal
yIdeal = [-10 -11 -14 -15 -16 -17 -18 -20];
%snr of correlation in lineal units multiplied *10
snrIdeal = [126 112 78 71 63 55 49 40];
snrIdeal = 10*log10(snrIdeal/10);
%suppression in lineal units multiplied *10
supIdeal = [100 87 59 58 48 41 37 29];
supIdeal = 10*log10(supIdeal/10);

%% Regular shift
%snr of received signal
yReg = [-10 -11 -12 -13 -14 -15];
%snr of correlation in lineal units multiplied *10
snrReg = [94 84 74 64 57 50];
snrReg = 10*log10(snrReg/10);
%suppression in lineal units multiplied *10
supReg = [76 58 52 32 31 31];
supReg = 10*log10(supReg/10);

%% Plot
y1 = [snrIdeal;supIdeal];
y2 = [snrReg; supReg];

plotQualityFPGA(yIdeal, y1, yReg, y2);

% plot(yIdeal, snrIdeal, yIdeal, supIdeal);
% hold on;
% plot(yReg, snrReg, yReg, supReg);