for iChan=1:401
    for iCond=1:8
        testTrials(iChan,iCond,:) = mean(Spec_Chan_All{iChan}{iCond});
    end
end

%for iChan=1:401;for iCond=1:8;testTrialsM(iChan,iCond,:)=mean(Spec_Chan_All_M{iChan}{iCond});end;end;

cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560],[34/255 139/255 34/255],[1 0 1],[1 192/255 203/255],[119/255 136/255 153/255]);

% get list of Chans that have label
NewAreaLocLabelA=find(NewAreaLoc>0);
NewAreaLocLabelB=find(NewAreaLoc~=7);
NewAreaLocLabel=intersect(NewAreaLocLabelA,NewAreaLocLabelB);

GoodChanIdxL2=intersect(GoodChanIdxL,NewAreaLocLabel);
GoodChanIdxT2=intersect(GoodChanIdxT,NewAreaLocLabel);
GoodChanIdxP2=intersect(GoodChanIdxP,NewAreaLocLabel);
GoodChanIdxLT2=intersect(GoodChanIdxLT,NewAreaLocLabel);
GoodChanIdxLP2=intersect(GoodChanIdxLP,NewAreaLocLabel);
GoodChanIdxPT2=intersect(GoodChanIdxPT,NewAreaLocLabel);
GoodChanIdxLTP2=intersect(GoodChanIdxLTP,NewAreaLocLabel);

List1=GoodChanIdxL2;
figure;
for iChan=1:length(List1);
    subplot(6,10,iChan);
plot(sq(mean(testTrials(List1(iChan),[1:2,5:6],:),2)),'color',cvals(1,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[3:4,7:8],:),2)),'color',cvals(2,:));
axis('tight');
titleIdx=List1(iChan);
title(titleIdx)
% titleIdx=NewAreaLoc(List1(iChan));
% title(NewAreaLegend{titleIdx})
end

supertitle('Words vs Nonwords')

List1=GoodChanIdxT2;
figure;
for iChan=1:length(List1);
    subplot(6,10,iChan);
plot(sq(mean(testTrials(List1(iChan),[1:4],:),2)),'color',cvals(1,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[5:8],:),2)),'color',cvals(2,:));
axis('tight');
titleIdx=List1(iChan);
title(titleIdx)
% titleIdx=NewAreaLoc(List1(iChan));
% title(NewAreaLegend{titleIdx})
end

supertitle('Dec vs. Rep')

List1=GoodChanIdxP2;
figure;
for iChan=1:length(List1);
    subplot(6,10,iChan);
plot(sq(mean(testTrials(List1(iChan),[1,3,5,7],:),2)),'color',cvals(1,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[2,4,6,8],:),2)),'color',cvals(2,:));
axis('tight');
titleIdx=List1(iChan);
title(titleIdx)
% titleIdx=NewAreaLoc(List1(iChan));
% title([NewAreaLegend{titleIdx} ' ' num2str(iChan)])
end

supertitle('H vs. L')

List1=GoodChanIdxLT2;
figure;
for iChan=1:length(List1);
    subplot(6,10,iChan);
plot(sq(mean(testTrials(List1(iChan),[1,2],:),2)),'color',cvals(1,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[3,4],:),2)),'color',cvals(2,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[5,6],:),2)),'color',cvals(3,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[7,8],:),2)),'color',cvals(4,:));
axis('tight');
titleIdx=List1(iChan);
title(titleIdx)
% titleIdx=NewAreaLoc(List1(iChan));
% title(NewAreaLegend{titleIdx})
end

legend('WD','NWD','WR','NWR')

supertitle('L x T')

List1=GoodChanIdxLP2;
figure;
for iChan=1:length(List1);
    subplot(6,10,iChan);
plot(sq(mean(testTrials(List1(iChan),[1,5],:),2)),'color',cvals(1,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[2,6],:),2)),'color',cvals(2,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[3,7],:),2)),'color',cvals(3,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[4,8],:),2)),'color',cvals(4,:));
axis('tight');
titleIdx=List1(iChan);
title(titleIdx)
% titleIdx=NewAreaLoc(List1(iChan));
% title(NewAreaLegend{titleIdx})
end

legend('HW','LW','HNW','LNW')
supertitle('L x P')

List1=GoodChanIdxPT2;
figure;
for iChan=1:length(List1);
    subplot(6,10,iChan);
plot(sq(mean(testTrials(List1(iChan),[1,3],:),2)),'color',cvals(1,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[2,4],:),2)),'color',cvals(2,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[5,7],:),2)),'color',cvals(3,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[6,8],:),2)),'color',cvals(4,:));
axis('tight');
titleIdx=List1(iChan);
title(titleIdx)
% titleIdx=NewAreaLoc(List1(iChan));
% title(NewAreaLegend{titleIdx})
end

legend('HD','LD','HR','LR')
supertitle('P x T')

List1=GoodChanIdxPT2;
figure;
for iChan=1:length(List1);
    subplot(6,10,iChan);
plot(sq(mean(testTrials(List1(iChan),[1,3],:),2)),'color',cvals(1,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[2,4],:),2)),'color',cvals(2,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[5,7],:),2)),'color',cvals(3,:));
hold on;
plot(sq(mean(testTrials(List1(iChan),[6,8],:),2)),'color',cvals(4,:));
axis('tight');
titleIdx=List1(iChan);
title(titleIdx)
% titleIdx=NewAreaLoc(List1(iChan));
% title(NewAreaLegend{titleIdx})
end

legend('HD','LD','HR','LR')
supertitle('P x T')


List1=GoodChanIdxLTP2;
figure;
for iChan=1:length(List1);
    subplot(6,10,iChan);
    for iCond=1:8;
        hold on
        plot(sq(testTrials(List1(iChan),iCond,:)),'color',cvals(iCond,:));
    end
    axis('tight');
    titleIdx=List1(iChan);
    title(titleIdx)
    %titleIdx=NewAreaLoc(List1(iChan));
    %title(NewAreaLegend{titleIdx})
end
supertitle('L x P x T')
legend('HWD','LWD','HNWD','LNWD','HWR','LWR','HNWR','LNWR')


List1=GoodChanIdxLTP2;
figure;
for iCond=1:8;
    hold on;
plot(sq(mean(testTrials(List1,iCond,:))),'color',cvals(iCond,:));
end
legend('HWD','LWD','HNWD','LNWD','HWR','LWR','HNWR','LNWR')


List1=GoodChanIdxLP2;
figure;
plot(sq(mean(mean(testTrials(List1,[1,5],:)))),'color',cvals(1,:));
hold on;
plot(sq(mean(mean(testTrials(List1,[2,6],:)))),'color',cvals(2,:));
hold on;
plot(sq(mean(mean(testTrials(List1,[3,7],:)))),'color',cvals(3,:));
hold on;
plot(sq(mean(mean(testTrials(List1,[4,8],:)))),'color',cvals(4,:));
axis('tight');
legend('HW','LW','HNW','LNW')

List1=GoodChanIdxPT2;
figure;
plot(sq(mean(mean(testTrials(List1,[1,3],:)))),'color',cvals(1,:));
hold on;
plot(sq(mean(mean(testTrials(List1,[2,4],:)))),'color',cvals(2,:));
hold on;
plot(sq(mean(mean(testTrials(List1,[5,7],:)))),'color',cvals(3,:));
hold on;
plot(sq(mean(mean(testTrials(List1,[6,8],:)))),'color',cvals(4,:));
axis('tight');
legend('HD','LD','HR','LR')


