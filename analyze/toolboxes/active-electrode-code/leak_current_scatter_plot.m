    
    current_channel = 21;
    Vbias_channel = 24;
    lowF = 1;

    % grab all demuxed channels belonging to the trigger channel
    current_data = data((current_channel-1)*numRow+1:current_channel*numRow,:);
    current_data = current_data / vtoi_conversion_factor;   % scale to amps
    
    % filter
    current_data_filtered = EEGlowpass(current_data, lowF, Fs);
    current_data_filtered = mean(current_data_filtered,1);         % average all the demultiplexed current channels back together
    
    
    % grab all demuxed channels belonging to the trigger channel
    vbias_data = data((Vbias_channel-1)*numRow+1:Vbias_channel*numRow,:);
    
    % filter
    vbias_data_filtered = EEGlowpass(vbias_data, lowF, Fs);
    vbias_data_filtered = mean(vbias_data_filtered,1);         % average all the demultiplexed current channels back together
    
  
    scatter(vbias_data_filtered,current_data_filtered)
    xlabel('Vbias (Volts)')
    ylabel('Leakage Current (Amps)')