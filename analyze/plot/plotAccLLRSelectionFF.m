function plotAccLLRSelectionFF(Results)
%
%  plotAccLLRSelectionFF(Results)
%

%  Plot AccLLRFF
figure;
Lfp1HitDir1 = find(~isnan(Results.NoHist.Dir1.DiscrimTimesF1));
Lfp1NoneDir1 = find(isnan(Results.NoHist.Dir1.DiscrimTimesF1) & ...
    isnan(Results.NoHist.Dir1.ErrorTimesF1));
Lfp1MissDir1 = find(~isnan(Results.NoHist.Dir1.ErrorTimesF1));
Lfp1HitDir2 = find(~isnan(Results.NoHist.Dir2.DiscrimTimesF1));
Lfp1NoneDir2 = find(isnan(Results.NoHist.Dir2.DiscrimTimesF1) & ...
    isnan(Results.NoHist.Dir2.ErrorTimesF1));
Lfp1MissDir2 = find(~isnan(Results.NoHist.Dir2.ErrorTimesF1));

Lfp2HitDir1 = find(~isnan(Results.NoHist.Dir1.DiscrimTimesF2));
Lfp2NoneDir1 = find(isnan(Results.NoHist.Dir1.DiscrimTimesF2) & ...
    isnan(Results.NoHist.Dir1.ErrorTimesF2));
Lfp2MissDir1 = find(~isnan(Results.NoHist.Dir1.ErrorTimesF2));
Lfp2HitDir2 = find(~isnan(Results.NoHist.Dir2.DiscrimTimesF2));
Lfp2NoneDir2 = find(isnan(Results.NoHist.Dir2.DiscrimTimesF2) & ...
    isnan(Results.NoHist.Dir2.ErrorTimesF2));
Lfp2MissDir2 = find(~isnan(Results.NoHist.Dir2.ErrorTimesF2));

subplot(1,2,1); cla; hold on
nT = size(Results.NoHist.Dir1.AccLLRLfp1,2);
AccLLRLfp1HitDir1 = zeros(1,nT); AccLLRLfp1HitDir2 = zeros(1,nT);
AccLLRLfp1NoneDir1 = zeros(1,nT); AccLLRLfp1NoneDir2 = zeros(1,nT);
AccLLRLfp1MissDir1 = zeros(1,nT); AccLLRLfp1MissDir2 = zeros(1,nT);
for iT = 1:nT
    ind = find(Results.NoHist.Dir1.DiscrimTimesF1(Lfp1HitDir1) > iT+1);
    AccLLRLfp1HitDir1(iT) = mean(Results.NoHist.Dir1.AccLLRLfp1(Lfp1HitDir1(ind),iT));
    ind = find(Results.NoHist.DiscrimParams.Dir1.EndAcc(Lfp1NoneDir1) > iT);
    AccLLRLfp1NoneDir1(iT) = mean(Results.NoHist.Dir1.AccLLRLfp1(Lfp1NoneDir1(ind),iT));
    ind = find(Results.NoHist.Dir1.ErrorTimesF1(Lfp1MissDir1) > iT+1);
    AccLLRLfp1MissDir1(iT) = mean(Results.NoHist.Dir1.AccLLRLfp1(Lfp1MissDir1(ind),iT));
    
    ind = find(Results.NoHist.Dir2.DiscrimTimesF1(Lfp1HitDir2) > iT+1);
    AccLLRLfp1HitDir2(iT) = mean(Results.NoHist.Dir2.AccLLRLfp1(Lfp1HitDir2(ind),iT));
    ind = find(Results.NoHist.DiscrimParams.Dir2.EndAcc(Lfp1NoneDir2) > iT);
    AccLLRLfp1NoneDir2(iT) = mean(Results.NoHist.Dir2.AccLLRLfp1(Lfp1NoneDir2(ind),iT));
    ind = find(Results.NoHist.Dir2.ErrorTimesF1(Lfp1MissDir2) > iT+1);
    AccLLRLfp1MissDir2(iT) = mean(Results.NoHist.Dir2.AccLLRLfp1(Lfp1MissDir2(ind),iT));
end
plot(AccLLRLfp1HitDir1,'b'); hold on;
plot(AccLLRLfp1MissDir1,'r');
plot(AccLLRLfp1HitDir2,'g');
plot(AccLLRLfp1MissDir2,'m');
plot(AccLLRLfp1NoneDir1,'k');
plot(AccLLRLfp1NoneDir2,'c');

