


close all
figure(1)
t = [t1 t2];
xAvg = [xAvg1 xAvg2];


numClusters = max(jonResults.clusterLabels);

if exist('spikeRates', 'var') == 0
    spikeRates = zeros(numClusters,size(xAvg,2));
    for i = 1:numClusters
        spikeRates(i,round(spikeTimes(jonResults.clusterLabels == i)* Fs)) = 1;
        
        spikeRates(i,:) = smooth(spikeRates(i,:), round(Fs * 5));
        
    end
end


%for j = 1:numClusters
clf
plot(t,xAvg)
yMin =  -2e-3;
yMax = 13e-3;
axis([2400 3190 yMin yMax])
hold on
%scatter(spikeTimes,ones(size(spikeTimes))*5e-4, [],jonResults.clusterLabels', 'filled')

which_chan = [2 4 12 14 19];
%which_chan = 12;

scale = (jonResults.clusterLabels') * 2e-4 + 8e-3;
scatter(spikeTimes,scale, 5,jonResults.clusterLabels', 'filled')

plot(t,spikeRates(which_chan,:)' * 2e-1 + 5e-3)
title(['cluster ' num2str(j)])

%          for i = 2350 : 40: round(size(xAvg,2) / Fs)
%      figure(1)
%      axis([i i + 100 yMin yMax])
%     pause
%          end


%end