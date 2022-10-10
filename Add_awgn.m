clc
%close all
%clear all

step = 0.01
t = (0:step:1-step)';

hold on

for BPSK = 0:1

    % wave form by BPSK value
    x = sin(2*pi*t+BPSK*pi);
    plot(t, x)

    % display power signal
    bandpower(x)

    % Apply white Gaussian noise and plot the results.
    for index = 1:10
        y = awgn(x, 3, 'measured');

        plot(t, y, ":")
        %scatterplot([x y])
    end

    % display power signal
    bandpower(x)


end

legend('Original Signal','Signal with AWGN')

hold off
