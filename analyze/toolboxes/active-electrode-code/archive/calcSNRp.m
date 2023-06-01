function [SNRSum, MaxSNRSum, MaxSNRLoc] = calcSNRp(data, realFs, signalHz, numCol, numRow, nfft)
%load(filenm);
%numSeconds = 8;     % how many seconds from the file to analyze
%data = data(:,1:numSeconds*fs);

%data = data(:,1:6250);

% if realFs < 12500
%     interpFactor = round(12500 / realFs);
%     Fs = 12500;     % normalize all recordings to 12500 Hz
% else
%     interpFactor = 1;
%     Fs = realFs;
% end

Fs = 25000 / 18;


%nfft = 8192*4;

% Calculate the numberof unique points
NumUniquePts = ceil((nfft+1)/2);

mx2 = [];

for j = 1:size(data,1)
%    x = interp(data(j,:),interpFactor);
    x = data(j,:);
    
    psd = pwelch(x,16384);
    
    mx2(j,:) = psd;
end

nfft = (size(mx2,2) - 1)*2;

mx = mx2;

% This is an evenly spaced frequency vector with NumUniquePts points.
f = (0:nfft/2)*Fs/nfft;

% Discarding low frequency components
discard_f = 1;
discard_i = ceil(discard_f * (nfft/Fs));
mx(:,1:discard_i) = 0;

hundredHzIdx = ceil((nfft/Fs) * 100);
figure(1)
subplot(3,1,1)
%plot(f(1:hundredHzIdx),mx(:,1:hundredHzIdx)');
plot(f,mx');


% calculate power in signal bandwidth
inputHz = signalHz;       % input is 20 hz
bandwHz = 2;        % + / - 2 hz
sigIdx = ceil((nfft/Fs) * inputHz);
bandwidth =  ceil((nfft/Fs) * bandwHz);
sigPower = sum(mx(:,sigIdx-bandwidth:sigIdx+bandwidth),2);
mx(:,sigIdx-bandwidth:sigIdx+bandwidth) = 0;


% zero out 60 Hz +/- 1 Hz
inputHz = 60;       % input is 20 hz
bandwHz = 3;        % + / - 3 hz
sigIdx = ceil((nfft/Fs) * inputHz);
bandwidth =  ceil((nfft/Fs) * bandwHz);
mx(:,sigIdx-bandwidth:sigIdx+bandwidth) = 0;

figure(1)
subplot(3,1,2)
hundredHzIdx = ceil((nfft/Fs) * 100);
%plot(f(1:hundredHzIdx),mx(:,1:hundredHzIdx)');
plot(f,mx');


% calculate power out of signal band
%NoiseMean = mean(mx,2);
NoiseSum = sum(mx,2);

%SNRMean = sigPower ./ NoiseMean;
SNRSum = sigPower ./ NoiseSum;

[MaxSNRSum, MaxSNRLoc] = max(SNRSum);
%[MaxSNRMean, MaxSNRLoc] = max(SNRMean);

%signalPower = sigPower(MaxSNRLoc);
%noisePower = NoiseSum(MaxSNRLoc);


%Generate the plot, title and labels.
% figure(i)
% plot(f,mx(MaxSNRLoc,:));

xlabel('Frequency (Hz)');
ylabel('Power');

figure(2)
plot(data(MaxSNRLoc,:));

% now plot the one we chose as best

mx = mx2;
% Discarding low frequency components
discard_f = 1;
discard_i = ceil(discard_f * (nfft/Fs));
mx(:,1:discard_i) = 0;


figure(1)
subplot(3,1,3)
%plot(f(1:hundredHzIdx),mx(MaxSNRLoc,1:hundredHzIdx)');
plot(f,mx(MaxSNRLoc,:)');

figure(3)
hist(SNRSum,20)
title('Histogram of Signal to Noise Ratios for all Channels')
xlabel('Signal to Noise Ratio')
ylabel('Number of Channels')

figure(4)
% create green / red color map
numc = 900;
colm = hsv(256*3);
colm = colm(1:255,:);

snrMap = reshape(SNRSum,numRow,numCol);
imagesc(snrMap)
title('Map of Signal to Noise Ratio')
colormap(colm);

colorbar

end
