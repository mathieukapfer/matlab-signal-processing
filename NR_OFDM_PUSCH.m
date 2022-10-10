
% SNR range from 0 to 10 by step of 0.1 db
EbN0_dB_range = -5:0.5:20;

semilogy(EbN0_dB_range,0) % force log scale in y
hold on

for k = [2:2:8]
    qam = 2^k 
    BER = []
    for SNR = EbN0_dB_range
        BER = [BER ofdm_and_qam_modulation(qam, SNR)]
    end    
    semilogy(EbN0_dB_range,BER)
end
hold off

%  ofdm modulation
function BER = ofdm_and_qam_modulation(qam, SNR)
    k = log2(qam); % nb bits per symbol

    %Generate OFDM Modulated Waveform
    %Set carrier configuration parameters, specifying a subcarrier spacing of 30 kHz and 24 resource blocks (RBs) in the carrier resource array.
    carrier = nrCarrierConfig('SubcarrierSpacing',30,'NSizeGrid',24);

    %Get OFDM information for the specified carrier configuration.
    info = nrOFDMInfo(carrier);

    %Produce the frame resource array by creating and concatenating individual slot resource arrays.
    grid = [];
    data_sent = [];
    for nslot = 0:(info.SlotsPerFrame - 1)

        % Fill the entire resource grid with random data
        %  - generate random data according to modulation and grid size
        data_slot = randi([0 qam-1], carrier.NSizeGrid*12, 14);
        data_sent = [data_sent data_slot];
        x = qammod(data_slot, qam);

        % Fill OFDM symbol with random data
        carrier.NSlot = nslot;
        slotGrid = nrResourceGrid(carrier);
        slotGrid = x;
        grid = [grid slotGrid];
    end

    %Perform OFDM modulation on the resource array for the specified carrier configuration.
    [waveform,info] = nrOFDMModulate(carrier,grid);

    % + Adding 0db SNR
    waveform = awgn(waveform,SNR,"measured");

    % + plot the waveform in frequency domaine
    % plot(abs(fft(waveform)))

    % + OFDM demodumation
    RxGrid=nrOFDMDemodulate(carrier,waveform);
    data_received = qamdemod(RxGrid,qam);

    % compute BER
    data_sent_bin_matrix = int2bit(data_sent, k);
    data_sent_bin = data_sent_bin_matrix(:); % return data in column vector

    data_recv_bin_matrix = int2bit(data_received, k);
    data_recv_bin = data_recv_bin_matrix(:); % return data in column vector

    [nb_err, BER]=biterr(data_sent_bin,data_recv_bin);
end

