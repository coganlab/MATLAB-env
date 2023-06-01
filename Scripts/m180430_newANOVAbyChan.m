duke;
global experiment
Subject = struct([]);

Subject(1).Name = 'D1'; Subject(1).Day = '260216'; % 160216 is clin 1, 160217 is clin 2
Subject(3).Name = 'D3'; Subject(3).Day = '100916';
Subject(7).Name = 'D7'; Subject(7).Day = '030117';
Subject(8).Name = 'D8'; Subject(8).Day = '030317';
Subject(9).Name = 'D12'; Subject(9).Day = '090917';
Subject(10).Name = 'D13'; Subject(10).Day = '071017';
Subject(11).Name = 'D14'; Subject(11).Day = '101117';
Subject(12).Name= 'D15'; Subject(12).Day = '171217';
Subject(13).Name = 'D16'; Subject(13).Day ='200118';
Subject(14).Name = 'D17'; Subject(14).Day = '180309';
Subject(2).Name = 'S1'; Subject(2).Day = '080318';

ClusterSize=3;

counterChan=0;
for SN = [9:12,14];
    Subject(SN).Experiment = loadExperiment(Subject(SN).Name);
    Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');
    %Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_CovertOvert'); % Test line
    Trials = Subject(SN).Trials;
    experiment = Subject(SN).Experiment;
    
    %CondParams.Conds = [1:4];
    
    
    
    %CondParams.bn = [-2500,3500];
    %AnalParams.Tapers = [0.5,10];
    AnalParams.Tapers = [.5,10];
    %AnalParams.Tapers = [1,10];
    AnalParams.fk = 500;
    %AnalParams.Reference = 'Grand average'; %'Grand average'; % other is 'Single-ended';
    AnalParams.RefChans=subjRefChans(Subject(SN).Name);
    AnalParams.Reference =  'IndRef'; %'Grand average', 'Grand average induced'% induced' 'Single-ended','IndRef';
    AnalParams.ArtifactThreshold = 8;
    AnalParams.dn=0.05;
    
    if strcmp(Subject(SN).Name,'D1')
        AnalParams.Channel = [1:66];
        
    elseif  strcmp(Subject(SN).Name,'D7')
        %   AnalParams.Channel = [1:102];
        AnalParams.Channel = [17:80]; % just grid
    elseif  strcmp(Subject(SN).Name,'D3')
        AnalParams.Channel = [1:52];
        badChans=[12];
        AnalParams.Channel=setdiff(AnalParams.Channel,badChans);
    elseif strcmp(Subject(SN).Name,'D8')
        AnalParams.Channel = [1:110];
    elseif strcmp(Subject(SN).Name,'D12')
        AnalParams.Channel = [1:110];
        %  AnalParams.ReferenceChannels=[30];
    elseif strcmp(Subject(SN).Name,'D13')
        AnalParams.Channel = [1:120];
        %   AnalParams.ReferenceChannels=[18:20];
    elseif strcmp(Subject(SN).Name,'D14')
        AnalParams.Channel = [1:120];
    elseif strcmp(Subject(SN).Name,'D15')
        AnalParams.Channel = [1:120];
    elseif strcmp(Subject(SN).Name,'D16');
        AnalParams.Channel = [1:41];
    elseif strcmp(Subject(SN).Name,'D17');
        AnalParams.Channel=[1:114];
    elseif strcmp(Subject(SN).Name,'S1');
   % AnalParams.Channel=[1:256];
    AnalParams.Channel=setdiff(1:256,[2,32,64,66,96,128,130,160,192,194,224,256]);
    else
        AnalParams.Channel = [1:64];
    end
    CondParams.Conds=[1:4];
    NumTrials = SelectChannels(Subject(SN).Trials, CondParams, AnalParams);
    %NumTrials=repmat(270,1,66);
    %SelectedChannels = AnalParams.Channel(find(NumTrials > (0.8*length(Trials)))); %STRICT?
    % SelectedChannels = AnalParams.Channel(find(NumTrials > (0.65*length(Trials)))); %LESS STRICT?
    SelectedChannels=AnalParams.Channel; % really loose: accounts for practice trial confound
    AnalParams.ReferenceChannels = SelectedChannels;
    AnalParams.Channel = SelectedChannels;
    AnalParams.TrialPooling = 0 %1;  %1; % used to be 1
    
    
    % CondParams.Field = 'Start';
    % CondParams.bn = [-500,1000];
    % for iCode = 1:length(CondParams.Conds)
    %
    %     if isfield(CondParams,'Conds2')
    %         CondParams.Conds = CondParams.Conds2(iCode);
    %     else
    %         CondParams.Conds = iCode;
    %     end
    %     tic
    %     [Start_Spec{iCode}, Start_Data, Start_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
    %     toc
    %     display(['Cond = ' num2str(iCode)])
    % end
    
    load([DUKEDIR '/' Subject(SN).Name '/' Subject(SN).Day '/mat/Trials_HighLow.mat']);
    Subject(SN).Trials=Trials;
    
    CondParams.Conds=[1:8];
    CondParams.Field = 'Auditory';
    CondParams.bn = [-500,2500];
    for iCode = 1:length(CondParams.Conds)
        
        if isfield(CondParams,'Conds2')
            CondParams.Conds = CondParams.Conds2(iCode);
        else
            CondParams.Conds = iCode;
        end
        tic
        [Auditory_Spec{iCode}, Auditory_Data, Auditory_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
        toc
        display(['Cond = ' num2str(iCode)])
    end
    
    fRange=70:150;
  %  fRange=30:50;
    outcut=10;
    for iChan=1:length(AnalParams.Channel);
        iChan2=iChan+counterChan;
        baseline1=[];
        baseline2=[];
        for iCond=1:8;
            tmp=sq(mean(Auditory_Spec{iCond}{iChan}(:,:,fRange),3));
            tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDX=setdiff(1:size(tmp,1),unique(i));
          %  tmp=tmp./mean(mean(tmp(:,1:10))); % each cond baseline   
         %   tmp=tmp./mean(tmp(:,1:10),2); % each trial baseline
     
            Spec_Chan_All{iChan2}{iCond}=sq(mean(Auditory_Spec{iCond}{iChan}(tmpIDX,:,fRange),3));
            Spec_Subject(iChan2)=SN;
%             if iCond<=4
%                 baseline1=cat(1,baseline1,sq(mean(mean(Auditory_Spec{iCond}{iChan}(:,1:10,fRange),2),3)));
%             elseif iCond>=5
%                 baseline2=cat(1,baseline2,sq(mean(mean(Auditory_Spec{iCond}{iChan}(:,1:10,fRange),2),3)));
%             end
        end
       
%         baseline1=mean(baseline1);
%         baseline2=mean(baseline2);
%         for iCond=1:8;
%             if iCond<=4
%             Spec_Chan_All{iChan2}{iCond}=Spec_Chan_All{iChan2}{iCond}./baseline1;
%             elseif iCond>=5
%             Spec_Chan_All{iChan2}{iCond}=Spec_Chan_All{iChan2}{iCond}./baseline2;
%             end
%         end
    end
    
    counterChan=counterChan+length(AnalParams.Channel);
end

%Spec_Chan_All=Spec_Chan_AllH;

% % %single baseline
% for iChan=1:counterChan
%     tmp=[];
%     for iCond=1:8
%         tmp=cat(1,tmp,Spec_Chan_All{iChan}{iCond});
%     end
%     for iCond=1:8
%     Spec_Chan_All{iChan}{iCond}=Spec_Chan_All{iChan}{iCond}./mean(mean(tmp(:,1:10)));
%     end
% end

% % trial baseline
for iChan=1:counterChan  
    for iCond=1:8
    Spec_Chan_All{iChan}{iCond}=Spec_Chan_All{iChan}{iCond}./mean(Spec_Chan_All{iChan}{iCond}(:,1:10),2);
    end
end
%
% % block baseline
% for iChan=1:counterChan
%     tmp1=[];
%     tmp2=[];
%     for iCond=1:4
%         tmp1=cat(1,tmp1,Spec_Chan_All{iChan}{iCond});
%         tmp2=cat(1,tmp2,Spec_Chan_All{iChan}{iCond+4});
%     end
%     for iCond=1:4
%     Spec_Chan_All{iChan}{iCond}=Spec_Chan_All{iChan}{iCond}./mean(mean(tmp1(:,1:10)));
%     Spec_Chan_All{iChan}{iCond+4}=Spec_Chan_All{iChan}{iCond+4}./mean(mean(tmp2(:,1:10)));
%     end
% end

% % condition baseline
% for iChan=1:counterChan
%     for iCond=1:8
%     Spec_Chan_All{iChan}{iCond}=Spec_Chan_All{iChan}{iCond}./mean(mean(Spec_Chan_All{iChan}{iCond}(:,1:10)));
%     end
% end
% 
% % norm against baseline
% for iChan=1:counterChan
%     tmp=[];
%     for iCond=1:8
%         tmp=cat(1,tmp,Spec_Chan_All{iChan}{iCond});
%     end
%     tmp2=tmp(:,1:10);
%     [m s]=normfit(tmp2(:));
%     for iCond=1:8
%     Spec_Chan_All{iChan}{iCond}=(Spec_Chan_All{iChan}{iCond}-m)./s;
%     end
% end
% 
% % norm against all
% for iChan=1:counterChan
%     tmp=[];
%     for iCond=1:8
%         tmp=cat(1,tmp,Spec_Chan_All{iChan}{iCond});
%     end
%     [m s]=normfit(tmp(:));
%     for iCond=1:8
%     Spec_Chan_All{iChan}{iCond}=(Spec_Chan_All{iChan}{iCond}-m)./s;
%     end
% end

cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560],[34/255 139/255 34/255],[1 0 1],[1 192/255 203/255],[119/255 136/255 153/255]);

