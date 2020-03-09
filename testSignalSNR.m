function [] = testSignalSNR(filename1, filename2, pulse, m, fFPGA, fReal, n, c)
% Done to test SignalSNR

vt = (1/(fReal*1e6))*(c/n);

%% 1
signal1 = textToSignal(filename1, pulse, m, fFPGA, fReal);
signal2 = textToSignal(filename2, pulse, m, fFPGA, fReal);

%% 2 
% The AC component is substracted.
meanS1 = mean(signal1);
meanS2 = mean(signal2);
signal1 = signal1 - meanS1;
signal2 = signal2 - meanS2;

%% 3
% xocrr return the correlation of two signals and the position of that
%   correlation. If the maximum was in the middle of the vector, both signals
%   would be equal.
[correlation, ~] = xcorr(signal1, signal2);

signalSNR(signal1, signal2, correlation);
end

