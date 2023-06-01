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
          %  tmp=sq(mean(Auditory_Spec{iCond}{iChan}(:,:,fRange)./repmat(mean(Auditory_Spec{iCond}{iChan}(:,1:10,fRange),2),1,size(Auditory_Spec{iCond}{iChan},2),1),3));
           % tmp=sq(mean(Auditory_Spec{iCond}{iChan}(:,:,fRange)./repmat(mean(mean(Auditory_Spec{iCond}{iChan}(:,1:10,fRange),2),1),size(Auditory_Spec{iCond}{iChan},1),size(Auditory_Spec{iCond}{iChan},2),1),3));
           tmp=sq(mean(Auditory_Spec{iCond}{iChan}(:,:,fRange),3));
            Spec_Chan_All{iChan2}{iCond}=tmp;
            Spec_Subject(iChan2)=SN;
            if iCond<=4
                baseline1=cat(1,baseline1,sq(mean(mean(Auditory_Spec{iCond}{iChan}(:,1:10,fRange),2),3)));
            elseif iCond>=5
                baseline2=cat(1,baseline2,sq(mean(mean(Auditory_Spec{iCond}{iChan}(:,1:10,fRange),2),3)));
            end
        end
       
        baseline1=mean(baseline1);
        baseline2=mean(baseline2);
        for iCond=1:8;
            if iCond<=4
            Spec_Chan_All{iChan2}{iCond}=Spec_Chan_All{iChan2}{iCond}./baseline1;
            elseif iCond>=5
            Spec_Chan_All{iChan2}{iCond}=Spec_Chan_All{iChan2}{iCond}./baseline2;
            end

        end
    end
    
    counterChan=counterChan+length(AnalParams.Channel);
end

cIdx=15:30;
for iChan=1:401;
    tmp=[];
    for iCond=1:8;
        tmp=cat(1,tmp,Spec_Chan_All{iChan}{iCond});
    end
    actdiff=mean(mean(tmp(:,cIdx)))-mean(mean(tmp(:,1:10)));
    combval=cat(1,mean(tmp(:,cIdx),2),mean(tmp(:,1:10),2));
    for iPerm=1:10000;
        sIdx=shuffle(1:size(combval,1));
        permval(iPerm)=mean(combval(sIdx(1:size(tmp,1))))-mean(combval(sIdx(size(tmp,1)+1:length(sIdx))));
    end
    pvalsS(iChan)=length(find(permval>actdiff))./10000;
    display(iChan)
end
    
