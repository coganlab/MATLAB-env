% across conds
nPerm=1000;
for iChan=1:size(Spec_Chan_All_Aud,2);
    tmpD=[];
    tmpR=[];
    for iCond=1:4;
        tmpD=cat(1,tmpD,Spec_Chan_All_Aud{iChan}{iCond}./mean(mean(Spec_Chan_All_Aud{iChan}{iCond}(:,1:10))));
        tmpR=cat(1,tmpR,Spec_Chan_All_Aud{iChan}{iCond+4}./mean(mean(Spec_Chan_All_Aud{iChan}{iCond+4}(:,1:10))));
    end
    
%     baselineD=mean(mean(tmpD(:,1:10)));
%     baselineR=mean(mean(tmpR(:,1:10)));
%     tmpD=tmpD./baselineD;
%     tmpR=tmpR./baselineR;
%     
%     baselines=cat(1,repmat(baselineD,4,1),repmat(baselineR,4,1));
    
    tmpW=[];
    tmpNW=[];
    listOrder=[1,2,5,6,3,4,7,8];
    for iCond=1:4;
        tmpW=cat(1,tmpW,Spec_Chan_All_Aud{iChan}{listOrder(iCond)}./mean(mean(Spec_Chan_All_Aud{iChan}{listOrder(iCond)}(:,1:10))));
        tmpNW=cat(1,tmpNW,Spec_Chan_All_Aud{iChan}{listOrder(iCond+4)}./mean(mean(Spec_Chan_All_Aud{iChan}{listOrder(iCond+4)}(:,1:10))));
    end
    
    tmpH=[];
    tmpL=[];
    listOrder=[1,3,5,7,2,4,6,8];
    for iCond=1:4;
        tmpH=cat(1,tmpH,Spec_Chan_All_Aud{iChan}{listOrder(iCond)}./mean(mean(Spec_Chan_All_Aud{iChan}{listOrder(iCond)}(:,1:10))));
        tmpL=cat(1,tmpL,Spec_Chan_All_Aud{iChan}{listOrder(iCond+4)}./mean(mean(Spec_Chan_All_Aud{iChan}{listOrder(iCond+4)}(:,1:10))));
    end
    
    
    for iTime=1:40;
    actdiffDR=mean(tmpD(:,iTime))-mean(tmpR(:,iTime));
    combvalDR=cat(1,mean(tmpD(:,iTime),2),mean(tmpR(:,iTime),2));
    actdiffWNW=mean(tmpW(:,iTime))-mean(tmpNW(:,iTime));
    combvalWNW=cat(1,mean(tmpW(:,iTime),2),mean(tmpNW(:,iTime),2));
    actdiffHL=mean(tmpH(:,iTime))-mean(tmpL(:,iTime));
    combvalHL=cat(1,mean(tmpH(:,iTime),2),mean(tmpL(:,iTime),2));
    for iPerm=1:nPerm;
        sIdxDR=shuffle(1:size(combvalDR,1));
        permvalDR(iPerm)=mean(combvalDR(sIdxDR(1:size(tmpD,1))))-mean(combvalDR(sIdxDR(size(tmpD,1)+1:length(sIdxDR))));
        sIdxWNW=shuffle(1:size(combvalWNW,1));
        permvalWNW(iPerm)=mean(combvalWNW(sIdxWNW(1:size(tmpW,1))))-mean(combvalWNW(sIdxWNW(size(tmpW,1)+1:length(sIdxWNW))));
        sIdxHL=shuffle(1:size(combvalHL,1));
        permvalHL(iPerm)=mean(combvalHL(sIdxHL(1:size(tmpH,1))))-mean(combvalHL(sIdxHL(size(tmpH,1)+1:length(sIdxHL))));        
    end
    
    zvalsDR(iChan,iTime)=(actdiffDR-mean(permvalDR))./std(permvalDR);
    zvalsWNW(iChan,iTime)=(actdiffWNW-mean(permvalWNW))./std(permvalWNW);
    zvalsHL(iChan,iTime)=(actdiffHL-mean(permvalHL))./std(permvalHL);
    
    pvalsDR(iChan,iTime)=length(find(permvalDR>actdiffDR))./nPerm;
    pvalsWNW(iChan,iTime)=length(find(permvalWNW>actdiffWNW))./nPerm;
    pvalsHL(iChan,iTime)=length(find(permvalHL>actdiffHL))./nPerm;

    end
    display(iChan)
end




