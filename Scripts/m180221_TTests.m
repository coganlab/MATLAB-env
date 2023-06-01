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
            tmp=sq(mean(Auditory_Spec{iCond}{iChan}(:,:,fRange)./repmat(mean(Auditory_Spec{iCond}{iChan}(:,1:10,fRange),2),1,size(Auditory_Spec{iCond}{iChan},2),1),3));
           % tmp=sq(mean(Auditory_Spec{iCond}{iChan}(:,:,fRange)./repmat(mean(mean(Auditory_Spec{iCond}{iChan}(:,1:10,fRange),2),1),size(Auditory_Spec{iCond}{iChan},1),size(Auditory_Spec{iCond}{iChan},2),1),3));
          %  tmp=sq(mean(Auditory_Spec{iCond}{iChan}(:,:,fRange),3));
            Spec_Chan_All{iChan2}{iCond}=tmp;
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
% 
%         end
    end
    
    counterChan=counterChan+length(AnalParams.Channel);
end

designMat=[1 1 0 0 1 1 0 0;1 1 1 1 0 0 0 0;1 0 1 0 1 0 1 0];
%fRange=fRange.*2;
%tRange=21:30;
load([DUKEDIR '/NewAreas.mat'])
GoodChanIdx=1:401;
for iChan=1:length(GoodChanIdx);
    F1D=[];
    F2D=[];
    F3D=[];
    F1R=[];
    F2R=[];
    F3R=[];
    dataD=[];
    dataR=[];
    
    F1DM=[];
    F2DM=[];
    F3DM=[];
    F1RM=[];
    F2RM=[];
    F3RM=[];
    dataDM=[];
    dataRM=[];
    for iCond=1:4
        F1D=cat(1,F1D,designMat(1,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
        F2D=cat(1,F2D,designMat(2,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
        F3D=cat(1,F3D,designMat(3,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
      %  data=cat(1,data,Auditory_Spec{iCond}{iChan});
        dataD=cat(1,dataD,Spec_Chan_All{GoodChanIdx(iChan)}{iCond});
        
        F1R=cat(1,F1R,designMat(1,iCond+4)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond+4},1),1));
        F2R=cat(1,F2R,designMat(2,iCond+4)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond+4},1),1));
        F3R=cat(1,F3R,designMat(3,iCond+4)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond+4},1),1));
      %  data=cat(1,data,Auditory_Spec{iCond}{iChan});
        dataR=cat(1,dataR,Spec_Chan_All{GoodChanIdx(iChan)}{iCond+4});
        
%         F1DM=cat(1,F1DM,designMat(1,iCond)*ones(size(Spec_Chan_All_M{GoodChanIdx(iChan)}{iCond},1),1));
%         F2DM=cat(1,F2DM,designMat(2,iCond)*ones(size(Spec_Chan_All_M{GoodChanIdx(iChan)}{iCond},1),1));
%         F3DM=cat(1,F3DM,designMat(3,iCond)*ones(size(Spec_Chan_All_M{GoodChanIdx(iChan)}{iCond},1),1));
%       %  data=cat(1,data,Auditory_Spec{iCond}{iChan});
%         dataDM=cat(1,dataDM,Spec_Chan_All_M{GoodChanIdx(iChan)}{iCond});
        
