
% DEC AUD
idx=iiAC_T; %_NT2; %setdiff(totalActiveElecsJustDA_T,iiAC_T);

for iChan=1:length(idx)
    test1=[];
    for iCond=1:4;
        test1=cat(1,test1,Spec_Chan_All_Start{idx(iChan)}{iCond});
        baselineval2(iChan,iCond)=mean(mean(Spec_Chan_All_Start{idx(iChan)}{iCond}(:,1:10)));
    end
    baselineval(iChan)=mean(mean(test1(:,1:10)));
    
end

sigvals={};
for iCond=1:4;
    test1=[];
    for iChan=1:length(idx);
 %   test1=cat(1,test1,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(Spec_Chan_All_Aud{idx(iChan)}{iCond}(:,1:10),2));
     test1=cat(1,test1,Spec_Chan_All_Aud{idx(iChan)}{iCond}./baselineval(iChan));
  %   test1=cat(1,test1,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(Spec_Chan_All_Aud{idx(iChan)}{iCond}(:,1:40),2));
  %  test1=cat(1,test1,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(Spec_Chan_All_Start{idx(iChan)}{iCond}(:,1:10),2),1));

    end
    sigvals{iCond}=(test1);
end




figure;
for iCond=1:4;
    hold on
    errorbar(mean(sigvals{iCond}),std(sigvals{iCond},[],1)./sqrt(size(sigvals{iCond},1)));
end


nPerm=10000;
for iTime=1:40;
    actvalL=abs(mean(cat(1,sigvals{1}(:,iTime),sigvals{2}(:,iTime)))-mean(cat(1,sigvals{3}(:,iTime),sigvals{4}(:,iTime))));
    actvalP=abs(mean(cat(1,sigvals{1}(:,iTime),sigvals{3}(:,iTime)))-mean(cat(1,sigvals{2}(:,iTime),sigvals{4}(:,iTime))));
    actsizeL=size(cat(1,sigvals{1},sigvals{2}),1);
    actsizeP=size(cat(1,sigvals{1},sigvals{3}),1);
    catval=cat(1,sigvals{1}(:,iTime),sigvals{2}(:,iTime),sigvals{3}(:,iTime),sigvals{4}(:,iTime));
 
    for iPerm=1:nPerm;
        sIdx=shuffle(1:size(catval,1));
        permvalsL(iPerm)=abs(mean(catval(sIdx(1:actsizeL)))-mean(catval(sIdx(actsizeL+1:end))));
        permvalsP(iPerm)=abs(mean(catval(sIdx(1:actsizeP)))-mean(catval(sIdx(actsizeP+1:end))));        
    end
    pTestL(iTime)=length(find(actvalL<permvalsL))./nPerm;
    pTestP(iTime)=length(find(actvalP<permvalsP))./nPerm;
    display(iTime)
end

figure;plot(-log(pTestL),'b')
hold on;plot(-log(pTestP),'g')
hold on;plot(-log(0.05)*ones(40,1),'r--')
hold on;plot(-log(0.01)*ones(40,1),'m--')
legend('Lex','Phono','p = 0.05','p = 0.01')



% REP AUD
idx=iiBD_T; %_NT2; %setdiff(totalActiveElecsJustDA_T,iiAC_T);

for iChan=1:length(idx)
    test1=[];
    for iCond=1:4;
        test1=cat(1,test1,Spec_Chan_All_Start{idx(iChan)}{iCond+4});
        baselineval2(iChan,iCond)=mean(mean(Spec_Chan_All_Start{idx(iChan)}{iCond+4}(:,1:10)));
    end
    baselineval(iChan)=mean(mean(test1(:,1:10)));
    
end

sigvals={};
for iCond=1:4;
    test1=[];
    for iChan=1:length(idx);
 %   test1=cat(1,test1,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(Spec_Chan_All_Aud{idx(iChan)}{iCond}(:,1:10),2));
     test1=cat(1,test1,Spec_Chan_All_Aud{idx(iChan)}{iCond+4}./baselineval(iChan));
  %   test1=cat(1,test1,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(Spec_Chan_All_Aud{idx(iChan)}{iCond}(:,1:40),2));
  %  test1=cat(1,test1,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(Spec_Chan_All_Start{idx(iChan)}{iCond}(:,1:10),2),1));

    end
    sigvals{iCond}=(test1);
