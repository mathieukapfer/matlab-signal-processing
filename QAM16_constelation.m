clc
%close all
%clear

% Transmit and receive data using a nonrectangular 16-ary constellation in the presence of Gaussian noise. Show the scatter plot of the noisy constellation and estimate the symbol error rate (SER) for two different signal-to-noise ratios.

% 16-QAM constellation based on the V.29 standard for telephone-line modems.
% c = [-5 -5i 5 5i -3 -3-3i -3i 3-3i 3 3+3i 3i -3+3i -1 -1i 1 1i];

% 16-QAM
% c = [-3+3i -1+3i 1+3i 3+3i -3+1i -1+1i 1+1i 3+1i -3-1i -1-1i 1-1i 3-1i -3-3i -1-3i 1-3i 3-3i];

% QPSK
% c = [-1+i 1+i -1-i 1-i];

% BPSK
c = [-1 +1];

M = length(c);

% Generate random symbols.
% data = randi([0 M-1],2000,1);
data = randi(1, 2000,1);

% Modulate the data by using the genqammod function. General QAM modulation is necessary because the custom constellation is not rectangular.
modData = genqammod(data,c);

% Pass the signal through an AWGN channel having a 20 dB signal-to-noise ratio (SNR).
rxSig = awgn(modData,0,'measured');

% Display a scatter plot of the received signal and the reference constellation, c.
h = scatterplot(rxSig);
hold on
scatterplot(c,[],[],'r*',h)
grid
hold off

% Demodulate the received signal by using the genqamdemod function. Determine the number of symbol errors and the symbol error ratio.

demodData = genqamdemod(rxSig,c);
[numErrors,ser] = symerr(data,demodData)

