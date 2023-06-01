GoodChanIdxDL=find(ChanClusterSizeDB(:,1)>=ClusterSize);
GoodChanIdxDP=find(ChanClusterSizeDB(:,2)>=ClusterSize);
GoodChanIdxDLP=find(ChanClusterSizeDB(:,3)>=ClusterSize);

GoodChanIdxRL=find(ChanClusterSizeRB(:,1)>=ClusterSize);
GoodChanIdxRP=find(ChanClusterSizeRB(:,2)>=ClusterSize);
GoodChanIdxRLP=find(ChanClusterSizeRB(:,3)>=ClusterSize);

GoodChanIdxDL=intersect(GoodChanIdxDL,iiDS);
GoodChanIdxDP=intersect(GoodChanIdxDP,iiDS);
GoodChanIdxDLP=intersect(GoodChanIdxDLP,iiDS);

GoodChanIdxRL=intersect(GoodChanIdxRL,iiRS);
GoodChanIdxRP=intersect(GoodChanIdxRP,iiRS);
GoodChanIdxRLP=intersect(GoodChanIdxRLP,iiRS);

% NewAreaLocLabelA=find(NewAreaLoc>0);
% NewAreaLocLabelB=find(NewAreaLoc~=7);
% NewAreaLocLabel=intersect(NewAreaLocLabelA,NewAreaLocLabelB);
% 
% GoodChanIdxL=intersect(GoodChanIdxL,NewAreaLocLabel);
% GoodChanIdxP=intersect(GoodChanIdxP,NewAreaLocLabel);
% GoodChanIdxT=intersect(GoodChanIdxT,NewAreaLocLabel);
% GoodChanIdxLP=intersect(GoodChanIdxLP,NewAreaLocLabel);
% GoodChanIdxLT=intersect(GoodChanIdxLT,NewAreaLocLabel);
% GoodChanIdxPT=intersect(GoodChanIdxPT,NewAreaLocLabel);
% GoodChanIdxLPT=intersect(GoodChanIdxLPT,NewAreaLocLabel);

figure;
chanL=GoodChanIdxDL;
idx1=[1,2];
idx2=[3,4];
for iChan=1:length(chanL)
    subplot(8,10,iChan)
    plot(sq(mean(dataA(chanL(iChan),idx1,:),2)),'b');
    hold on;
    plot(sq(mean(dataA(chanL(iChan),idx2,:),2)),'r');
    axis('tight');
    
   % title([NewAreaLegend{NewAreaLoc(chanL(iChan))} ' ' num2str(chanL(iChan))])
    title(['Channel ' num2str(chanL(iChan))])
    tmp=bwconncomp(sq(pmaskDB(chanL(iChan),:,1)));
        for ii=1:length(tmp.PixelIdxList);ii2(ii)=length(tmp.PixelIdxList{ii});end
    ii3=find(ii2>=ClusterSize);
    if length(ii3)>=1   
    for ii=1:length(ii3)
    hold on;
    plot(tmp.PixelIdxList{ii3(ii)},ones(length(tmp.PixelIdxList{ii3(ii)}),1),'color','k','LineWidth',2)
    end
    end
    clear ii2

end
supertitle('Lexical Decision')

figure;
chanL=GoodChanIdxRL;
idx1=[5,6];
idx2=[7,8];
for iChan=1:length(chanL)
    subplot(11,10,iChan)
    plot(sq(mean(dataA(chanL(iChan),idx1,:),2)),'b');
    hold on;
    plot(sq(mean(dataA(chanL(iChan),idx2,:),2)),'r');
    axis('tight');
    
   % title([NewAreaLegend{NewAreaLoc(chanL(iChan))} ' ' num2str(chanL(iChan))])
    title(['Channel ' num2str(chanL(iChan))])
    tmp=bwconncomp(sq(pmaskRB(chanL(iChan),:,1)));
        for ii=1:length(tmp.PixelIdxList);ii2(ii)=length(tmp.PixelIdxList{ii});end
    ii3=find(ii2>=ClusterSize);
    if length(ii3)>=1   
    for ii=1:length(ii3)
    hold on;
    plot(tmp.PixelIdxList{ii3(ii)},ones(length(tmp.PixelIdxList{ii3(ii)}),1),'color','k','LineWidth',2)
    end
    end
    clear ii2

