function decision = Detect(energy, zcr)
% Detect() classifies the frame to three main classes: 
%           VOICED
%           UNVOICED, and 
%           SILENCE
% The tresholds are calculated by observing the zcr and energy plot.
%
% ARGUMENTS:
%           energy - energy of the frame
%           zcr - zero-crossing rate of the frame
% RETURNS:
%           decision - 0 for silence, 1 for unvoiced, 2 for voiced

low_energy = 4;
high_energy = 10;
low_zcr = 0.15;
high_zcr = 0.3;
n = length(energy);
decision = zeros(1,n);

for k = 1:n
    if energy(k) < low_energy
        if zcr(k) < low_zcr
            decision(k) = 0;
        elseif zcr(k) < high_zcr
            decision(k) = 0;
        end
    elseif energy(k) < high_energy
        if zcr(k) < low_zcr
            decision(k) = 1;
        elseif zcr(k) < high_zcr
            decision(k) = 2;
        else
            decision(k) = 1;
        end
    else
        decision(k) = 2;
    end
end
end