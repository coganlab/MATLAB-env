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



for iChan=1:size(Spec_Chan_All,2)
    
    tmpval1=[];
    
    for iCond=1:8;
        tmpval1=cat(1,tmpval1,Spec_Chan_All{iChan}{iCond});
    end
    for iTime=1:size(Spec_Chan_All{iChan}{iCond},2);
      %  for iPerm=1:1000;
           % p=ranksum(tmpval1(:,iTime),mean(tmpval1(:,2:10),2));
           
           [h p ci stats]=ttest(tmpval1(:,iTime),mean(tmpval1(:,1:10),2));
            pvals(iChan,iTime)=p;
            tvals(iChan,iTime)=stats.tstat;
      %  end
    end
    data_vals(iChan,:)=mean(tmpval1);
end

pmask2=zeros(size(pvals,1),size(pvals,2),size(pvals,3));
ii=find(pvals<.05);
pmask2(ii)=1;
[pfdr pmask2]=fdr(reshape(pvals,size(pvals,1)*size(pvals,2),1),.05);
pmask2=reshape(pmask2,size(pvals,1),size(pvals,2));

for iChan=1:size(pmask2,1);
    tmp=bwconncomp(pmask2(iChan,:));
    if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    ChanClusterSize(iChan)=max(ii);
    clear ii2
    else
        ChanClusterSize(iChan)=0;
    end
    
end

ClusterSize=3;
GoodChanIdx=find(ChanClusterSize>ClusterSize);
%GoodChanIdx2=iiA(GoodChanIdx);


pmask3=zeros(size(pmask2,1),size(pmask2,2));
ii=find(pmask2==1);
pmask3(ii)=1;

ii=GoodChanIdx;
ii=1:401;
testTrials=[];
F1=[];
F2=[];
F3=[];
    SubjectTrials=[];
    for iChan=1:length(ii)
      %  tmp=[];
        for iCond=1:8
       %     tmp=cat(1,tmp,mean(Spec_Chan_All{ii(iChan)}{iCond}));
        
           % testTrials(iChan,:)=cat(2,testTrials(iChan,:),mean(Spec_Chan_All{ii(iChan)}{iCond}));
            testTrials(iChan,iCond,:)=mean(Spec_Chan_All{ii(iChan)}{iCond});
            F1(iChan,iCond)=designMat(1,iCond);
            F2(iChan,iCond)=designMat(2,iCond);
            F3(iChan,iCond)=designMat(3,iCond);
            
        end
    end

    FS1=cat(1,reshape(F1,1,size(F1,1)*size(F1,2)),reshape(F2,1,size(F2,1)*size(F2,2)),reshape(F3,1,size(F3,1)*size(F3,2)));
    FS2=cat(1,FS1,FS1(1,:).*FS1(2,:),FS1(1,:).*FS1(3,:),FS1(2,:).*FS1(3,:),FS1(1,:).*FS1(2,:).*FS1(3,:),ones(1,size(FS1,2)));
    
    for iTime=1:size(testTrials,3);
        dataT=reshape(sq(testTrials(:,:,iTime)),size(testTrials,1)*size(testTrials,2),1);
        

        
        [P T]=anovan(dataT,FS1','model','full','display','off');
        [b,bint,r,rint,stats] = regress(dataT,FS2');
        TA{iTime}=T;
        PA(iTime,:)=P;
        BB(iTime,:)=b;
        bint2(iTime,:,:)=bint;
        PP(iTime,:)=stats(3);
    end
    
    PA2=zeros(size(PA,1),7);
    ii=find(PA<.05);
    PA2(ii)=1;
    
    PA3=zeros(size(PA2,1),size(PA2,2));
    for iChan=1:size(PA2,2);
        tmp=bwconncomp(PA2(:,iChan));
        if size(tmp.PixelIdxList,2)>0
            for ii=1:size(tmp.PixelIdxList,2);
                ii2(ii)=size(tmp.PixelIdxList{ii},1);
            end
            ii3=find(ii2>=4);
            if (size(ii3,1)>0)
                for i1=1:length(ii3)
                    PA3(tmp.PixelIdxList{ii3(i1)},iChan)=1;
                end
            end
            ChanClusterSize2(iChan)=max(ii);
            clear ii2
        else
            ChanClusterSize2(iChan)=0;
        end
    end
    

    figure;imagesc(PA3')
