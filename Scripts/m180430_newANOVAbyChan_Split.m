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

ClusterSize=4;
counterChan=0;
for SN = 10:13
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
    AnalParams.Reference = 'Grand average'; %'Grand average'; % other is 'Single-ended';
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
    CondParams.bn = [-500,1500];
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
    
    for iChan=1:length(AnalParams.Channel);
        iChan2=iChan+counterChan;
        baseline1=[];
        baseline2=[];
        for iCond=1:8;
         tmp=log(sq(mean(Auditory_Spec{iCond}{iChan}(:,:,fRange),3)));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmp=tmp(setdiff(1:size(tmp,1),unique(i)),:);
            tmp=tmp./mean(mean(tmp(:,1:10)));
            
         %   tmp=sq(mean(Auditory_Spec{iCond}{iChan}(:,:,fRange)./repmat(mean(Auditory_Spec{iCond}{iChan}(:,1:10,fRange),2),1,size(Auditory_Spec{iCond}{iChan},2),1),3));
         %   tmp=sq(mean(Auditory_Spec{iCond}{iChan}(:,:,fRange)./repmat(mean(mean(Auditory_Spec{iCond}{iChan}(:,1:10,fRange),2),1),size(Auditory_Spec{iCond}{iChan},1),size(Auditory_Spec{iCond}{iChan},2),1),3));
       %    tmp=sq(mean(Auditory_Spec{iCond}{iChan}(:,:,fRange),3));
            Spec_Chan_All{iChan2}{iCond}=tmp;
            Spec_Subject(iChan2)=SN;
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

% cIdx=15:30;
% for iChan=1:size(Spec_Chan_All,2);
%     tmp=[];
%     for iCond=1:8;
%         tmp=cat(1,tmp,Spec_Chan_All{iChan}{iCond});
%     end
%     actdiff=mean(mean(tmp(:,cIdx)))-mean(mean(tmp(:,1:10)));
%     combval=cat(1,mean(tmp(:,cIdx),2),mean(tmp(:,1:10),2));
%     for iPerm=1:10000;
%         sIdx=shuffle(1:size(combval,1));
%         permval(iPerm)=mean(combval(sIdx(1:size(tmp,1))))-mean(combval(sIdx(size(tmp,1)+1:length(sIdx))));
%     end
%     pvalsS(iChan)=length(find(permval>actdiff))./10000;
%     display(iChan)
% end
% 
% iiS=find(pvalsS<.05);

nPerm=1000;
for iChan=1:size(Spec_Chan_All,2);
    tmpD=[];
    tmpR=[];
    for iCond=1:4;
        tmpD=cat(1,tmpD,Spec_Chan_All{iChan}{iCond});
        tmpR=cat(1,tmpR,Spec_Chan_All{iChan}{iCond+4});
    end
    for iTime=1:40;
    actdiffD=mean(tmpD(:,iTime))-mean(mean(tmpD(:,1:10)));
    combvalD=cat(1,mean(tmpD(:,iTime),2),mean(tmpD(:,1:10),2));
    actdiffR=mean(tmpR(:,iTime))-mean(mean(tmpR(:,1:10)));
    combvalR=cat(1,mean(tmpR(:,iTime),2),mean(tmpR(:,1:10),2));
    for iPerm=1:nPerm;
        sIdxD=shuffle(1:size(combvalD,1));
        permvalD(iPerm)=mean(combvalD(sIdxD(1:size(tmpD,1))))-mean(combvalD(sIdxD(size(tmpD,1)+1:length(sIdxD))));
        sIdxR=shuffle(1:size(combvalR,1));
        permvalR(iPerm)=mean(combvalR(sIdxR(1:size(tmpR,1))))-mean(combvalR(sIdxR(size(tmpR,1)+1:length(sIdxR))));
    end
    pvalsSD(iChan,iTime)=length(find(permvalD>actdiffD))./nPerm;
    pvalsSR(iChan,iTime)=length(find(permvalR>actdiffR))./nPerm;
    end
    display(iChan)
