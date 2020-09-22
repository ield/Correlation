%Engineer: ield
%Company: ALTER-UPM

function [correlation] = FourierCorr(signal1,signal2)
%% General Explanation
%FourierCorr returns the correlation between two signals using the
%   definition of correlation inFourier's domain, tranforming both signals to
%   Fourier usinf the fft. The correlation is later recovered to time
%   domain by performing the ifft.

TFs1 = fft(signal1);
TFs2 = fft(signal2);

TFcorrelation = TFs1 .* conj(TFs2);
correlation = ifft(TFcorrelation);
end

