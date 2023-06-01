designMat=[1 1 0 0 ;1 0 1 0 ;0 1 1 0];
idx=1:925; %iiABCD;]
outcut=3;
for iChan=1:length(idx); %704 %length(ii);
    F1=[];
    F2=[];
    F3=[];

    % ii=find(NewAreaLoc==iChan);
    AreaTrials=[];
    %   SubjectTrials=[];
  
    
%     baselineVals=[];
%     for iCond=1:8;
%         baselineVals=cat(1,baselineVals,Spec_Chan_All_Start{idx(iChan)}{iCond}(:,1:10));
%     end
    
    baselineValsD=[];
    baselineValsR=[];
    for iCond=1:4;
        baselineValsD=cat(1,baselineValsD,Spec_Chan_All_Start{idx(iChan)}{iCond}(:,1:10));
        baselineValsR=cat(1,baselineValsR,Spec_Chan_All_Start{idx(iChan)}{iCond+4}(:,1:10));
    end
    
    
    
    [mD sD]=normfit(log(baselineValsD(:)));
    [mR sR]=normfit(log(baselineValsR(:)));
    
    [ID J]=find(log(baselineValsD)>outcut*sD+mD);
    goodIdxD=setdiff(1:size(baselineValsD,1),unique(ID));
    tmp=baselineValsD(goodIdxD,:);
    [mD sD]=normfit(log(tmp(:)));
    [IR J]=find(log(baselineValsD)>outcut*sD+mD);
    goodIdxR=setdiff(1:size(baselineValsR,1),unique(IR));
    tmp=baselineValsR(goodIdxR,:);

    [mR sR]=normfit(log(tmp(:)));
    
    
    
    for iCond=1:4
        %    AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(Spec_Chan_All_Aud{idx(iChan)}{iCond}(:,1:10))));
     %   AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(baselineVals)));
     
       %     AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(baselineValsD)));
            AreaTrials=cat(1,AreaTrials,(log(Spec_Chan_All_Aud{idx(iChan)}{iCond})-mD)./sD);
  
        
        % SubjectTrials=cat(1,SubjectTrials,Spec_Subject(ii(iChan))*ones(size(Spec_Chan_All_Aud{ii(iChan)}{iCond},1),1));
        F1=cat(1,F1,designMat(1,iCond)*ones(size(Spec_Chan_All_Aud{idx(iChan)}{iCond},1),1));
        F2=cat(1,F2,designMat(2,iCond)*ones(size(Spec_Chan_All_Aud{idx(iChan)}{iCond},1),1));
        F3=cat(1,F3,designMat(3,iCond)*ones(size(Spec_Chan_All_Aud{idx(iChan)}{iCond},1),1));
     

    end
    
    
    [m s]=normfit(AreaTrials(:));
    [I J]=find(AreaTrials>outcut*s+m);
    goodTrials=setdiff(1:size(AreaTrials,1),unique(I));
    
    
    
    % FS=cat(2,F1,F2,F3,F1.*F2,F1.*F3,F2.*F3); % mains and inter
    FS1=cat(2,F1,F2,F3); % just mains
    %  FS=cat(2,FS1,SubjectTrials); % subject random effects
    FS=cat(2,FS1,ones(size(FS1,1),1)); % add constant
    FS2=cat(2,FS1,FS1(:,1).*FS1(:,2),FS1(:,1).*FS1(:,3),FS1(:,2).*FS1(:,3),FS1(:,1).*FS1(:,2).*FS1(:,3));
    
    FS1=FS1(goodTrials,:);
    FS=FS(goodTrials,:);
    FS2=FS2(goodTrials,:);
    AreaTrials=AreaTrials(goodTrials,:);
        
    for iTime=1:40
        dataT=AreaTrials(:,iTime);
        % normalize?
     %   dataT=(log(dataT)-mean(log(dataT)))./std(log(dataT));
        % [b,bint,r,rint,stats] = regress(dataT,FS);
        %mdl=fitlm(FS,dataT,'interactions','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
        %   mdl=fitlm(FS1,dataT,'interactions','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
        [P T stats terms]=anovan(dataT,FS1,'model','full','display','off');
        [B FitInfo]=lasso(FS2,dataT,'CV',5);
        TvalsD(iChan,iTime,:)=stats.coeffs;
      %  LassoVals(iChan,iTime,:)=B(:,1);
        LassoValsD(iChan,iTime,:)=B(:,FitInfo.IndexMinMSE);
  %      LassoVals(iChan,iTime,:)=B(:,FitInfo.Index1SE);
       
        
        %      Tvals(iChan,iTime,:)=b; %Tvals1;
        %     Pvals(iChan,iTime,:)=stats(3);
        PvalsD(iChan,iTime,:)=P; %stats(3);
        FvalsD(iChan,iTime,1)=T{2,6};
        FvalsD(iChan,iTime,2)=T{3,6};
        FvalsD(iChan,iTime,3)=T{4,6};
        FvalsD(iChan,iTime,4)=T{5,6};
        FvalsD(iChan,iTime,5)=T{6,6};
        FvalsD(iChan,iTime,6)=T{7,6};
        FvalsD(iChan,iTime,7)=T{8,6};
%         Fvals(iChan,iTime,8)=T{9,6};
%         Fvals(iChan,iTime,9)=T{10,6};
%         Fvals(iChan,iTime,10)=T{11,6};
%         Fvals(iChan,iTime,11)=T{12,6};
%         Fvals(iChan,iTime,12)=T{13,6};
%         Fvals(iChan,iTime,13)=T{14,6};
%         Fvals(iChan,iTime,14)=T{15,6};
%         Fvals(iChan,iTime,15)=T{16,6};

        %     Rvals(iChan,iTime,:)=stats(1);
        %     TvalsM{iChan}{iTime}=mdl;
    end
    display(iChan)
    
end


designMat=[1 1 0 0 ;1 0 1 0 ;0 1 1 0];
idx=1:925; %iiABCD;]
outcut=3;
for iChan=1:length(idx); %704 %length(ii);
    F1=[];
    F2=[];
    F3=[];

    % ii=find(NewAreaLoc==iChan);
    AreaTrials=[];
    %   SubjectTrials=[];
  
    
%     baselineVals=[];
%     for iCond=1:8;
%         baselineVals=cat(1,baselineVals,Spec_Chan_All_Start{idx(iChan)}{iCond}(:,1:10));
%     end
    
    baselineValsD=[];
    baselineValsR=[];
    for iCond=1:4;
        baselineValsD=cat(1,baselineValsD,Spec_Chan_All_Start{idx(iChan)}{iCond}(:,1:10));
        baselineValsR=cat(1,baselineValsR,Spec_Chan_All_Start{idx(iChan)}{iCond+4}(:,1:10));
    end
    
    
    
    [mD sD]=normfit(log(baselineValsD(:)));
    [mR sR]=normfit(log(baselineValsR(:)));
    
    [ID J]=find(log(baselineValsD)>outcut*sD+mD);
    goodIdxD=setdiff(1:size(baselineValsD,1),unique(ID));
    tmp=baselineValsD(goodIdxD,:);
    [mD sD]=normfit(log(tmp(:)));
    [IR J]=find(log(baselineValsD)>outcut*sD+mD);
    goodIdxR=setdiff(1:size(baselineValsR,1),unique(IR));
    tmp=baselineValsR(goodIdxR,:);

    [mR sR]=normfit(log(tmp(:)));
    
    
    
    for iCond=1:4
        %    AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(Spec_Chan_All_Aud{idx(iChan)}{iCond}(:,1:10))));
     %   AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(baselineVals)));
     
       %     AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(baselineValsD)));
            AreaTrials=cat(1,AreaTrials,(log(Spec_Chan_All_Aud{idx(iChan)}{iCond+4})-mR)./sR);
  
        
        % SubjectTrials=cat(1,SubjectTrials,Spec_Subject(ii(iChan))*ones(size(Spec_Chan_All_Aud{ii(iChan)}{iCond},1),1));
        F1=cat(1,F1,designMat(1,iCond)*ones(size(Spec_Chan_All_Aud{idx(iChan)}{iCond+4},1),1));
        F2=cat(1,F2,designMat(2,iCond)*ones(size(Spec_Chan_All_Aud{idx(iChan)}{iCond+4},1),1));
        F3=cat(1,F3,designMat(3,iCond)*ones(size(Spec_Chan_All_Aud{idx(iChan)}{iCond+4},1),1));
     

    end
    
    
    [m s]=normfit(AreaTrials(:));
    [I J]=find(AreaTrials>outcut*s+m);
    goodTrials=setdiff(1:size(AreaTrials,1),unique(I));
    
    
    
    % FS=cat(2,F1,F2,F3,F1.*F2,F1.*F3,F2.*F3); % mains and inter
    FS1=cat(2,F1,F2,F3); % just mains
    %  FS=cat(2,FS1,SubjectTrials); % subject random effects
    FS=cat(2,FS1,ones(size(FS1,1),1)); % add constant
    FS2=cat(2,FS1,FS1(:,1).*FS1(:,2),FS1(:,1).*FS1(:,3),FS1(:,2).*FS1(:,3),FS1(:,1).*FS1(:,2).*FS1(:,3));
    
    FS1=FS1(goodTrials,:);
    FS=FS(goodTrials,:);
    FS2=FS2(goodTrials,:);
    AreaTrials=AreaTrials(goodTrials,:);
        
    for iTime=1:40
        dataT=AreaTrials(:,iTime);
        % normalize?
     %   dataT=(log(dataT)-mean(log(dataT)))./std(log(dataT));
        % [b,bint,r,rint,stats] = regress(dataT,FS);
        %mdl=fitlm(FS,dataT,'interactions','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
        %   mdl=fitlm(FS1,dataT,'interactions','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
        [P T stats terms]=anovan(dataT,FS1,'model','full','display','off');
        [B FitInfo]=lasso(FS2,dataT,'CV',5);
        TvalsR(iChan,iTime,:)=stats.coeffs;
      %  LassoVals(iChan,iTime,:)=B(:,1);
        LassoValsR(iChan,iTime,:)=B(:,FitInfo.IndexMinMSE);
  %      LassoVals(iChan,iTime,:)=B(:,FitInfo.Index1SE);
       
        
        %      Tvals(iChan,iTime,:)=b; %Tvals1;
        %     Pvals(iChan,iTime,:)=stats(3);
        PvalsR(iChan,iTime,:)=P; %stats(3);
        FvalsR(iChan,iTime,1)=T{2,6};
        FvalsR(iChan,iTime,2)=T{3,6};
        FvalsR(iChan,iTime,3)=T{4,6};
        FvalsR(iChan,iTime,4)=T{5,6};
        FvalsR(iChan,iTime,5)=T{6,6};
        FvalsR(iChan,iTime,6)=T{7,6};
        FvalsR(iChan,iTime,7)=T{8,6};
%         Fvals(iChan,iTime,8)=T{9,6};
%         Fvals(iChan,iTime,9)=T{10,6};
%         Fvals(iChan,iTime,10)=T{11,6};
%         Fvals(iChan,iTime,11)=T{12,6};
%         Fvals(iChan,iTime,12)=T{13,6};
%         Fvals(iChan,iTime,13)=T{14,6};
%         Fvals(iChan,iTime,14)=T{15,6};
%         Fvals(iChan,iTime,15)=T{16,6};

        %     Rvals(iChan,iTime,:)=stats(1);
        %     TvalsM{iChan}{iTime}=mdl;
    end
    display(iChan)
    
end





sigCut=0.05;
clusterSize=6;


PvalsDM=zeros(size(PvalsD,1),size(PvalsD,2),size(PvalsD,3));
ii=find(PvalsD<sigCut);
PvalsDM(ii)=1;



clusterStartD=zeros(size(PvalsDM,1),size(PvalsDM,3));
for iCond=1:size(PvalsD,3);
    
    
    for iChan=1:size(clusterStartD,1);
        
        %tmp=bwconncomp(sq(PvalsM(iChan,:,iCond)));
        tmp=bwconncomp(sq(PvalsDM(iChan,:,iCond)));
        
        if size(tmp.PixelIdxList,2)>0
            for ii=1:size(tmp.PixelIdxList,2);
                ii2(ii)=size(tmp.PixelIdxList{ii},1);
            end
            
            ii2B=find(ii2>=clusterSize);
            if length(ii2B)>0
                for ii=1:length(ii2B);
                    ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
                    clusterStartD(iChan,iCond)=ii3(ii);
                end
            end
            
            
            clear ii3
            
            
            SigClusterSizeD(iChan,iCond)=max(ii2);
        else
            SigClusterSizeD(iChan,iCond)=0;
        end
        clear ii2
    end
    
end
clear iiSig
for iCond=1:size(PvalsD,3);
    iiSigD{iCond}=find(SigClusterSizeD(:,iCond)>=clusterSize);
end



PvalsRM=zeros(size(PvalsR,1),size(PvalsR,2),size(PvalsR,3));
ii=find(PvalsR<sigCut);
PvalsRM(ii)=1;



clusterStartR=zeros(size(PvalsRM,1),size(PvalsRM,3));
for iCond=1:size(PvalsR,3);
    
    
    for iChan=1:size(clusterStartR,1);
        
        %tmp=bwconncomp(sq(PvalsM(iChan,:,iCond)));
        tmp=bwconncomp(sq(PvalsRM(iChan,:,iCond)));
        
        if size(tmp.PixelIdxList,2)>0
            for ii=1:size(tmp.PixelIdxList,2);
                ii2(ii)=size(tmp.PixelIdxList{ii},1);
            end
            
            ii2B=find(ii2>=clusterSize);
            if length(ii2B)>0
                for ii=1:length(ii2B);
                    ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
                    clusterStartR(iChan,iCond)=ii3(ii);
                end
            end
            
            
            clear ii3
            
            
            SigClusterSizeR(iChan,iCond)=max(ii2);
        else
            SigClusterSizeR(iChan,iCond)=0;
        end
        clear ii2
    end
    
end
clear iiSig
for iCond=1:size(PvalsR,3);
    iiSigR{iCond}=find(SigClusterSizeR(:,iCond)>=clusterSize);
end

idx=11:40;
iiLPosD=find(sum(sq(PvalsDM(iiSigD{1},idx,1)).*sq(TvalsD(iiSigD{1},idx,3)),2)>0);
iiLNegD=find(sum(sq(PvalsDM(iiSigD{1},idx,1)).*sq(TvalsD(iiSigD{1},idx,3)),2)<0);

iiPPosD=find(sum(sq(PvalsDM(iiSigD{2},idx,2)).*sq(TvalsD(iiSigD{2},idx,5)),2)>0);
iiPNegD=find(sum(sq(PvalsDM(iiSigD{2},idx,2)).*sq(TvalsD(iiSigD{2},idx,5)),2)<0);


iiLPosR=find(sum(sq(PvalsRM(iiSigR{1},idx,1)).*sq(TvalsR(iiSigR{1},idx,3)),2)>0);
iiLNegR=find(sum(sq(PvalsRM(iiSigR{1},idx,1)).*sq(TvalsR(iiSigR{1},idx,3)),2)<0);

iiPPosR=find(sum(sq(PvalsRM(iiSigR{2},idx,2)).*sq(TvalsR(iiSigR{2},idx,5)),2)>0);
iiPNegR=find(sum(sq(PvalsRM(iiSigR{2},idx,2)).*sq(TvalsR(iiSigR{2},idx,5)),2)<0);