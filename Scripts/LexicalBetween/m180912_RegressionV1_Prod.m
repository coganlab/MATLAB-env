designMat=[1 1 0 0 1 1 0 0;1 1 1 1 0 0 0 0;1 0 1 0 1 0 1 0];
idx=1:925; %iiABCD;]
outcut=3;
for iChan=1:length(idx); %704 %length(ii);
    F1=[];
    F2=[];
    F3=[];

    % ii=find(NewAreaLoc==iChan);
    AreaTrials=[];
    %   SubjectTrials=[];
  
    
    baselineVals=[];
    for iCond=1:8;
        baselineVals=cat(1,baselineVals,Spec_Chan_All_Start{idx(iChan)}{iCond}(:,1:10));
    end
    
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
    
    
    
    for iCond=1:8
        %    AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(Spec_Chan_All_Aud{idx(iChan)}{iCond}(:,1:10))));
     %   AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(baselineVals)));
        if iCond<=4
       %     AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(baselineValsD)));
            AreaTrials=cat(1,AreaTrials,(log(Spec_Chan_All_Prod{idx(iChan)}{iCond})-mD)./sD);
            
        elseif iCond>=5
           % AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(baselineValsR)));
            AreaTrials=cat(1,AreaTrials,(log(Spec_Chan_All_Prod{idx(iChan)}{iCond})-mR)./sR);
            
        end
        
        % SubjectTrials=cat(1,SubjectTrials,Spec_Subject(ii(iChan))*ones(size(Spec_Chan_All_Aud{ii(iChan)}{iCond},1),1));
        F1=cat(1,F1,designMat(1,iCond)*ones(size(Spec_Chan_All_Prod{idx(iChan)}{iCond},1),1));
        F2=cat(1,F2,designMat(2,iCond)*ones(size(Spec_Chan_All_Prod{idx(iChan)}{iCond},1),1));
        F3=cat(1,F3,designMat(3,iCond)*ones(size(Spec_Chan_All_Prod{idx(iChan)}{iCond},1),1));


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
%          AreaTrials2=AreaTrials*AreaTrials';
%     [u,s,v]=svd(AreaTrials);
%     vTrial=u(:,:)*s(:,1:1)*v(:,1:1)';
   % AreaTrials3=AreaTrials*vTrial;  
    for iTime=1:40
        dataT=AreaTrials(:,iTime);
%     dataT2=dataT*dataT';
%     [u,s,v]=svd(dataT2);
%     vTrial=dataT'*v(:,1);
%     dataT3=dataT*vTrial;
        % normalize?
     %   dataT=(log(dataT)-mean(log(dataT)))./std(log(dataT));
        % [b,bint,r,rint,stats] = regress(dataT,FS);
       mdl=fitlm(FS1,dataT,'linear','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
       mdlValsP{iChan}{iTime}=mdl;
       
        %   mdl=fitlm(FS1,dataT,'interactions','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
    %     [P T stats terms]=anovan(dataT,FS1,'model','linear','display','off');
      %   [B FitInfo]=lasso(FS1,dataT,'CV',5);
   %      TvalsP(iChan,iTime,:)=stats.coeffs;
  %      LassoValsP(iChan,iTime,:)=B(:,1);
    %     LassoVals(iChan,iTime,:)=B(:,FitInfo.IndexMinMSE);
  %      LassoVals(iChan,iTime,:)=B(:,FitInfo.Index1SE);
       
        
        %      Tvals(iChan,iTime,:)=b; %Tvals1;
%         %     Pvals(iChan,iTime,:)=stats(3);
%         Pvals(iChan,iTime,:)=P; %stats(3);
%         Fvals(iChan,iTime,1)=T{2,6};
%        Fvals(iChan,iTime,2)=T{3,6};
%        Fvals(iChan,iTime,3)=T{4,6};
%         Fvals(iChan,iTime,4)=T{5,6};
%         Fvals(iChan,iTime,5)=T{6,6};
%         Fvals(iChan,iTime,6)=T{7,6};
%         Fvals(iChan,iTime,7)=T{8,6};
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


mdlPvalsP=zeros(925,40,4);
mdlTvalsP=zeros(925,40,4);
mdlRvalsP=zeros(925,40);
mdlBvalsP=zeros(925,40,4);
mdlMSEvalsP=zeros(925,40);
for iChan=1:925;
    for iTime=1:40;
    mdlPvalsP(iChan,iTime,:)=mdlValsP{iChan}{iTime}.Coefficients.pValue;
    mdlTvalsP(iChan,iTime,:)=mdlValsP{iChan}{iTime}.Coefficients.tStat;
    mdlBvalsP(iChan,iTime,:)=mdlValsP{iChan}{iTime}.Coefficients.Estimate;
    mdlRvalsP(iChan,iTime)=mdlValsP{iChan}{iTime}.Rsquared.Adjusted;
    mdlMSEvalsP(iChan,iTime)=mdlValsP{iChan}{iTime}.MSE;
    end
end
 