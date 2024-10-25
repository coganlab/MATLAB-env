for iTime=1:40;
    Ptest(iTime)=length(find(sq(mean(abs(TvalsS(:,:,iTime,6)),2))>sq(mean(abs(Tvals(iiAC,iTime,6))))))./100;
end



for iChan=1:704
    for iTime=1:40
        Ptest(iChan,iTime,1)=length(find(sq(abs(TvalsS(:,iChan,iTime,2)))>sq(abs(Tvals(iChan,iTime,2)))))./nPerm;
        Ptest(iChan,iTime,2)=length(find(sq(abs(TvalsS(:,iChan,iTime,4)))>sq(abs(Tvals(iChan,iTime,4)))))./nPerm;
        Ptest(iChan,iTime,3)=length(find(sq(abs(TvalsS(:,iChan,iTime,6)))>sq(abs(Tvals(iChan,iTime,6)))))./nPerm;
        
    end
end

idx=iiABCD;
figure;
for iChan=1:length(idx);
    subplot(6,10,iChan);
    plot(-log(PtestL(idx(iChan),:)));
    hold on
    plot(-log(PtestT(idx(iChan),:)),'r');
    hold on;
    plot(-log(PtestP(idx(iChan),:)),'g');
    hold on;
    plot(-log(.05)*ones(40,1),'m--');
end



PvalsM=zeros(size(Ptest,1),size(Ptest,2),size(Ptest,3));
ii=find(Ptest<0.01);
PvalsM(ii)=1;




sigClusterSize=[];
clusterStart=zeros(size(Spec_Chan_All_Aud,2),3);
for iC=1:3

for iChan=1:size(PvalsM,1);

    tmp=bwconncomp(sq(PvalsM(iChan,:,iC)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStart(iChan,iC)=ii3(1);
            clusterIdent{iChan}{iC}{ii}=tmp.PixelIdxList{ii2B(ii)};
        end
    end
    clear ii3
    
    sigClusterSize(iChan,iC)=max(ii2);
    else
        sigClusterSize(iChan,iC)=0;
    end
    clear ii2
end
end

iiL=find(sigClusterSize(:,1)>=ClusterSize);
iiT=find(sigClusterSize(:,2)>=ClusterSize);
iiP=find(sigClusterSize(:,3)>=ClusterSize);



for iChan=1:length(iiL)
    tmp=clusterIdent{iiL(iChan)}{1};
    tmp2=[];
    for iA=1:size(tmp,2)
        tmp2=cat(2,tmp2,sq(Tvals(iiL(iChan),tmp{iA},2)));
    end
    clusterSignL(iChan)=mean(tmp2);
end

for iChan=1:length(iiT);
    tmp=clusterIdent{iiT(iChan)}{2};
    tmp2=[];
    for iA=1:size(tmp,2)
        tmp2=cat(2,tmp2,sq(Tvals(iiT(iChan),tmp{iA},2)));
    end
    clusterSignT(iChan)=mean(tmp2);
end

for iChan=1:length(iiP)
     tmp=clusterIdent{iiP(iChan)}{3};
    tmp2=[];
    for iA=1:size(tmp,2)
        tmp2=cat(2,tmp2,sq(Tvals(iiP(iChan),tmp{iA},3)));
    end
    clusterSignP(iChan)=mean(tmp2);
end

idx=iiAC;
figure;
for iChan=1:length(idx);
    subplot(5,10,iChan);
    if length(intersect(iiL,idx(iChan))>0)
    hold on
    plot(sq(Tvals(idx(iChan),:,2)),'b');
    end
    if length(intersect(iiT,idx(iChan))>0)
    hold on
    plot(sq(Tvals(idx(iChan),:,4)),'r');
    end
    if length(intersect(iiP,idx(iChan))>0)
    hold on
    plot(sq(Tvals(idx(iChan),:,6)),'g');
    end
    hold on
    plot(zeros(40,1),'m--');
end
    



idx=iiAC;
figure;
for iChan=1:length(idx);
    subplot(5,10,iChan);
    hold on
    plot(sq(Tvals(idx(iChan),:,2)),'b');

    hold on
    plot(sq(Tvals(idx(iChan),:,4)),'r');

    hold on
    plot(sq(Tvals(idx(iChan),:,6)),'g');

    hold on
    plot(zeros(40,1),'m--');
end
    


