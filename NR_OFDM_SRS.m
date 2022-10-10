%%  ofdm modulation

%Generate OFDM Modulated Waveform
%Generate a waveform by performing OFDM modulation of a resource array that contains sounding reference signals (SRSs). The resource array spans an entire frame.
%Set carrier configuration parameters, specifying a subcarrier spacing of 30 kHz and 24 resource blocks (RBs) in the carrier resource array.
carrier = nrCarrierConfig('SubcarrierSpacing',30,'NSizeGrid',24);
%Configure SRS parameters, setting the slot periodicity to 2 and the offset to zero.
srs = nrSRSConfig('SRSPeriod',[2 0]);
%Get OFDM information for the specified carrier configuration.
info = nrOFDMInfo(carrier);
%Produce the frame resource array by creating and concatenating individual slot resource arrays.
grid = [];
for nslot = 0:(info.SlotsPerFrame - 1)
    carrier.NSlot = nslot;
    slotGrid = nrResourceGrid(carrier);
    ind = nrSRSIndices(carrier,srs);
    sym = nrSRS(carrier,srs);
    slotGrid(ind) = sym;
    grid = [grid slotGrid];
end

%Perform OFDM modulation on the resource array for the specified carrier configuration.
[waveform,info] = nrOFDMModulate(carrier,grid);

% + Adding 0db SNR
waveform = awgn(waveform,0,"measured")

% + plot the waveform in frequency domaine
plot(abs(fft(waveform)))

% + OFDM demodumation
RxGrid=nrOFDMDemodulate(carrier,waveform)


