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

SNList=[3,5,7,8,9,12,13,14,15,16,17,18,20,22,23,24,26,27,28,29]; 
SNList=[3,5,7,8,9,12,13,14,15,16,17,18,20,22,23,24,26,27,28]; 

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
  %  AnalParams.ReferenceChannels=[72,99,100];
elseif strcmp(Subject(SN).Name,'D28');
    AnalParams.Channel=[1:108];
elseif strcmp(Subject(SN).Name,'D29');
     AnalParams.Channel=[1:140]; % change to 140
else
    AnalParams.Channel = [1:64];
end


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
    
 chanCount=floor(0.5*length(AnalParams.Channel));
 chanNums=[1:2:length(AnalParams.Channel)-1];
 ieegAud=trialIEEG(Trials,AnalParams.Channel,'Auditory',[-750 1750]);
 ieegGo=trialIEEG(Trials,AnalParams.Channel,'Go',[-750 1750]);
 ieegStart=trialIEEG(Trials,AnalParams.Channel,'Start',[-750 750]);

 ieegAudBi=zeros(size(ieegAud,1),length(chanNums),size(ieegAud,3));
 ieegGoBi=zeros(size(ieegGo,1),length(chanNums),size(ieegGo,3));
 ieegStartBi=zeros(size(ieegStart,1),length(chanNums),size(ieegStart,3));

 for iChan=1:length(chanNums)
     ieegAudBi(:,iChan,:)=ieegAud(:,chanNums(iChan),:)-ieegAud(:,chanNums(iChan)+1,:);
     ieegGoBi(:,iChan,:)=ieegGo(:,chanNums(iChan),:)-ieegGo(:,chanNums(iChan)+1,:);
     ieegStartBi(:,iChan,:)=ieegStart(:,chanNums(iChan),:)-ieegStart(:,chanNums(iChan)+1,:);
 end




outVal=8;
for iChan=1:size(ieegAudBi,2)
    tmpA=sq(ieegAudBi(:,iChan,:));
    [mA sA]=normfit(log(tmpA(:).^2));
    tmpG=sq(ieegGoBi(:,iChan,:));
    [mG sG]=normfit(log(tmpG(:).^2));
    tmpS=sq(ieegStartBi(:,iChan,:));
    [mS sS]=normfit(log(tmpS(:).^2));
    
    [iA jA]=find(log(tmpA.^2)>outVal*sA+mA);
    [iG jG]=find(log(tmpG.^2)>outVal*sG+mG);
    [iS jS]=find(log(tmpS.^2)>outVal*sS+mS);
inChan{iChan}=setdiff(1:size(ieegAudBi,1),cat(1,unique(iA),unique(iG),unique(iS)));
outChan{iChan}=cat(1,unique(iA),unique(iG),unique(iS));

end
    
clear condVals
 for iTrials=1:length(Trials);
     condVals(iTrials)=Trials(iTrials).StartCode;
 end
 
 specAudAll=zeros(size(ieegAudBi,2),size(ieegAudBi,1),37,41);
 specGoAll=zeros(size(ieegGoBi,2),size(ieegGoBi,1),37,41);
 specStartAll=zeros(size(ieegStartBi,2),size(ieegStartBi,1),37,21);

 srate=experiment.processing.ieeg.sample_rate;
for iChan=1:size(ieegAudBi,2)
    [waveAud,period,scale,coi]=basewave6(sq(ieegAudBi(:,iChan,:)),srate,2,300,5,0.5,0.05);
specAudAll(iChan,:,:,:)=waveAud;
    [waveGo,period,scale,coi]=basewave6(sq(ieegGoBi(:,iChan,:)),srate,2,300,5,0.5,0.05);
specGoAll(iChan,:,:,:)=waveGo;
    [waveStart,period,scale,coi]=basewave6(sq(ieegStartBi(:,iChan,:)),srate,2,300,5,0.5,0.05);
specStartAll(iChan,:,:,:)=waveStart;
display(iChan);
end
   
save([DUKEDIR '/SentenceRep/Spec/' Subject(SN).Name '_LocalizerLSLMJL_Spec_Wavelet_Bipolar.mat'],'spec*','condVals','AnalParams','period','inChan','outChan','-v7.3');
clear inChan outChan
end