for iChan=1:size(Spec_Chan_All,2);
    for iCond=1:8
        dataA(iChan,iCond,:)=mean(Spec_Chan_All{iChan}{iCond});
    end
end
% 
% figure;
% for iCond=1:8;
%     hold on;
%     errorbar(sq(mean(dataA(:,iCond,:))),std(sq(dataA(:,iCond,:)),[],1)./sqrt(size(dataA,1)),'color',cvals(iCond,:));
% end
% legend('HWD','LWD','HNWD','LNWD','HWR','LWR','HNWR','LNWR')


nPerm=1000;
for iChan=1:size(Spec_Chan_All,2);
    tmp=[];
    for iCond=1:8;
        tmp=cat(1,tmp,Spec_Chan_All{iChan}{iCond});
    end
    for iTime=1:40;
    actdiff=mean(tmp(:,iTime))-mean(mean(tmp(:,1:10)));
    combval=cat(1,mean(tmp(:,iTime),2),mean(tmp(:,1:10),2));
    for iPerm=1:nPerm;
        sIdx=shuffle(1:size(combval,1));
        permval(iPerm)=mean(combval(sIdx(1:size(tmp,1))))-mean(combval(sIdx(size(tmp,1)+1:length(sIdx))));
    end
    pvalsS(iChan,iTime)=length(find(permval>actdiff))./nPerm;
    end
    display(iChan)
