duke;
global experiment

Subject(3).Name = 'D3'; Subject(3).Day = '160910';
Subject(5).Name = 'D5'; Subject(5).Day = '161028';
Subject(7).Name = 'D7'; Subject(7).Day = '170130';
Subject(8).Name = 'D8'; Subject(8).Day = '030317';
Subject(9).Name = 'D9'; Subject(9).Day = '170526';
Subject(11).Name = 'D11'; Subject(11).Day = '170809';
Subject(12).Name= 'D12'; Subject(12).Day = '170911';
Subject(13).Name = 'D13'; Subject(13).Day = '171009';
Subject(14).Name = 'D14'; Subject(14).Day = '171112';
Subject(15).Name = 'D15'; Subject(15).Day = '171216'; % 180309 = lexical between, 180310 = lexical long no delay
Subject(16).Name = 'D16'; Subject(16).Day = '180123';
Subject(17).Name = 'D17'; Subject(17).Day = '180310';
Subject(18).Name = 'D18'; Subject(18).Day = '180327';
Subject(20).Name = 'D20'; Subject(20).Day = '180519';
Subject(22).Name = 'D22'; Subject(22).Day = '180705';
Subject(23).Name = 'D23'; Subject(23).Day = '180715';
Subject(24).Name = 'D24'; Subject(24).Day = '181027';
Subject(26).Name = 'D26'; Subject(26).Day = '190129';
Subject(27).Name = 'D27'; Subject(27).Day = '190303';
Subject(28).Name = 'D28'; Subject(28).Day = '190302';
Subject(29).Name = 'D29'; Subject(29).Day = '190315';
%Subject(30).Name = 'D30'; Subject(30).Day = '181027';
%Subject(31).Name = 'D31'; Subject(31).Day = '181027';

%SNList=[3,5,7,8,9,12,13,14,15,16,17,18,20,22,23,24,26,27,28,29]; 
SNList=[3,5,7,9,12,13,14,15,16,17,18,20,22,23,24,26,27,28,29]; 

nPerm=1000;
numTails=2;
zThresh=1.6449;
%zThresh=1.96;

%fRange=70:100;
fRange=35:75;

for iSN=1:length(SNList)

SN = SNList(iSN);
Subject(SN).Experiment = loadExperiment(Subject(SN).Name);
Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');
%Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_CovertOvert'); % Test line
Trials = Subject(SN).Trials;
experiment = Subject(SN).Experiment;

CondParams.Conds = [1:18];



%CondParams.bn = [-2500,3500];
%AnalParams.Tapers = [0.5,10];
AnalParams.Channel = createChannels(Subject(SN).Name);



    CondParams.Conds=[1:18];
    NumTrials = SelectChannels(Subject(SN).Trials, CondParams, AnalParams);
%NumTrials=repmat(270,1,66);
%SelectedChannels = AnalParams.Channel(find(NumTrials > (0.8*length(Trials)))); %STRICT?
% SelectedChannels = AnalParams.Channel(find(NumTrials > (0.65*length(Trials)))); %LESS STRICT?
SelectedChannels=AnalParams.Channel; % really loose: accounts for practice trial confound
AnalParams.ReferenceChannels = SelectedChannels;
AnalParams.Channel = SelectedChannels;
AnalParams.TrialPooling = 1; %1;  %1; % used to be 1
AnalParams.dn=0.05;

AnalParams.Tapers = [.5,10];
%AnalParams.Tapers = [1,5];
%AnalParams.Tapers = [.25 16];
AnalParams.fk = 200;
if experiment.recording.sample_rate==2000 || experiment.recording.sample_rate==1000
AnalParams.pad=1;
elseif experiment.recording.sample_rate==2048
    AnalParams.pad=0.5;
end
%AnalParams.RefChans=subjRefChans(Subject(SN).Name);
AnalParams.Reference = 'Grand average';% 'IndRef'; %'Grand average', 'Grand average induced'% induced' 'Single-ended','IndRef';%AnalParams.RefChans=subjRefChansInd(Subject(SN).Name);
AnalParams.ArtifactThreshold = 12; %8 %12;
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
    
 %   load([DUKEDIR '/' Subject(SN).Name '/' Subject(SN).Day '/mat/Trials_HighLow.mat']);
 %   Subject(SN).Trials=Trials;
    
