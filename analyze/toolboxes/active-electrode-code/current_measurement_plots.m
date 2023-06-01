close all;
clear all;

filename = 'C:\Users\TNeuro\Desktop\Electrode Testing\2013-10-15 Active samples (Ship date 10-1-2013)\Sample 4\test_006.mat';
%filename = 'C:\Users\TNeuro\Desktop\Electrode Testing\2013-09-27 BCB active samples\Sample 4\test_006.mat';
load(filename);

save_fig = 'TRUE';


lowF = 1;  % low pass filter current data to below 1 Hz
vtoi_conversion_factor = 200000;    % I = V / 200,000 for current measurement system



% setup output folder and filename
if strcmp(save_fig, 'TRUE')
    dateString = datestr(now, 29);  % get date in yyyy-mm-dd form for output folder
    [pathStr,name] = fileparts(filename);
    mkdir([pathStr,'\Figures ',dateString]);
end



for current_channel = 21:24; % which channel the current measurement BNC is connected
    
    % grab all demuxed channels belonging to the trigger channel
    current_data = data((current_channel-1)*numRow+1:current_channel*numRow,:);
    
    current_data = current_data / vtoi_conversion_factor;   % scale to amps
    
    % filter
    current_data_filtered = EEGlowpass(current_data, lowF, Fs);
    
    % get average current for each row (after 10 seconds settling)
    current_data_individual = mean(current_data_filtered(:,round(Fs*10):end),2);
    
    figure(1)
    bar(current_data_individual)
    xlabel('Rows')
    ylabel('Amps')
    titleStr = 'Leakage Current per Row BNC CH';
    titleStr = strcat(titleStr, num2str(current_channel));
    title(titleStr);
    try
        text(0,min(current_data_individual),info.Note)
    end
    
    if strcmp(save_fig, 'TRUE')
        fileString = [pathStr,'\Figures ',dateString,'\',name,'_',titleStr,'.fig'];
        saveas(gcf, fileString, 'fig')
    end
    
    % average all of these channels
    current_data_overall_filtered = mean(current_data_filtered,1);         % average all the demultiplexed current channels back together
    current_data_overall = mean(current_data,1);         % average all the demultiplexed current channels back together
    
    
    
    figure(2)
    x = 0:1/Fs:size(current_data_overall,2)/Fs-1/Fs;
    x = x / 60;  % convert to minutes
    plot(x,current_data_overall);   % plot unfiltered data
    xlabel('Minutes')
    ylabel('Amps')
    titleStr = 'Leakage Current Over Time BNC CH';
    titleStr = strcat(titleStr, num2str(current_channel));
    title(titleStr);
    try
        text(0,min(current_data_overall),info.Note)
    end
    
    if strcmp(save_fig, 'TRUE')
        fileString = [pathStr,'\Figures ',dateString,'\',name,'_',titleStr,'.fig'];
        saveas(gcf, fileString, 'fig')
    end
    
    
    figure(3)
    plot(x,current_data_overall_filtered)
    xlabel('Minutes')
    ylabel('Amps')
    titleStr = 'Low-Pass Filtered Leakage Current Over Time BNC CH';
    titleStr = strcat(titleStr, num2str(current_channel));
    title(titleStr);
    try
        text(0,min(current_data_overall_filtered),info.Note)
    end
    
    if strcmp(save_fig, 'TRUE')
        fileString = [pathStr,'\Figures ',dateString,'\',name,'_',titleStr,'.fig'];
        saveas(gcf, fileString, 'fig')
    end
    
    current_data_overall_filtered = current_data_overall_filtered * vtoi_conversion_factor;   % scale back to volts
    
    figure(4)
    plot(x,current_data_overall_filtered)
    xlabel('Minutes')
    ylabel('Volts')
    titleStr = 'Low-Pass Filtered Voltage Over Time BNC CH';
    titleStr = strcat(titleStr, num2str(current_channel));
    title(titleStr);
    try
        text(0,min(current_data_overall_filtered),info.Note)
    end
    
    if strcmp(save_fig, 'TRUE')
        fileString = [pathStr,'\Figures ',dateString,'\',name,'_',titleStr,'.fig'];
        saveas(gcf, fileString, 'fig')
    end
    
    
end

