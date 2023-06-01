duke;

Subject=[];


filedir=['H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data'];
Subject(23).Name='D23'; Subject(23).Prefix = '/Sternberg/D23_Sternberg_trialInfo'; Subject(23).Day = '180718';
Subject(24).Name='D24'; Subject(24).Prefix = '/Sternberg/D24_Sternberg_trialInfo'; Subject(24).Day = '181028';
Subject(26).Name='D26'; Subject(26).Prefix = '/Sternberg/D26_Sternberg_trialInfo'; Subject(26).Day = '190128';
Subject(27).Name='D27'; Subject(27).Prefix = '/Neighborhood Sternberg/D27_Sternberg_trialInfo'; Subject(27).Day = '190304';
Subject(28).Name='D28'; Subject(28).Prefix = '/Neighborhood Sternberg/D28_Sternberg_trialInfo';  Subject(28).Day = '190302';
Subject(29).Name='D29'; Subject(29).Prefix = '/NeighborhoodSternberg/D29_Sternberg_trialInfo';  Subject(29).Day = '190315';
Subject(30).Name='D30'; Subject(30).Prefix = '/NeighborhoodSternberg/D30_Sternberg_trialInfo'; Subject(30).Day = '190413';
Subject(31).Name='D31'; Subject(31).Prefix = '/NeighborhoodSternberg/D31_Sternberg_trialInfo'; Subject(31).Day = '190423';
Subject(33).Name='D33'; Subject(33).Prefix = '/NeighborhoodSternberg/D33_Sternberg_trialInfo'; Subject(33).Day = '190603';
Subject(34).Name='D34'; Subject(34).Prefix = '/NeighborhoodSternberg/D34_Sternberg_trialInfo'; Subject(34).Day = '190730';
Subject(35).Name='D35'; Subject(35).Prefix = '/NeighborhoodSternberg/D35_Sternberg_trialInfo'; Subject(35).Day = '190801';
Subject(36).Name='D36'; Subject(36).Prefix = '/NeighborhoodSternberg/D36_Sternberg_trialInfo'; Subject(36).Day = '190808';
Subject(37).Name='D37'; Subject(37).Prefix = '/NeighborhoodSternberg/D37_Sternberg_trialInfo'; Subject(37).Day = '190913';
Subject(38).Name='D38'; Subject(38).Prefix = '/NeighborhoodSternberg/D38_Sternberg_trialInfo'; Subject(38).Day = '190921';

SNList=[29,30,31,33,34,35,36,37,38];


DUKEDIR = ['H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg'];
for iSN=1:length(SNList);
    SN=SNList(iSN);
    
