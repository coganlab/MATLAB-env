idx=iiDA;

gvals(1,:)=[1,2];
gvals(2,:)=[3,4];

figure;
for iChan=1:length(idx);
    subplot(5,10,iChan);
    sig1=[];
    sig2=[];
    for iCond=1:2;
        sig1=cat(1,sig1,Spec_Chan_All_Aud{idx(iChan)}{gvals(1,iCond)}./mean(Spec_Chan_All_Aud{idx(iChan)}{gvals(1,iCond)}(:,1:10),2));
        sig2=cat(1,sig2,Spec_Chan_All_Aud{idx(iChan)}{gvals(2,iCond)}./mean(Spec_Chan_All_Aud{idx(iChan)}{gvals(2,iCond)}(:,1:10),2));
    end
    errorbar(mean(sig1),std(sig1,[],1)./sqrt(length(sig1)));
    hold on;
    errorbar(mean(sig2),std(sig2,[],1)./sqrt(length(sig2)));
end



clear pTestChan
clear sigPosNeg
for iChan=1:length(idx);
    sig1=[];
    sig2=[];
    for iCond=1:2;
        sig1=cat(1,sig1,Spec_Chan_All_Aud{idx(iChan)}{gvals(1,iCond)}./mean(Spec_Chan_All_Aud{idx(iChan)}{gvals(1,iCond)}(:,1:10),2));
        sig2=cat(1,sig2,Spec_Chan_All_Aud{idx(iChan)}{gvals(2,iCond)}./mean(Spec_Chan_All_Aud{idx(iChan)}{gvals(2,iCond)}(:,1:10),2));
    end
    
    nPerm=1000;
for iTime=1:40;
    actval=abs(mean(sig1(:,iTime))-mean(sig2(:,iTime)));
    catval=cat(1,sig1(:,iTime),sig2(:,iTime));
    for iPerm=1:nPerm;
        sIdx=shuffle(1:size(catval,1));
        permvals(iPerm)=abs(mean(catval(sIdx(1:size(sig1,1))))-mean(catval(sIdx(size(sig1,1)+1:end))));
    end
    pTestChan(iChan,iTime)=length(find(actval<permvals))./nPerm;
end
sigPosNeg(iChan,:)=mean(sig1,1)-mean(sig2,1);
    display(iChan)
end

figure;
for iChan=1:length(idx);
    subplot(5,10,iChan);
    plot(-log(sq(pTestChan(iChan,:))));
    hold on;
    plot(-log(.05)*ones(40,1),'r--');
    hold on;
    plot(-log(0.01)*ones(40,1),'m--');
end


figure;
for iChan=1:length(idx);
    subplot(5,10,iChan);
    plot(-log(sq(pTestChan(iChan,:))));
    hold on;
    plot(-log(.05)*ones(40,1),'r--');
    hold on;
    plot(-log(0.01)*ones(40,1),'m--');
end

pTestChanFDR=zeros(size(pTestChan,1),size(pTestChan,2));
for iChan=1:size(pTestChan,1)
    [PMASK, PFDR]=fdr(sq(pTestChan(iChan,:)),0.05);
    pTestChanFDR(iChan,:)=1.*PFDR;
end
figure;imagesc(pTestChanFDR)

pTestChanT=zeros(size(pTestChan,1),size(pTestChan,2));
ii=find(pTestChan<0.05);
pTestChanT(ii)=1;
figure;imagesc(pTestChanT)

ClusterSize=3;
clusterStartPTest=zeros(size(pTestChanT,1),4);
clusterStartRP2=zeros(size(pTestChanT,1),1);
for iChan=1:size(pTestChanT,1);

    tmp=bwconncomp(sq(pTestChanT(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            clusterStartPTest2(iChan)=ii3(ii);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartPTest(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartPTest(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartPTest(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartPTest(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartPTest(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartPTest(iChan,6)=1;
            end
        end
    end
    clear ii3
    
    SigClusterSizePTest(iChan)=max(ii2);
    else
        SigClusterSizePTest(iChan)=0;
    end
    clear ii2
end

iiPTest=find(SigClusterSizePTest>=ClusterSize);
iiPTestPos=find(sum(sigPosNeg(iiPTest,:).*pTestChanT(iiPTest,:),2)>0);
iiPTestNeg=find(sum(sigPosNeg(iiPTest,:).*pTestChanT(iiPTest,:),2)<0);

