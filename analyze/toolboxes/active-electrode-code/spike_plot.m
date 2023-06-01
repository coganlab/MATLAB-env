


    close all
    plot(t,xAvg)
    hold on
    scatter(spikeTimes,ones(size(spikeTimes))*5e-4,'g', 'filled')

    for i = 1 : 20: round(size(xAvg,2) / Fs)
    figure(1)    
    axis([i i + 20 -5e-3 5e-3])
    pause
    end
    
    
    