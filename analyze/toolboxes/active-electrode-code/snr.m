
function snrMap = snr(signal, noise, numRow, numCol)

% define SNR as signal amplitude over noise amplitude
snrMap = signal ./ noise;

% sort the snr
sortedSNR = sort(snrMap(:));

% find 99% index
satIdx = floor(size(sortedSNR,1)* 0.995);

% saturate at 99%
snrMap(snrMap > sortedSNR(satIdx)) = sortedSNR(satIdx);


figure(1)
imagesc(snrMap)
colorbar
title('Signal to noise ratio')


% calculate and display some metrics about the data
meanVal = mean(snrMap(:));
medianVal = median(snrMap(:));
stdVal = std(snrMap(:));


% define an electrode as working if its amplitude is within 1 standard
% deviation of the mean value
workingMap = reshape(snrMap(:) > (meanVal - stdVal),numRow,numCol);
numWorking = sum(sum(workingMap));
percentWorking = numWorking / (numRow * numCol);

figure(2)
imagesc(workingMap)
colorbar
title('Working (1) vs non-working (0) electrodes');

disp(['  Mean SNR    value             : ' num2str(meanVal)   ' ' num2str(20*log10(meanVal)) ' dB' ]);
disp(['  Median SNR    value           : ' num2str(medianVal) ' ' num2str(20*log10(medianVal)) ' dB'   ]);
disp(['  Standard Deviation            : ' num2str(stdVal)    ' ' num2str(20*log10(stdVal)) ' dB'    ]);
disp(['  Number of working electrodes  : ' num2str(numWorking)       ]);
disp(['  Percentage working electrodes : ' num2str(percentWorking)   ]);

% plot a histogram of values
figure(3)
hist(snrMap(:),20)
title('Histogram of SNR');


end