%      load([filedir '\' Subject(SN).Name  '\'  Subject(SN).Prefix '.mat'])
%         trialLengthIdx = lengthIdx(trialInfo);
%     condIdx = catIdx(trialInfo);
%     trialCorrectIdx = correctIdx(trialInfo);
%     probeValIdx = probeIdx(trialInfo);
%     trialRTIdx = rtIdx(trialInfo);
%     
%     behaviorMat(1,:)=iSN*ones(1,160);
%     behaviorMat(2,:)=trialLengthIdx;
%     behaviorMat(3,:)=condIdx;
%     behaviorMat(4,:)=probeValIdx;
%     
%     wordIdx=find(condIdx==1 | condIdx==3);
%     highIdx=find(condIdx==1 | condIdx==2);
%     behaviorMat(5,wordIdx)=1;
%     behaviorMat(6,highIdx)=1;
%     behaviorMat(7,:)=trialCorrectIdx;
%     behaviorMat(8,:)=trialRTIdx;
%     behaviorMat(9,:)=(trialRTIdx-nanmean(trialRTIdx))./nanstd(trialRTIdx);
%     
%     probePositionVals=zeros(160,1);
%     idxP=find(probeValIdx==1);
%     for iP=1:length(idxP);
%         pString=trialInfo{idxP(iP)}.probeSound_name;
%         for iS=1:length(trialInfo{idxP(iP)}.stimulusSounds_name)
%             if strcmp(pString,trialInfo{idxP(iP)}.stimulusSounds_name(iS))
%                 probePositionVals(idxP(iP))=iS;
%             end
%         end
%     end
%             
%     behaviorMat(10,:)=probePositionVals;
%     
% 
% 
% relPos=zeros(size(behaviorMat,2),size(behaviorMat,3));
% lengthList=[3,5,7,9];
% 
%     for iTrials=1:160;
%         tmp=sq(behaviorMat(:,iTrials));
%         if tmp(4)==1 && tmp(10)==1
%             relPos(iTrials)=1;
%         elseif tmp(4)==1 && tmp(10)==2
%             relPos(iTrials)=2;
%         elseif tmp(2)>3 && tmp(4)==1 && tmp(10)==3
%             relPos(iTrials)=2;
%         elseif tmp(2)==3 && tmp(4)==1 && tmp(10)==3
%             relPos(iTrials)=3;
%         elseif tmp(4)==1 && tmp(10)==4
%             relPos(iTrials)=2;
%         elseif tmp(2)>5 && tmp(4)==1 && tmp(10)==5
%             relPos(iTrials)=2;
%         elseif tmp(2)==5 && tmp(4)==1 && tmp(10)==5
%             relPos(iTrials)=3;
%         elseif tmp(4)==1 && tmp(10)==6
%             relPos(iTrials)=2;
%         elseif tmp(2)>7 && tmp(4)==1 && tmp(10)==7
%             relPos(iTrials)=2;
%         elseif tmp(2)==7 && tmp(4)==1 && tmp(10)==7
%             relPos(iTrials)=3;
%         elseif tmp(4)==1 && tmp(10)==8
%             relPos(iTrials)=2;
%         elseif tmp(4)==1 && tmp(10)==9
%             relPos(iTrials)=3;
%         end
%     end
% 
% 
% behaviorMat(11,:)=relPos;



    
    
Subject(SN).Experiment = loadExperiment(Subject(SN).Name);
%Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');
load([DUKEDIR '\' Subject(SN).Name '\' Subject(SN).Day '\mat\Trials.mat']);

   for iTrials=1:length(Trials);
    %   Trials(iTrials).StartCode=Trials(iTrials).FirstStimAuditoryCode;
       Trials(iTrials).StartCode=1;
       Trials(iTrials).AuditoryCode=Trials(iTrials).StartCode+25;
       Trials(iTrials).GoCode=Trials(iTrials).StartCode+50;
       Trials(iTrials).Auditory=Trials(iTrials).FirstStimAuditory;
       Trials(iTrials).Start=Trials(iTrials).ListenCueOnset;
       Trials(iTrials).Go=Trials(iTrials).ProbeAuditory;
   end
    

Subject(SN).Trials=Trials;
%Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_CovertOvert'); % Test line
%Subject(SN).Trials = recodeStartCodeTrials(Subject(SN).Trials);
%Trials = Subject(SN).Trials;
experiment = Subject(SN).Experiment;

CondParams.Conds=1:1



%CondParams.bn = [-2500,3500];
%AnalParams.Tapers = [0.5,10];


if strcmp(Subject(SN).Name,'D1')
    AnalParams.Channel = [1:66];
elseif  strcmp(Subject(SN).Name,'D3')
    AnalParams.Channel = [1:52];
    badChans=[12];
    AnalParams.Channel=setdiff(AnalParams.Channel,badChans);
elseif  strcmp(Subject(SN).Name,'D5')
    AnalParams.Channel = [1:44];
elseif  strcmp(Subject(SN).Name,'D7')
    AnalParams.Channel = [1:102];
    %   AnalParams.Channel = [17:80]; % just grid
elseif strcmp(Subject(SN).Name,'D8')
    AnalParams.Channel = [1:110];
elseif strcmp(Subject(SN).Name,'D9')
    AnalParams.Channel = [1:120];
elseif strcmp(Subject(SN).Name,'D11')
    AnalParams.Channel = [1:118];
elseif strcmp(Subject(SN).Name,'D12')
    AnalParams.Channel = [1:110];
elseif strcmp(Subject(SN).Name,'D13')
    AnalParams.Channel = [1:120];
    %   AnalParams.ReferenceChannels=[18:20];
elseif strcmp(Subject(SN).Name,'D14')
    AnalParams.Channel = [1:120];
elseif strcmp(Subject(SN).Name,'D15')
    AnalParams.Channel = [1:120];
    %  AnalParams.ReferenceChannels=[62:63,105:106];
elseif strcmp(Subject(SN).Name,'D16')
    AnalParams.Channel = [1:41];
elseif strcmp(Subject(SN).Name,'S1');
    % AnalParams.Channel=[1:256];
    AnalParams.Channel=setdiff(1:256,[2,32,64,66,96,128,130,160,192,194,224,256]);
elseif strcmp(Subject(SN).Name,'D17');
    AnalParams.Channel=[1:114];
elseif strcmp(Subject(SN).Name,'D18');
    AnalParams.Channel=[1:122];
elseif strcmp(Subject(SN).Name,'D19');
    AnalParams.Channel=[1:76];
elseif strcmp(Subject(SN).Name,'S6');
    AnalParams.Channel=setdiff(1:256,[12,32,53,66,96,128,130,160,192,204,224,245]);
elseif strcmp(Subject(SN).Name,'D20');
    AnalParams.Channel=[1:120];
elseif strcmp(Subject(SN).Name,'D22');
    AnalParams.Channel=[1:100];
elseif strcmp(Subject(SN).Name,'D23');
    AnalParams.Channel=[1:121];
elseif strcmp(Subject(SN).Name,'D24');
    AnalParams.Channel=[1:52];
elseif strcmp(Subject(SN).Name,'D26');
    AnalParams.Channel=[1:60];
elseif strcmp(Subject(SN).Name,'D27');
    AnalParams.Channel=[1:114];
    badChans=[1,2,21,22];
    AnalParams.Channel=setdiff(AnalParams.Channel,badChans);
  %  AnalParams.ReferenceChannels=[72,99,100];
elseif strcmp(Subject(SN).Name,'D28');
    AnalParams.Channel=[1:108];
    AnalParams.badChannels=[20,43,77,78];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);    
elseif strcmp(Subject(SN).Name,'D29');
    AnalParams.Channel=[1:140];
    AnalParams.badChannels=[8,56,133,136,137,140];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);
elseif strcmp(Subject(SN).Name,'D30')
    AnalParams.Channel=[1:104];
    AnalParams.badChannels=[12,13,19,36,37,80,82]; 
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);    
elseif strcmp(Subject(SN).Name,'D31')
    AnalParams.Channel=[1:160];
    AnalParams.badChannels=[9,17,67,68,40,117,148,149]; 
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);       
elseif strcmp(Subject(SN).Name,'D33')
    AnalParams.Channel=[1:240];
  %  AnalParams.badChannels=[39,100,101,102,104,175,184,188];
    AnalParams.badChannels=[37,38,39,40,100,101,102,104,105,175,183,184,185,188,222];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);       