end
supertitle('Lexical Repeat')

    
figure;
chanL=GoodChanIdxDP;
idx1=[1,3];
idx2=[2,4];
for iChan=1:length(chanL)
    subplot(10,10,iChan)
    plot(sq(mean(dataA(chanL(iChan),idx1,:),2)),'b');
    hold on;
    plot(sq(mean(dataA(chanL(iChan),idx2,:),2)),'r');
    axis('tight');
    
    %title([NewAreaLegend{NewAreaLoc(chanL(iChan))}  ' ' num2str(chanL(iChan))])
    title(['Channel ' num2str(chanL(iChan))])
    tmp=bwconncomp(sq(pmaskDB(chanL(iChan),:,2)));
        for ii=1:length(tmp.PixelIdxList);ii2(ii)=length(tmp.PixelIdxList{ii});end
    ii3=find(ii2>=ClusterSize);
    if length(ii3)>=1   
    for ii=1:length(ii3)
    hold on;
    plot(tmp.PixelIdxList{ii3(ii)},ones(length(tmp.PixelIdxList{ii3(ii)}),1),'color','k','LineWidth',2)
    end
    end
    clear ii2

end
supertitle('Phono Decision')

figure;
chanL=GoodChanIdxRP;
idx1=[5,7];
idx2=[6,8];
for iChan=1:length(chanL)
    subplot(11,10,iChan)
    plot(sq(mean(dataA(chanL(iChan),idx1,:),2)),'b');
    hold on;
    plot(sq(mean(dataA(chanL(iChan),idx2,:),2)),'r');
    axis('tight');
    
    %title([NewAreaLegend{NewAreaLoc(chanL(iChan))}  ' ' num2str(chanL(iChan))])
    title(['Channel ' num2str(chanL(iChan))])
    tmp=bwconncomp(sq(pmaskRB(chanL(iChan),:,2)));
        for ii=1:length(tmp.PixelIdxList);ii2(ii)=length(tmp.PixelIdxList{ii});end
    ii3=find(ii2>=ClusterSize);
    if length(ii3)>=1   
    for ii=1:length(ii3)
    hold on;
    plot(tmp.PixelIdxList{ii3(ii)},ones(length(tmp.PixelIdxList{ii3(ii)}),1),'color','k','LineWidth',2)
    end
    end
    clear ii2

end
supertitle('Phono Repeat')



figure;
chanL=GoodChanIdxDLP;
idx1=[1];
idx2=[2];
idx3=[3];
idx4=[4];
for iChan=1:length(chanL)
    subplot(3,10,iChan)
    plot(sq(dataA(chanL(iChan),idx1,:)),'b');
    hold on;
    plot(sq(dataA(chanL(iChan),idx2,:)),'r');
    hold on;
    plot(sq(dataA(chanL(iChan),idx3,:)),'g');
    hold on;
    plot(sq(dataA(chanL(iChan),idx4,:)),'m');
    axis('tight');
    
   % title([NewAreaLegend{NewAreaLoc(chanL(iChan))} ' ' num2str(chanL(iChan))])
    title(['Channel ' num2str(chanL(iChan))])
    tmp=bwconncomp(sq(pmaskDB(chanL(iChan),:,3)));
        for ii=1:length(tmp.PixelIdxList);ii2(ii)=length(tmp.PixelIdxList{ii});end
    ii3=find(ii2>=ClusterSize);
    if length(ii3)>=1   
    for ii=1:length(ii3)
    hold on;
    plot(tmp.PixelIdxList{ii3(ii)},ones(length(tmp.PixelIdxList{ii3(ii)}),1),'color','k','LineWidth',2)
    end
    end
    clear ii2

end
supertitle('Lexical x Phono Decision')
legend('HW','LW','HNW','LNW')

figure;
chanL=GoodChanIdxRLP;
idx1=[5];
idx2=[6];
idx3=[7];
idx4=[8];
for iChan=1:length(chanL)
    subplot(3,10,iChan)
    plot(sq(mean(dataA(chanL(iChan),idx1,:),2)),'b');
    hold on;
    plot(sq(mean(dataA(chanL(iChan),idx2,:),2)),'r');
    hold on;
    plot(sq(mean(dataA(chanL(iChan),idx3,:),2)),'g');
    hold on;
    plot(sq(mean(dataA(chanL(iChan),idx4,:),2)),'m');
    axis('tight');
    
   % title([NewAreaLegend{NewAreaLoc(chanL(iChan))} ' ' num2str(chanL(iChan))])
    title(['Channel ' num2str(chanL(iChan))])
    tmp=bwconncomp(sq(pmaskRB(chanL(iChan),:,3)));
        for ii=1:length(tmp.PixelIdxList);ii2(ii)=length(tmp.PixelIdxList{ii});end
    ii3=find(ii2>=ClusterSize);
    if length(ii3)>=1   
    for ii=1:length(ii3)
    hold on;
    plot(tmp.PixelIdxList{ii3(ii)},ones(length(tmp.PixelIdxList{ii3(ii)}),1),'color','k','LineWidth',2)
    end
    end
    clear ii2

end
supertitle('Lexical x Phono Repeat')
legend('HW','LW','HNW','LNW')
