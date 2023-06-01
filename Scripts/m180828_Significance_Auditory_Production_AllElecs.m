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

    
    CondParams.Conds=[1:8];
    CondParams.Field = 'Go';
    CondParams.bn = [-500,1500];
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
    fRange=70:120;
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
          %  tmp=tmp./mean(mean(tmp(:,1:10))); % each cond baseline   
         %   tmp=tmp./mean(tmp(:,1:10),2); % each trial baseline
     
            Spec_Chan_All_Aud{iChan2}{iCond}=sq(mean(Auditory_Spec{iCond}{iChan}(tmpIDX1,:,fRange),3));
            Spec_Subject_Aud(iChan2)=SN;
            
            Spec_Chan_All_Prod{iChan2}{iCond}=sq(mean(Motor_Spec{iCond}{iChan}(tmpIDX2,:,fRange),3));
            Spec_Subject_Prod(iChan2)=SN;
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

for iChan=1:size(Spec_Chan_All_Aud,2);
    tmpAD=[];
    tmpAR=[];
    for iCond=1:4
        tmpAD=cat(1,tmpAD,Spec_Chan_All_Aud{iChan}{iCond});
        tmpAR=cat(1,tmpAR,Spec_Chan_All_Aud{iChan}{iCond+4});
    end
    for iCond=1:4;
        dataAD(iChan,iCond,:)=mean(Spec_Chan_All_Aud{iChan}{iCond})./mean(mean(tmpAD(:,1:10)));
        dataPD(iChan,iCond,:)=mean(Spec_Chan_All_Prod{iChan}{iCond})./mean(mean(tmpAD(:,1:10)));
        dataAR(iChan,iCond,:)=mean(Spec_Chan_All_Aud{iChan}{iCond+4})./mean(mean(tmpAR(:,1:10)));
        dataPR(iChan,iCond,:)=mean(Spec_Chan_All_Prod{iChan}{iCond+4})./mean(mean(tmpAR(:,1:10)));
    end
end
% nPerm=1000;
% for iChan=1:size(Spec_Chan_All,2);
%     tmp=[];
%     for iCond=1:8;
%         tmp=cat(1,tmp,Spec_Chan_All{iChan}{iCond});
%     end
%     for iTime=1:40;
%     actdiff=mean(tmp(:,iTime))-mean(mean(tmp(:,1:10)));
%     combval=cat(1,mean(tmp(:,iTime),2),mean(tmp(:,1:10),2));
%     for iPerm=1:nPerm;
%         sIdx=shuffle(1:size(combval,1));
%         permval(iPerm)=mean(combval(sIdx(1:size(tmp,1))))-mean(combval(sIdx(size(tmp,1)+1:length(sIdx))));
%     end
%     pvalsS(iChan,iTime)=length(find(permval>actdiff))./nPerm;
%     end
%     display(iChan)
% end


% against baseline
timeA=16:30;
timeP=26:40;
nPerm=10000;
for iChan=1:size(Spec_Chan_All_Aud,2);
    tmpA=[];
    tmpP=[];
    for iCond=5:8;
        tmpA=cat(1,tmpA,Spec_Chan_All_Aud{iChan}{iCond});
        tmpP=cat(1,tmpP,Spec_Chan_All_Prod{iChan}{iCond});
    end
  
    actdiffA=mean(mean(tmpA(:,timeA)))-mean(mean(tmpA(:,1:10)));
    combvalA=cat(1,mean(tmpA(:,timeA),2),mean(tmpA(:,1:10),2));
    actdiffP=mean(mean(tmpP(:,timeP)))-mean(mean(tmpA(:,1:10)));
    combvalP=cat(1,mean(tmpP(:,timeP),2),mean(tmpA(:,1:10),2));
    for iPerm=1:nPerm;
        sIdxA=shuffle(1:size(combvalA,1));
        sIdxP=shuffle(1:size(combvalP,1));
        permvalA(iPerm)=mean(combvalA(sIdxA(1:size(tmpA,1))))-mean(combvalA(sIdxA(size(tmpA,1)+1:length(sIdxA))));
        permvalP(iPerm)=mean(combvalP(sIdxP(1:size(tmpP,1))))-mean(combvalP(sIdxP(size(tmpP,1)+1:length(sIdxP))));

    end
    pvalsA(iChan)=length(find(permvalA>actdiffA))./nPerm;
    pvalsP(iChan)=length(find(permvalP>actdiffP))./nPerm;
 
    display(iChan)
end





