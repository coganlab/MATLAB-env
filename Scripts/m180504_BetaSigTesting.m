betaBL=sq(betaB(GoodChanIdxL,:,1));
betaBP=sq(betaB(GoodChanIdxP,:,2));
betaBT=sq(betaB(GoodChanIdxT,:,3));

betaBL=sq(betaB(iiS,:,1));
betaBP=sq(betaB(iiS,:,2));
betaBT=sq(betaB(iiS,:,3));
nPerm=1000;


nPerm=1000;
for iTime=1:40;
    actdiffL=mean(betaBL(:,iTime))-mean(mean(betaBL(:,1:10)));
    actdiffP=mean(betaBP(:,iTime))-mean(mean(betaBP(:,1:10)));
    actdiffT=mean(betaBT(:,iTime))-mean(mean(betaBT(:,1:10)));
    
    combvalL=cat(1,betaBL(:,iTime),mean(betaBL(:,1:10),2));
    combvalP=cat(1,betaBP(:,iTime),mean(betaBP(:,1:10),2));
    combvalT=cat(1,betaBT(:,iTime),mean(betaBT(:,1:10),2));

    for iPerm=1:nPerm;
        shuffidxL=shuffle(1:length(combvalL));
        shuffidxP=shuffle(1:length(combvalP));
        shuffidxT=shuffle(1:length(combvalT));
        permvalL(iPerm)=mean(combvalL(shuffidxL(1:size(betaBL,1))))-mean(combvalL(shuffidxL(size(betaBL,1)+1:length(combvalL))));
        permvalP(iPerm)=mean(combvalP(shuffidxP(1:size(betaBP,1))))-mean(combvalP(shuffidxP(size(betaBP,1)+1:length(combvalP))));
        permvalT(iPerm)=mean(combvalT(shuffidxT(1:size(betaBT,1))))-mean(combvalT(shuffidxT(size(betaBT,1)+1:length(combvalT))));
    end
    pvalL(iTime)=length(find(actdiffL<permvalL))./nPerm;
    pvalP(iTime)=length(find(actdiffP<permvalP))./nPerm;
    pvalT(iTime)=length(find(actdiffT<permvalT))./nPerm;
end
ii=find(pvalL==0);
pvalL(ii)=1/nPerm;
ii=find(pvalT==0);
pvalT(ii)=1/nPerm;
ii=find(pvalP==0);
pvalP(ii)=1/nPerm;

ii=find(pvalL==1);
pvalL(ii)=1-1/nPerm;
ii=find(pvalT==1);
pvalT(ii)=1-1/nPerm;
ii=find(pvalP==1);
pvalP(ii)=1-1/nPerm;

