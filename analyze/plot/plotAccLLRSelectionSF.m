function plotAccLLRSelectionSF(Results)
%
%  plotAccLLRSelectionSF(Results)
%

%  Plot AccLLRSpike
figure;
LfpHitDir1 = find(~isnan(Results.NoHist.Dir1.DiscrimTimesF));
LfpNoneDir1 = find(isnan(Results.NoHist.Dir1.DiscrimTimesF) & ...
    isnan(Results.NoHist.Dir1.ErrorTimesF));
LfpMissDir1 = find(~isnan(Results.NoHist.Dir1.ErrorTimesF));
LfpHitDir2 = find(~isnan(Results.NoHist.Dir2.DiscrimTimesF));
LfpNoneDir2 = find(isnan(Results.NoHist.Dir2.DiscrimTimesF) & ...
    isnan(Results.NoHist.Dir2.ErrorTimesF));
LfpMissDir2 = find(~isnan(Results.NoHist.Dir2.ErrorTimesF));

SpikeHitDir1 = find(~isnan(Results.NoHist.Dir1.DiscrimTimesS));
SpikeNoneDir1 = find(isnan(Results.NoHist.Dir1.DiscrimTimesS) & ...
    isnan(Results.NoHist.Dir1.ErrorTimesS));
SpikeMissDir1 = find(~isnan(Results.NoHist.Dir1.ErrorTimesS));
SpikeHitDir2 = find(~isnan(Results.NoHist.Dir2.DiscrimTimesS));
SpikeNoneDir2 = find(isnan(Results.NoHist.Dir2.DiscrimTimesS) & ...
    isnan(Results.NoHist.Dir2.ErrorTimesS));
SpikeMissDir2 = find(~isnan(Results.NoHist.Dir2.ErrorTimesS));

subplot(1,2,1); cla; hold on
nT = size(Results.NoHist.Dir1.AccLLRLfp,2);
AccLLRLfpHitDir1 = zeros(1,nT); AccLLRLfpHitDir2 = zeros(1,nT);
AccLLRLfpNoneDir1 = zeros(1,nT); AccLLRLfpNoneDir2 = zeros(1,nT);
AccLLRLfpMissDir1 = zeros(1,nT); AccLLRLfpMissDir2 = zeros(1,nT);
for iT = 1:nT
    ind = find(Results.NoHist.Dir1.DiscrimTimesF(LfpHitDir1) > iT+1);
    AccLLRLfpHitDir1(iT) = mean(Results.NoHist.Dir1.AccLLRLfp(LfpHitDir1(ind),iT));
    ind = find(Results.NoHist.DiscrimParams.Dir1.EndAcc(LfpNoneDir1) > iT);
    AccLLRLfpNoneDir1(iT) = mean(Results.NoHist.Dir1.AccLLRLfp(LfpNoneDir1(ind),iT));
    ind = find(Results.NoHist.Dir1.ErrorTimesF(LfpMissDir1) > iT+1);
    AccLLRLfpMissDir1(iT) = mean(Results.NoHist.Dir1.AccLLRLfp(LfpMissDir1(ind),iT));
    
    ind = find(Results.NoHist.Dir2.DiscrimTimesF(LfpHitDir2) > iT+1);
    AccLLRLfpHitDir2(iT) = mean(Results.NoHist.Dir2.AccLLRLfp(LfpHitDir2(ind),iT));
    ind = find(Results.NoHist.DiscrimParams.Dir2.EndAcc(LfpNoneDir2) > iT);
    AccLLRLfpNoneDir2(iT) = mean(Results.NoHist.Dir2.AccLLRLfp(LfpNoneDir2(ind),iT));
    ind = find(Results.NoHist.Dir2.ErrorTimesF(LfpMissDir2) > iT+1);
    AccLLRLfpMissDir2(iT) = mean(Results.NoHist.Dir2.AccLLRLfp(LfpMissDir2(ind),iT));