subplot(1,2,2); cla; hold on
nT = size(Results.NoHist.Dir1.AccLLRLfp2,2);
AccLLRLfp2HitDir1 = zeros(1,nT); AccLLRLfp2HitDir2 = zeros(1,nT);
AccLLRLfp2NoneDir1 = zeros(1,nT); AccLLRLfp2NoneDir2 = zeros(1,nT);
AccLLRLfp2MissDir1 = zeros(1,nT); AccLLRLfp2MissDir2 = zeros(1,nT);
for iT = 1:nT
    ind = find(Results.NoHist.Dir1.DiscrimTimesF2(Lfp2HitDir1) > iT+1);
    AccLLRLfp2HitDir1(iT) = mean(Results.NoHist.Dir1.AccLLRLfp2(Lfp2HitDir1(ind),iT));
    ind = find(Results.NoHist.DiscrimParams.Dir1.EndAcc(Lfp2NoneDir1) > iT);
    AccLLRLfp2NoneDir1(iT) = mean(Results.NoHist.Dir1.AccLLRLfp2(Lfp2NoneDir1(ind),iT));
    ind = find(Results.NoHist.Dir1.ErrorTimesF2(Lfp2MissDir1) > iT+1);
    AccLLRLfp2MissDir1(iT) = mean(Results.NoHist.Dir1.AccLLRLfp2(Lfp2MissDir1(ind),iT));
    
    ind = find(Results.NoHist.Dir2.DiscrimTimesF2(Lfp2HitDir2) > iT+1);
    AccLLRLfp2HitDir2(iT) = mean(Results.NoHist.Dir2.AccLLRLfp2(Lfp2HitDir2(ind),iT));
    ind = find(Results.NoHist.DiscrimParams.Dir2.EndAcc(Lfp2NoneDir2) > iT);
    AccLLRLfp2NoneDir2(iT) = mean(Results.NoHist.Dir2.AccLLRLfp2(Lfp2NoneDir2(ind),iT));
    ind = find(Results.NoHist.Dir2.ErrorTimesF2(Lfp2MissDir2) > iT+1);
    AccLLRLfp2MissDir2(iT) = mean(Results.NoHist.Dir2.AccLLRLfp2(Lfp2MissDir2(ind),iT));
end
plot(AccLLRLfp2HitDir1,'b'); hold on;
plot(AccLLRLfp2MissDir1,'r');
plot(AccLLRLfp2HitDir2,'g');
plot(AccLLRLfp2MissDir2,'m');
plot(AccLLRLfp2NoneDir1,'k');
plot(AccLLRLfp2NoneDir2,'c');

%  Plot field-field ST correlations

% Times for Dir1
ind1 = find(~isnan(Results.NoHist.Dir1.DiscrimTimesF1) & ...
    ~isnan(Results.NoHist.Dir1.DiscrimTimesF2));

ind2 = find(~isnan(Results.NoHist.Dir2.DiscrimTimesF1) & ...
    ~isnan(Results.NoHist.Dir2.DiscrimTimesF2));

Field1ST = [Results.NoHist.Dir1.DiscrimTimesF1(ind1) ...
    Results.NoHist.Dir2.DiscrimTimesF1(ind2)];

Field2ST = [Results.NoHist.Dir1.DiscrimTimesF2(ind1) ...
    Results.NoHist.Dir2.DiscrimTimesF2(ind2)];

figure;
plot(Field1ST,Field2ST,'.','Markersize',10);
xlabel('Field1 Selection Time (ms)');
ylabel('Field2 Selection Time (ms)');
axis([0 250 0 250]); line([0 250],[0 250]); axis square
r = corrcoef(Field1ST, Field2ST); r = r(1,2);
title(num2str(r));

SRT = [Results.Dir1.SRT(ind1) Results.Dir2.SRT(ind2)];
RRT = [Results.Dir1.RRT(ind1) Results.Dir2.RRT(ind2)];
figure;
plot(SRT,RRT,'.','Markersize',10);
xlabel('Saccade Reaction Time (ms)');
ylabel('Reach Reaction Time (ms)');
axis([100 550 150 600]); axis square
r = corrcoef(SRT, RRT); r = r(1,2);
title(num2str(r));