%fRange=fRange.*2;
%tRange=21:30;
load([DUKEDIR '/NewAreas.mat'])
GoodChanIdx=1:401;
% decision
designMat=[1 1 0 0;1 0 1 0];
for iChan=1:length(GoodChanIdx);
    F1=[];
    F2=[];
  %  F3=[];
    data=[];
    for iCond=1:4
        F1=cat(1,F1,designMat(1,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
        F2=cat(1,F2,designMat(2,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
     %   F3=cat(1,F3,designMat(3,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
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
        mdl=fitlm(FS1,dataT,'interactions','PredictorVars',{'Lex','Phono'},'CategoricalVar',{'Lex','Phono'});
       
      %[b,bint,r,rint,stats] = regress(dataT,FS);
         [P T]=anovan(dataT,FS1,'model','full','display','off');
        %         for iT=1:7;
        %             Tvals1(iT)=cell2num(T(iT+1,6));
        %         end
        %  Tvals(iChan,iTRange,:)=Tvals1;
      %  Tvals(iChan,iTRange,:)=b; %Tvals1;
        %Pvals2(iChan,iTRange)=stats(3);
        AvalsD{iChan}{iTRange}=T;
        PvalsD(iChan,iTRange,:)=P;
        ModelD{iChan}{iTRange}=mdl;
    end
    display(iChan)
end


%fRange=fRange.*2;
%tRange=21:30;
load([DUKEDIR '/NewAreas.mat'])
GoodChanIdx=1:401;
% repeat
designMat=[1 1 0 0;1 0 1 0];
for iChan=1:length(GoodChanIdx);
    F1=[];
    F2=[];
  %  F3=[];
    data=[];
    for iCond=1:4
        F1=cat(1,F1,designMat(1,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond+4},1),1));
        F2=cat(1,F2,designMat(2,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond+4},1),1));
     %   F3=cat(1,F3,designMat(3,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
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
      %  mdl=fitlm(FS,dataT,'interactions','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
       
    %  [b,bint,r,rint,stats] = regress(dataT,FS);
         mdl=fitlm(FS1,dataT,'interactions','PredictorVars',{'Lex','Phono'},'CategoricalVar',{'Lex','Phono'});

         [P T]=anovan(dataT,FS1,'model','full','display','off');
        %         for iT=1:7;
        %             Tvals1(iT)=cell2num(T(iT+1,6));
        %         end
        %  Tvals(iChan,iTRange,:)=Tvals1;
      %  Tvals(iChan,iTRange,:)=b; %Tvals1;
        %Pvals2(iChan,iTRange)=stats(3);
        AvalsR{iChan}{iTRange}=T;
        PvalsR(iChan,iTRange,:)=P;
        ModelR{iChan}{iTRange}=mdl;

    end
    display(iChan)
end

%[pfdr pmask]=fdr(reshape(PvalsA,size(PvalsA,1)*size(PvalsA,2)*size(PvalsA,3),1),.05);
%pmask2=reshape(pmask,size(PvalsA,1),size(PvalsA,2),size(PvalsA,3));

betaD=zeros(401,40,3);
pvalD=zeros(401,40,3);
for iChan=1:401
    for iTime=1:40
        tmp=ModelD{iChan}{iTime}.Coefficients.Estimate;
        tmp2=ModelD{iChan}{iTime}.Coefficients.pValue;
        betaD(iChan,iTime,:)=tmp(2:end);
        pvalD(iChan,iTime,:)=tmp2(2:end);
    end
end

for iChan=1:401;
    for iCond=1:4;
        dataD(iChan,iCond,:)=mean(Spec_Chan_All{iChan}{iCond});
    end
end

%decision
pvals3=zeros(401,40,3);
for iChan=1:size(AvalsD,2);
    for iTime=1:size(AvalsD{1},2);
        for iComp=1:3
            pvals3(iChan,iTime,iComp)=cell2num(AvalsD{iChan}{iTime}(iComp+1,7));
        end
    end
end
pmask2BD=zeros(size(pvals3,1),size(pvals3,2),size(pvals3,3));
ii=find(pvals3<.05);
pmask2BD(ii)=1;

% [pfdr pmask]=fdr(reshape(pvals3,size(pvals3,1)*size(pvals3,2)*size(pvals3,3),1),.05);
% pmask2=reshape(pmask,size(pvals3,1),size(pvals3,2),size(pvals3,3));


for iChan=1:size(pmask2BD,1);
    for iComp=1:3;
    tmp=bwconncomp(sq(pmask2BD(iChan,:,iComp)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeD(iChan,iComp)=max(ii);
    clear ii2
    else
        ChanClusterSizeD(iChan,iComp)=0;
    end
    end
end

ClusterSize=3;
GoodChanIdxLD=find(ChanClusterSize(:,1)>ClusterSize);
%GoodChanIdxT=find(ChanClusterSize(:,2)>ClusterSize);
GoodChanIdxPD=find(ChanClusterSize(:,2)>ClusterSize);
GoodChanIdxLPD=find(ChanClusterSize(:,3)>ClusterSize);
GoodChanIdxLD=intersect(GoodChanIdx,GoodChanIdxLD);
GoodChanIdxPD=intersect(GoodChanIdx,GoodChanIdxPD);
GoodChanIdxLPD=intersect(GoodChanIdx,GoodChanIdxLPD);

for iChan=1:length(GoodChanIdxLD);
    for iTime=1:40;
        FvaluesLD(iChan,iTime)=cell2num(AvalsD{GoodChanIdxLD(iChan)}{iTime}(2,6));
    end
end

for iChan=1:length(GoodChanIdxPD);
    for iTime=1:40;
        FvaluesPD(iChan,iTime)=cell2num(AvalsD{GoodChanIdxPD(iChan)}{iTime}(3,6));
    end
end

for iChan=1:length(GoodChanIdxLPD);
    for iTime=1:40;
        FvaluesLPD(iChan,iTime)=cell2num(AvalsD{GoodChanIdxLPD(iChan)}{iTime}(4,6));
    end
end



%repetition
betaR=zeros(401,40,3);
pvalR=zeros(401,40,3);
for iChan=1:401
    for iTime=1:40
        tmp=ModelR{iChan}{iTime}.Coefficients.Estimate;
        tmp2=ModelR{iChan}{iTime}.Coefficients.pValue;
        betaR(iChan,iTime,:)=tmp(2:end);
        pvalR(iChan,iTime,:)=tmp2(2:end);

    end
end

for iChan=1:401;
    for iCond=1:4;
        dataR(iChan,iCond,:)=mean(Spec_Chan_All{iChan}{iCond+4});
    end
end


pvals3=zeros(401,40,3);
for iChan=1:size(AvalsR,2);
    for iTime=1:size(AvalsR{1},2);
        for iComp=1:3
            pvals3(iChan,iTime,iComp)=cell2num(AvalsR{iChan}{iTime}(iComp+1,7));
        end
    end
end
pmask2BR=zeros(size(pvals3,1),size(pvals3,2),size(pvals3,3));
ii=find(pvals3<.05);
pmask2BR(ii)=1;

% [pfdr pmask]=fdr(reshape(pvals3,size(pvals3,1)*size(pvals3,2)*size(pvals3,3),1),.05);
% pmask2=reshape(pmask,size(pvals3,1),size(pvals3,2),size(pvals3,3));


for iChan=1:size(pmask2BR,1);
    for iComp=1:3;
    tmp=bwconncomp(sq(pmask2BR(iChan,:,iComp)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeR(iChan,iComp)=max(ii);
    clear ii2
    else
        ChanClusterSizeR(iChan,iComp)=0;
    end
    end
end

ClusterSize=3;
GoodChanIdxLR=find(ChanClusterSize(:,1)>ClusterSize);
%GoodChanIdxT=find(ChanClusterSize(:,2)>ClusterSize);
GoodChanIdxPR=find(ChanClusterSize(:,2)>ClusterSize);
GoodChanIdxLPR=find(ChanClusterSize(:,3)>ClusterSize);
GoodChanIdxLR=intersect(GoodChanIdx,GoodChanIdxLR);
GoodChanIdxPR=intersect(GoodChanIdx,GoodChanIdxPR);
GoodChanIdxLPR=intersect(GoodChanIdx,GoodChanIdxLPR);

for iChan=1:length(GoodChanIdxLR);
    for iTime=1:40;
        FvaluesLR(iChan,iTime)=cell2num(AvalsR{GoodChanIdxLR(iChan)}{iTime}(2,6));
    end
end

for iChan=1:length(GoodChanIdxPR);
    for iTime=1:40;
        FvaluesPR(iChan,iTime)=cell2num(AvalsR{GoodChanIdxPR(iChan)}{iTime}(3,6));
    end
end

for iChan=1:length(GoodChanIdxLPR);
    for iTime=1:40;
        FvaluesLPR(iChan,iTime)=cell2num(AvalsR{GoodChanIdxLPR(iChan)}{iTime}(4,6));
    end
end


