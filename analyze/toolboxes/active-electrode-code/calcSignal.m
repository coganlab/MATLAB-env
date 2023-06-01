
function [signal, meanVal, medianVal]  = calcSignal(data, signalType, startSec, endSec, numRow, numCol, numChan, Fs, save_fig, pathStr, filename, headstage_gain, BncChannel, gain_working_threshold, noise_low, noise_high)

% startSec - number of seconds to chop off the start of the file
% endSec - number of seconds to chop off the end of the file
% BncChannel = 23;        % feed in the signal generator (source) to this channel to calculate gain

% gain_working_threshold = 0.5;

if strcmp(signalType, 'SIGNAL')
    % filter the data around the signal freq
    dataf = EEGbandpass(data(:,round(startSec*Fs):end-round(endSec*Fs)),5,15,Fs);
end

if strcmp(signalType, 'NOISE')
    % filter the data full bandwidth
    %dataf = EEGbandpass(data(:,round(startSec*Fs):end-round(endSec*Fs)),1,floor(Fs/2),Fs);
    
    % filter the data 300 Hz band
    dataf = EEGbandpass(data(:,round(startSec*Fs):end-round(endSec*Fs)),1,300,Fs);
    %dataf = EEGbandpass(data(:,round(startSec*Fs):end-round(endSec*Fs)),1,50,Fs);
end

% discard edge effects
dataf = dataf(:,round(3*Fs):end-round(3*Fs));
%dataf = data;

if (exist('save_fig', 'var') == 0) || (size(save_fig,1) == 0)
    save_fig = 'FALSE';
end

% setup output folder and filename
if strcmp(save_fig, 'TRUE')
    dateString = datestr(now, 29);  % get date in yyyy-mm-dd form for output folder
    [~,name] = fileparts(filename);
    mkdir([pathStr,'\Figures ',dateString]);
end



% test filtered data
%plots(dataf, numCol, numRow, 1, numChan, Fs)