end
% uncorrected
pvalsSM=zeros(size(pvalsS,1),size(pvalsS,2));
iiS=find(pvalsS<.05);
pvalsSM(iiS)=1;

pvalsSM=zeros(size(pvalsS,1),size(pvalsS,2));
for iChan=1:size(pvalsSM,1)
[pmask pfdr]=fdr(pvalsS(iChan,:),.05);
pvalsSM(iChan,:)=pfdr;
end

clear ii2
clusterStart=zeros(40,6);
for iChan=1:size(pvalsSM,1);

    tmp=bwconncomp(sq(pvalsSM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStart(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStart(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStart(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStart(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStart(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStart(iChan,6)=1;
            end
        end
    end
    clear ii3
    
    
    SigClusterSize(iChan)=max(ii2);
    else
        SigClusterSize(iChan)=0;
    end
    clear ii2
end

iiS=find(SigClusterSize>=ClusterSize);
%iiS=find(SigClusterSize>=1);


%load([DUKEDIR '/NewAreas.mat'])
GoodChanIdx=1:size(Spec_Chan_All,2);
%k = 0:1e-5:5e-3;
designMat=[1 1 0 0 1 1 0 0;1 0 1 0 1 0 1 0;1 1 1 1 0 0 0 0;];
%designMat=[0 0 1 1 0 0 1 1;1 0 1 0 1 0 1 0;1 1 1 1 0 0 0 0;];
%designMat=[1 1 -1 -1 1 1 -1 -1;1 -1 1 -1 1 -1 1 -1;1 1 1 1 -1 -1 -1 -1;];

for iChan=1:length(GoodChanIdx);
    F1=[];
    F2=[];
    F3=[];
    F4=[];
    data=[];
    for iCond=1:8
        F1=cat(1,F1,designMat(1,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
        F2=cat(1,F2,designMat(2,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
        F3=cat(1,F3,designMat(3,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
      %  F4=cat(1,F4,iCond*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
      %  data=cat(1,data,Auditory_Spec{iCond}{iChan});
        data=cat(1,data,Spec_Chan_All{GoodChanIdx(iChan)}{iCond});
    end
  %  data_tmp=reshape(sq(mean(data(:,1:10,fRange),3)),size(data,1)*10,1);
   % [data_m data_s]=normfit(data_tmp);
  %  FS=cat(2,F1,F2,F3,F1.*F2,F1.*F3,F2.*F3);
    FS1=cat(2,F1,F2,F3);
  %  FS=cat(2,FS1,ones(size(FS1,1),1));
%     FS2=FS1;
%     FS2(:,4)=FS1(:,1).*FS1(:,2);
%     FS2(:,5)=FS1(:,1).*FS1(:,3);
%     FS2(:,6)=FS1(:,2).*FS1(:,3);
%     FS2(:,7)=FS1(:,1).*FS1(:,2).*FS1(:,3);
   % data=sq(mean(data(:,:,fRange),3));
  %  data=(data-data_m)./data_s;
    tRange=1:40;
    
    for iTRange=1:length(tRange)
        %  for iTRange=1:3
        % tRange=iTRange*10+1:iTRange*10+10;
        dataT=mean(data(:,iTRange),2)-1;
        dataT=mean(data2(:,iTRange),2)-1;
   % tbl=table(data(:,iTRange),FS1(:,1),FS1(:,2),FS1(:,3),'VariableNames',{'HG','Lex','Phono','Task'});
 %   lme=fitlme(tbl,'HG~1+Lex+Phono+Task+Lex:Phono+Lex:Task+Phono:Task+Lex:Phono:Task+(1|Item)');

      % mdl=stepwiselm(FS,dataT,'interactions','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
      %  mdl=fitlm(FS1,dataT,'interactions','PredictorVars',{'Lex','Phono','Task'},'CategoricalVar',{'Lex','Phono','Task'});
        mdl=fitlm(FS1,dataT,'y~1+x1+x2+x3+x1:x2+x1:x3+x2:x3+x1:x2:x3','PredictorVars',{'x1','x2','x3'},'CategoricalVar',{'x1','x2','x3'});
     %   mdlM=fitlm(FS1,dataT,'interactions','PredictorVars',{'x1','x2','x3'},'CategoricalVar',{'x1','x2','x3'});

        %  [XL,YL,XS,YS,BETA PCTVAR] = plsregress(FS2,dataT,5);
   %  b = ridge(dataT,FS2,k);
        %   mdl2=fitlm(FS1,dataT,'y~1+x1+x2+x3+x1:x2+x1:x3+x2:x3+x1:x2:x3','PredictorVars',{'x1','x2','x3'},'CategoricalVar',{'x1','x2','x3'},'RobustOpts','bisquare');
   %  mdl2=fitrlinear(FS1,dataT,'y~1+x1+x2+x3+x1:x2+x1:x3+x2:x3+x1:x2:x3');
   %  mdl=fitlm(FS2,dataT,'PredictorVars',{'x1','x2','x3','x4','x5','x6','x7'},'CategoricalVar',{'x1','x2','x3','x4','x5','x6','x7'});

   %  mdl2=fitrlinear(FS2,dataT);
        %  mdl2=fitlm(FS1,dataT,'quadratic','PredictorVars',{'x1','x2','x3'},'CategoricalVar',{'x1','x2','x3'});

        %[b,bint,r,rint,stats] = regress(dataT,FS);
    %     [P T]=anovan(dataT,FS1,'model','full','display','off');
        %         for iT=1:7;
        %             Tvals1(iT)=cell2num(T(iT+1,6));
        %         end
        %  Tvals(iChan,iTRange,:)=Tvals1;
      %  Tvals(iChan,iTRange,:)=b; %Tvals1;
        %Pvals2(iChan,iTRange)=stats(3);
    %    AvalsB{iChan}{iTRange}=T;
    %    PvalsA(iChan,iTRange,:)=P;
       ModelB{iChan}{iTRange}=mdl;
    %    ModelM{iChan}{iTRange}=mdlM;
      %  BetaBM(iChan,iTRange,:)=BETA(2:8);
    %    BetaBMV(iChan,iTRange,:)=PCTVAR(2,:);
     %   BetaBR(iChan,iTRange,:,:)=b;
    end
    display(iChan)
end


betaB=zeros(size(Spec_Chan_All,2),40,8);
%betaM=zeros(size(Spec_Chan_All,2),40,4);
%betaBM=zeros(size(Spec_Chan_All,2),40,7);
%pvalBM=zeros(size(Spec_Chan_All,2),40,7);
pvalB=zeros(size(Spec_Chan_All,2),40,8);
pvalFB=zeros(size(Spec_Chan_All,2),40);
fvalB=zeros(size(Spec_Chan_All,2),40);
rval=zeros(size(Spec_Chan_All,2),40);
rvalA=zeros(size(Spec_Chan_All,2),40);
%rvalM=zeros(size(Spec_Chan_All,2),40);
%rvalAM=zeros(size(Spec_Chan_All,2),40);
FvalsA=zeros(size(Spec_Chan_All,2),40,7);

%rvalMA=zeros(size(Spec_Chan_All,2),40);
for iChan=1:size(Spec_Chan_All,2)
    for iTime=1:40
        tmp=ModelB{iChan}{iTime}.Coefficients.Estimate;
        tmp2=ModelB{iChan}{iTime}.Coefficients.pValue;
        betaB(iChan,iTime,:)=tmp(1:end);
        pvalB(iChan,iTime,:)=tmp2(1:end);
   %      tmp=ModelM{iChan}{iTime}.Coefficients.Estimate;
    %    tmp2=ModelM{iChan}{iTime}.Coefficients.pValue;
    %    betaM(iChan,iTime,:)=tmp(1:end);
    %    pvalM(iChan,iTime,:)=tmp2(1:end);
    %   betaBM(iChan,iTime,:)=ModelBM{iChan}{iTime}.Betas;
    %    tmp=ModelBM{iChan}{iTime}.Coefficients.Estimate;
    %    tmp2=ModelBM{iChan}{iTime}.Coefficients.pValue;
    %    betaBM(iChan,iTime,:)=tmp(2:end);
    %    pvalBM(iChan,iTime,:)=tmp2(2:end);
        [p,f]=coefTest(ModelB{iChan}{iTime});
        fvalB(iChan,iTime)=f;
        pvalFB(iChan,iTime)=p;
        rval(iChan,iTime)=ModelB{iChan}{iTime}.Rsquared.Ordinary;
        rvalA(iChan,iTime)=ModelB{iChan}{iTime}.Rsquared.Adjusted;
   %     rvalM(iChan,iTime)=ModelM{iChan}{iTime}.Rsquared.Ordinary;
   %     rvalAM(iChan,iTime)=ModelM{iChan}{iTime}.Rsquared.Adjusted;
   %     tmp=AvalsB{iChan}{iTime};
   %     FvalsA(iChan,iTime,:)=cell2num(tmp(2:8,6));
    %    rvalM(iChan,iTime)=ModelBM{iChan}{iTime}.Rsquared.Ordinary;
    %    rvalMA(iChan,iTime)=ModelBM{iChan}{iTime}.Rsquared.Adjusted;
    end
end

betaB2=betaB;
%betaB2(:,:,1)=betaB2(:,:,1)-1;
betaTable={};
betaTable{1}=[1:8]; % W H D
betaTable{2}=[1,2,4,6]; % W L D
betaTable{3}=[1,4,7]; % NW H D;
betaTable{4}=[1,4]; % NW L D;
betaTable{5}=[1,2,3,5]; % W H R;
betaTable{6}=[1,2]; % W L R;
betaTable{7}=[1,3]; % NW H R;
betaTable{8}=[1]; % NW L R;

for iB=1:8
    betaB3(:,:,iB)=sq(sum(betaB2(:,:,betaTable{iB}),3));
end


fvalsF=zeros(size(Spec_Chan_All,2),40);
pvalsF=zeros(size(Spec_Chan_All,2),40);
for iChan=1:size(Spec_Chan_All,2)
    for iTime=1:40;
    [p,f]=coefTest(ModelB{iChan}{iTime});
    fvalsF(iChan,iTime)=f;
    pvalsF(iChan,iTime)=p;
    end
end

% uncorrected
pmaskB=zeros(size(pvalB,1),size(pvalB,2),size(pvalB,3));
ii=find(pvalB<.05);
pmaskB(ii)=1;

% pmaskB=zeros(size(PvalsB,1),size(PvalsB,2),size(PvalsB,3));
% for iChan=1:size(pmaskB,1)
%     for iComp=1:size(PvalsB,3)
%     [pmask pfdr]=fdr(sq(PvalsB(iChan,:,iComp)),.05);
%     pmaskB(iChan,:,iComp)=pfdr;
%     end
% end

% [pfdr pmask]=fdr(reshape(pvals3,size(pvals3,1)*size(pvals3,2)*size(pvals3,3),1),.05);
% pmask2=reshape(pmask,size(pvals3,1),size(pvals3,2),size(pvals3,3));


for iChan=1:size(pmaskB,1);
    for iComp=1:7;
    tmp=bwconncomp(sq(pmaskB(iChan,:,iComp)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeB(iChan,iComp)=max(ii2);
    else
        ChanClusterSizeB(iChan,iComp)=0;
    end
    clear ii2
    end
end

pmaskF=zeros(size(pvalsF,1),size(pvalsF,2));
ii=find(pvalsF<.05);
pmaskF(ii)=1;


for iChan=1:size(pmaskF,1);
    
    tmp=bwconncomp(pmaskF(iChan,:));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeF(iChan)=max(ii2);
    else
        ChanClusterSizeF(iChan)=0;
    end
    clear ii2
end


for iChan=1:size(dataA,1)
    ii=max(sq(mean(dataA(iChan,:,:),2)));
    ii2=find(sq(mean(dataA(iChan,:,:),2))==ii);
    iiSMax(iChan)=ii2(1);
end

idxE=find(iiSMax>=11 & iiSMax<=20);
idxM=find(iiSMax>=21 & iiSMax<=30);
idxL=find(iiSMax>=31 & iiSMax<=40);
GoodChanIdxF=find(ChanClusterSizeF>=ClusterSize);
% GoodChanIdxL=find(ChanClusterSizeB(:,1)>=ClusterSize);
% GoodChanIdxP=find(ChanClusterSizeB(:,2)>=ClusterSize);
% GoodChanIdxT=find(ChanClusterSizeB(:,3)>=ClusterSize);
% GoodChanIdxLP=find(ChanClusterSizeB(:,4)>=ClusterSize);
% GoodChanIdxLT=find(ChanClusterSizeB(:,5)>=ClusterSize);
% GoodChanIdxPT=find(ChanClusterSizeB(:,6)>=ClusterSize);
% GoodChanIdxLPT=find(ChanClusterSizeB(:,7)>=ClusterSize);
iiS2=intersect(GoodChanIdxF,iiS);
% GoodChanIdxL=intersect(GoodChanIdxL,iiS);
% GoodChanIdxP=intersect(GoodChanIdxP,iiS);
% GoodChanIdxT=intersect(GoodChanIdxT,iiS);
% GoodChanIdxLP=intersect(GoodChanIdxLP,iiS);
% GoodChanIdxLT=intersect(GoodChanIdxLT,iiS);
% GoodChanIdxPT=intersect(GoodChanIdxPT,iiS);
% GoodChanIdxLPT=intersect(GoodChanIdxLPT,iiS);

% NewAreaLocLabelA=find(NewAreaLoc>0);
% NewAreaLocLabelB=find(NewAreaLoc~=7);
% NewAreaLocLabel=intersect(NewAreaLocLabelA,NewAreaLocLabelB);
% 
% GoodChanIdxL=intersect(GoodChanIdxL,NewAreaLocLabel);
% GoodChanIdxP=intersect(GoodChanIdxP,NewAreaLocLabel);
% GoodChanIdxT=intersect(GoodChanIdxT,NewAreaLocLabel);
% GoodChanIdxLP=intersect(GoodChanIdxLP,NewAreaLocLabel);
% GoodChanIdxLT=intersect(GoodChanIdxLT,NewAreaLocLabel);
% GoodChanIdxPT=intersect(GoodChanIdxPT,NewAreaLocLabel);
% GoodChanIdxLPT=intersect(GoodChanIdxLPT,NewAreaLocLabel);

% figure;
% chanL=GoodChanIdxL;
% idx1=[1,2,5,6];
% idx2=[3,4,7,8];
% Ltime=zeros(40,1);
% for iChan=1:length(chanL)
%     subplot(9,10,iChan)
%     plot(sq(mean(dataA(chanL(iChan),idx1,:),2)),'b');
%     hold on;
%     plot(sq(mean(dataA(chanL(iChan),idx2,:),2)),'r');
%     axis('tight');
%     
%    % title([NewAreaLegend{NewAreaLoc(chanL(iChan))} ' ' num2str(chanL(iChan))])
%     title(['Channel ' num2str(chanL(iChan))])
%     tmp=bwconncomp(sq(pmaskB(chanL(iChan),:,1)));
%         for ii=1:length(tmp.PixelIdxList);ii2(ii)=length(tmp.PixelIdxList{ii});end
%     ii3=find(ii2>=ClusterSize);
%     if length(ii3)>=1   
%     for ii=1:length(ii3)
%     Ltime(tmp.PixelIdxList{ii3(ii)})=Ltime(tmp.PixelIdxList{ii3(ii)})+1;
%     hold on;
%     plot(tmp.PixelIdxList{ii3(ii)},ones(length(tmp.PixelIdxList{ii3(ii)}),1),'color','k','LineWidth',2)
%     end
%     end
%     clear ii2
% 
% end
% supertitle('Lexical')
% 
% Ptime=zeros(40,1);    
% figure;
% chanL=GoodChanIdxP;
% idx1=[1,3,5,7];
% idx2=[2,4,6,8];
% for iChan=1:length(chanL)
%     subplot(8,10,iChan)
%     plot(sq(mean(dataA(chanL(iChan),idx1,:),2)),'b');
%     hold on;
%     plot(sq(mean(dataA(chanL(iChan),idx2,:),2)),'r');
%     axis('tight');
%     
%     %title([NewAreaLegend{NewAreaLoc(chanL(iChan))}  ' ' num2str(chanL(iChan))])
%     title(['Channel ' num2str(chanL(iChan))])
%     tmp=bwconncomp(sq(pmaskB(chanL(iChan),:,2)));
%         for ii=1:length(tmp.PixelIdxList);ii2(ii)=length(tmp.PixelIdxList{ii});end
%     ii3=find(ii2>=ClusterSize);
%     if length(ii3)>=1   
%     for ii=1:length(ii3)
%     Ptime(tmp.PixelIdxList{ii3(ii)})=Ptime(tmp.PixelIdxList{ii3(ii)})+1;
%     hold on;
%     plot(tmp.PixelIdxList{ii3(ii)},ones(length(tmp.PixelIdxList{ii3(ii)}),1),'color','k','LineWidth',2)
%     end
%     end
%     clear ii2
% 
% end
% supertitle('Phono')
% 
% Ttime=zeros(40,1);
% figure;
% chanL=GoodChanIdxT;
% idx1=[1:4];
% idx2=[5:8];
% for iChan=1:length(chanL)
%     subplot(9,10,iChan)
%     plot(sq(mean(dataA(chanL(iChan),idx1,:),2)),'b');
%     hold on;
%     plot(sq(mean(dataA(chanL(iChan),idx2,:),2)),'r');
%     axis('tight');
%     
%     %title([NewAreaLegend{NewAreaLoc(chanL(iChan))}  ' ' num2str(chanL(iChan))])
%     title(['Channel ' num2str(chanL(iChan))])
%     tmp=bwconncomp(sq(pmaskB(chanL(iChan),:,3)));
%         for ii=1:length(tmp.PixelIdxList);ii2(ii)=length(tmp.PixelIdxList{ii});end
%     ii3=find(ii2>=ClusterSize);
%     if length(ii3)>=1 
%     for ii=1:length(ii3)
%     Ttime(tmp.PixelIdxList{ii3(ii)})=Ttime(tmp.PixelIdxList{ii3(ii)})+1;
%     hold on;
%     plot(tmp.PixelIdxList{ii3(ii)},ones(length(tmp.PixelIdxList{ii3(ii)}),1),'color','k','LineWidth',2)
%     end
%     end
%     clear ii2
% 
% end
% supertitle('Task')
% 
% 
% LPtime=zeros(40,1);
% figure;
% chanL=GoodChanIdxLP;
% idx1=[1,5];
% idx2=[2,6];
% idx3=[3,7];
% idx4=[4,8];
% for iChan=1:length(chanL)
%     subplot(4,10,iChan)
%     plot(sq(mean(dataA(chanL(iChan),idx1,:),2)),'b');
%     hold on;
%     plot(sq(mean(dataA(chanL(iChan),idx2,:),2)),'r');
%     hold on;
%     plot(sq(mean(dataA(chanL(iChan),idx3,:),2)),'g');
%     hold on;
%     plot(sq(mean(dataA(chanL(iChan),idx4,:),2)),'m');
%     axis('tight');
%     
%    % title([NewAreaLegend{NewAreaLoc(chanL(iChan))} ' ' num2str(chanL(iChan))])
%     title(['Channel ' num2str(chanL(iChan))])
%     tmp=bwconncomp(sq(pmaskB(chanL(iChan),:,4)));
%         for ii=1:length(tmp.PixelIdxList);ii2(ii)=length(tmp.PixelIdxList{ii});end
%     ii3=find(ii2>=ClusterSize);
%     if length(ii3)>=1   
%     for ii=1:length(ii3)
%     LPtime(tmp.PixelIdxList{ii3(ii)})=LPtime(tmp.PixelIdxList{ii3(ii)})+1;
%     hold on;
%     plot(tmp.PixelIdxList{ii3(ii)},ones(length(tmp.PixelIdxList{ii3(ii)}),1),'color','k','LineWidth',2)
%     end
%     end
%     clear ii2
% 
% end
% supertitle('Lexical x Phono')
% legend('HW','LW','HNW','LNW')
% 
% LTtime=zeros(40,1);
% figure;
% chanL=GoodChanIdxLT;
% idx1=[1,2];
% idx2=[3,4];
% idx3=[5,6];
% idx4=[7,8];
% for iChan=1:length(chanL)
%     subplot(6,10,iChan)
%     plot(sq(mean(dataA(chanL(iChan),idx1,:),2)),'b');
%     hold on;
%     plot(sq(mean(dataA(chanL(iChan),idx2,:),2)),'r');
%     hold on;
%     plot(sq(mean(dataA(chanL(iChan),idx3,:),2)),'g');
%     hold on;
%     plot(sq(mean(dataA(chanL(iChan),idx4,:),2)),'m');
%     axis('tight');
%     
%     %title([NewAreaLegend{NewAreaLoc(chanL(iChan))} ' ' num2str(chanL(iChan))])
%     title(['Channel ' num2str(chanL(iChan))])
%     tmp=bwconncomp(sq(pmaskB(chanL(iChan),:,5)));
%         for ii=1:length(tmp.PixelIdxList);ii2(ii)=length(tmp.PixelIdxList{ii});end
%     ii3=find(ii2>=ClusterSize);
%     if length(ii3)>=1   
%     for ii=1:length(ii3)
%     LTtime(tmp.PixelIdxList{ii3(ii)})=LTtime(tmp.PixelIdxList{ii3(ii)})+1;
%     hold on;
%     plot(tmp.PixelIdxList{ii3(ii)},ones(length(tmp.PixelIdxList{ii3(ii)}),1),'color','k','LineWidth',2)
%     end
%     end
%     clear ii2
% 
% end
% supertitle('Lexical x Task')
% legend('WD','NWD','WR','NWR')
% 
% PTtime=zeros(40,1);
% figure;
% chanL=GoodChanIdxPT;
% idx1=[1,3];
% idx2=[2,4];
% idx3=[5,7];
% idx4=[6,8];
% for iChan=1:length(chanL)
%     subplot(6,10,iChan)
%     plot(sq(mean(dataA(chanL(iChan),idx1,:),2)),'b');
%     hold on;
%     plot(sq(mean(dataA(chanL(iChan),idx2,:),2)),'r');
%     hold on;
%     plot(sq(mean(dataA(chanL(iChan),idx3,:),2)),'g');
%     hold on;
%     plot(sq(mean(dataA(chanL(iChan),idx4,:),2)),'m');
%     axis('tight');
%     
%     %title([NewAreaLegend{NewAreaLoc(chanL(iChan))} ' ' num2str(chanL(iChan))])
%     title(['Channel ' num2str(chanL(iChan))])
%     tmp=bwconncomp(sq(pmaskB(chanL(iChan),:,6)));
%         for ii=1:length(tmp.PixelIdxList);ii2(ii)=length(tmp.PixelIdxList{ii});end
%     ii3=find(ii2>=ClusterSize);
%     if length(ii3)>=1   
%     for ii=1:length(ii3)
%     PTtime(tmp.PixelIdxList{ii3(ii)})=PTtime(tmp.PixelIdxList{ii3(ii)})+1;
%     hold on;
%     plot(tmp.PixelIdxList{ii3(ii)},ones(length(tmp.PixelIdxList{ii3(ii)}),1),'color','k','LineWidth',2)
%     end
%     end
%     clear ii2
% 
% end
% supertitle('Phono x Task')
% legend('HD','LD','HR','LR')
% 
% 
% LPTtime=zeros(40,1);
% figure;
% chanL=GoodChanIdxLPT;
% 
% for iChan=1:length(chanL)
%     subplot(8,10,iChan)
%     for iCond=1:8
%         hold on
%     plot(sq(dataA(chanL(iChan),iCond,:)),'color',cvals(iCond,:));
%     end
%     axis('tight');
%     
%     %title([NewAreaLegend{NewAreaLoc(chanL(iChan))} ' ' num2str(chanL(iChan))])
%     title(['Channel ' num2str(chanL(iChan))])
%     tmp=bwconncomp(sq(pmaskB(chanL(iChan),:,7)));
%         for ii=1:length(tmp.PixelIdxList);ii2(ii)=length(tmp.PixelIdxList{ii});end
%     ii3=find(ii2>=ClusterSize);
%     if length(ii3)>=1   
%     for ii=1:length(ii3)
%     LPTtime(tmp.PixelIdxList{ii3(ii)})=LPTtime(tmp.PixelIdxList{ii3(ii)})+1;
%     hold on;
%     plot(tmp.PixelIdxList{ii3(ii)},ones(length(tmp.PixelIdxList{ii3(ii)}),1),'color','k','LineWidth',2)
%     end
%     end
%     clear ii2
% 
% end
% supertitle('Lexical x Phono x Task')
% legend('HWD','LWD','HNWD','LNWD','HWR','LWR','HNWR','LNWR')