end
pvalsSDM=zeros(size(pvalsSD,1),size(pvalsSD,2));
iiS=find(pvalsSD<.05);
pvalsSDM(iiS)=1;

pvalsSRM=zeros(size(pvalsSR,1),size(pvalsSR,2));
iiS=find(pvalsSR<.05);
pvalsSRM(iiS)=1;

pvalsSDM=zeros(size(pvalsSD,1),size(pvalsSD,2));
for iChan=1:size(pvalsSDM,1)
[pmask pfdr]=fdr(pvalsSD(iChan,:),.05);
pvalsSDM(iChan,:)=pfdr;
end

pvalsSRM=zeros(size(pvalsSR,1),size(pvalsSR,2));
for iChan=1:size(pvalsSRM,1)
[pmask pfdr]=fdr(pvalsSR(iChan,:),.05);
pvalsSRM(iChan,:)=pfdr;
end

% %
clusterStartD=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSDM,1);

    tmp=bwconncomp(sq(pvalsSDM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartD(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartD(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartD(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartD(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartD(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartD(iChan,6)=1;
            end
        end
    end
    clear ii3
 
       
    SigClusterSizeD(iChan)=max(ii2);
    else
        SigClusterSizeD(iChan)=0;
    end
    clear ii2
end

iiDS=find(SigClusterSizeD>=ClusterSize);

clusterStartR=zeros(size(Spec_Chan_All,2),6);
for iChan=1:size(pvalsSRM,1);

    tmp=bwconncomp(sq(pvalsSRM(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    
    ii2B=find(ii2>=ClusterSize);
    if length(ii2B)>0
        for ii=1:length(ii2B);
            ii3(ii)=tmp.PixelIdxList{ii2B(ii)}(1);
            if ii3(ii)>=11 && ii3(ii)<=15
                clusterStartR(iChan,1)=1;
            elseif ii3(ii)>=16 && ii3(ii)<=20
                clusterStartR(iChan,2)=1;
            elseif ii3(ii)>=21 && ii3(ii)<=25
                clusterStartR(iChan,3)=1;
            elseif ii3(ii)>=26 && ii3(ii)<=30
                clusterStartR(iChan,4)=1;
            elseif ii3(ii)>=31 && ii3(ii)<=35
                clusterStartR(iChan,5)=1;
            elseif ii3(ii)>=36 && ii3(ii)<=40
                clusterStartR(iChan,6)=1;
            end
        end
    end
    clear ii3
    
    SigClusterSizeR(iChan)=max(ii2);
    else
        SigClusterSizeR(iChan)=0;
    end
    clear ii2
end

iiRS=find(SigClusterSizeR>=ClusterSize);

cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560],[34/255 139/255 34/255],[1 0 1],[1 192/255 203/255],[119/255 136/255 153/255]);


load([DUKEDIR '/NewAreas.mat'])
GoodChanIdx=1:size(Spec_Chan_All,2);

designMat=[1 1 0 0;1 0 1 0;];
for iChan=1:length(GoodChanIdx);
    F1=[];
    F2=[];
   % F3=[];
    data=[];
    for iCond=1:4
        F1=cat(1,F1,designMat(1,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
        F2=cat(1,F2,designMat(2,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
      %  F3=cat(1,F3,designMat(3,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
      %  data=cat(1,data,Auditory_Spec{iCond}{iChan});
        data=cat(1,data,Spec_Chan_All{GoodChanIdx(iChan)}{iCond});
    end
  %  data_tmp=reshape(sq(mean(data(:,1:10,fRange),3)),size(data,1)*10,1);
   % [data_m data_s]=normfit(data_tmp);
  %  FS=cat(2,F1,F2,F3,F1.*F2,F1.*F3,F2.*F3);
    FS1=cat(2,F1,F2);
    FS=cat(2,FS1,ones(size(FS1,1),1));
   % data=sq(mean(data(:,:,fRange),3));
  %  data=(data-data_m)./data_s;
    tRange=1:40;
    
    for iTRange=1:length(tRange)
        %  for iTRange=1:3
        % tRange=iTRange*10+1:iTRange*10+10;
        dataT=mean(data(:,iTRange),2);
      % mdl=stepwiselm(FS,dataT,'interactions','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
      %  mdl=fitlm(FS1,dataT,'interactions','PredictorVars',{'Lex','Phono','Task'},'CategoricalVar',{'Lex','Phono','Task'});
        mdl=fitlm(FS1,dataT,'y~1+x1+x2+x1:x2','PredictorVars',{'x1','x2'},'CategoricalVar',{'x1','x2'});
      %[b,bint,r,rint,stats] = regress(dataT,FS);
         [P T]=anovan(dataT,FS1,'model','full','display','off');
        %         for iT=1:7;
        %             Tvals1(iT)=cell2num(T(iT+1,6));
        %         end
        %  Tvals(iChan,iTRange,:)=Tvals1;
      %  Tvals(iChan,iTRange,:)=b; %Tvals1;
        %Pvals2(iChan,iTRange)=stats(3);
        AvalsDB{iChan}{iTRange}=T;
        PvalsDB(iChan,iTRange,:)=P;
        ModelDB{iChan}{iTRange}=mdl;
    end
    display(iChan)
end


betaDB=zeros(size(Spec_Chan_All,2),40,3);
pvalDB=zeros(size(Spec_Chan_All,2),40,3);
pvalDFB=zeros(size(Spec_Chan_All,2),40);
fvalDB=zeros(size(Spec_Chan_All,2),40);
rvalD=zeros(size(Spec_Chan_All,2),40);
rvalDA=zeros(size(Spec_Chan_All,2),40);
for iChan=1:size(Spec_Chan_All,2)
    for iTime=1:40
        tmp=ModelDB{iChan}{iTime}.Coefficients.Estimate;
        tmp2=ModelDB{iChan}{iTime}.Coefficients.pValue;
        betaDB(iChan,iTime,:)=tmp(2:end);
        pvalDB(iChan,iTime,:)=tmp2(2:end);
        [p,f]=coefTest(ModelDB{iChan}{iTime});
        fvalDB(iChan,iTime)=f;
        pvalDFB(iChan,iTime)=p;
        rvalD(iChan,iTime)=ModelDB{iChan}{iTime}.Rsquared.Ordinary;
        rvalDA(iChan,iTime)=ModelDB{iChan}{iTime}.Rsquared.Adjusted;
    end
end


designMat=[1 1 0 0;1 0 1 0;];
for iChan=1:length(GoodChanIdx);
    F1=[];
    F2=[];
   % F3=[];
    data=[];
    for iCond=1:4
        F1=cat(1,F1,designMat(1,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond+4},1),1));
        F2=cat(1,F2,designMat(2,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond+4},1),1));
      %  F3=cat(1,F3,designMat(3,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
      %  data=cat(1,data,Auditory_Spec{iCond}{iChan});
        data=cat(1,data,Spec_Chan_All{GoodChanIdx(iChan)}{iCond+4});
    end
  %  data_tmp=reshape(sq(mean(data(:,1:10,fRange),3)),size(data,1)*10,1);
   % [data_m data_s]=normfit(data_tmp);
  %  FS=cat(2,F1,F2,F3,F1.*F2,F1.*F3,F2.*F3);
    FS1=cat(2,F1,F2);
    FS=cat(2,FS1,ones(size(FS1,1),1));
   % data=sq(mean(data(:,:,fRange),3));
  %  data=(data-data_m)./data_s;
    tRange=1:40;
    
    for iTRange=1:length(tRange)
        %  for iTRange=1:3
        % tRange=iTRange*10+1:iTRange*10+10;
        dataT=mean(data(:,iTRange),2);
      % mdl=stepwiselm(FS,dataT,'interactions','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
      %  mdl=fitlm(FS1,dataT,'interactions','PredictorVars',{'Lex','Phono','Task'},'CategoricalVar',{'Lex','Phono','Task'});
        mdl=fitlm(FS1,dataT,'y~1+x1+x2+x1:x2','PredictorVars',{'x1','x2'},'CategoricalVar',{'x1','x2'});
      %[b,bint,r,rint,stats] = regress(dataT,FS);
         [P T]=anovan(dataT,FS1,'model','full','display','off');
        %         for iT=1:7;
        %             Tvals1(iT)=cell2num(T(iT+1,6));
        %         end
        %  Tvals(iChan,iTRange,:)=Tvals1;
      %  Tvals(iChan,iTRange,:)=b; %Tvals1;
        %Pvals2(iChan,iTRange)=stats(3);
        AvalsRB{iChan}{iTRange}=T;
        PvalsRB(iChan,iTRange,:)=P;
        ModelRB{iChan}{iTRange}=mdl;
    end
    display(iChan)
end


betaRB=zeros(size(Spec_Chan_All,2),40,3);
pvalRB=zeros(size(Spec_Chan_All,2),40,3);
pvalRFB=zeros(size(Spec_Chan_All,2),40);
fvalRB=zeros(size(Spec_Chan_All,2),40);
rvalR=zeros(size(Spec_Chan_All,2),40);
rvalRA=zeros(size(Spec_Chan_All,2),40);
for iChan=1:size(Spec_Chan_All,2)
    for iTime=1:40
        tmp=ModelRB{iChan}{iTime}.Coefficients.Estimate;
        tmp2=ModelRB{iChan}{iTime}.Coefficients.pValue;
        betaRB(iChan,iTime,:)=tmp(2:end);
        pvalRB(iChan,iTime,:)=tmp2(2:end);
        [p,f]=coefTest(ModelRB{iChan}{iTime});
        fvalRB(iChan,iTime)=f;
        pvalRFB(iChan,iTime)=p;
        rvalR(iChan,iTime)=ModelRB{iChan}{iTime}.Rsquared.Ordinary;
        rvalRA(iChan,iTime)=ModelRB{iChan}{iTime}.Rsquared.Adjusted;
    end
end



pmaskDB=zeros(size(PvalsDB,1),size(PvalsDB,2),size(PvalsDB,3));
ii=find(PvalsDB<.05);
pmaskDB(ii)=1;

pmaskRB=zeros(size(PvalsRB,1),size(PvalsRB,2),size(PvalsRB,3));
ii=find(PvalsRB<.05);
pmaskRB(ii)=1;

% [pfdr pmask]=fdr(reshape(pvals3,size(pvals3,1)*size(pvals3,2)*size(pvals3,3),1),.05);
% pmask2=reshape(pmask,size(pvals3,1),size(pvals3,2),size(pvals3,3));
for iChan=1:size(Spec_Chan_All,2);
    for iCond=1:8
        dataA(iChan,iCond,:)=mean(Spec_Chan_All{iChan}{iCond});
    end
end

for iChan=1:size(pmaskDB,1);
    for iComp=1:3;
    tmp=bwconncomp(sq(pmaskDB(iChan,:,iComp)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeDB(iChan,iComp)=max(ii2);
    else
        ChanClusterSizeDB(iChan,iComp)=0;
    end
    clear ii2
    end
end

for iChan=1:size(pmaskRB,1);
    for iComp=1:3;
    tmp=bwconncomp(sq(pmaskRB(iChan,:,iComp)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeRB(iChan,iComp)=max(ii2);
    else
        ChanClusterSizeRB(iChan,iComp)=0;
    end
    clear ii2
    end
end

iiRRS=setdiff(iiRS,intersect(iiDS,iiRS));
iiDDS=setdiff(iiDS,intersect(iiDS,iiRS));
iiDRS=intersect(iiDS,iiRS);
