clc
%close all
%clear

% SNR range from 0 to 10 by step of 0.1 db
EbN0_dB_range = -3:0.1:20;

% compare BER computed manually and mathematic model 
semilogy(EbN0_dB_range,0) % force log scale in y
hold on
% for BPSK modulation
BER_pratical(EbN0_dB_range/3,2);
BER_theoric(EbN0_dB_range/3);
% for others modulations
BER_pratical(EbN0_dB_range,4);
BER_pratical(EbN0_dB_range,8);
BER_pratical(EbN0_dB_range,16);
BER_pratical(EbN0_dB_range,32);
legend({ ...
    "BPSK theorical" ...
    "BPSK", ...
    "QPSK", ...
    "8QAM", ...
    "16QAM", ...
    "32QAM", ...    
    });
hold off


% Compte BER for a given SNR range
function BER_pratical(EbN0_dB_range, qam)
    BER=[];
    for EbN0 = EbN0_dB_range
        BER=[BER BER_pratical_(EbN0, qam)];
    end

    semilogy(EbN0_dB_range, BER) % , 'DisplayName', sprintf("BER for %dQAM",qam))
end

% Compute BER for a given SNR
function BER = BER_pratical_(EbN0_db, qam)
    % generate random data
    data_sent = randi([0 1], 1000, 1);
    % modulate
    if qam <= 2
        x = genqammod(data_sent, [-1 1]);
    else
        x = qammod(data_sent, qam);
    end
    % add noise
    y = awgn(x, EbN0_db, 'measured');
    % demodulate
    if qam <= 2
        data_received = genqamdemod(y,[-1 1]);
    else
        data_received = qamdemod(y,qam);
    end
    % compute BER
    BER = 0;
    for index = 1:length(data_sent)
        if data_sent(index) ~= data_received(index)
            BER = BER+1;
        end
    end
    BER = BER / length(data_sent)  ;
end

% Compute BER using math modelisation i.e. based on erfc function
function BER_theoric(EbN0_dB_range)
    EbN0 = 10.^(EbN0_dB_range/10);
    BER = 1/2.*erfc(sqrt(EbN0));
    semilogy(EbN0_dB_range, BER) %, 'DisplayName', 'BER theorical (BPSK)')
    grid on
    ylabel('BER')
    xlabel('E_b/N_0 (dB)')
    title('Bit Error Rate for Binary Phase-Shift Keying *')
end

