function [distance] = correlateFPGA(filename1,filename2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
pulse = 40;
m = 256;
vt = 8;

signal1 = textToSignal(filename1);
meanS1 = mean(signal1);
figure, plot(signal1);
signal2 = textToSignal(filename2);
signal2 = -signal2;
hold on
plot(signal2, 'r');
meanS2 = mean(signal2);

signal1 = signal1 - meanS1;
signal2 = signal2 - meanS2;

s1Shift = signal1;

correlation = zeros(m);

for i = 1:m
    correlation(i,1) = dot(s1Shift,signal2);
    
    s1Shift = circshift(s1Shift, pulse);
end

figure, plot(correlation);

corMax = max(correlation);
corMax = corMax(1);
pos = find(correlation == corMax);

if(correlation(pos+1,1) > correlation(pos-1,1))
    pos = pos + interpole(corMax, correlation(pos+1,1));   
else
    pos = pos - interpole(corMax, correlation(pos-1,1));
end

distance = pos*vt;

end

