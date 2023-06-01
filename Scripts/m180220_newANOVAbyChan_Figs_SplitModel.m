% decision
clear testTrials
for iChan=1:401
    for iCond=1:4
        testTrials(iChan,iCond,:) = mean(Spec_Chan_All{iChan}{iCond});
    end
end

%for iChan=1:401;for iCond=1:8;testTrialsM(iChan,iCond,:)=mean(Spec_Chan_All_M{iChan}{iCond});end;end;

cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560],[34/255 139/255 34/255],[1 0 1],[1 192/255 203/255],[119/255 136/255 153/255]);

% get list of Chans that have label
NewAreaLocLabelA=find(NewAreaLoc>0);
NewAreaLocLabelB=find(NewAreaLoc~=7);
NewAreaLocLabel=intersect(NewAreaLocLabelA,NewAreaLocLabelB);

GoodChanIdxLD2=intersect(GoodChanIdxLD,NewAreaLocLabel);
GoodChanIdxPD2=intersect(GoodChanIdxPD,NewAreaLocLabel);
GoodChanIdxLPD2=intersect(GoodChanIdxLPD,NewAreaLocLabel);

List1=GoodChanIdxLD2;
figure;
for iChan=1:length(List1);
    subplot(6,10,iChan);
plot(sq(mean(testTrials(List1(iChan),[1:2],:),2)),'color',cvals(1,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[3:4],:),2)),'color',cvals(2,:));
axis('tight');
titleIdx=NewAreaLoc(List1(iChan));
title(NewAreaLegend{titleIdx})
end

supertitle('Words vs Nonwords Decision')


List1=GoodChanIdxPD2;
figure;
for iChan=1:length(List1);
    subplot(6,10,iChan);
plot(sq(mean(testTrials(List1(iChan),[1,3],:),2)),'color',cvals(1,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[2,4],:),2)),'color',cvals(2,:));
axis('tight');
titleIdx=NewAreaLoc(List1(iChan));
title([NewAreaLegend{titleIdx} ' ' num2str(iChan)])
end

supertitle('H vs. L Decision')

List1=GoodChanIdxLPD2;
figure;
for iChan=1:length(List1);
    subplot(6,10,iChan);
plot(sq(mean(testTrials(List1(iChan),[1],:),2)),'color',cvals(1,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[2],:),2)),'color',cvals(2,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[3],:),2)),'color',cvals(3,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[4],:),2)),'color',cvals(4,:));
axis('tight');
titleIdx=NewAreaLoc(List1(iChan));
title(NewAreaLegend{titleIdx})
end

legend('HW','LW','HNW','LNW')
supertitle('L x P Decision')



% repetition
clear testTrials
for iChan=1:401
    for iCond=1:4
        testTrials(iChan,iCond,:) = mean(Spec_Chan_All{iChan}{iCond+4});
    end
end

%for iChan=1:401;for iCond=1:8;testTrialsM(iChan,iCond,:)=mean(Spec_Chan_All_M{iChan}{iCond});end;end;

cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560],[34/255 139/255 34/255],[1 0 1],[1 192/255 203/255],[119/255 136/255 153/255]);

% get list of Chans that have label
NewAreaLocLabelA=find(NewAreaLoc>0);
NewAreaLocLabelB=find(NewAreaLoc~=7);
NewAreaLocLabel=intersect(NewAreaLocLabelA,NewAreaLocLabelB);

GoodChanIdxLR2=intersect(GoodChanIdxLR,NewAreaLocLabel);
GoodChanIdxPR2=intersect(GoodChanIdxPR,NewAreaLocLabel);
GoodChanIdxLPR2=intersect(GoodChanIdxLPR,NewAreaLocLabel);

List1=GoodChanIdxLR2;
figure;
for iChan=1:length(List1);
    subplot(6,10,iChan);
plot(sq(mean(testTrials(List1(iChan),[1:2],:),2)),'color',cvals(1,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[3:4],:),2)),'color',cvals(2,:));
axis('tight');
titleIdx=NewAreaLoc(List1(iChan));
title(NewAreaLegend{titleIdx})
end

supertitle('Words vs Nonwords Repetition')


List1=GoodChanIdxPR2;
figure;
for iChan=1:length(List1);
    subplot(6,10,iChan);
plot(sq(mean(testTrials(List1(iChan),[1,3],:),2)),'color',cvals(1,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[2,4],:),2)),'color',cvals(2,:));
axis('tight');
titleIdx=NewAreaLoc(List1(iChan));
title([NewAreaLegend{titleIdx} ' ' num2str(iChan)])
end

supertitle('H vs. L Repetition')

List1=GoodChanIdxLPR2;
figure;
for iChan=1:length(List1);
    subplot(6,10,iChan);
plot(sq(mean(testTrials(List1(iChan),[1],:),2)),'color',cvals(1,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[2],:),2)),'color',cvals(2,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[3],:),2)),'color',cvals(3,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[4],:),2)),'color',cvals(4,:));
axis('tight');
titleIdx=NewAreaLoc(List1(iChan));
title(NewAreaLegend{titleIdx})
end

legend('HW','LW','HNW','LNW')
supertitle('L x P Repetition')

