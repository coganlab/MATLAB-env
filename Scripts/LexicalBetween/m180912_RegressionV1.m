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
            AreaTrials=cat(1,AreaTrials,(log(Spec_Chan_All_Aud{idx(iChan)}{iCond})-mD)./sD);
            
        elseif iCond>=5
           % AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(baselineValsR)));
            AreaTrials=cat(1,AreaTrials,(log(Spec_Chan_All_Aud{idx(iChan)}{iCond})-mR)./sR);
            
        end
        
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
    %    mdl=fitlm(FS1,dataT,'interactions','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
    %   mdlVals{iChan}{iTime}=mdl;
          mdl=fitlm(FS1,dataT,'linear','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
 %        [P T stats terms]=anovan(dataT,FS1,'model','linear','display','off');
%       [B,dev,stats] = mnrfit(dataT,categorical(FS1(:,1)));
%       Blog(iChan,iTime,1)=B(2);
%       Plog(iChan,iTime,1)=stats.p(2);
%       [B,dev,stats] = mnrfit(dataT,categorical(FS1(:,2)));
%       Blog(iChan,iTime,2)=B(2);
%       Plog(iChan,iTime,2)=stats.p(2);
%       [B,dev,stats] = mnrfit(dataT,categorical(FS1(:,3)));
%       Blog(iChan,iTime,3)=B(2);
%       Plog(iChan,iTime,3)=stats.p(2);
%       beta=mvregress(FS,dataT);
%       mvrBC(iChan,iTime,:)=beta;
        % [B FitInfo]=lasso(FS1,dataT,'CV',5);
  %       Tvals(iChan,iTime,:)=stats.coeffs;
  %      LassoVals(iChan,iTime,:)=B(:,1);
%         LassoVals(iChan,iTime,:)=B(:,FitInfo.IndexMinMSE);
       % LassoVals(iChan,iTime,:)=B(:,FitInfo.Index1SE);
       mdlVals{iChan}{iTime}=mdl;
 %       TvalsMSE(iChan,iTime)=stats.mse;
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


mdlPvals=zeros(925,40,4);
mdlTvals=zeros(925,40,4);
mdlRvals=zeros(925,40);
mdlBvals=zeros(925,40,4);
mdlMSEvals=zeros(925,40);
for iChan=1:925;
    for iTime=1:40;
    mdlPvals(iChan,iTime,:)=mdlVals{iChan}{iTime}.Coefficients.pValue;
    mdlTvals(iChan,iTime,:)=mdlVals{iChan}{iTime}.Coefficients.tStat;
    mdlBvals(iChan,iTime,:)=mdlVals{iChan}{iTime}.Coefficients.Estimate;
    mdlRvals(iChan,iTime)=mdlVals{iChan}{iTime}.Rsquared.Adjusted;
    mdlMSEvals(iChan,iTime)=mdlVals{iChan}{iTime}.MSE;
    end
end
 

pvalsMDLM=zeros(925,40,7);
ii=find(mdlPvals<0.05);
pvalsMDLM(ii)=1;


% for iChan=1:704
%     for iTime=1:40;
%         InterceptPvals(iChan,iTime)=TvalsM{iChan}{iTime}.Coefficients.pValue(1);
%         LexPvals(iChan,iTime)=TvalsM{iChan}{iTime}.Coefficients.pValue(2);
%         TaskPvals(iChan,iTime)=TvalsM{iChan}{iTime}.Coefficients.pValue(3);
%         PhonoPvals(iChan,iTime)=TvalsM{iChan}{iTime}.Coefficients.pValue(4);
%         LexTaskPvals(iChan,iTime)=TvalsM{iChan}{iTime}.Coefficients.pValue(5);
%         LexPhonoPvals(iChan,iTime)=TvalsM{iChan}{iTime}.Coefficients.pValue(6);
%         TaskPhonoPvals(iChan,iTime)=TvalsM{iChan}{iTime}.Coefficients.pValue(7);
%
%         InterceptTvals(iChan,iTime)=TvalsM{iChan}{iTime}.Coefficients.tStat(1);
%         LexTvals(iChan,iTime)=TvalsM{iChan}{iTime}.Coefficients.tStat(2);
%         TaskTvals(iChan,iTime)=TvalsM{iChan}{iTime}.Coefficients.tStat(3);
%         PhonoTvals(iChan,iTime)=TvalsM{iChan}{iTime}.Coefficients.tStat(4);
%         LexTasTPvals(iChan,iTime)=TvalsM{iChan}{iTime}.Coefficients.tStat(5);
%         LexPhonoTvals(iChan,iTime)=TvalsM{iChan}{iTime}.Coefficients.tStat(6);
%         TaskPhonoTvals(iChan,iTime)=TvalsM{iChan}{iTime}.Coefficients.tStat(7);
%     end
% end
%
% sigCut=0.05;
% 
% PvalsM=zeros(size(Pvals,1),size(Pvals,2),size(Pvals,3));
% ii=find(Pvals<sigCut);
% PvalsM(ii)=1;
PvalsM=pvalsMDLM;
clusterSize=3;

clusterStart=zeros(size(PvalsM,1),size(PvalsM,3));
for iCond=1:size(PvalsM,3);
    
    
    for iChan=1:size(clusterStart,1);
        
        %tmp=bwconncomp(sq(PvalsM(iChan,:,iCond)));
        tmp=bwconncomp(sq(PvalsM(iChan,:,iCond)));
        
        if size(tmp.PixelIdxList,2)>0
            for ii=1:size(tmp.PixelIdxList,2);
                ii2(ii)=size(tmp.PixelIdxList{ii},1);
            end
            
            ii2B=find(ii2>=clusterSize);
            if length(ii2B)>0
                for ii=1:length(ii2B);
                    ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
                    clusterStart(iChan,iCond)=ii3(ii);
                end
            end
            
            
            clear ii3
            
            
            SigClusterSize(iChan,iCond)=max(ii2);
        else
            SigClusterSize(iChan,iCond)=0;
        end
        clear ii2
    end
    
end
clear iiSig
for iCond=1:size(PvalsM,3);
    iiSig{iCond}=find(SigClusterSize(:,iCond)>=clusterSize);
end

% for iC=1:size(iiSig,2)
%     iiSig{iC}=intersect(iiSig{iC},totalActiveElecsA);
% end
idx=11:40;
iiLPos=find(sum(sq(PvalsM(iiSig{1},idx,1)).*sq(Tvals(iiSig{1},idx,3)),2)>0);
iiLNeg=find(sum(sq(PvalsM(iiSig{1},idx,1)).*sq(Tvals(iiSig{1},idx,3)),2)<0);

iiTPos=find(sum(sq(PvalsM(iiSig{2},idx,2)).*sq(Tvals(iiSig{2},idx,5)),2)>0);
iiTNeg=find(sum(sq(PvalsM(iiSig{2},idx,2)).*sq(Tvals(iiSig{2},idx,5)),2)<0);

iiPPos=find(sum(sq(PvalsM(iiSig{3},idx,3)).*sq(Tvals(iiSig{3},idx,7)),2)>0);
iiPNeg=find(sum(sq(PvalsM(iiSig{3},idx,3)).*sq(Tvals(iiSig{3},idx,7)),2)<0);

iiLTPos=find(sum(sq(PvalsM(iiSig{4},idx,4)).*sq(Tvals(iiSig{4},idx,11)),2)>0);
iiLTNeg=find(sum(sq(PvalsM(iiSig{4},idx,4)).*sq(Tvals(iiSig{4},idx,11)),2)<0);

iiLPPos=find(sum(sq(PvalsM(iiSig{5},idx,5)).*sq(Tvals(iiSig{5},idx,15)),2)>0);
iiLPNeg=find(sum(sq(PvalsM(iiSig{5},idx,5)).*sq(Tvals(iiSig{5},idx,15)),2)<0);

iiTPPos=find(sum(sq(PvalsM(iiSig{6},idx,6)).*sq(Tvals(iiSig{6},idx,19)),2)>0);
iiTPNeg=find(sum(sq(PvalsM(iiSig{6},idx,6)).*sq(Tvals(iiSig{6},idx,19)),2)<0);

iiLTPPos=find(sum(sq(PvalsM(iiSig{7},idx,7)).*sq(Tvals(iiSig{7},idx,27)),2)>0);
iiLTPNeg=find(sum(sq(PvalsM(iiSig{7},idx,7)).*sq(Tvals(iiSig{7},idx,27)),2)<0);





test1=repmat(reshape(sq(PvalsM(iiSig{1},:,1)),length(iiSig{1}),1,40),1,8,1);
figure;plot(mean(sq(mean(test1(iiLPos,:,:).*dataADAR(iiSig{1}(iiLPos),:,:)))'))
figure;plot(mean(sq(mean(test1(iiLNeg,:,:).*dataADAR(iiSig{1}(iiLNeg),:,:)))'))

test1=repmat(reshape(sq(PvalsM(iiSig{2},:,2)),length(iiSig{2}),1,40),1,8,1);
figure;plot(mean(sq(mean(test1(iiTPos,:,:).*dataADAR(iiSig{2}(iiTPos),:,:)))'))
figure;plot(mean(sq(mean(test1(iiTNeg,:,:).*dataADAR(iiSig{2}(iiTNeg),:,:)))'))

test1=repmat(reshape(sq(PvalsM(iiSig{3},:,3)),length(iiSig{3}),1,40),1,8,1);
figure;plot(mean(sq(mean(test1(iiPPos,:,:).*dataADAR(iiSig{3}(iiPPos),:,:)))'))
figure;plot(mean(sq(mean(test1(iiPNeg,:,:).*dataADAR(iiSig{3}(iiPNeg),:,:)))'))

% test1=repmat(reshape(sq(PvalsM(iiSig{4},:,4)),length(iiSig{4}),1,40),1,8,1);
% figure;plot(mean(sq(mean(test1(iiLTPos,:,:).*dataADAR(iiSig{4}(iiLTPos),:,:)))'))
% figure;plot(mean(sq(mean(test1(iiLTNeg,:,:).*dataADAR(iiSig{4}(iiLTNeg),:,:)))'))
%
% test1=repmat(reshape(sq(PvalsM(iiSig{5},:,5)),length(iiSig{5}),1,40),1,8,1);
% figure;plot(mean(sq(mean(test1(iiLPPos,:,:).*dataADAR(iiSig{5}(iiLPPos),:,:)))'))
% figure;plot(mean(sq(mean(test1(iiLPNeg,:,:).*dataADAR(iiSig{5}(iiLPNeg),:,:)))'))
%
% test1=repmat(reshape(sq(PvalsM(iiSig{6},:,6)),length(iiSig{6}),1,40),1,8,1);
% figure;plot(mean(sq(mean(test1(iiTPPos,:,:).*dataADAR(iiSig{6}(iiTPPos),:,:)))'))
% figure;plot(mean(sq(mean(test1(iiTPNeg,:,:).*dataADAR(iiSig{6}(iiTPNeg),:,:)))'))
%
% test1=repmat(reshape(sq(PvalsM(iiSig{7},:,7)),length(iiSig{7}),1,40),1,8,1);
% figure;plot(mean(sq(mean(test1(iiLTPPos,:,:).*dataADAR(iiSig{7}(iiLTPPos),:,:)))'))
% figure;plot(mean(sq(mean(test1(iiLTPNeg,:,:).*dataADAR(iiSig{7}(iiLTPNeg),:,:)))'))

[WL,HL,DL]=nnmf(sq(PvalsM(iiSig{1},:,1)),2);
[WT,HT,DT]=nnmf(sq(PvalsM(iiSig{2},:,2)),2);
[WP,HP,DP]=nnmf(sq(PvalsM(iiSig{3},:,3)),2);
% [WLT,HLT,DLT]=nnmf(sq(PvalsM(iiSig{4},:,4)),2);
% [WLP,HLP,DLP]=nnmf(sq(PvalsM(iiSig{5},:,5)),2);
% [WTP,HTP,DTP]=nnmf(sq(PvalsM(iiSig{6},:,6)),2);
% [WLTP,HLTP,DLTP]=nnmf(sq(PvalsM(iiSig{7},:,7)),2);

LexC=mean(sq(PvalsM(iiSig{1},:,1)).*sq(Tvals(iiSig{1},:,2)),2);
TaskC=mean(sq(PvalsM(iiSig{2},:,2)).*sq(Tvals(iiSig{2},:,4)),2);
PhonoC=mean(sq(PvalsM(iiSig{3},:,3)).*sq(Tvals(iiSig{3},:,6)),2);


LexPosStart=mean(clusterStart(iiSig{1}(iiLPos),1))
LexNegStart=mean(clusterStart(iiSig{1}(iiLNeg),1))
TaskPosStart=mean(clusterStart(iiSig{2}(iiTPos),2))
TaskNegStart=mean(clusterStart(iiSig{2}(iiTNeg),2))
PhonoPosStart=mean(clusterStart(iiSig{3}(iiPNeg),3))
PhonoNegStart=mean(clusterStart(iiSig{3}(iiPPos),3))

