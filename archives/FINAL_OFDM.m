clc;
%clear;
%close all;

modulation_order = 64

%% Initializing parameters
L=51*12*4 % OFDM block length of QPSK : RB * 12 * nb bits/RE
Ncp=round(L*0.0625); % Length of OFDM CP
%% Transmitter


% data generation
Tx_data=randi([0 modulation_order-1],L,Ncp);
%%%%%%%%%%%%%%%%%%% QAM modulation %%%%%%%%%%%%%%%%%%%%%
mod_data=qammod(Tx_data,modulation_order);
% Serial to Parallel
s2p=mod_data.';
% IFFT
am=ifft(s2p);
% Parallel to series
p2s=am.';
% Cyclic Prefixing
CP_part=p2s(:,end-Ncp+1:end); %Cyclic Prefix part to be appended.
cp=[CP_part p2s];

%%  Receiver

% Adding Noise using AWGN
SNRstart=0;
SNRincrement=1;
SNRend=10;
c=0;
r=zeros(size(SNRstart:SNRincrement:SNRend));
for snr=SNRstart:SNRincrement:SNRend
    c=c+1;
    noisy=awgn(cp,snr,'measured');
% Remove cyclic prefix part
    cpr=noisy(:,Ncp+1:Ncp+Ncp); %remove the Cyclic prefix
% series to parallel
    parallel=cpr.';
% FFT
    amdemod=fft(parallel);
% Parallel to serial
    rserial=amdemod.';
%%%%%%%%%%%%%%%%%%%% QAM demodulation %%%%%%%%%%%%%%%%%%%%%
    Umap=qamdemod(rserial,modulation_order);
% Calculating the Bit Error Rate
    [n, r(c)]=biterr(Tx_data,Umap)

end
snr=SNRstart:SNRincrement:SNRend
%% Plotting BER vs SNR

hold on
semilogy(snr,r,'-ok')
grid on;

title('OFDM Bit Error Rate .VS. Signal To Noise Ratio');
ylabel('BER');
xlabel('SNR [dB]');

% hold off