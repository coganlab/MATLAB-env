function plotCorrCoef(spikeCounts,spikeID,jointPos,nBin,nLag)

if nargin < 5
    nLag = 5;
    if nargin < 4
        nBin = 2;
    end
end

spikes = zeros(size(spikeCounts,1)-nBin+1,1);
for i = 1:length(spikes)
    spikes(i) = sum(spikeCounts(i:i+nBin-1,spikeID));
end
for t = 0:nLag
    figure(t+1)
    for i = 1:size(jointPos,2)
        cc = corrcoef(spikes(1:end-t),jointPos(t+nBin:end,i));
        subplot(6,6,i)
        scatter(spikes(1:end-t),jointPos(t+nBin:end,i))
        title(['r^2 = ' num2str(cc(2)^2)])
    end
end