% dec vs rep
timeA=16:30;
timeP=26:40;
nPerm=10000;
for iChan=1:size(Spec_Chan_All_Aud,2);
    tmpAD=[];
    tmpPD=[];
    tmpAR=[];
    tmpPR=[];
    for iCond=1:4
        tmpAD=cat(1,tmpAD,Spec_Chan_All_Aud{iChan}{iCond});
        tmpPD=cat(1,tmpPD,Spec_Chan_All_Prod{iChan}{iCond});
        tmpAR=cat(1,tmpAR,Spec_Chan_All_Aud{iChan}{iCond+4});
        tmpPR=cat(1,tmpPR,Spec_Chan_All_Prod{iChan}{iCond+4});       
    end
  
    tmpAD=tmpAD./mean(mean(tmpAD(:,1:10)));
    tmpPD=tmpPD./mean(mean(tmpAD(:,1:10)));
    tmpAR=tmpAR./mean(mean(tmpAR(:,1:10)));
    tmpPR=tmpPR./mean(mean(tmpAR(:,1:10)));

    
    actdiffA=mean(mean(tmpAD(:,timeA)))-mean(mean(tmpAR(:,timeA)));
    combvalA=cat(1,mean(tmpAD(:,timeA),2),mean(tmpAR(:,timeA),2));
    actdiffP=mean(mean(tmpPD(:,timeP)))-mean(mean(tmpPR(:,timeP)));
    combvalP=cat(1,mean(tmpPD(:,timeP),2),mean(tmpPR(:,timeP),2));
    for iPerm=1:nPerm;
        sIdxA=shuffle(1:size(combvalA,1));
        sIdxP=shuffle(1:size(combvalP,1));
        permvalA(iPerm)=mean(combvalA(sIdxA(1:size(tmpAD,1))))-mean(combvalA(sIdxA(size(tmpAD,1)+1:length(sIdxA))));
        permvalP(iPerm)=mean(combvalP(sIdxP(1:size(tmpPD,1))))-mean(combvalP(sIdxP(size(tmpPD,1)+1:length(sIdxP))));

    end
    pvalsA(iChan)=length(find(permvalA>actdiffA))./nPerm;
    pvalsP(iChan)=length(find(permvalP>actdiffP))./nPerm;
 
    display(iChan)
end



% lex within decision
timeA=16:30;
timeP=26:40;
nPerm=10000;
for iChan=1:size(Spec_Chan_All_Aud,2);
    tmpAWD=[];
    tmpPWD=[];
    tmpANWD=[];
    tmpPNWD=[];
    for iCond=1:2
        tmpAWD=cat(1,tmpAWD,Spec_Chan_All_Aud{iChan}{iCond});
        tmpPWD=cat(1,tmpPWD,Spec_Chan_All_Prod{iChan}{iCond});
        tmpANWD=cat(1,tmpANWD,Spec_Chan_All_Aud{iChan}{iCond+2});
        tmpPNWD=cat(1,tmpPNWD,Spec_Chan_All_Prod{iChan}{iCond+2});       
    end
  
%     tmpAWD=tmpAWD./mean(mean(tmpAWD(:,1:10)));
%     tmpPWD=tmpPWD./mean(mean(tmpAWD(:,1:10)));
%     tmpANWD=tmpANWD./mean(mean(tmpANWD(:,1:10)));
%     tmpPNWD=tmpPNWD./mean(mean(tmpANWD(:,1:10)));

    
    actdiffA=mean(mean(tmpAWD(:,timeA)))-mean(mean(tmpANWD(:,timeA)));
    combvalA=cat(1,mean(tmpAWD(:,timeA),2),mean(tmpANWD(:,timeA),2));
    actdiffP=mean(mean(tmpPWD(:,timeP)))-mean(mean(tmpPNWD(:,timeP)));
    combvalP=cat(1,mean(tmpPWD(:,timeP),2),mean(tmpPNWD(:,timeP),2));
    for iPerm=1:nPerm;
        sIdxA=shuffle(1:size(combvalA,1));
        sIdxP=shuffle(1:size(combvalP,1));
        permvalA(iPerm)=mean(combvalA(sIdxA(1:size(tmpAWD,1))))-mean(combvalA(sIdxA(size(tmpAWD,1)+1:length(sIdxA))));
        permvalP(iPerm)=mean(combvalP(sIdxP(1:size(tmpPWD,1))))-mean(combvalP(sIdxP(size(tmpPWD,1)+1:length(sIdxP))));

    end
    pvalsA(iChan)=length(find(permvalA>actdiffA))./nPerm;
    pvalsP(iChan)=length(find(permvalP>actdiffP))./nPerm;
 
    display(iChan)
end