elecRef=findLocalReference(Subject(SN).Name,AnalParams.Channel);

 ieegAud=trialIEEG(Trials,AnalParams.Channel,'Auditory',[-750 1750]);
 ieegGo=trialIEEG(Trials,AnalParams.Channel,'Go',[-750 1750]);
 ieegStart=trialIEEG(Trials,AnalParams.Channel,'Start',[-750 750]);

 % CAR first
 ieegAud=ieegAud-mean(ieegAud,2);
 ieegGo=ieegGo-mean(ieegGo,2);
 ieegStart=ieegStart-mean(ieegStart,2);

 ieegAudLocal=zeros(size(ieegAud,1),size(ieegAud,2),size(ieegAud,3));
 ieegGoLocal=zeros(size(ieegGo,1),size(ieegGo,2),size(ieegGo,3));
 ieegStartLocal=zeros(size(ieegStart,1),size(ieegStart,2),size(ieegStart,3));

 for iChan=1:size(ieegAud,2)
     ieegAudLocal(:,iChan,:)=ieegAud(:,iChan,:)-mean(ieegAud(:,elecRef{iChan},:),2);
     ieegGoLocal(:,iChan,:)=ieegGo(:,iChan,:)-mean(ieegGo(:,elecRef{iChan},:),2);
     ieegStartLocal(:,iChan,:)=ieegStart(:,iChan,:)-mean(ieegStart(:,elecRef{iChan},:),2);
 end




outVal=8;
for iChan=1:size(ieegAudLocal,2)
    tmpA=sq(ieegAudLocal(:,iChan,:));
    [mA sA]=normfit(log(tmpA(:).^2));
    tmpG=sq(ieegGoLocal(:,iChan,:));
    [mG sG]=normfit(log(tmpG(:).^2));
    tmpS=sq(ieegStartLocal(:,iChan,:));
    [mS sS]=normfit(log(tmpS(:).^2));
    
    [iA jA]=find(log(tmpA.^2)>outVal*sA+mA);
    [iG jG]=find(log(tmpG.^2)>outVal*sG+mG);
    [iS jS]=find(log(tmpS.^2)>outVal*sS+mS);
inChan{iChan}=setdiff(1:size(ieegAudLocal,1),cat(1,unique(iA),unique(iG),unique(iS)));
outChan{iChan}=cat(1,unique(iA),unique(iG),unique(iS));

end
    
clear condVals
 for iTrials=1:length(Trials);
     condVals(iTrials)=Trials(iTrials).StartCode;
 end
 
 specAudAll=zeros(size(ieegAudLocal,2),size(ieegAudLocal,1),37,41);
 specGoAll=zeros(size(ieegGoLocal,2),size(ieegGoLocal,1),37,41);
 specStartAll=zeros(size(ieegStartLocal,2),size(ieegStartLocal,1),37,21);

 srate=experiment.processing.ieeg.sample_rate;
for iChan=1:size(ieegAudLocal,2)
    [waveAud,period,scale,coi]=basewave6(sq(ieegAudLocal(:,iChan,:)),srate,2,300,5,0.5,0.05);
specAudAll(iChan,:,:,:)=waveAud;
    [waveGo,period,scale,coi]=basewave6(sq(ieegGoLocal(:,iChan,:)),srate,2,300,5,0.5,0.05);
specGoAll(iChan,:,:,:)=waveGo;
    [waveStart,period,scale,coi]=basewave6(sq(ieegStartLocal(:,iChan,:)),srate,2,300,5,0.5,0.05);
specStartAll(iChan,:,:,:)=waveStart;
display(iChan);
end
   
save([DUKEDIR '/SentenceRep/Spec/' Subject(SN).Name '_LocalizerLSLMJL_Spec_Wavelet_CARLocalRef.mat'],'spec*','condVals','AnalParams','period','inChan','outChan','-v7.3');
clear inChan outChan
end