clear numTrials;
%nComps=8;
groupvals(1)=1;
groupvals(2)=2;
idx=iiAC; %totalActiveElecsDA(iiW2);
for iChan=1:length(idx);
    for iCond=1:4;
        numTrials(iChan,iCond)=size(Spec_Chan_All_Aud{idx(iChan)}{iCond},1);
    end
end

[I J]=find(numTrials<=10);
idx=idx(setdiff(1:length(idx),unique(I)));
numTrials=numTrials(setdiff(1:size(numTrials,1),unique(I)),:);
minTrials=min(min(numTrials));
clear PmatrixT3
for iIter=1:100;

clear PmatrixT;
for iTime=1:40;


clear class
sig2=[];
groups=[];
groups3=[];
groups3B=[];

for iChan=1:length(idx);
    tmpAD=[];
    tmpAR=[];
    groupsD=[];
    groupsR=[];
    
    for iCond=1:4
        tmpAD=cat(1,tmpAD,Spec_Chan_All_Aud{idx(iChan)}{iCond});
        tmpAR=cat(1,tmpAR,Spec_Chan_All_Aud{idx(iChan)}{iCond+4});
        groupsD=cat(1,groupsD,iCond*ones(size(Spec_Chan_All_Aud{idx(iChan)}{iCond},1),1));
        groupsR=cat(1,groupsR,iCond*ones(size(Spec_Chan_All_Aud{idx(iChan)}{iCond+4},1),1));
    end
% %     [MD SD]=normfit(mean(tmpAD(:,1:10),2));
% %     [MR SR]=normfit(mean(tmpAR(:,1:10),2));
%     [MD SD]=normfit(reshape(tmpAD(:,1:10),size(tmpAD,1)*10,1));
%     [MR SR]=normfit(reshape(tmpAR(:,1:10),size(tmpAR,1)*10,1));
% 
%     iiOutD=find(mean(tmpAD(:,1:10),2)>2*SD+MD);
%     iiOutR=find(mean(tmpAR(:,1:10),2)>2*SR+MR);
%     iiInD=setdiff(1:length(tmpAD),iiOutD);
%     iiInR=setdiff(1:length(tmpAR),iiOutR);
%     
    
    
    sig1=[];
    groups=[];
    for iCond=1:4;
     %   sig1A=Spec_Chan_All_Aud{iChan}{iCond+4}./mean(mean(Spec_Chan_All_Aud{iChan}{iCond+4}(1:10,:)));
        sig1A=Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(Spec_Chan_All_Aud{idx(iChan)}{iCond}(:,1:10),2);

%         sig1A=Spec_Chan_All_Aud{idx(iChan)}{iCond+4}(:,:);
  %       sig1A=sig1A./mean(mean(tmpAD));
     %   if iCond<=4
      %      sig1A=sig1A./mean(mean(tmpAR(:,1:10)));
     %   elseif iCond>=5
      %      sig1A=sig1A./mean(mean(tmpAR(:,1:10)));
     %   end
%sig1A=sig1A./mean(mean(cat(1,tmpAD(:,1:10),tmpAR(:,1:10))));
         sig1idx=shuffle(1:size(sig1A,1));
         sig1idx=sig1idx(1:minTrials);

        sig1=cat(1,sig1A(sig1idx,:),sig1);
     
      %  groups=cat(2,groups,iCond*ones(size(sig1A,1),1));
    end
   % sig1=sig1(iiInD,:);
   % groups=groups(iiInD);
    
    
%     groups2=zeros(size(groups,1),2);
%     ii=find(groups==1);
%     groups2(ii,1)=1;
%     groups2(ii,2)=1;
%     ii=find(groups==2);
%     groups2(ii,1)=1;
%     ii=find(groups==3);
%     groups2(ii,2)=1;
    
  %  groups3=cat(1,groups3,groups2);
  %  sig2=cat(1,sig2,sig1(:,iTime));
    sig2=cat(2,sig2,sig1(:,iTime));

  %  groups3B=cat(1,groups3B,groups);