end




figure;
for iCond=1:4;
    hold on
    errorbar(mean(sigvals{iCond}),std(sigvals{iCond},[],1)./sqrt(size(sigvals{iCond},1)));
end


nPerm=10000;
for iTime=1:40;
    actvalL=abs(mean(cat(1,sigvals{1}(:,iTime),sigvals{2}(:,iTime)))-mean(cat(1,sigvals{3}(:,iTime),sigvals{4}(:,iTime))));
    actvalP=abs(mean(cat(1,sigvals{1}(:,iTime),sigvals{3}(:,iTime)))-mean(cat(1,sigvals{2}(:,iTime),sigvals{4}(:,iTime))));
    actsizeL=size(cat(1,sigvals{1},sigvals{2}),1);
    actsizeP=size(cat(1,sigvals{1},sigvals{3}),1);
    catval=cat(1,sigvals{1}(:,iTime),sigvals{2}(:,iTime),sigvals{3}(:,iTime),sigvals{4}(:,iTime));
 
    for iPerm=1:nPerm;
        sIdx=shuffle(1:size(catval,1));
        permvalsL(iPerm)=abs(mean(catval(sIdx(1:actsizeL)))-mean(catval(sIdx(actsizeL+1:end))));
        permvalsP(iPerm)=abs(mean(catval(sIdx(1:actsizeP)))-mean(catval(sIdx(actsizeP+1:end))));        
    end
    pTestL(iTime)=length(find(actvalL<permvalsL))./nPerm;
    pTestP(iTime)=length(find(actvalP<permvalsP))./nPerm;
    display(iTime)
end

figure;plot(-log(pTestL),'b')
hold on;plot(-log(pTestP),'g')
hold on;plot(-log(0.05)*ones(40,1),'r--')
hold on;plot(-log(0.01)*ones(40,1),'m--')
legend('Lex','Phono','p = 0.05','p = 0.01')


% DEC PROD
idx=iiAC_T; %_NT2; %setdiff(totalActiveElecsJustDA_T,iiAC_T);

for iChan=1:length(idx)
    test1=[];
    for iCond=1:4;
        test1=cat(1,test1,Spec_Chan_All_Start{idx(iChan)}{iCond});
        baselineval2(iChan,iCond)=mean(mean(Spec_Chan_All_Start{idx(iChan)}{iCond}(:,1:10)));
    end
    baselineval(iChan)=mean(mean(test1(:,1:10)));
    
end

sigvals={};
for iCond=1:4;
    test1=[];
    for iChan=1:length(idx);
 %   test1=cat(1,test1,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(Spec_Chan_All_Aud{idx(iChan)}{iCond}(:,1:10),2));
     test1=cat(1,test1,Spec_Chan_All_Prod{idx(iChan)}{iCond}./baselineval(iChan));
  %   test1=cat(1,test1,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(Spec_Chan_All_Aud{idx(iChan)}{iCond}(:,1:40),2));
  %  test1=cat(1,test1,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(Spec_Chan_All_Start{idx(iChan)}{iCond}(:,1:10),2),1));

    end
    sigvals{iCond}=(test1);
end




figure;
for iCond=1:4;
    hold on
    errorbar(mean(sigvals{iCond}),std(sigvals{iCond},[],1)./sqrt(size(sigvals{iCond},1)));
end


