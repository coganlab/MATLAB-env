
idx=iiABCD_NT;

figure;
for iCond=1:4;
    hold on;
    errorbar(sq(mean(dataAD(idx,iCond,:))),std(sq(dataAD(idx,iCond,:)),[],1)./sqrt(length(idx)));
end



%idx=iiAC_NT;
clear gvals
gvals(1,:)=[1,2];
gvals(2,:)=[3,4];
figure;
for iCond=1:2;
    hold on;
    errorbar(sq(mean(mean(dataAD(idx,gvals(iCond,:),:)))),std(sq(mean(dataAD(idx,gvals(iCond,:),:),2)),[],1)./sqrt(length(idx)));
end



%idx=iiAC_NT;

% gvals(1,:)=[1,2];
% gvals(2,:)=[3,4];
nPerm=10000;
for iTime=1:40;
    actval=abs(mean(mean(dataAD(idx,gvals(1,:),iTime)))-mean(mean(dataAD(idx,gvals(2,:),iTime))));
    catval=cat(1,mean(dataAD(idx,gvals(1,:),iTime),2),mean(dataAD(idx,gvals(2,:),iTime),2));
    for iPerm=1:nPerm;
        sIdx=shuffle(1:size(catval,1));
        permvals(iPerm)=abs(mean(catval(sIdx(1:length(idx))))-mean(catval(sIdx(length(idx)+1:end))));
    end
    pTest(iTime)=length(find(actval<permvals))./nPerm;
    display(iTime)
end

figure;plot(-log(pTest))
hold on;plot(-log(0.05)*ones(40,1),'r--')
hold on;plot(-log(0.01)*ones(40,1),'m--')






idx=iiBD_T;

figure;
for iCond=1:4;
    hold on;
    errorbar(sq(mean(dataAR(idx,iCond,:))),std(sq(dataAR(idx,iCond,:)),[],1)./sqrt(length(idx)));
end



%idx=iiAB_T;
clear gvals
gvals(1,:)=[1,3];
gvals(2,:)=[2,4];
figure;
for iCond=1:2;
    hold on;
    errorbar(sq(mean(mean(dataAR(idx,gvals(iCond,:),:)))),std(sq(mean(dataAR(idx,gvals(iCond,:),:),2)),[],1)./sqrt(length(idx)));
end



%idx=iiB;

gvals(1,:)=[1,2];
gvals(2,:)=[3,4];
nPerm=10000;
for iTime=1:40;
    actval=abs(mean(mean(dataAR(idx,gvals(1,:),iTime)))-mean(mean(dataAR(idx,gvals(2,:),iTime))));
    catval=cat(1,mean(dataAR(idx,gvals(1,:),iTime),2),mean(dataAR(idx,gvals(2,:),iTime),2));
    for iPerm=1:nPerm;
        sIdx=shuffle(1:size(catval,1));
        permvals(iPerm)=abs(mean(catval(sIdx(1:length(idx))))-mean(catval(sIdx(length(idx)+1:end))));
    end
    pTest(iTime)=length(find(actval<permvals))./nPerm;
    display(iTime)
end

figure;plot(-log(pTest))
hold on;plot(-log(0.05)*ones(40,1),'r--')
hold on;plot(-log(0.01)*ones(40,1),'m--')



dataADR=cat(2,dataAD,dataAR);

idx=iiABCD_NT;
clear gvals
gvals(1,:)=[1,2,3,4];
gvals(2,:)=[5,6,7,8];
figure;
for iCond=1:2;
    hold on;
    errorbar(sq(mean(mean(dataADR(idx,gvals(iCond,:),:)))),std(sq(mean(dataADR(idx,gvals(iCond,:),:),2)),[],1)./sqrt(length(idx)));
end


idx=iiABCD_NT;
clear gvals
gvals(1,:)=[1,2,3,4];
gvals(2,:)=[5,6,7,8];
nPerm=10000;
for iTime=1:40;
    actval=abs(mean(mean(dataADR(idx,gvals(1,:),iTime)))-mean(mean(dataADR(idx,gvals(2,:),iTime))));
    catval=cat(1,mean(dataADR(idx,gvals(1,:),iTime),2),mean(dataADR(idx,gvals(2,:),iTime),2));
    for iPerm=1:nPerm;
        sIdx=shuffle(1:size(catval,1));
        permvals(iPerm)=abs(mean(catval(sIdx(1:length(idx))))-mean(catval(sIdx(length(idx)+1:end))));
    end
    pTest(iTime)=length(find(actval<permvals))./nPerm;
    display(iTime)
end

figure;plot(-log(pTest))
hold on;plot(-log(0.05)*ones(40,1),'r--')
hold on;plot(-log(0.01)*ones(40,1),'m--')