% within conds
nPerm=1000;
for iChan=1:size(Spec_Chan_All_Aud,2);   
    tmpWD=[];
    tmpNWD=[];
    listOrder=[1,2,3,4];
    for iCond=1:2;
        tmpWD=cat(1,tmpWD,Spec_Chan_All_Aud{iChan}{listOrder(iCond)}./mean(mean(Spec_Chan_All_Aud{iChan}{listOrder(iCond)}(:,1:10))));
        tmpNWD=cat(1,tmpNWD,Spec_Chan_All_Aud{iChan}{listOrder(iCond+2)}./mean(mean(Spec_Chan_All_Aud{iChan}{listOrder(iCond+2)}(:,1:10))));
    end
    
    tmpHD=[];
    tmpLD=[];
    listOrder=[1,3,2,4];
    for iCond=1:2;
        tmpHD=cat(1,tmpHD,Spec_Chan_All_Aud{iChan}{listOrder(iCond)}./mean(mean(Spec_Chan_All_Aud{iChan}{listOrder(iCond)}(:,1:10))));
        tmpLD=cat(1,tmpLD,Spec_Chan_All_Aud{iChan}{listOrder(iCond+2)}./mean(mean(Spec_Chan_All_Aud{iChan}{listOrder(iCond+2)}(:,1:10))));
    end
    
    tmpWR=[];
    tmpNWR=[];
    listOrder=[5,6,7,8];
    for iCond=1:2;
        tmpWR=cat(1,tmpWR,Spec_Chan_All_Aud{iChan}{listOrder(iCond)}./mean(mean(Spec_Chan_All_Aud{iChan}{listOrder(iCond)}(:,1:10))));
        tmpNWR=cat(1,tmpNWR,Spec_Chan_All_Aud{iChan}{listOrder(iCond+2)}./mean(mean(Spec_Chan_All_Aud{iChan}{listOrder(iCond+2)}(:,1:10))));
    end
    
    tmpHR=[];
    tmpLR=[];
    listOrder=[5,7,6,8];
    for iCond=1:2;
        tmpHR=cat(1,tmpHR,Spec_Chan_All_Aud{iChan}{listOrder(iCond)}./mean(mean(Spec_Chan_All_Aud{iChan}{listOrder(iCond)}(:,1:10))));
        tmpLR=cat(1,tmpLR,Spec_Chan_All_Aud{iChan}{listOrder(iCond+2)}./mean(mean(Spec_Chan_All_Aud{iChan}{listOrder(iCond+2)}(:,1:10))));
    end
    
    
    for iTime=1:40;
   
    actdiffWNWD=mean(tmpWD(:,iTime))-mean(tmpNWD(:,iTime));
    combvalWNWD=cat(1,mean(tmpWD(:,iTime),2),mean(tmpNWD(:,iTime),2));
    actdiffHLD=mean(tmpHD(:,iTime))-mean(tmpLD(:,iTime));
    combvalHLD=cat(1,mean(tmpHD(:,iTime),2),mean(tmpLD(:,iTime),2));
    
    actdiffWNWR=mean(tmpWR(:,iTime))-mean(tmpNWR(:,iTime));
    combvalWNWR=cat(1,mean(tmpWR(:,iTime),2),mean(tmpNWR(:,iTime),2));
    actdiffHLR=mean(tmpHR(:,iTime))-mean(tmpLR(:,iTime));
    combvalHLR=cat(1,mean(tmpHR(:,iTime),2),mean(tmpLR(:,iTime),2));
    for iPerm=1:nPerm;
        sIdxWNWD=shuffle(1:size(combvalWNWD,1));
        permvalWNWD(iPerm)=mean(combvalWNWD(sIdxWNWD(1:size(tmpWD,1))))-mean(combvalWNWD(sIdxWNWD(size(tmpWD,1)+1:length(sIdxWNWD))));
        sIdxHLD=shuffle(1:size(combvalHLD,1));
        permvalHLD(iPerm)=mean(combvalHLD(sIdxHLD(1:size(tmpHD,1))))-mean(combvalHLD(sIdxHLD(size(tmpHD,1)+1:length(sIdxHLD)))); 
        sIdxWNWR=shuffle(1:size(combvalWNWR,1));
        permvalWNWR(iPerm)=mean(combvalWNWR(sIdxWNWR(1:size(tmpWR,1))))-mean(combvalWNWR(sIdxWNWR(size(tmpWR,1)+1:length(sIdxWNWR))));
        sIdxHLR=shuffle(1:size(combvalHLR,1));
        permvalHLR(iPerm)=mean(combvalHLR(sIdxHLR(1:size(tmpHR,1))))-mean(combvalHLR(sIdxHLR(size(tmpHR,1)+1:length(sIdxHLR))));        
    end
    
    zvalsWNWD(iChan,iTime)=(actdiffWNWD-mean(permvalWNWD))./std(permvalWNWD);
    zvalsHLD(iChan,iTime)=(actdiffHLD-mean(permvalHLD))./std(permvalHLD);
    
    pvalsWNWD(iChan,iTime)=length(find(permvalWNWD>actdiffWNWD))./nPerm;
    pvalsHLD(iChan,iTime)=length(find(permvalHLD>actdiffHLD))./nPerm;
    
    zvalsWNWR(iChan,iTime)=(actdiffWNWR-mean(permvalWNWR))./std(permvalWNWR);
    zvalsHLR(iChan,iTime)=(actdiffHLR-mean(permvalHLR))./std(permvalHLR);
    
    pvalsWNWR(iChan,iTime)=length(find(permvalWNWR>actdiffWNWR))./nPerm;
    pvalsHLR(iChan,iTime)=length(find(permvalHLR>actdiffHLR))./nPerm;

    end
    display(iChan)
end
