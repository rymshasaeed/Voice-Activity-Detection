function [coef, error, allpole] = LPC(x, order)
% LPC() calculates the LPC coefficients and performs signal estimation
%
% ARGUMENTS:
%           x - signal
%           order - pth order of the filter
% RETURNS:
%           coef - LPC coefficients
%           error - error estimate
%           allpole - all-pole transfer function

[coef, g] = lpc(x, order);
coef = 0 - coef(2:end);
est_x = filter(coef, 1, x);
error = x - est_x;
allpole = filter(sqrt(g), coef, est_x);

end