% PROD?



idx=iiABCD_NT;

figure;
for iCond=1:4;
    hold on;
    errorbar(sq(mean(dataPD(idx,iCond,:))),std(sq(dataPD(idx,iCond,:)),[],1)./sqrt(length(idx)));
end



idx=iiABCD_NT;
clear gvals
gvals(1,:)=[1,2];
gvals(2,:)=[3,4];
figure;
for iCond=1:2;
    hold on;
    errorbar(sq(mean(mean(dataPD(idx,gvals(iCond,:),:)))),std(sq(mean(dataPD(idx,gvals(iCond,:),:),2)),[],1)./sqrt(length(idx)));
end



idx=iiABCD_NT;
clear gvals
gvals(1,:)=[1,2];
gvals(2,:)=[3,4];
nPerm=10000;
for iTime=1:40;
    actval=abs(mean(mean(dataPD(idx,gvals(1,:),iTime)))-mean(mean(dataPD(idx,gvals(2,:),iTime))));
    catval=cat(1,mean(dataPD(idx,gvals(1,:),iTime),2),mean(dataPD(idx,gvals(2,:),iTime),2));
    for iPerm=1:nPerm;
        sIdx=shuffle(1:size(catval,1));
        permvals(iPerm)=abs(mean(catval(sIdx(1:length(idx))))-mean(catval(sIdx(length(idx)+1:end))));
    end
    pTest(iTime)=length(find(actval<permvals))./nPerm;
    display(iTime)
end

figure;plot(-log(pTest))
hold on;plot(-log(0.05)*ones(40,1),'r--')
hold on;plot(-log(0.01)*ones(40,1),'m--')






idx=iiBD_NT;

figure;
for iCond=1:4;
    hold on;
    errorbar(sq(mean(dataPR(idx,iCond,:))),std(sq(dataPR(idx,iCond,:)),[],1)./sqrt(length(idx)));
end



idx=iiBD_NT;
clear gvals
gvals(1,:)=[1,2];
gvals(2,:)=[3,4];
figure;
for iCond=1:2;
    hold on;
    errorbar(sq(mean(mean(dataPR(idx,gvals(iCond,:),:)))),std(sq(mean(dataPR(idx,gvals(iCond,:),:),2)),[],1)./sqrt(length(idx)));
end



idx=iiBD_NT;

gvals(1,:)=[1,2];
gvals(2,:)=[3,4];
nPerm=10000;
for iTime=1:40;
    actval=abs(mean(mean(dataPR(idx,gvals(1,:),iTime)))-mean(mean(dataPR(idx,gvals(2,:),iTime))));
    catval=cat(1,mean(dataPR(idx,gvals(1,:),iTime),2),mean(dataPR(idx,gvals(2,:),iTime),2));
    for iPerm=1:nPerm;
        sIdx=shuffle(1:size(catval,1));
        permvals(iPerm)=abs(mean(catval(sIdx(1:length(idx))))-mean(catval(sIdx(length(idx)+1:end))));
    end
    pTest(iTime)=length(find(actval<permvals))./nPerm;
    display(iTime)
end

figure;plot(-log(pTest))
hold on;plot(-log(0.05)*ones(40,1),'r--')
hold on;plot(-log(0.01)*ones(40,1),'m--')



dataPDR=cat(2,dataPD,dataPR);

idx=iiABCD_NT;
clear gvals
gvals(1,:)=[1,2,3,4];
gvals(2,:)=[5,6,7,8];
figure;
for iCond=1:2;
    hold on;
    errorbar(sq(mean(mean(dataPDR(idx,gvals(iCond,:),:)))),std(sq(mean(dataPDR(idx,gvals(iCond,:),:),2)),[],1)./sqrt(length(idx)));
end


idx=iiABCD_NT;
clear gvals
gvals(1,:)=[1,2,3,4];
gvals(2,:)=[5,6,7,8];
nPerm=10000;
for iTime=1:40;
    actval=abs(mean(mean(dataPDR(idx,gvals(1,:),iTime)))-mean(mean(dataPDR(idx,gvals(2,:),iTime))));
    catval=cat(1,mean(dataPDR(idx,gvals(1,:),iTime),2),mean(dataPDR(idx,gvals(2,:),iTime),2));
    for iPerm=1:nPerm;
        sIdx=shuffle(1:size(catval,1));
        permvals(iPerm)=abs(mean(catval(sIdx(1:length(idx))))-mean(catval(sIdx(length(idx)+1:end))));
    end
    pTest(iTime)=length(find(actval<permvals))./nPerm;
    display(iTime)
end

figure;plot(-log(pTest))
hold on;plot(-log(0.05)*ones(40,1),'r--')
hold on;plot(-log(0.01)*ones(40,1),'m--')