if strcmp(signalType, 'SIGNAL')
    % calculate p-p signal based on standard deviation
    %signal = reshape(std(dataf(1:numCol*numRow,:)'),numRow,numCol)*2*sqrt(2);
    
    
    signal = [];
    
    % BNC recording of sine wave
    
    %inputSig = dataf(368,:);
    inputSig = mean(dataf((BncChannel-1)*numRow+1:(BncChannel-1)*numRow+numRow,:));
    
    
    dataf = dataf ./ headstage_gain;  % headstage gain of 5
    
    figure
    signal = reshape(std(dataf(1:numCol*numRow,:)'),numRow,numCol)*2*sqrt(2);
    imagesc(signal * 1000)
    colorbar
    titleStr = 'Peak to peak amplitude (mV)';
    title(titleStr);
    
    if strcmp(save_fig, 'TRUE')
        fileString = [pathStr,'\Figures ',dateString,'\',name,'_',titleStr,'.fig'];
        saveas(gcf, fileString, 'fig')
    end
    
    % scale input data to + / - 1 range before xcov, based on BNC amplitude
    %fudge_factor = 20;
    
    bnc_pp = std(inputSig) * 2 * sqrt(2);
    disp(['  BNC p-p input voltage ' signalType ' value         (mV) : ' num2str(bnc_pp*1000)     ]);
    fudge_factor = 2 / bnc_pp;
    
    % calculate gain using xcov
    for i = 1:numRow*numCol
        correlation = xcov(fudge_factor*inputSig, fudge_factor*dataf(i,:), 'unbiased');
        signal(i) = correlation(length(dataf(1,:))) * 2;
    end
    signal = reshape(signal,numRow,numCol);
    
end

if strcmp(signalType, 'NOISE')
    dataf = dataf ./ headstage_gain;  % headstage gain of 5
    
    % calculate p-p signal based on standard deviation
    signal = reshape(std(dataf(1:numCol*numRow,:)'),numRow,numCol);
end


if strcmp(signalType, 'SIGNAL')
    % define an electrode as working if its gain is greater than gain_working_threshold
    working = signal(:) > gain_working_threshold;
    workingMap = reshape(working,numRow,numCol);
end

if strcmp(signalType, 'NOISE')
    % define an electrode as working if its amplitude is less than 3x
    % the median value
    workingMap = reshape(((signal(:) > noise_low) & (signal(:) < noise_high)),numRow,numCol);
    %workingMap(reshape(signal(:) < 2e-6,numRow,numCol)) = 0;
end

% calculate and display some metrics about the data, but only on working
% channels
meanVal = mean(signal(workingMap == 1));
medianVal = median(signal(workingMap == 1));
stdVal = std(signal(workingMap == 1));



numWorking = sum(sum(workingMap));
percentWorking = numWorking / (numRow * numCol);


if strcmp(signalType, 'SIGNAL')
    disp(['  Gain Mean value         (unitless) : ' num2str(meanVal)     ]);
    disp(['  Gain Median value       (unitless) : ' num2str(medianVal)   ]);
    disp(['  Gain Standard Deviation (unitless) : ' num2str(stdVal)      ]);
    
end

if strcmp(signalType, 'NOISE')
    disp(['  Mean ' signalType ' noise value         (RMS) : ' num2str(meanVal)     ]);
    disp(['  Median ' signalType ' noise value       (RMS) : ' num2str(medianVal)   ]);
    disp(['  Standard ' signalType ' noise Deviation (RMS) : ' num2str(stdVal)      ]);
end


disp(['  Number of working electrodes  : ' num2str(numWorking)       ]);
disp(['  Percentage working electrodes : ' num2str(percentWorking*100)   ]);



%%%%%%%%%%%%%%%%%%%% plot a color map of gain %%%%%%%%%%%%%%%%%%%%%%%%%
figure
if strcmp(signalType, 'SIGNAL')
    imagesc(signal, [0 1])
    titleStr = 'Electrode Gain (unitless)';
    title(titleStr);
    colorbar
    textString = ['Average Gain: ' num2str(meanVal) '    Median Gain: '  num2str(medianVal) '     Number of working electrodes: ' num2str(numWorking) '    Yield: ' num2str(percentWorking*100) char(37)];
    uicontrol('Style', 'text', 'String', textString, 'Units','normalized', 'Position', [0.0 0.0 1 0.05]);
end

if strcmp(signalType, 'NOISE')
    imagesc(signal)
    titleStr = 'RMS Noise Amplitude (RMS)';
    title(titleStr);
    textString = ['Mean noise (RMS): ' num2str(meanVal) '   Median noise (RMS): ' num2str(medianVal) '   Standard dev (RMS) : ' num2str(stdVal)];
    uicontrol('Style', 'text', 'String', textString, 'Units','normalized', 'Position', [0.0 0.0 1 0.05]);
    colorbar
end

if strcmp(save_fig, 'TRUE')
    fileString = [pathStr,'\Figures ',dateString,'\',name,'_',titleStr,'.fig'];
    saveas(gcf, fileString, 'fig')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
imagesc(workingMap)
colorbar
titleStr = 'Working (1) vs non-working (0) electrodes';
title(titleStr);
textString = ['Number of working electrodes: ' num2str(numWorking) '    Percentage working electrodes: ' num2str(percentWorking*100) char(37)];
uicontrol('Style', 'text', 'String', textString, 'Units','normalized', 'Position', [0.0 0.0 1 0.05]);

if strcmp(save_fig, 'TRUE')
    fileString = [pathStr,'\Figures ',dateString,'\',name,'_',titleStr,'.fig'];
    saveas(gcf, fileString, 'fig')
end

% map and histogram of DC offset values
% calculate average DC offset from unfiltered data
dc_vals = reshape(mean(data(1:numRow*numCol,round(startSec*Fs):end-round(endSec*Fs)),2),numRow,numCol);
dc_vals_working = dc_vals(workingMap == 1);

% imagemap of DC offsets
figure
imagesc(dc_vals);
colorbar
titleStr = 'Average DC Offset (V)';
title(titleStr);
textString =['Min offset: ' num2str(min(dc_vals_working(:))) '    Max offset: '  num2str(max(dc_vals_working(:))) '     Average offset: ' num2str(mean(dc_vals_working(:)))];
uicontrol('Style', 'text', 'String', textString, 'Units','normalized', 'Position', [0.0 0.0 1 0.05]);

if strcmp(save_fig, 'TRUE')
    fileString = [pathStr,'\Figures ',dateString,'\',name,'_',titleStr,'.fig'];
    saveas(gcf, fileString, 'fig')
end

% Histogram of Average DC Offsets for Working Channels (Gain > gain_working_threshold)
figure
hist(dc_vals_working(:),100);
titleStr = ['Histogram of Average DC Offsets for Working Channels (Gain over ' num2str(gain_working_threshold) ' )'];
title(titleStr);
textString =['Min offset: ' num2str(min(dc_vals_working(:))) '    Max offset: '  num2str(max(dc_vals_working(:))) '     Average offset: ' num2str(mean(dc_vals_working(:)))];
uicontrol('Style', 'text', 'String', textString, 'Units','normalized', 'Position', [0.0 0.0 1 0.05]);

if strcmp(save_fig, 'TRUE')
    fileString = [pathStr,'\Figures ',dateString,'\',name,'_',titleStr,'.fig'];
    saveas(gcf, fileString, 'fig')
end

% plot a histogram of values
figure
if strcmp(signalType, 'SIGNAL')
    hist(signal(:), 500)
    titleStr = 'Histogram of Gain (unitless)';
    title(titleStr);
    textString = ['Average Gain: ' num2str(meanVal) '    Median Gain: '  num2str(medianVal) '     Number of working electrodes: ' num2str(numWorking) '    Yield: ' num2str(percentWorking*100) char(37)];
    uicontrol('Style', 'text', 'String', textString, 'Units','normalized', 'Position', [0.0 0.0 1 0.05]);
end

if strcmp(signalType, 'NOISE')
    hist(signal(:), 500)
    titleStr = ['Histogram of RMS Noise Amplitude (RMS)'];
    title(titleStr);
    textString = ['Mean noise (RMS): ' num2str(meanVal) '   Median noise (RMS): ' num2str(medianVal) '   Standard dev (RMS) : ' num2str(stdVal)];
    uicontrol('Style', 'text', 'String', textString, 'Units','normalized', 'Position', [0.0 0.0 1 0.05]);
end

if strcmp(save_fig, 'TRUE')
    fileString = [pathStr,'\Figures ',dateString,'\',name,'_',titleStr,'.fig'];
    saveas(gcf, fileString, 'fig')
end

% if strcmp(signalType, 'SIGNAL')
%     % compare filtered data to raw data to estimate noise
%     dataf2 = EEGhighpass(data(:,round(startSec*Fs):end-round(endSec*Fs)),2,Fs);
%     dataf2 = dataf2(:,round(2*Fs):end-round(2*Fs));
%     dataf2 = dataf2 ./ headstage_gain;
%
%     noise_est = std((dataf - dataf2),[],2);
%     noise_est = reshape(noise_est(1:numRow*numCol),numRow,numCol);
%     noise_est(workingMap == 0) = 0; % blank out noise from non-working electrodes
%
%     meanVal_noise = mean(noise_est(workingMap == 1));
%     medianVal_noise = median(noise_est(workingMap == 1));
%
%     figure
%     imagesc(noise_est)
%     colorbar
%     titleStr = 'Estimated Noise (V RMS)';
%     title(titleStr);
%
%     textString1 = ['  Mean noise estimate (RMS) : ' num2str(meanVal_noise)];
%     textString2 = ['  Median noise estimate (RMS) : ' num2str(medianVal_noise)   ];
%     uicontrol('Style', 'text', 'String', [textString1 ' ' textString2], 'Units','normalized', 'Position', [0.0 0.0 1 0.05]);
%     disp(textString1);
%     disp(textString2);
%
%     if strcmp(save_fig, 'TRUE')
%         fileString = [pathStr,'\Figures ',dateString,'\',name,'_',titleStr,'.fig'];
%         saveas(gcf, fileString, 'fig')
%     end
%
%     figure
%     hist(noise_est(workingMap == 1), 100)
%     titleStr = 'Histogram of Estimated Noise (V RMS)';
%     title(titleStr);
%     uicontrol('Style', 'text', 'String', [textString1 ' ' textString2], 'Units','normalized', 'Position', [0.0 0.0 1 0.05]);
%
%     if strcmp(save_fig, 'TRUE')
%         fileString = [pathStr,'\Figures ',dateString,'\',name,'_',titleStr,'.fig'];
%         saveas(gcf, fileString, 'fig')
%     end
%
% end


end
