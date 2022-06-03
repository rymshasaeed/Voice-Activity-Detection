function [Y, fs] = DFT(y, f)
% DFT() computes and plot sdcrete fourier transform of a given signal y
%
% ARGUMENTS:
%           x - signal
%           f - sampling frequency
% RETURNS:
%           Y - DFT of the input signal y
%           fs - sampling frequency

L = length(y);
nfft = 2^nextpow2(L); 
Y = fft(y, nfft)/L;
fs = f/2*linspace(0, 1, nfft/2+1);

% Plot single-sided amplitude spectrum
plot(fs, 2*abs(Y(1:nfft/2+1))) 
title('Discrete Fourier Transform')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
end