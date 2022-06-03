clc, clearvars, close all

%% Read the voice signal
[y, Fs] = audioread('male.wav');

% Get time vector
t = (0:length(y)-1)*1/Fs;

% Plot the waveform
figure('name', 'Voice sample')
plot(t, y)
grid on
xlabel('Time (s)')
ylabel('Amplitude')
title('Speech Signal')

%% Compute spectrogram using hamming window
% Time in seconds
Tw = [0.010, 0.100];
Ts = Tw(1)/2;

% Window size in samples
windowSize = [Tw(1)*Fs, Tw(2)*Fs];
windowOverlap = ceil(Ts * Fs);
nfft = [2^nextpow2(windowSize(1)), 2^nextpow2(windowSize(2))];

% Generate hamming window
wideWindow = hamming(windowSize(1));
narrowWindow = hamming(windowSize(2));

% Plot spectograms
figure('name', 'Spectrogram for wide window')
spectrogram(y, wideWindow, windowOverlap, nfft(1), Fs, 'yaxis')
title(['Using ', num2str(nfft(1)), ' DFT points'])

figure('name', 'Spectrogram for narrow window')
spectrogram(y, narrowWindow, windowOverlap, nfft(2), Fs, 'yaxis')
title(['Using ', num2str(nfft(2)), ' DFT points'])

%% Voiced, unvoiced and silence detection
% Here, wide window parameters are being used
window  = ceil(0.010 * Fs);
overlap = ceil(0.005 * Fs);

% Buffer speech signal into matrix of data frames
dataframes = buffer(y, window, overlap, 'nodelay')';
num_df = size(dataframes, 1);

% Initialize vectors
E = zeros(1,num_df);
ZCR = zeros(1,num_df);
decision = zeros(1,num_df);
pitch = zeros(1,num_df);

voiced = 0;
for k = 1:num_df
    % Extract one frame
    x = dataframes(k,:);
    
    % Compute its energy
    E(k) = sum(x.^2);
    
    % Compute its zero-crossing rate
    ZCR(k) = sum(abs(diff(x>0)))/length(x);
    
    % Check if the frame is voice, no voice or, silence
    decision(k) = Detect(E(k), ZCR(k));
    
    % Compute pitch and number of voiced frames
    if decision(k) == 2 % i.e., voice
        voiced = voiced + 1;
        pitch(k) = Pitch(x, Fs);
    end
end

% Plot Energy and Zero-Crossing Rate
figure('name', 'Energy and Zero-Crossing Rate')
subplot(3,1,1)
plot(t, y), grid on
title('Input Signal'), xlabel('Time (s)')

subplot(3,1,2)
plot(E, '-'), grid on
title('Energy'), xlabel('Frames')

subplot(3,1,3)
plot(ZCR, '-'), grid on
title('Zero-Crossing Rate'), xlabel('Frames')

%% Linear predictive coding - LPC Analysis
voicedFrame = zeros(window, 1);
unvoicedFrame = zeros(window, 1);

% Isolate a voiced frame
t_voiced = (0:length(voicedFrame)-1)*1/Fs;
for k = 1:num_df
    if decision(k) == 2
        voicedFrame = dataframes(k, :);
        break;
    end
end

% Isolate an unvoiced frame
t_unvoiced = (0:length(unvoicedFrame)-1)*1/Fs;
for k = 1:num_df
    if decision(k) == 1
        unvoicedFrame = dataframes(k,:);
        break;
    end
end

% LPC on voiced part
[lpc8v,  error8v, Hv_8] = LPC(voicedFrame, 8);
[lpc12v, error12v, Hv_12] = LPC(voicedFrame, 12);
[lpc16v, error16v, Hv_16] = LPC(voicedFrame, 16);

% LPC on unvoiced part
[lpc8u,  error8u,  Hu_8]   = LPC(unvoicedFrame, 8);
[lpc12u, error12u, Hu_12]  = LPC(unvoicedFrame, 12);
[lpc16u, error16u, Hu_16]  = LPC(unvoicedFrame, 16);

% Plot LPC of voiced frames
figure('name', 'LPC - Voiced')
subplot(3,1,1)
plot(t_voiced, voicedFrame)
title('Voiced frame')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(3,1,2)
DFT(voicedFrame, Fs);

subplot(3,1,3)
plot(t_voiced, error8v, t_voiced, error12v, t_voiced, error16v, t_voiced, abs(Hv_8),t_voiced, abs(Hv_12),t_voiced, abs(Hv_16))
title('Prediction Error')
xlabel('Time (s)')
ylabel('Amplitude')
legend('8','12','16','allpole8','allpole12','allpole16','Location', 'EastOutside')

% Plot LPC of unvoiced frames
figure('name', 'LPC - Unvoiced')
subplot(3,1,1)
plot(t_unvoiced,unvoicedFrame)
title('Unvoiced frame')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(3,1,2)
DFT(unvoicedFrame, Fs);

subplot(3,1,3)
plot(t_unvoiced, error8u, t_unvoiced, error12u, t_unvoiced, error16u,t_unvoiced,abs(Hu_8),t_unvoiced, abs(Hu_12),t_unvoiced, abs(Hu_16));
title('Prediction Error')
xlabel('Time (s)')
ylabel('Amplitude')
legend('8','12','16', 'allpole8','allpole12','allpole16', 'Location', 'EastOutside')

%% Extract voice, unvoiced and silence frames
% Initialize vectors
voiced = zeros(1, numel(decision));
unvoiced = zeros(1, numel(decision));
silence =  zeros(1, numel(decision));

for k = 1:numel(decision)
    if decision(k) == 0         % silence
        voiced(k) = NaN;
        unvoiced(k) = NaN;
    elseif decision(k) == 1     % unvoiced
        unvoiced(k) = 1;
        voiced(k) = NaN;
        silence(k) = NaN;
    else                        % voiced
        voiced(k) = 2;
        unvoiced(k) = NaN;
        silence(k) = NaN;
    end
end

% Plot voice activity detection
figure('name', 'Voice Activity Detection')
subplot(2,1,1), plot(t,y), grid on
title('Input Signal'), xlabel('Time (s)')

subplot(2,1,2)
plot(1:num_df, silence, 'b', ...
     1:num_df, unvoiced, 'y+', ...
     1:num_df, voiced, 'r*')
grid on, ylim([-1 3])
title('Voiced-Unvoiced-Silence Detection'), xlabel('Frames'), ylabel('Classification')
legend('silence', 'unvoiced', 'voiced')

%% Pitch Estimation
for k = 1:length(pitch)
    if pitch(k) == 0
        pitch(k) = NaN;
    end
end
disp('Estimated pitch in voice activity:')
fprintf('%.1f Hz\n', unique(pitch(pitch>0)))

