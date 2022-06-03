# Voice Activity Detection
The project implements a voice activity detection algorithm and performs pitch estimation. 
The proposed algorithm uses audio inputs and detects voiced, unvoiced and silence durations in a speech signal. The analysis is carried out by observing the spectral properties of the signal in terms of spectrograms computed using hamming window. Afterwards, the signal is buffered into data frames and the short time energy (STE) in each frame as well as the zero-crossing rate (ZCR) is calculated. A decision is made on voice activity by comparing the energies and ZCR. In order to check the performance of the method, individual voiced and unvoiced segments are extracted from the speech signal and linear predictive coding (LPC) is employed.
The findings show that the algorithm is able to classify voice activity in speech. The approach could be further extended to real-time signals given that certain parameters (i.e., noise content, number of audio channels, energy, correlation, short time zero-crossing etc.) are met.

## Voice Activity Detection Methods
The job of recognizing the vocal folds activity zones in a speech signal is known as voice activity detection. Unvoiced speech and silence zones are included in non-voice speech. Voice/non-voice detectors are utilized in a variety of speech-processing applications, including speech coding, augmentation, and recognition. Approaches for detecting speech activity can be divided into two categories: 
- time domain methods, and
- spectral domain methods.

Energy, periodicity, and short-term correlation properties of voiced speech areas are exploited by time and spectral domain VAD algorithms. For voice detection, time domain characteristics such as the zero-crossing rate (ZCR), auto-correlation coefficients, and long-term normalized auto-correlation peak intensity are employed. The linear predictive coding (LPC) coefficients and spectral harmonicity in voiced areas is used by spectral domain VAD algorithms. In loud speech, harmonic peaks in the amplitude spectrum of voiced speech areas are frequently retained.

### a. Zero-Crossing Rate
A signal's zero-crossing rate (ZCR) is the rate at which the signal changes its sign during the frame. In other words, it is the number of times the signal value changes from positive to negative and back, divided by the frame’s duration. A voice signal’s magnitude in a frame travel across the zero axis several times. While a voiced speech frame has a limited quantity of sign changes owing to the periodic flow stimulation of the vocal tract, the zero-crossing count for an unvoiced speech frame rapidly grows due to the noise like airflow. It can also be used as a frequency indicator. As a result, the zero-crossing count is utilized to categorize speech signals as voiced or unvoiced. The ZCR is the average value of a signal sign change throughout a frame. For a 20ms analysis frame, average ZCR values for a voiced speech area are less than 0.1, but for an unvoiced speech region, it is larger than 0.3.

### b. Short Time Energy
The amplitude changes in a voice signal are reflected in its short time energy (STE). The energy of spoken speech segments is higher than that of unvoiced speech parts. A voice signal’s peak magnitude fluctuates over time. Time-domain analysis can reveal information about a signal’s voiced/unvoiced decision since magnitudes in voiced areas are substantially higher than in unvoiced regions. A windowing of length N is conducted as a first step in the short time analysis of a speech signal, with a window size of 20–50ms to reflect amplitude changes. After that, for each window, the STE of the windowed signal is determined. A silent duration at the start of the speech signal is used to calculate the threshold value for a VAD decision.

### c. Linear Predictive Coding Coefficients
Linear predictive coding (LPC) is a method for compressing the spectral envelope of a digital voice signal using information from a linear predictive model. It is widely utilized in audio signal processing and speech processing. LPC coefficients represent the spectral form and can be used to recognize speech. LPC coefficients indicate the linearly predicted logarithmic magnitude spectrum’s Fourier transform visualization. Because of its capacity to properly depict speech waveforms and properties with a small number of variables, LPC analysis is widely used in the field of speech processing. Noise is not a problem with LPC coefficients. When compared to other spectral estimation features, LPC features have a reduced error rate. Higher-order LPC coefficients are theoretically constrained, resulting in a vast array of variances when shifting from lower-order coefficients to the higher-order coefficients.

## Results
<p align="center">
  <img src="https://github.com/rimshasaeed/Voice-Activity-Detection/blob/main/results/figure1.jpg", alt="speech signal" width="50%">
  <br>
  <i>Input speech signal</i>
</p>
<p align="center">
  <img src="https://github.com/rimshasaeed/Voice-Activity-Detection/blob/main/results/figure2.jpg", alt="Narrow window spectrogram" width="50%">
  <br>
  <i>Narrow window spectrogram</i>
</p>
<p align="center">
  <img src="https://github.com/rimshasaeed/Voice-Activity-Detection/blob/main/results/figure3.jpg", alt="Wide window spectrogram" width="50%">
  <br>
  <i>Wide window spectrogram</i>
</p>
<p align="center">
  <img src="https://github.com/rimshasaeed/Voice-Activity-Detection/blob/main/results/figure4.jpg", alt="zero-crossing rate" width="50%">
  <br>
  <i>Energy and zero-crossing rate</i>
</p>
<p align="center">
  <img src="https://github.com/rimshasaeed/Voice-Activity-Detection/blob/main/results/figure5.jpg", alt="LPC for voiced frame" width="50%">
  <br>
  <i>LPC for voiced frame</i>
</p>
<p align="center">
  <img src="https://github.com/rimshasaeed/Voice-Activity-Detection/blob/main/results/figure6.jpg", alt="LPC for unvoiced frame" width="50%">
  <br>
  <i>LPC for unvoiced frame</i>
</p>
<p align="center">
  <img src="https://github.com/rimshasaeed/Voice-Activity-Detection/blob/main/results/figure7.jpg", alt="Voice activity detection" width="50%">
  <br>
  <i>Voice activity detection</i>
</p>

#### Pitch Estimation
```
Estimated pitch in voice activity:
100.0 Hz
22050.0 Hz
44100.0 Hz
```