elseif strcmp(Subject(SN).Name,'D34')
    AnalParams.Channel=[1:182];
    AnalParams.badChannels=[40,41,45,100,174];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);       
elseif strcmp(Subject(SN).Name,'D35')
    AnalParams.Channel=[1:174];
    AnalParams.badChannels= [8,26,37,38,39,40,54,79,80,81,82,143,155];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);           
elseif strcmp(Subject(SN).Name,'D36')
    AnalParams.Channel=[1:216];
    AnalParams.badChannels=[8,32,101,170];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);        
elseif strcmp(Subject(SN).Name,'D37')
    AnalParams.Channel=[1:180];
   % AnalParams.badChannels=[89,92,157,158];
    AnalParams.badChannels=[61,76,87,88,89,90,92,93,157,158,179,180];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);  
    elseif strcmp(Subject(SN).Name,'D38')
    AnalParams.Channel=[1:208];
    AnalParams.badChannels=[5,8,48,61,158,179,197];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels); 
else
    AnalParams.Channel = [1:64];
end


NumTrials = SelectChannels(Subject(SN).Trials, CondParams, AnalParams);
%NumTrials=repmat(270,1,66);
%SelectedChannels = AnalParams.Channel(find(NumTrials > (0.8*length(Trials)))); %STRICT?
% SelectedChannels = AnalParams.Channel(find(NumTrials > (0.65*length(Trials)))); %LESS STRICT?
SelectedChannels=AnalParams.Channel; % really loose: accounts for practice trial confound
AnalParams.ReferenceChannels = SelectedChannels;
AnalParams.Channel = SelectedChannels;
AnalParams.TrialPooling = 1; %1;  %1; % used to be 1
AnalParams.dn=0.05;

