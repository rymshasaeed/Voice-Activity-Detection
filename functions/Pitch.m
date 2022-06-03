function pitch = Pitch(x, f)
% Pitch() calculates the the pitch for a framed signal
%
% ARGUMENTS:
%           x - frame signal
%           f - sampling frequency
% RETURNS:
%           pitch - fundamental frequency

[n,m] = size(x);
pitch = zeros(n,1);
for k = 1:n
    c = ifft(log(abs(fft(x(k, :), m)) + eps));
    [~, idx] = max(abs(c));
    pitch(k) = f/idx;
end
end