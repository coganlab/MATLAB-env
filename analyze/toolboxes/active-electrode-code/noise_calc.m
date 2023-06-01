
function noise = noise_calc(dataf, numCol, numRow, signalT)


figure(5)
noise = std(dataf');
num_val = size(noise,2);
sorted_noise = sort(noise);

% Saturate if calculating noise, if signal, no saturation
if signalT == 1
    num_val = floor(1 * num_val);
else
    num_val = floor(0.90 * num_val);
end

if signalT == 1
    hist(noise * 1000,25);
    xlabel('Signal Level (mV RMS)')
    title('Histogram of Standard Deviation')
    ylabel('Number of Channels')
    
    figure(10)
    hist(noise * (2*sqrt(2)) * 1000, 25)
    xlabel('Signal Level (mV p-p)')
else
    sorted_noise = sorted_noise(1:num_val);
    hist(sorted_noise * 1000 * 1000,50);
    xlabel('Noise Level (uV RMS)')
end


title('Histogram of Standard Deviation')
ylabel('Number of Channels')

fprintf('Mean of 90 percent of channels: %d\n', mean(sorted_noise));
fprintf('Median of 90 percent of channels: %d\n', median(sorted_noise));
fprintf('Mean of 100 percent of channels: %d\n', mean(noise));
fprintf('Median of 100 percent of channels: %d\n', median(noise));


figure(6)
% create green / red color map
colm = hsv(256*3);
colm = colm(1:256,:);

% reverse red / green
if signalT == 0
    colm = colm(256:-1:1,:);
end

noiseMap = reshape(noise,numRow,numCol);

if signalT == 1
    % display in mV
    % saturate above 90% value
    noiseMap(noiseMap > sorted_noise(num_val)) = sorted_noise(num_val);
    
    imagesc(noiseMap * 1000)
    title('Map of Standard Deviation (mV RMS)')
else
    % saturate above 90% value
    noiseMap(noiseMap > sorted_noise(num_val)) = sorted_noise(num_val);
    imagesc(noiseMap * 1000 * 1000)
    title('Map of Standard Deviation (uV RMS)')
end

colormap(colm);
colorbar



figure(7)
ampMap = max(dataf,[],2) - min(dataf,[],2);
ampMap = reshape(ampMap,numRow,numCol);
imagesc(ampMap)
colormap(colm);
colorbar

title('Map of Max - Min Value (p-p value)')

figure(8)
for i=1:size(dataf,1)
    noiseRMS(i) = rms(dataf(i,:));
end
noiseRMS = reshape(noiseRMS,numRow,numCol);
imagesc(noiseRMS)
colormap(colm);
colorbar

title('Map of RMS Value')

figure(9)

if signalT == 1
    % display in mV
    imagesc(noiseMap.*(2*sqrt(2)) * 1000)
    title('Map of Peak to Peak value (mV)')
else
    % saturate above 90% value
    imagesc(noiseMap.*(2*sqrt(2)) * 1000 * 1000)
    title('Map of Peak to Peak value (uV)')
end

colormap(colm);
colorbar















