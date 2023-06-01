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
for SN = 10:14
    Subject(SN).Experiment = loadExperiment(Subject(SN).Name);
    Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');
    %Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_CovertOvert'); % Test line
    Trials = Subject(SN).Trials;
    experiment = Subject(SN).Experiment;
    
    %CondParams.Conds = [1:4];
    
    
    
    %CondParams.bn = [-2500,3500];
    AnalParams.Tapers = [0.5,10];
    %AnalParams.Tapers = [.25,20];
    %AnalParams.Tapers=[1,4];
    %AnalParams.Tapers = [1,10];
    AnalParams.fk = 500;
    AnalParams.Reference = 'Grand average'; %'Grand average'; % other is 'Single-ended';
    AnalParams.ArtifactThreshold = 25;
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
    
    
    % CondParams.Field = 'ResponseStart';
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
    CondParams.bn = [-500,2000];
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
    
    CondParams.Conds=[1:8];
    CondParams.Field = 'Go';
    CondParams.bn = [-1000,2000];
    for iCode = 1:length(CondParams.Conds)
        
        if isfield(CondParams,'Conds2')
            CondParams.Conds = CondParams.Conds2(iCode);
        else
            CondParams.Conds = iCode;
        end
        tic
        [Motor_Spec{iCode}, Motor_Data, Motor_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
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
            tmpIDX1=setdiff(1:size(tmp,1),unique(i));
            
            tmp=sq(mean(Motor_Spec{iCond}{iChan}(:,:,fRange),3));
            tmp=tmp-mean(mean(tmp));
            [m s]=normfit(tmp(:));
            [i j]=find(tmp>(outcut*s+m));
            tmpIDX2=setdiff(1:size(tmp,1),unique(i));
            
            tmpIDX=unique(cat(2,tmpIDX1,tmpIDX2));
            minAct=min(cat(1,size(Auditory_Spec{iCond}{iChan},1),size(Motor_Spec{iCond}{iChan},1)));
            if minAct<max(tmpIDX)
                ii=find(tmpIDX>minAct);
                tmpIDX=setdiff(tmpIDX,tmpIDX(ii));
            end
            %  tmp=tmp./mean(mean(tmp(:,1:10))); % each cond baseline
            %   tmp=tmp./mean(tmp(:,1:10),2); % each trial baseline
            
            Spec_Chan_All{iChan2}{iCond}=sq(mean(Auditory_Spec{iCond}{iChan}(tmpIDX,:,fRange),3));
            Spec_Chan_AllM{iChan2}{iCond}=sq(mean(Motor_Spec{iCond}{iChan}(tmpIDX,:,fRange),3));
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

% % % trial baseline
% for iChan=1:counterChan
%     for iCond=1:8
%     Spec_Chan_All{iChan}{iCond}=Spec_Chan_All{iChan}{iCond}./mean(Spec_Chan_All{iChan}{iCond}(:,1:10),2);
%     end
% end
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

% condition baseline
for iChan=1:counterChan
    for iCond=1:8
        tmp1=Spec_Chan_All{iChan}{iCond};
        tmp2=Spec_Chan_AllM{iChan}{iCond};
        Spec_Chan_All{iChan}{iCond}=tmp1./mean(mean(tmp1(:,1:10)));
        Spec_Chan_AllM{iChan}{iCond}=tmp2./mean(mean(tmp1(:,1:10)));
        %  Spec_Chan_All{iChan}{iCond}=Spec_Chan_All{iChan}{iCond}./mean(mean(Spec_Chan_All{iChan}{iCond}(:,1:10)));
        %  Spec_Chan_AllM{iChan}{iCond}=Spec_Chan_AllM{iChan}{iCond}./mean(mean(Spec_Chan_All{iChan}{iCond}(:,1:10)));
        
    end
end
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
        dataM(iChan,iCond,:)=mean(Spec_Chan_AllM{iChan}{iCond});
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
    
    %     % collapsed significance
    %     tmp=[];
    %     tmpM=[];
    %     for iCond=1:8;
    %         tmp=cat(1,tmp,Spec_Chan_All{iChan}{iCond});
    %         tmpM=cat(1,tmpM,Spec_Chan_AllM{iChan}{iCond});
    %     end
    %     for iTime=1:50;
    %     actdiff=mean(tmp(:,iTime))-mean(mean(tmp(:,1:10)));
    %     combval=cat(1,mean(tmp(:,iTime),2),mean(tmp(:,1:10),2));
    %     actdiffM=mean(tmpM(:,iTime))-mean(mean(tmp(:,1:10)));
    %     combvalM=cat(1,mean(tmpM(:,iTime),2),mean(tmp(:,1:10),2));
    %     for iPerm=1:nPerm;
    %         sIdx=shuffle(1:size(combval,1));
    %         permval(iPerm)=mean(combval(sIdx(1:size(tmp,1))))-mean(combval(sIdx(size(tmp,1)+1:length(sIdx))));
    %         sIdxM=shuffle(1:size(combvalM,1));
    %         permvalM(iPerm)=mean(combvalM(sIdxM(1:size(tmpM,1))))-mean(combvalM(sIdxM(size(tmpM,1)+1:length(sIdxM))));
    %     end
    %     pvalsS(iChan,iTime)=length(find(permval>actdiff))./nPerm;
    %     pvalsM(iChan,iTime)=length(find(permvalM>actdiffM))./nPerm;
    %     end
    %     display(iChan)
    
    % seperate collapsed significance
    tmpD=[];
    tmpDM=[];
    tmpR=[];
    tmpRM=[];
    for iCond=1:4;
        tmpD=cat(1,tmpD,Spec_Chan_All{iChan}{iCond});
        tmpDM=cat(1,tmpDM,Spec_Chan_AllM{iChan}{iCond});
        tmpR=cat(1,tmpR,Spec_Chan_All{iChan}{iCond+4});
        tmpRM=cat(1,tmpRM,Spec_Chan_AllM{iChan}{iCond+4});
    end
    
    for iTime=1:50;
        actdiffD=mean(tmpD(:,iTime))-mean(mean(tmpD(:,1:10)));
        combvalD=cat(1,mean(tmpD(:,iTime),2),mean(tmpD(:,1:10),2));
        actdiffDM=mean(tmpDM(:,iTime))-mean(mean(tmpD(:,1:10)));
        combvalDM=cat(1,mean(tmpDM(:,iTime),2),mean(tmpD(:,1:10),2));
        
        actdiffR=mean(tmpR(:,iTime))-mean(mean(tmpR(:,1:10)));
        combvalR=cat(1,mean(tmpR(:,iTime),2),mean(tmpR(:,1:10),2));
        actdiffRM=mean(tmpRM(:,iTime))-mean(mean(tmpR(:,1:10)));
        combvalRM=cat(1,mean(tmpRM(:,iTime),2),mean(tmpR(:,1:10),2));
        
        for iPerm=1:nPerm;
            sIdxD=shuffle(1:size(combvalD,1));
            permvalD(iPerm)=mean(combvalD(sIdxD(1:size(tmpD,1))))-mean(combvalD(sIdxD(size(tmpD,1)+1:length(sIdxD))));
            sIdxDM=shuffle(1:size(combvalDM,1));
            permvalDM(iPerm)=mean(combvalDM(sIdxDM(1:size(tmpDM,1))))-mean(combvalDM(sIdxDM(size(tmpDM,1)+1:length(sIdxDM))));
            
            sIdxR=shuffle(1:size(combvalR,1));
            permvalR(iPerm)=mean(combvalR(sIdxR(1:size(tmpR,1))))-mean(combvalR(sIdxR(size(tmpR,1)+1:length(sIdxR))));
            sIdxRM=shuffle(1:size(combvalRM,1));
            permvalRM(iPerm)=mean(combvalRM(sIdxRM(1:size(tmpRM,1))))-mean(combvalRM(sIdxRM(size(tmpRM,1)+1:length(sIdxRM))));
        end
        pvalsDS(iChan,iTime)=length(find(permvalD>actdiffD))./nPerm;
        pvalsDM(iChan,iTime)=length(find(permvalDM>actdiffDM))./nPerm;
        pvalsRS(iChan,iTime)=length(find(permvalR>actdiffR))./nPerm;
        pvalsRM(iChan,iTime)=length(find(permvalRM>actdiffRM))./nPerm;
    end
    display(iChan)
    %
end
% uncorrected
% pvalsSM=zeros(size(pvalsS,1),size(pvalsS,2));
% iiS=find(pvalsS<.05);
% pvalsSM(iiS)=1;
%
% pvalsSM=zeros(size(pvalsS,1),size(pvalsS,2)-10);
% for iChan=1:size(pvalsSM,1)
% [pmask pfdr]=fdr(pvalsS(iChan,1:40),.05);
% pvalsSM(iChan,:)=pfdr;
% end
%
%
% pvalsMM=zeros(size(pvalsM,1),size(pvalsM,2));
% iiS=find(pvalsM<.05);
% pvalsMM(iiS)=1;
%
% pvalsMM=zeros(size(pvalsM,1),size(pvalsM,2));
% for iChan=1:size(pvalsMM,1)
% [pmask pfdr]=fdr(pvalsM(iChan,:),.05);
% pvalsMM(iChan,:)=pfdr;
% end
%
pvalsDS2=zeros(size(pvalsDS,1),size(pvalsDS,2));
iiS=find(pvalsDS<.05);
pvalsDS2(iiS)=1;

pvalsDS2=zeros(size(pvalsDS,1),size(pvalsDS,2)-10);
for iChan=1:size(pvalsDS,1)
    [pmask pfdr]=fdr(pvalsDS(iChan,1:40),.05);
    pvalsDS2(iChan,:)=pfdr;
end

pvalsRS2=zeros(size(pvalsRS,1),size(pvalsRS,2));
iiS=find(pvalsRS<.05);
pvalsRS2(iiS)=1;

pvalsRS2=zeros(size(pvalsRS,1),size(pvalsRS,2)-10);
for iChan=1:size(pvalsRS,1)
    [pmask pfdr]=fdr(pvalsRS(iChan,1:40),.05);
    pvalsRS2(iChan,:)=pfdr;
end

pvalsDM2=zeros(size(pvalsDM,1),size(pvalsDM,2));
iiS=find(pvalsDM<.05);
pvalsDM2(iiS)=1;

pvalsDM2=zeros(size(pvalsDM,1),size(pvalsDM,2));
for iChan=1:size(pvalsDM,1)
    [pmask pfdr]=fdr(pvalsDM(iChan,:),.05);
    pvalsDM2(iChan,:)=pfdr;
end

pvalsRM2=zeros(size(pvalsRM,1),size(pvalsRM,2));
iiS=find(pvalsRM<.05);
pvalsRM2(iiS)=1;

pvalsRM2=zeros(size(pvalsRM,1),size(pvalsRM,2));
for iChan=1:size(pvalsRM,1)
    [pmask pfdr]=fdr(pvalsRM(iChan,:),.05);
    pvalsRM2(iChan,:)=pfdr;
end



clear ii2

clusterStartC=zeros(515,1);
clusterStartMC=zeros(515,1);

clusterStartDC=zeros(515,1);
clusterStartDMC=zeros(515,1);

clusterStartRC=zeros(515,1);
clusterStartRMC=zeros(515,1);
for iChan=1:size(pvalsDM,1);
    
    %     tmp=bwconncomp(sq(pvalsSM(iChan,:)));
    %     if size(tmp.PixelIdxList,2)>0
    %         for ii=1:size(tmp.PixelIdxList,2);
    %             ii2(ii)=size(tmp.PixelIdxList{ii},1);
    %         end
    %         ii2B=find(ii2>=ClusterSize);
    %         if length(ii2B)>0
    %              tmp2=tmp.PixelIdxList{ii2B(1)};
    %             clusterStartC(iChan)=tmp2(1);
    %         end
    %         clear ii3
    %         SigClusterSize(iChan)=max(ii2);
    %     else
    %         SigClusterSize(iChan)=0;
    %     end
    %     clear ii2
    %
    %
    %     tmp=bwconncomp(sq(pvalsMM(iChan,:)));
    %     if size(tmp.PixelIdxList,2)>0
    %         for ii=1:size(tmp.PixelIdxList,2);
    %             ii2(ii)=size(tmp.PixelIdxList{ii},1);
    %         end
    %         ii2B=find(ii2>=ClusterSize);
    %         if length(ii2B)>0
    %             tmp2=tmp.PixelIdxList{ii2B(1)};
    %             clusterStartMC(iChan)=tmp2(1);
    %         end
    %         clear ii3
    %         SigClusterSizeM(iChan)=max(ii2);
    %     else
    %         SigClusterSizeM(iChan)=0;
    %     end
    %     clear ii2
    
    tmp=bwconncomp(sq(pvalsDS2(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
        for ii=1:size(tmp.PixelIdxList,2);
            ii2(ii)=size(tmp.PixelIdxList{ii},1);
        end
        ii2B=find(ii2>=ClusterSize);
        if length(ii2B)>0
            tmp2=tmp.PixelIdxList{ii2B(1)};
            clusterStartDC(iChan)=tmp2(1);
        end
        clear ii3
        SigClusterSizeDS(iChan)=max(ii2);
    else
        SigClusterSizeDS(iChan)=0;
    end
    clear ii2
    
    
    tmp=bwconncomp(sq(pvalsDM2(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
        for ii=1:size(tmp.PixelIdxList,2);
            ii2(ii)=size(tmp.PixelIdxList{ii},1);
        end
        ii2B=find(ii2>=ClusterSize);
        if length(ii2B)>0
            tmp2=tmp.PixelIdxList{ii2B(1)};
            clusterStartDMC(iChan)=tmp2(1);
        end
        clear ii3
        SigClusterSizeDM(iChan)=max(ii2);
    else
        SigClusterSizeDM(iChan)=0;
    end
    clear ii2
    
    
    tmp=bwconncomp(sq(pvalsRS2(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
        for ii=1:size(tmp.PixelIdxList,2);
            ii2(ii)=size(tmp.PixelIdxList{ii},1);
        end
        ii2B=find(ii2>=ClusterSize);
        if length(ii2B)>0
            tmp2=tmp.PixelIdxList{ii2B(1)};
            clusterStartRC(iChan)=tmp2(1);
        end
        clear ii3
        SigClusterSizeRS(iChan)=max(ii2);
    else
        SigClusterSizeRS(iChan)=0;
    end
    clear ii2
    
    
    tmp=bwconncomp(sq(pvalsRM2(iChan,:)));
    if size(tmp.PixelIdxList,2)>0
        for ii=1:size(tmp.PixelIdxList,2);
            ii2(ii)=size(tmp.PixelIdxList{ii},1);
        end
        ii2B=find(ii2>=ClusterSize);
        if length(ii2B)>0
            tmp2=tmp.PixelIdxList{ii2B(1)};
            clusterStartRMC(iChan)=tmp2(1);
        end
        clear ii3
        SigClusterSizeRM(iChan)=max(ii2);
    else
        SigClusterSizeRM(iChan)=0;
    end
    clear ii2
end

% iiS=find(SigClusterSize>=ClusterSize); % combined tasks, sensory epoch
% iiM=find(SigClusterSizeM>=ClusterSize);% combined task, motor epoch

iiDS=find(SigClusterSizeDS>=ClusterSize); % decision only, sensory epoch A
iiDM=find(SigClusterSizeDM>=ClusterSize); % decision only, motor epoch C

iiRS=find(SigClusterSizeRS>=ClusterSize); % repetition only, sensory epoch B
iiRM=find(SigClusterSizeRM>=ClusterSize); % repetition only, motor epoch D

iiALL=unique(cat(2,iiDS,iiRS,iiDM,iiRM));

iiA=iiDS;
iiB=iiRS;
iiC=iiDM;
iiD=iiRM;

iiABCD=intersect(iiA,intersect(iiB,intersect(iiC,iiD))); % 40 SM ALL

iiABC=setdiff(intersect(iiA,intersect(iiB,iiC)),iiD); % 2 ALL S, DEC M
iiABD=setdiff(intersect(iiA,intersect(iiB,iiD)),iiC); % 4 ALL S, REP M
iiACD=setdiff(intersect(iiA,intersect(iiC,iiD)),iiB); %17 DEC S, ALL M
iiBCD=setdiff(intersect(iiB,intersect(iiC,iiD)),iiA); % 6 REP S, ALL M

iiBC=setdiff(intersect(iiB,iiC),unique(cat(2,iiBCD,iiABC,iiABCD))); % 0 REP S, DEC M
iiAC=setdiff(intersect(iiA,iiC),unique(cat(2,iiACD,iiABD,iiABCD))); % 18 DEC S, DEC M
iiAD=setdiff(intersect(iiA,iiD),unique(cat(2,iiACD,iiABD,iiABCD))); % 1 DEC S, REP M
iiBD=setdiff(intersect(iiB,iiD),unique(cat(2,iiBCD,iiABD,iiABCD))); % 15 REP S, REP M
iiCD=setdiff(intersect(iiC,iiD),unique(cat(2,iiBCD,iiACD,iiABCD))); % 51 DEC M, REP M
iiAB=setdiff(intersect(iiA,iiB),unique(cat(2,iiABC,iiABD,iiABCD))); % 7 DEC S, REP S

iiA=setdiff(iiA,unique(cat(2,iiAB,iiAC,iiABC,iiABCD,iiACD,iiAD,iiABD))); % 3 JUST DEC S
iiB=setdiff(iiB,unique(cat(2,iiAB,iiBC,iiABC,iiBCD,iiABCD,iiBD,iiABD))); % 3 JUST REP S
iiC=setdiff(iiC,unique(cat(2,iiCD,iiBC,iiBCD,iiABC,iiABCD,iiAC,iiACD))); % 17 JUST DEC M
iiD=setdiff(iiD,unique(cat(2,iiCD,iiBCD,iiBD,iiABCD,iiABD,iiACD,iiAD))); % 52 JUST REP M







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
        %  dataT=mean(data2(:,iTRange),2)-1;
        % tbl=table(data(:,iTRange),FS1(:,1),FS1(:,2),FS1(:,3),'VariableNames',{'HG','Lex','Phono','Task'});
        %   lme=fitlme(tbl,'HG~1+Lex+Phono+Task+Lex:Phono+Lex:Task+Phono:Task+Lex:Phono:Task+(1|Item)');
        
        
        mdl=fitlm(FS1,dataT,'y~1+x1+x2+x3+x1:x2+x1:x3+x2:x3+x1:x2:x3','PredictorVars',{'x1','x2','x3'},'CategoricalVar',{'x1','x2','x3'});
        %   mdlM=fitlm(FS1,dataT,'y~1+x1+x2+x3');
        %  mdlM2=fitlm(FS1,dataT,'y~1+x2');
        
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
betaM=zeros(size(Spec_Chan_All,2),40,4);
%betaBM=zeros(size(Spec_Chan_All,2),40,7);
%pvalBM=zeros(size(Spec_Chan_All,2),40,7);
pvalB=zeros(size(Spec_Chan_All,2),40,8);
pvalM=zeros(size(Spec_Chan_All,2),40,4);
pvalFP=zeros(size(Spec_Chan_All,2),40);
fvalB=zeros(size(Spec_Chan_All,2),40);
rval=zeros(size(Spec_Chan_All,2),40);
rvalA=zeros(size(Spec_Chan_All,2),40);
rvalM=zeros(size(Spec_Chan_All,2),40);
rvalAM=zeros(size(Spec_Chan_All,2),40);
%FvalsA=zeros(size(Spec_Chan_All,2),40,7);

%rvalMA=zeros(size(Spec_Chan_All,2),40);
for iChan=1:size(Spec_Chan_All,2)
    for iTime=1:40
        tmp=ModelB{iChan}{iTime}.Coefficients.Estimate;
        tmp2=ModelB{iChan}{iTime}.Coefficients.pValue;
        betaB(iChan,iTime,:)=tmp(1:end);
        pvalB(iChan,iTime,:)=tmp2(1:end);
        %  tmp=ModelM{iChan}{iTime}.Coefficients.Estimate;
        %   tmp2=ModelM{iChan}{iTime}.Coefficients.pValue;
        %   betaM(iChan,iTime,:)=tmp(1:end);
        %   pvalM(iChan,iTime,:)=tmp2(1:end);
        
        
        
        %   betaBM(iChan,iTime,:)=ModelBM{iChan}{iTime}.Betas;
        %    tmp=ModelBM{iChan}{iTime}.Coefficients.Estimate;
        %    tmp2=ModelBM{iChan}{iTime}.Coefficients.pValue;
        %    betaBM(iChan,iTime,:)=tmp(2:end);
        %    pvalBM(iChan,iTime,:)=tmp2(2:end);
        [p,f]=coefTest(ModelB{iChan}{iTime});
        fvalB(iChan,iTime)=f;
        pvalFP(iChan,iTime)=p;
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

iiS2=intersect(GoodChanIdxF,iiS);



GoodChanIdx=1:size(Spec_Chan_All,2);
%k = 0:1e-5:5e-3;
designMat=[1 1 0 0;1 0 1 0];


for iChan=1:length(GoodChanIdx);
    F1D=[];
    F2D=[];
    F1R=[];
    F2R=[];
    dataD=[];
    dataR=[];
    for iCond=1:4
        F1D=cat(1,F1D,designMat(1,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
        F2D=cat(1,F2D,designMat(2,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond},1),1));
        F1R=cat(1,F1R,designMat(1,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond+4},1),1));
        F2R=cat(1,F2R,designMat(2,iCond)*ones(size(Spec_Chan_All{GoodChanIdx(iChan)}{iCond+4},1),1));
        
        dataD=cat(1,dataD,Spec_Chan_All{GoodChanIdx(iChan)}{iCond});
        dataR=cat(1,dataR,Spec_Chan_All{GoodChanIdx(iChan)}{iCond+4});
    end
    
    FS1D=cat(2,F1D,F2D);
    FS1R=cat(2,F1R,F2R);
    
    tRange=1:40;
    
    for iTRange=1:length(tRange)
        
        dataTD=mean(dataD(:,iTRange),2)-1;
        dataTR=mean(dataR(:,iTRange),2)-1;
        %   mdlD=fitlm(FS1D,dataTD,'y~1+x1+x2');
        %   mdlR=fitlm(FS1R,dataTR,'y~1+x1+x2');
        [PD TD STATSD TERMSD]=anovan(dataTD,FS1D,'model','full','display','off');
        [PR TR STATSR TERMSR]=anovan(dataTR,FS1R,'model','full','display','off');
        
        %  ModelD{iChan}{iTRange}=mdlD;
        %  ModelR{iChan}{iTRange}=mdlR;
        AnovaD{iChan}{iTRange}=TD;
        AnovaR{iChan}{iTRange}=TR;
        AnovaDS{iChan}{iTRange}=STATSD;
        AnovaRS{iChan}{iTRange}=STATSR;
        
    end
    display(iChan)
end


betaD=zeros(size(Spec_Chan_All,2),40,3);
betaR=zeros(size(Spec_Chan_All,2),40,3);
pvalD=zeros(size(Spec_Chan_All,2),40,3);
pvalR=zeros(size(Spec_Chan_All,2),40,3);
rvalD=zeros(size(Spec_Chan_All,2),40);
rvalDA=zeros(size(Spec_Chan_All,2),40);
rvalR=zeros(size(Spec_Chan_All,2),40);
rvalRA=zeros(size(Spec_Chan_All,2),40);
fvalsD=zeros(size(Spec_Chan_All,2),40,3);
fvalsR=zeros(size(Spec_Chan_All,2),40,3);
fvalsPD=zeros(size(Spec_Chan_All,2),40,3);
fvalsPR=zeros(size(Spec_Chan_All,2),40,3);
fvalsDC=zeros(size(Spec_Chan_All,2),40,9);
fvalsRC=zeros(size(Spec_Chan_All,2),40,9);

for iChan=1:size(Spec_Chan_All,2)
    for iTime=1:40
        %         tmp=ModelD{iChan}{iTime}.Coefficients.Estimate;
        %         tmp2=ModelD{iChan}{iTime}.Coefficients.pValue;
        %         betaD(iChan,iTime,:)=tmp(1:end);
        %         pvalD(iChan,iTime,:)=tmp2(1:end);
        %        tmp=ModelR{iChan}{iTime}.Coefficients.Estimate;
        %        tmp2=ModelR{iChan}{iTime}.Coefficients.pValue;
        %        betaR(iChan,iTime,:)=tmp(1:end);
        %        pvalR(iChan,iTime,:)=tmp2(1:end);
        %         rvalD(iChan,iTime)=ModelD{iChan}{iTime}.Rsquared.Ordinary;
        %         rvalDA(iChan,iTime)=ModelD{iChan}{iTime}.Rsquared.Adjusted;
        %         rvalR(iChan,iTime)=ModelR{iChan}{iTime}.Rsquared.Ordinary;
        %         rvalRA(iChan,iTime)=ModelR{iChan}{iTime}.Rsquared.Adjusted;
        tmp=AnovaD{iChan}{iTime};
        fvalsD(iChan,iTime,:)=cell2num(tmp(2:4,6));
        fvalsPD(iChan,iTime,:)=cell2num(tmp(2:4,7));
        tmp=AnovaR{iChan}{iTime};
        fvalsR(iChan,iTime,:)=cell2num(tmp(2:4,6));
        fvalsPR(iChan,iTime,:)=cell2num(tmp(2:4,7));
        fvalsDC(iChan,iTime,:)=AnovaDS{iChan}{iTime}.coeffs;
        fvalsRC(iChan,iTime,:)=AnovaRS{iChan}{iTime}.coeffs;
    end
end

fvalsPD2=zeros(size(fvalsPD,1),size(fvalsPD,2),size(fvalsPD,3));
ii=find(fvalsPD<0.05);
fvalsPD2(ii)=1;
fvalsPR2=zeros(size(fvalsPR,1),size(fvalsPR,2),size(fvalsPR,3));
ii=find(fvalsPR<0.05);
fvalsPR2(ii)=1;
for iChan=1:size(fvalsPD2,1);
    for iCond=1:3;
        tmp=bwconncomp(sq(fvalsPD2(iChan,:,iCond)));
        if size(tmp.PixelIdxList,2)>0
            for ii=1:size(tmp.PixelIdxList,2);
                ii2(ii)=size(tmp.PixelIdxList{ii},1);
            end
            ChanClusterSizePD(iChan,iCond)=max(ii2);
        else
            ChanClusterSizePD(iChan,iCond)=0;
        end
        clear ii2
    end
end

for iChan=1:size(fvalsPR2,1);
    for iCond=1:3;
        tmp=bwconncomp(sq(fvalsPR2(iChan,:,iCond)));
        if size(tmp.PixelIdxList,2)>0
            for ii=1:size(tmp.PixelIdxList,2);
                ii2(ii)=size(tmp.PixelIdxList{ii},1);
            end
            ChanClusterSizePR(iChan,iCond)=max(ii2);
        else
            ChanClusterSizePR(iChan,iCond)=0;
        end
        clear ii2
    end
end

iiPDL=find(sq(ChanClusterSizePD(:,1))>=ClusterSize);
iiPDP=find(sq(ChanClusterSizePD(:,2))>=ClusterSize);
iiPDLP=find(sq(ChanClusterSizePD(:,3))>=ClusterSize);

iiPRL=find(sq(ChanClusterSizePR(:,1))>=ClusterSize);
iiPRP=find(sq(ChanClusterSizePR(:,2))>=ClusterSize);
iiPRLP=find(sq(ChanClusterSizePR(:,3))>=ClusterSize);