%         F1RM=cat(1,F1RM,designMat(1,iCond+4)*ones(size(Spec_Chan_All_M{GoodChanIdx(iChan)}{iCond+4},1),1));
%         F2RM=cat(1,F2RM,designMat(2,iCond+4)*ones(size(Spec_Chan_All_M{GoodChanIdx(iChan)}{iCond+4},1),1));
%         F3RM=cat(1,F3RM,designMat(3,iCond+4)*ones(size(Spec_Chan_All_M{GoodChanIdx(iChan)}{iCond+4},1),1));
%       %  data=cat(1,data,Auditory_Spec{iCond}{iChan});
%         dataRM=cat(1,dataRM,Spec_Chan_All_M{GoodChanIdx(iChan)}{iCond+4});
    end
  %  data_tmp=reshape(sq(mean(data(:,1:10,fRange),3)),size(data,1)*10,1);
   % [data_m data_s]=normfit(data_tmp);
  %  FS=cat(2,F1,F2,F3,F1.*F2,F1.*F3,F2.*F3);
   % FS1=cat(2,F1,F2,F3);
   % FS=cat(2,FS1,ones(size(FS1,1),1));
   % data=sq(mean(data(:,:,fRange),3));
  %  data=(data-data_m)./data_s;
    tRange=1:40;
    
    for iTRange=1:length(tRange)
        %  for iTRange=1:3
        % tRange=iTRange*10+1:iTRange*10+10;
        dataTD=mean(dataD(:,iTRange),2);
        dataTR=mean(dataR(:,iTRange),2);
        
        dataTDB=mean(dataD(:,2:10),2);
        dataTRB=mean(dataR(:,2:10),2);
        
     %    dataTDM=mean(dataDM(:,iTRange),2);
    %    dataTRM=mean(dataRM(:,iTRange),2);
        
        
      % mdl=stepwiselm(FS,dataT,'interactions','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
      %  mdl=fitlm(FS,dataT,'interactions','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
      
      val1=dataTD(find(F1D==1));
      val2=dataTD(find(F1D==0));
      mintrials=min(cat(1,length(val1),length(val2)));
      [H P CI STATS]=ttest(val1(shuffle(1:mintrials)),val2(shuffle(1:mintrials)));
      PvalsDL(iChan,iTRange)=P;
      TvalsDL(iChan,iTRange)=STATS.tstat;
      
%       val1M=dataTDM(find(F1DM==1));
%       val2M=dataTDM(find(F1DM==0));
%       mintrials=min(cat(1,length(val1M),length(val2M)));
%       [H P CI STATS]=ttest(val1M(shuffle(1:mintrials)),val2M(shuffle(1:mintrials)));
%       PvalsDLM(iChan,iTRange)=P;
%       TvalsDLM(iChan,iTRange)=STATS.tstat;
      
     
      
      val1B=dataTD(find(F3D==1));
      val2B=dataTD(find(F3D==0));
      mintrialsB=min(cat(1,length(val1B),length(val2B)));
      [H P CI STATS]=ttest(val1B(shuffle(1:mintrialsB)),val2B(shuffle(1:mintrialsB)));
      PvalsDP(iChan,iTRange)=P;
      TvalsDP(iChan,iTRange)=STATS.tstat;
      
%       val1BM=dataTDM(find(F3DM==1));
%       val2BM=dataTDM(find(F3DM==0));
%       mintrialsB=min(cat(1,length(val1BM),length(val2BM)));
%       [H P CI STATS]=ttest(val1BM(shuffle(1:mintrialsB)),val2BM(shuffle(1:mintrialsB)));
%       PvalsDPM(iChan,iTRange)=P;
%       TvalsDPM(iChan,iTRange)=STATS.tstat;
      
     
      val1=dataTR(find(F1R==1));
      val2=dataTR(find(F1R==0));
      mintrials=min(cat(1,length(val1),length(val2)));
      [H P CI STATS]=ttest(val1(shuffle(1:mintrials)),val2(shuffle(1:mintrials)));
      PvalsRL(iChan,iTRange)=P;
      TvalsRL(iChan,iTRange)=STATS.tstat;
      
%       val1M=dataTRM(find(F1RM==1));
%       val2M=dataTRM(find(F1RM==0));
%       mintrials=min(cat(1,length(val1M),length(val2M)));
%       [H P CI STATS]=ttest(val1M(shuffle(1:mintrials)),val2M(shuffle(1:mintrials)));
%       PvalsRLM(iChan,iTRange)=P;
%       TvalsRLM(iChan,iTRange)=STATS.tstat;
      
      val1B=dataTR(find(F3R==1));
      val2B=dataTR(find(F3R==0));
      mintrialsB=min(cat(1,length(val1B),length(val2B)));
      [H P CI STATS]=ttest(val1B(shuffle(1:mintrialsB)),val2B(shuffle(1:mintrialsB)));
      PvalsRP(iChan,iTRange)=P;
      TvalsRP(iChan,iTRange)=STATS.tstat;
      
%       val1BM=dataTRM(find(F3RM==1));
%       val2BM=dataTRM(find(F3RM==0));
%       mintrialsB=min(cat(1,length(val1BM),length(val2BM)));
%       [H P CI STATS]=ttest(val1BM(shuffle(1:mintrialsB)),val2BM(shuffle(1:mintrialsB)));
%       PvalsRPM(iChan,iTRange)=P;
%       TvalsRPM(iChan,iTRange)=STATS.tstat;
      
      
      [H P CI STATS]=ttest(dataTD,dataTDB);
      PvalsDB(iChan,iTRange)=P;
      TvalsDB(iChan,iTRange)=STATS.tstat;
      
       [H P CI STATS]=ttest(dataTR,dataTRB);
      PvalsRB(iChan,iTRange)=P;
      TvalsRB(iChan,iTRange)=STATS.tstat;
      
%       
%         mintrials=min(cat(1,length(dataTDM),length(dataTDB)));
%        idx1=shuffle(1:length(dataTDM));
%        idx2=shuffle(1:length(dataTDB));
%       [H P CI STATS]=ttest(dataTDM(idx1(1:mintrials)),dataTDB(idx2(1:mintrials)));
%       PvalsDBM(iChan,iTRange)=P;
%       TvalsDBM(iChan,iTRange)=STATS.tstat;
      
%        mintrials=min(cat(1,length(dataTRM),length(dataTRB)));
%        idx1=shuffle(1:length(dataTRM));
%        idx2=shuffle(1:length(dataTRB));
%        [H P CI STATS]=ttest(dataTRM(idx1(1:mintrials)),dataTRB(idx2(1:mintrials)));
%       PvalsRBM(iChan,iTRange)=P;
%       TvalsRBM(iChan,iTRange)=STATS.tstat;
    end
    display(iChan)
end
 
PmaskDB=zeros(size(PvalsDB,1),size(PvalsDB,2));
ii=find(PvalsDB<0.05);
PmaskDB(ii)=1;

%  [pfdr pmask]=fdr(reshape(PvalsDL,size(PvalsDL,1)*size(PvalsDL,2),1),.05);
%  PmaskDL=reshape(pmask,size(PvalsDL,1),size(PvalsDL,2));
pmask=PmaskDB;
for iChan=1:size(pmask,1);
    
    tmp=bwconncomp(sq(pmask(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeDB(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSizeDB(iChan)=0;
    end
    
end

PmaskRB=zeros(size(PvalsRB,1),size(PvalsRB,2));
ii=find(PvalsRB<0.05);
PmaskRB(ii)=1;

%  [pfdr pmask]=fdr(reshape(PvalsDL,size(PvalsDL,1)*size(PvalsDL,2),1),.05);
%  PmaskDL=reshape(pmask,size(PvalsDL,1),size(PvalsDL,2));
pmask=PmaskRB;
for iChan=1:size(pmask,1);
    
    tmp=bwconncomp(sq(pmask(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeRB(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSizeRB(iChan)=0;
    end
    
end


PmaskDL=zeros(size(PvalsDL,1),size(PvalsDL,2));
ii=find(PvalsDL<0.05);
PmaskDL(ii)=1;

%  [pfdr pmask]=fdr(reshape(PvalsDL,size(PvalsDL,1)*size(PvalsDL,2),1),.05);
%  PmaskDL=reshape(pmask,size(PvalsDL,1),size(PvalsDL,2));
pmask=PmaskDL;
for iChan=1:size(pmask,1);
    
    tmp=bwconncomp(sq(pmask(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeDL(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSizeDL(iChan)=0;
    end
    
end

PmaskDP=zeros(size(PvalsDP,1),size(PvalsDP,2));
ii=find(PvalsDP<0.05);
PmaskDP(ii)=1;
pmask=PmaskDP;
for iChan=1:size(pmask,1);
    
    tmp=bwconncomp(sq(pmask(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeDP(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSizeDP(iChan)=0;
    end
    
end

PvalsDI=sq(pvals3(:,:,1,3)); % from an anova with interaction.  
PmaskDI=zeros(size(PvalsDI,1),size(PvalsDL,2));
ii=find(PvalsDI<0.05);
PmaskDI(ii)=1;

%  [pfdr pmask]=fdr(reshape(PvalsDL,size(PvalsDL,1)*size(PvalsDL,2),1),.05);
%  PmaskDL=reshape(pmask,size(PvalsDL,1),size(PvalsDL,2));
pmask=PmaskDI;
for iChan=1:size(pmask,1);
    
    tmp=bwconncomp(sq(pmask(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeDI(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSizeDI(iChan)=0;
    end
    
end

PvalsRI=sq(pvals3(:,:,2,3)); % from an anova with interaction.  
PmaskRI=zeros(size(PvalsRI,1),size(PvalsRL,2));
ii=find(PvalsRI<0.05);
PmaskRI(ii)=1;

%  [pfdr pmask]=fdr(reshape(PvalsDL,size(PvalsDL,1)*size(PvalsDL,2),1),.05);
%  PmaskDL=reshape(pmask,size(PvalsDL,1),size(PvalsDL,2));
pmask=PmaskRI;
for iChan=1:size(pmask,1);
    
    tmp=bwconncomp(sq(pmask(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeRI(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSizeRI(iChan)=0;
    end
    
end

PmaskRL=zeros(size(PvalsRL,1),size(PvalsRL,2));
ii=find(PvalsRL<0.05);
PmaskRL(ii)=1;
pmask=PmaskRL;
for iChan=1:size(pmask,1);
    
    tmp=bwconncomp(sq(pmask(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeRL(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSizeRL(iChan)=0;
    end
    
end



PmaskRP=zeros(size(PvalsRP,1),size(PvalsRP,2));
ii=find(PvalsRP<0.05);
PmaskRP(ii)=1;
pmask=PmaskRP;
for iChan=1:size(pmask,1);
    
    tmp=bwconncomp(sq(pmask(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeRP(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSizeRP(iChan)=0;
    end
    
end

cutoff=3;

GoodChanIdxDL=find(ChanClusterSizeDL>=cutoff);
GoodChanIdxDP=find(ChanClusterSizeDP>=cutoff);
GoodChanIdxRL=find(ChanClusterSizeRL>=cutoff);
GoodChanIdxRP=find(ChanClusterSizeRP>=cutoff);
GoodChanIdxDB=find(ChanClusterSizeDB>=cutoff);
GoodChanIdxRB=find(ChanClusterSizeRB>=cutoff);
GoodChanIdxDI=find(ChanClusterSizeDI>=cutoff);
GoodChanIdxRI=find(ChanClusterSizeRI>=cutoff);

ii1=find(NewAreaLoc>0);
ii2=find(NewAreaLoc~=7);
iiA=intersect(ii1,ii2);
iiDB=intersect(iiA,GoodChanIdxDB);
iiRB=intersect(iiA,GoodChanIdxRB);

iiDB_L=intersect(iiDB,GoodChanIdxDL);

iiDB_P=intersect(iiDB,GoodChanIdxDP);

iiDB_I=intersect(iiDB,GoodChanIdxDI);
iiRB_I=intersect(iiRB,GoodChanIdxRI);
iiRB_L=intersect(iiRB,GoodChanIdxRL);
iiRB_P=intersect(iiRB,GoodChanIdxRP);
ii_P=intersect(iiDB_P,iiRB_P);
iiRB_P_Diff=setdiff(iiRB_P,ii_P);
iiDB_P_Diff=setdiff(iiDB_P,ii_P)
ii_L=intersect(iiDB_L,iiRB_L);
iiDB_L_Diff=setdiff(iiDB_L,ii_L);



iiALL_D=unique(cat(1,iiDB_L,iiDB_L,iiDB_P));

iiALL_R=unique(cat(1,iiRB_L,iiRB_L,iiRB_P));

iiALL_DR=intersect(iiALL_D,iiALL_R);

iiALL_D_EXC=setdiff(iiALL_D,iiALL_DR);

iiALL_R_EXC=setdiff(iiALL_R,iiALL_DR);

iiALL_DR_INC=setdiff(iiALL_DR,iiALL_D_EXC);
iiALL_DR_INC=setdiff(iiALL_DR_INC,iiALL_R_EXC);









PmaskDBM=zeros(size(PvalsDBM,1),size(PvalsDBM,2));
ii=find(PvalsDBM<0.05);
PmaskDBM(ii)=1;

%  [pfdr pmask]=fdr(reshape(PvalsDL,size(PvalsDL,1)*size(PvalsDL,2),1),.05);
%  PmaskDL=reshape(pmask,size(PvalsDL,1),size(PvalsDL,2));
pmask=PmaskDBM;
for iChan=1:size(pmask,1);
    
    tmp=bwconncomp(sq(pmask(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeDBM(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSizeDBM(iChan)=0;
    end
    
end

PmaskRBM=zeros(size(PvalsRBM,1),size(PvalsRBM,2));
ii=find(PvalsRBM<0.05);
PmaskRBM(ii)=1;

%  [pfdr pmask]=fdr(reshape(PvalsDL,size(PvalsDL,1)*size(PvalsDL,2),1),.05);
%  PmaskDL=reshape(pmask,size(PvalsDL,1),size(PvalsDL,2));
pmask=PmaskRBM;
for iChan=1:size(pmask,1);
    
    tmp=bwconncomp(sq(pmask(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeRBM(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSizeRBM(iChan)=0;
    end
    
end


PmaskDLM=zeros(size(PvalsDLM,1),size(PvalsDLM,2));
ii=find(PvalsDLM<0.05);
PmaskDLM(ii)=1;

%  [pfdr pmask]=fdr(reshape(PvalsDL,size(PvalsDL,1)*size(PvalsDL,2),1),.05);
%  PmaskDL=reshape(pmask,size(PvalsDL,1),size(PvalsDL,2));
pmask=PmaskDL;
for iChan=1:size(pmask,1);
    
    tmp=bwconncomp(sq(pmask(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeDLM(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSizeDLM(iChan)=0;
    end
    
end

PmaskDPM=zeros(size(PvalsDPM,1),size(PvalsDPM,2));
ii=find(PvalsDPM<0.05);
PmaskDPM(ii)=1;
pmask=PmaskDPM;
for iChan=1:size(pmask,1);
    
    tmp=bwconncomp(sq(pmask(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeDPM(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSizeDPM(iChan)=0;
    end
    
end



PmaskRLM=zeros(size(PvalsRLM,1),size(PvalsRLM,2));
ii=find(PvalsRLM<0.05);
PmaskRLM(ii)=1;
pmask=PmaskRLM;
for iChan=1:size(pmask,1);
    
    tmp=bwconncomp(sq(pmask(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeRLM(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSizeRLM(iChan)=0;
    end
    
end



PmaskRPM=zeros(size(PvalsRPM,1),size(PvalsRPM,2));
ii=find(PvalsRPM<0.05);
PmaskRPM(ii)=1;
pmask=PmaskRPM;
for iChan=1:size(pmask,1);
    
    tmp=bwconncomp(sq(pmask(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSizeRPM(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSizeRPM(iChan)=0;
    end
    
end

cutoff=4;

GoodChanIdxDLM=find(ChanClusterSizeDLM>=cutoff);
GoodChanIdxDPM=find(ChanClusterSizeDPM>=cutoff);
GoodChanIdxRLM=find(ChanClusterSizeRLM>=cutoff);
GoodChanIdxRPM=find(ChanClusterSizeRPM>=cutoff);
GoodChanIdxDBM=find(ChanClusterSizeDBM>=cutoff);
GoodChanIdxRBM=find(ChanClusterSizeRBM>=cutoff);
ii1=find(NewAreaLoc>0);
ii2=find(NewAreaLoc~=7);
iiA=intersect(ii1,ii2);
iiDBM=intersect(iiA,GoodChanIdxDBM);
iiRBM=intersect(iiA,GoodChanIdxRBM);

iiDB_LM=intersect(iiDBM,GoodChanIdxDLM);
iiRB_LM=intersect(iiRBM,GoodChanIdxRLM);


ii_LM=intersect(iiDB_LM,iiRB_LM);
iiDB_PM=intersect(iiDBM,GoodChanIdxDPM);
iiRB_PM=intersect(iiRBM,GoodChanIdxRPM);
iiDB_LM_Diff=setdiff(iiDB_LM,ii_LM);
ii_PM=intersect(iiDB_PM,iiRB_PM);
iiRB_PM_Diff=setdiff(iiRB_PM,ii_PM);
iiDB_PM_Diff=setdiff(iiDB_PM,ii_PM);



iiDSM=intersect(iiDB,iiDBM);
iiRSM=intersect(iiRB,iiRBM);

iiD=setdiff(iiDB,iiDSM);
iiR=setdiff(iiRB,iiRSM);