nPerm=10000;
for iTime=1:40;
    actvalL=abs(mean(cat(1,sigvals{1}(:,iTime),sigvals{2}(:,iTime)))-mean(cat(1,sigvals{3}(:,iTime),sigvals{4}(:,iTime))));
    actvalP=abs(mean(cat(1,sigvals{1}(:,iTime),sigvals{3}(:,iTime)))-mean(cat(1,sigvals{2}(:,iTime),sigvals{4}(:,iTime))));
    actsizeL=size(cat(1,sigvals{1},sigvals{2}),1);
    actsizeP=size(cat(1,sigvals{1},sigvals{3}),1);
    catval=cat(1,sigvals{1}(:,iTime),sigvals{2}(:,iTime),sigvals{3}(:,iTime),sigvals{4}(:,iTime));
 
    for iPerm=1:nPerm;
        sIdx=shuffle(1:size(catval,1));
        permvalsL(iPerm)=abs(mean(catval(sIdx(1:actsizeL)))-mean(catval(sIdx(actsizeL+1:end))));
        permvalsP(iPerm)=abs(mean(catval(sIdx(1:actsizeP)))-mean(catval(sIdx(actsizeP+1:end))));        
    end
    pTestL(iTime)=length(find(actvalL<permvalsL))./nPerm;
    pTestP(iTime)=length(find(actvalP<permvalsP))./nPerm;
    display(iTime)
end

figure;plot(-log(pTestL),'b')
hold on;plot(-log(pTestP),'g')
hold on;plot(-log(0.05)*ones(40,1),'r--')
hold on;plot(-log(0.01)*ones(40,1),'m--')
legend('Lex','Phono','p = 0.05','p = 0.01')



% REP PROD
idx=iiABCD; %_NT2; %setdiff(totalActiveElecsJustDA_T,iiAC_T);

for iChan=1:length(idx)
    test1=[];
    for iCond=1:4;
        test1=cat(1,test1,Spec_Chan_All_Start{idx(iChan)}{iCond+4});
        baselineval2(iChan,iCond)=mean(mean(Spec_Chan_All_Start{idx(iChan)}{iCond+4}(:,1:10)));
    end
    baselineval(iChan)=mean(mean(test1(:,1:10)));
    
end

sigvals={};
for iCond=1:4;
    test1=[];
    for iChan=1:length(idx);
 %   test1=cat(1,test1,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(Spec_Chan_All_Aud{idx(iChan)}{iCond}(:,1:10),2));
     test1=cat(1,test1,Spec_Chan_All_Prod{idx(iChan)}{iCond+4}./baselineval(iChan));
  %   test1=cat(1,test1,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(Spec_Chan_All_Aud{idx(iChan)}{iCond}(:,1:40),2));
  %  test1=cat(1,test1,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(Spec_Chan_All_Start{idx(iChan)}{iCond}(:,1:10),2),1));

    end
    sigvals{iCond}=(test1);
end




figure;
for iCond=1:4;
    hold on
    errorbar(mean(sigvals{iCond}),std(sigvals{iCond},[],1)./sqrt(size(sigvals{iCond},1)));
end


nPerm=10000;
for iTime=1:40;
    actvalL=abs(mean(cat(1,sigvals{1}(:,iTime),sigvals{2}(:,iTime)))-mean(cat(1,sigvals{3}(:,iTime),sigvals{4}(:,iTime))));
    actvalP=abs(mean(cat(1,sigvals{1}(:,iTime),sigvals{3}(:,iTime)))-mean(cat(1,sigvals{2}(:,iTime),sigvals{4}(:,iTime))));
    actsizeL=size(cat(1,sigvals{1},sigvals{2}),1);
    actsizeP=size(cat(1,sigvals{1},sigvals{3}),1);
    catval=cat(1,sigvals{1}(:,iTime),sigvals{2}(:,iTime),sigvals{3}(:,iTime),sigvals{4}(:,iTime));
 
    for iPerm=1:nPerm;
        sIdx=shuffle(1:size(catval,1));
        permvalsL(iPerm)=abs(mean(catval(sIdx(1:actsizeL)))-mean(catval(sIdx(actsizeL+1:end))));
        permvalsP(iPerm)=abs(mean(catval(sIdx(1:actsizeP)))-mean(catval(sIdx(actsizeP+1:end))));        
    end
    pTestL(iTime)=length(find(actvalL<permvalsL))./nPerm;
    pTestP(iTime)=length(find(actvalP<permvalsP))./nPerm;
    display(iTime)
end

figure;plot(-log(pTestL),'b')
hold on;plot(-log(pTestP),'g')
hold on;plot(-log(0.05)*ones(40,1),'r--')
hold on;plot(-log(0.01)*ones(40,1),'m--')
legend('Lex','Phono','p = 0.05','p = 0.01')