end


groups=[];
for iCond=1:4;
    groups=cat(1,groups,iCond*ones(minTrials,1));
end

[M S]=normfit(sig2(:));
[iOut jOut]=find(sig2>M+3*S);

iOut=unique(iOut);
for iCond=1:4;
    amountOut(iCond)=length(find(groups(iOut)==iCond));
    amountIdent{iCond}=find(groups(iOut)==iCond);
    amountIdent{iCond}=iOut(amountIdent{iCond});
end

maxAmountOut=max(amountOut);

%counter=0;
pullOutVals=[];
for iCond=1:4;
    iCondPullOut=shuffle(setdiff(1:minTrials,amountIdent{iCond}-((iCond-1)*minTrials)));
    if amountOut(iCond)==0
        pullOutIdx=((iCond-1)*minTrials)+iCondPullOut(1:maxAmountOut);
    else
        pullOutIdx=cat(2,amountIdent{iCond}',((iCond-1)*minTrials)+iCondPullOut(1:(maxAmountOut-length(amountIdent{iCond}))));
    end
    pullOutVals=cat(1,pullOutVals,pullOutIdx');
end

sig2=sig2(setdiff(1:size(sig2,1),pullOutVals),:);
groups=groups(setdiff(1:size(groups,1),pullOutVals));

groups2=zeros(size(groups,1),size(groups,2));
iG=find(groups==groupvals(1) | groups==groupvals(2));
groups2(iG)=1;
groups2(setdiff(1:size(groups2,1),iG))=2;
groups2=groups2(shuffle(1:length(groups2)));




nTrial=size(sig2,1);
%groups2=groups;
for iTrial=1:size(sig2,1)
xLooTrial = sig2(setdiff(1:nTrial,iTrial),:);
%xLooTrial = sig2;

xLooTrial2 = xLooTrial*xLooTrial'; % called?
[u,s,v] = svd(xLooTrial2);
vTrial = xLooTrial'*v(:,:);
xTrial = sq(sig2(iTrial,:));
%uTrial(iTrial,:) = xTrial(:)'*vTrial;
% TestTrial=sig2(iTrial);
% TrainTrial=sig2(setdiff(1:size(sig2,1),iTrial));

TestTrial = xTrial(:)'*vTrial;
TrainTrial = xLooTrial*vTrial;
train = setdiff(1:nTrial,iTrial);

%SVMStruct = fitcsvm(TrainTrial(:,1:nComps),groups2(train));
%CVSVMModel = crossval(SVMStruct);
%[~,score] = predict(SVMStruct,TestTrial(:,1:nComps));
%scorevals(iTime)=score(2);

% [~,scorePred] = kfoldPredict(CVSVMModel);
% outlierRate = mean(scorePred<0)
% sv=SVMStruct.SupportVectors;
% figure;
% gscatter(TrainTrial(:,1),TrainTrial(:,2),groups2(train))
% hold on
% plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)

  %  SVMModel = fitcsvm(TrainTrial(:,1:nComps),groups2(train));
    
%     rng default
% SVMModel = fitcsvm(TrainTrial(:,1:nComps),groups2(train),'OptimizeHyperparameters','auto',...
%     'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
%     'expected-improvement-plus'));
%     class(iTrial) = predict(SVMModel,TestTrial(1,1:nComps));
Stemp=find(cumsum(diag(s)./sum(diag(s)))>=.6);
nComps=Stemp(1);
class(iTrial) = classify(TestTrial(1,1:nComps),TrainTrial(:,1:nComps),groups2(train));
%Idx = knnsearch(TrainTrial(:,1:nComps),TestTrial(:,1:nComps));
%class(iTrial)=groups2(train(Idx));
%Svals{iIter}{iTime}{iTrial}=cumsum(diag(s)./sum(diag(s)));

end

