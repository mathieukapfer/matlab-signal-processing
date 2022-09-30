clc
close all
clear all

t = (0:0.01:1)';

hold on


for BPSK = 0:1

    % wave form by BPSK value
    x = sin(2*pi*t+BPSK*pi);
    plot(t, x)
    
    % Apply white Gaussian noise and plot the results.
    for index = 1:10
        y = awgn(x, 0, 'measured');
    
        plot(t, y, ":")
        %scatterplot([x y])
    end

end

legend('Original Signal','Signal with AWGN')

hold off