AnalParams.Tapers = [0.5 10];
%AnalParams.Tapers = [.25 16];
AnalParams.fk = 200;
%AnalParams.RefChans=subjRefChans(Subject(SN).Name);
AnalParams.Reference = 'Grand average'; % 'IndRef'; %'Grand average', 'Grand average induced'% induced' 'Single-ended','IndRef';%AnalParams.RefChans=subjRefChansInd(Subject(SN).Name);
AnalParams.ArtifactThreshold = 12; %8 %12;
%NumTrials=repmat(270,1,66);
%SelectedChannels = AnalParams.Channel(find(NumTrials > (0.8*length(Trials)))); %STRICT?
% SelectedChannels = AnalParams.Channel(find(NumTrials > (0.65*length(Trials)))); %LESS STRICT?
SelectedChannels=AnalParams.Channel; % really loose: accounts for practice trial confound
%AnalParams.ReferenceChannels = SelectedChannels;
AnalParams.Channel = SelectedChannels;
AnalParams.TrialPooling = 0; %1;  %1; % used to be 1
srate=experiment.recording.sample_rate;
srate2=srate/4;
if srate<2048
    AnalParams.pad=2;
else
   AnalParams.pad=1;
end


for iTrials=1:length(Trials);
    Trials(iTrials).MaintenanceOnsetCode=1;
end
% 
Subject(SN).ieeg=trialIEEG(Trials,AnalParams.Channel,'Auditory',[-500 1000]);
end

fscale=[0:2048/3072:2047.99999];
for iSN=1:length(SNList)
    SN=SNList(iSN);
    tmpFFT=zeros(size(Subject(SN).ieeg,2),size(Subject(SN).ieeg,1),size(Subject(SN).ieeg,3));
    for iChan=1:size(Subject(SN).ieeg,2)
        tmpFFT(iChan,:,:)=(abs(fft(sq(Subject(SN).ieeg(:,iChan,:)),[],2))).^2;
    end
    Subject(SN).ieegFFT=sq(mean(tmpFFT,2));
end

fTop=200;
figure;
for iSN=1:length(SNList);
    SN=SNList(iSN);
    subplot(1,9,iSN)
    semilogy(fscale(1:fTop),Subject(SN).ieegFFT(:,1:fTop))
    title(Subject(SN).Name);
    ylim([10e2 10e10])
    xlim([0 fTop])
end

ii60=find(fscale==60);

for iSN=1:length(SNList);
    SN=SNList(iSN);
    power60(iSN)=mean(Subject(SN).ieegFFT(:,ii60));
end
figure;plot(power60);

ii50=find(fscale==50);

for iSN=1:length(SNList);
    SN=SNList(iSN);
    power50(iSN)=mean(Subject(SN).ieegFFT(:,ii50));
end
figure;
plot(power50);
    