nConds=2;
Pmatrix=zeros(nConds,nConds);
counter2=0;
maxtrial=length(iG); %minTrials; %length(iG);
for ii=1:nConds
    val1=class(counter2+1:counter2+maxtrial);
    for ii2=1:nConds
        val2=find(val1==ii2);
        Pmatrix(ii,ii2)=length(val2)./maxtrial;
    end
    counter2=counter2+maxtrial;
end
PmatrixT(iTime,:,:)=Pmatrix;

%display(iTime)
end

for iTime=1:40;
    PmatrixT2(iTime)=mean(diag(sq(PmatrixT(iTime,:,:))));
end

PmatrixT3(iIter,:)=PmatrixT2;
Svals{iIter}{iTime}{iTrial}=cumsum(diag(s)./sum(diag(s)));
display(iIter)
end
figure;plot(mean(PmatrixT3));
hold on;plot(0.7*ones(40,1),'r--')
% 
% 
% modelAP=[1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1];
% modelPP=[1 0 1 0;0 1 0 1;1 0 1 0;0 1 0 1];
% modelLP=[1 1 0 0;1 1 0 0;0 0 1 1;0 0 1 1];
% modelAN=abs(modelAP-1);
% modelPN=abs(modelPP-1);
% modelLN=abs(modelLP-1);
% Cmodel=repmat(1/16,4,4);
% 
% for iTime=1:40;
%     inpval=sq(PmatrixT(iTime,:,:));
% %     ii=find(inpval==0);
% %     inpval(ii)=1e-5;
%     Amodel=zeros(4,4);
%     Pmodel=zeros(4,4);
%     Lmodel=zeros(4,4);
%     AvalsP=sq(sum(sum(inpval.*modelAP))./sq(sum(sum(modelAP))));
%     PvalsP=sq(sum(sum(inpval.*modelPP))./sq(sum(sum(modelPP))));
%     LvalsP=sq(sum(sum(inpval.*modelLP))./sq(sum(sum(modelLP))));
%     AvalsN=sq(sum(sum(inpval.*modelAN))./sq(sum(sum(modelAN))));
%     PvalsN=sq(sum(sum(inpval.*modelPN))./sq(sum(sum(modelPN))));
%     LvalsN=sq(sum(sum(inpval.*modelLN))./sq(sum(sum(modelLN))));
%     Amodel=AvalsP.*modelAP+AvalsN.*modelAN;
%     Pmodel=PvalsP.*modelPP+PvalsN.*modelPN;
%     Lmodel=LvalsP.*modelLP+LvalsN.*modelLN;
%     
%  %   KLA=inpval.*log(inpval./Amodel);
%  %   KLP=inpval.*log(inpval./Pmodel);
%  %   KLL=inpval.*log(inpval./Lmodel);
%     KLA=Amodel.*log2(Amodel./inpval);
%     KLP=Pmodel.*log2(Pmodel./inpval);
%     KLL=Lmodel.*log2(Lmodel./inpval);
%     KLC=Cmodel.*log2(Cmodel./inpval);
%     ii=isnan(KLA);
%     KLA(ii)=0;
%     ii=find(KLA==inf);
%     KLA(ii)=0;
%     
%     ii=isnan(KLP);
%     KLP(ii)=0;
%     ii=find(KLP==inf);
%     KLP(ii)=0;
%     
%     ii=isnan(KLL);
%     KLL(ii)=0;
%     ii=find(KLL==inf);
%     KLL(ii)=0;
%     
%     ii=isnan(KLC);
%     KLC(ii)=0;
%     ii=find(KLC==inf);
%     KLC(ii)=0;
%     KLAs(iTime)=sq(sum(sum(KLA)));
%     KLPs(iTime)=sq(sum(sum(KLP)));
%     KLLs(iTime)=sq(sum(sum(KLL)));
%     KLCs(iTime)=sq(sum(sum(KLC)));
% end
%     
%     
%   