end
plot(AccLLRLfpHitDir1,'b'); hold on;
plot(AccLLRLfpMissDir1,'r');
plot(AccLLRLfpHitDir2,'g');
plot(AccLLRLfpMissDir2,'m');
plot(AccLLRLfpNoneDir1,'k');
plot(AccLLRLfpNoneDir2,'c');

subplot(1,2,2); cla; hold on;
nT = size(Results.NoHist.Dir1.AccLLRSpike,2);
AccLLRSpikeHitDir1 = zeros(1,nT); AccLLRSpikeHitDir2 = zeros(1,nT);
AccLLRSpikeNoneDir1 = zeros(1,nT); AccLLRSpikeNoneDir2 = zeros(1,nT);
AccLLRSpikeMissDir1 = zeros(1,nT); AccLLRSpikeMissDir2 = zeros(1,nT);
for iT = 1:nT
    ind = find(Results.NoHist.Dir1.DiscrimTimesS(SpikeHitDir1) > iT+1);
    AccLLRSpikeHitDir1(iT) = mean(Results.NoHist.Dir1.AccLLRSpike(SpikeHitDir1(ind),iT));
    ind = find(Results.NoHist.DiscrimParams.Dir1.EndAcc(SpikeNoneDir1) > iT);
    AccLLRSpikeNoneDir1(iT) = mean(Results.NoHist.Dir1.AccLLRSpike(SpikeNoneDir1(ind),iT));
    ind = find(Results.NoHist.Dir1.ErrorTimesS(SpikeMissDir1) > iT+1);
    AccLLRSpikeMissDir1(iT) = mean(Results.NoHist.Dir1.AccLLRSpike(SpikeMissDir1(ind),iT));
    
    ind = find(Results.NoHist.Dir2.DiscrimTimesS(SpikeHitDir2) > iT+1);
    AccLLRSpikeHitDir2(iT) = mean(Results.NoHist.Dir2.AccLLRSpike(SpikeHitDir2(ind),iT));
    ind = find(Results.NoHist.DiscrimParams.Dir2.EndAcc(SpikeNoneDir2) > iT);
    AccLLRSpikeNoneDir2(iT) = mean(Results.NoHist.Dir2.AccLLRSpike(SpikeNoneDir2(ind),iT));
    ind = find(Results.NoHist.Dir2.ErrorTimesS(SpikeMissDir2) > iT+1);
    AccLLRSpikeMissDir2(iT) = mean(Results.NoHist.Dir2.AccLLRSpike(SpikeMissDir2(ind),iT));
end
plot(AccLLRSpikeHitDir1,'b'); hold on;
plot(AccLLRSpikeMissDir1,'r');
plot(AccLLRSpikeHitDir2,'g');
plot(AccLLRSpikeMissDir2,'m');
plot(AccLLRSpikeNoneDir1,'k');
plot(AccLLRSpikeNoneDir2,'c');

%  Plot spike-field ST correlations

% Times for Dir1
ind1 = find(~isnan(Results.NoHist.Dir1.DiscrimTimesF) & ...
    ~isnan(Results.NoHist.Dir1.DiscrimTimesS));

ind2 = find(~isnan(Results.NoHist.Dir2.DiscrimTimesF) & ...
    ~isnan(Results.NoHist.Dir2.DiscrimTimesS));

FieldST = [Results.NoHist.Dir1.DiscrimTimesF(ind1) ...
    Results.NoHist.Dir2.DiscrimTimesF(ind2)];

SpikeST = [Results.NoHist.Dir1.DiscrimTimesS(ind1) ...
    Results.NoHist.Dir2.DiscrimTimesS(ind2)];

figure;
plot(FieldST,SpikeST,'.','Markersize',10);
axis([0 250 0 250]); line([0 250],[0 250]);
r = corrcoef(FieldST, SpikeST); r = r(1,2);
title(num2str(r));

