clc
%close all
%clear

% SNR range from 0 to 10 by step of 0.1 db
EbN0_dB_range = -10:0.1:20;

% compare BER computed manually and mathematic model
semilogy(EbN0_dB_range,0) % force log scale in y
hold on
% for BPSK modulation (reduce SNR range)
BER_theoric(EbN0_dB_range/3);
BER_pratical(EbN0_dB_range/3,2);
% for others modulations
BER_pratical(EbN0_dB_range,4);
BER_pratical(EbN0_dB_range,16);
BER_pratical(EbN0_dB_range,64);
BER_pratical(EbN0_dB_range,256);
%BER_theoric_QAM(EbN0_dB_range/2,4);
legend({ ...
    "BPSK theorical" ...
    "BPSK", ...
    "QPSK", ...
    "16QAM", ...
    "64QAM", ...
    "256QAM", ...
    });
hold off


% Compte BER for a given SNR range
function BER_pratical(EbN0_dB_range, qam)
    BER=[];
    for EbN0 = EbN0_dB_range
        EsN0=EbN0 + 10*log10(log2(qam))
        BER=[BER BER_pratical_(EsN0, qam)];
    end

    semilogy(EbN0_dB_range, BER) % , 'DisplayName', sprintf("BER for %dQAM",qam))
end

% Compute BER for a given SNR
function BER = BER_pratical_(EsN0_db, qam)
    % modulation order
    k=log2(qam);

    % generate random data
    data_sent = randi([0 qam-1], 10000, 1);

    % modulate
    if qam <= 2
        % force x as comlex (even if imginary part is null)
        x = genqammod(data_sent, [-1 1]);
    else
        x = qammod(data_sent, qam);
    end

    % add noise
    y = awgn(x, EsN0_db, 'measured');

    % demodulate
    if qam <= 2
        % force x as complex
        data_received = genqamdemod(y,[-1 1]);
    else
        data_received = qamdemod(y,qam);
    end

    % compute BER
    data_sent_bin_matrix = int2bit(data_sent, k);
    data_sent_bin = data_sent_bin_matrix(:); % return data in column vector

    data_recv_bin_matrix = int2bit(data_received, k);
    data_recv_bin = data_recv_bin_matrix(:); % return data in column vector

    [nb_err, BER]=biterr(data_sent_bin,data_recv_bin);

end

% Compute BER using math modelisation i.e. based on erfc function
function BER_theoric(EbN0_dB_range)
    EbN0 = 10.^(EbN0_dB_range/10);
    BER = 1/2*erfc(sqrt(EbN0));
    plot(EbN0_dB_range, BER) %, 'DisplayName', 'BER theorical (BPSK)')
    grid on
    ylabel('BER')
    xlabel('E_b/N_0 (dB)')
    title('BER for xPSK & xQAM')
end

% [Not working yet]
function BER_theoric_QAM(EbN0_dB_range,qam)
    EbN0 = 10.^(EbN0_dB_range/10);
    BER = 4/log2(qam)*1/2*erfc(sqrt((3*EbN0*log2(qam)/(qam-1))));
    plot(EbN0_dB_range, BER) %, 'DisplayName', 'BER theorical (BPSK)')
    %grid on
    %ylabel('BER')
    %xlabel('E_b/N_0 (dB)')
    %title('Bit Error Rate for Binary Phase-Shift Keying *')
end
