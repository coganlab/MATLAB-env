for iChan=1:704;
    tmpAD=[];
    tmpAR=[];
    groupsD=[];
    groupsR=[];
    
    for iCond=1:4
        tmpAD=cat(1,tmpAD,Spec_Chan_All_Aud{iChan}{iCond});
        tmpAR=cat(1,tmpAR,Spec_Chan_All_Aud{iChan}{iCond+4});
        groupsD=cat(1,groupsD,iCond*ones(size(Spec_Chan_All_Aud{iChan}{iCond},1),1));
        groupsR=cat(1,groupsR,iCond*ones(size(Spec_Chan_All_Aud{iChan}{iCond+4},1),1));
    end
%     [MD SD]=normfit(mean(tmpAD(:,1:10),2));
%     [MR SR]=normfit(mean(tmpAR(:,1:10),2));
    [MD SD]=normfit(reshape(tmpAD(:,1:10),size(tmpAD,1)*10,1));
    [MR SR]=normfit(reshape(tmpAR(:,1:10),size(tmpAR,1)*10,1));

    iiOutD=find(mean(tmpAD(:,1:10),2)>2*SD+MD);
    iiOutR=find(mean(tmpAR(:,1:10),2)>2*SR+MR);
    iiInD=setdiff(1:length(tmpAD),iiOutD);
    iiInR=setdiff(1:length(tmpAR),iiOutR);
    
    
    
    sig1=[];
    groups=[];
    for iCond=1:4;
        sig1A=Spec_Chan_All_Aud{iChan}{iCond}./mean(mean(Spec_Chan_All_Aud{iChan}{iCond}(1:10,:)));
       % sig1A=Spec_Chan_All_Aud{iChan}{iCond}(:,:);
        sig1A=Spec_Chan_All_Aud{iChan}{iCond}(:,:)./sq(mean(mean(tmpAD)));
        sig1=cat(1,sig1A,sig1);
        groups=cat(1,groups,iCond*ones(size(sig1A,1),1));
    end
    sig1=sig1(iiInD,:);
    groups=groups(iiInD);
    groups2=zeros(size(groups,1),2);
    ii=find(groups==1);
    groups2(ii,1)=1;
    groups2(ii,2)=1;
    ii=find(groups==2);
    groups2(ii,1)=1;
    ii=find(groups==3);
    groups2(ii,2)=1;
    
    for iTime=1:40;
        [P(iChan,iTime,:) T{iChan}{iTime}]=anovan(log(sig1(:,iTime)),groups2,'model','full','display','off');
    end
    display(iChan)
end

for iChan=1:704;
    for iTime=1:40;
        T2D(iChan,iTime,1)=T{iChan}{iTime}{2,6};
        T2D(iChan,iTime,2)=T{iChan}{iTime}{3,6};
        T2D(iChan,iTime,3)=T{iChan}{iTime}{4,6};
    end
end

sigB=[];
groupsB=[];
for iCode=1:4
sigB=cat(1,sigB,sq(dataAD(iiAC,iCode,:)));
groupsB=cat(1,groupsB,iCode*ones(length(iiAC),1));
end

groupsB2=zeros(size(groupsB,1),2);
    ii=find(groupsB==1);
    groupsB2(ii,1)=1;
    groupsB2(ii,2)=1;
    ii=find(groupsB==2);
    groupsB2(ii,1)=1;
    ii=find(groupsB==3);
    groupsB2(ii,2)=1;
for iTime=1:40;
        [P2(iTime,:) T2{iTime}]=anovan(log(sigB(:,iTime)),groupsB2,'model','full','display','off');
end



idx=iiABCD;
sigB=[];
groupsB=[];
for iCode=1:4
sigB=cat(1,sigB,sq(dataAD(idx,iCode,:)));
groupsB=cat(1,groupsB,iCode*ones(length(idx),1));
end

groupsB2=zeros(size(groupsB,1),2);
    ii=find(groupsB==1);
    groupsB2(ii,1)=1;
    groupsB2(ii,2)=1;
    ii=find(groupsB==2);
    groupsB2(ii,1)=1;
    ii=find(groupsB==3);
    groupsB2(ii,2)=1;
for iTime=1:40;
        [P2(iTime,:) T2{iTime}]=anovan((sigB(:,iTime)),groupsB2,'model','full','display','off');
end


figure;plot(-log(P2))
hold on;plot(-log(.01)*ones(40,1),'k--')