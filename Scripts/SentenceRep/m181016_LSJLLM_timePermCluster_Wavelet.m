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
    
 ieegAud=trialIEEG(Trials,AnalParams.Channel,'Auditory',[-750 1750]);
 ieegAudCar=ieegAud-mean(ieegAud,2);
 
ieegGo=trialIEEG(Trials,AnalParams.Channel,'Go',[-750 1750]);
ieegGoCar=ieegGo-mean(ieegGo,2);

ieegStart=trialIEEG(Trials,AnalParams.Channel,'Start',[-750 750]);
ieegStartCar=ieegStart-mean(ieegStart,2);

outVal=8;
for iChan=1:size(ieegAudCar,2)
    tmpA=sq(ieegAudCar(:,iChan,:));
    [mA sA]=normfit(log(tmpA(:).^2));
    tmpG=sq(ieegGoCar(:,iChan,:));
    [mG sG]=normfit(log(tmpG(:).^2));
    tmpS=sq(ieegStartCar(:,iChan,:));
    [mS sS]=normfit(log(tmpS(:).^2));
    
    [iA jA]=find(log(tmpA.^2)>outVal*sA+mA);
    [iG jG]=find(log(tmpG.^2)>outVal*sG+mG);
    [iS jS]=find(log(tmpS.^2)>outVal*sS+mS);
inChan{iChan}=setdiff(1:size(ieegAudCar,1),cat(1,unique(iA),unique(iG),unique(iS)));
outChan{iChan}=cat(1,unique(iA),unique(iG),unique(iS));

end
    
clear condVals
 for iTrials=1:length(Trials);
     condVals(iTrials)=Trials(iTrials).StartCode;
 end
 
 specAudAll=zeros(size(ieegAudCar,2),size(ieegAudCar,1),37,41);
 specGoAll=zeros(size(ieegGoCar,2),size(ieegGoCar,1),37,41);
 specStartAll=zeros(size(ieegStartCar,2),size(ieegStartCar,1),37,21);

 srate=experiment.processing.ieeg.sample_rate;
for iChan=1:size(ieegAud,2)
    [waveAud,period,scale,coi]=basewave6(sq(ieegAudCar(:,iChan,:)),srate,2,300,5,0.5,0.05);
specAudAll(iChan,:,:,:)=waveAud;
    [waveGo,period,scale,coi]=basewave6(sq(ieegGoCar(:,iChan,:)),srate,2,300,5,0.5,0.05);
specGoAll(iChan,:,:,:)=waveGo;
    [waveStart,period,scale,coi]=basewave6(sq(ieegStartCar(:,iChan,:)),srate,2,300,5,0.5,0.05);
specStartAll(iChan,:,:,:)=waveStart;
display(iChan);
end

    
    
    freqBand{1}=5:11; % theta
    freqBand{2}=12:15; % alpha
    freqBand{3}=16:19; % beta
    freqBand{4}=20:25; % gamma
    freqBand{5}=26:31; % HG    
 

%nPerm=1000;
for iChan=1:size(specAudAll,1);
   tic
    
    tmpLSA=[];
    tmpJLA=[];
    tmpLMA=[];
    tmpLSS=[];
    tmpJLS=[];
    tmpLMS=[];
    tmpLSP=[];
    tmpJLP=[];
    tmpLMP=[];
    for iCond=1:4;
        LSidx=find(condVals==iCond);
        JLidx=find(condVals==iCond+7);
        LMidx=find(condVals==iCond+14);
        tmpLSA=cat(1,tmpLSA,sq(specAudAll(iChan,intersect(inChan{iChan},LSidx),:,:)));
        tmpJLA=cat(1,tmpJLA,sq(specAudAll(iChan,intersect(inChan{iChan},JLidx),:,:)));
        tmpLMA=cat(1,tmpLMA,sq(specAudAll(iChan,intersect(inChan{iChan},LMidx),:,:)));
        tmpLSP=cat(1,tmpLSP,sq(specGoAll(iChan,intersect(inChan{iChan},LSidx),:,:)));
        tmpJLP=cat(1,tmpJLP,sq(specGoAll(iChan,intersect(inChan{iChan},JLidx),:,:)));
        tmpLMP=cat(1,tmpLMP,sq(specGoAll(iChan,intersect(inChan{iChan},LMidx),:,:)));
        tmpLSS=cat(1,tmpLSS,sq(specStartAll(iChan,intersect(inChan{iChan},LSidx),:,:)));
        tmpJLS=cat(1,tmpJLS,sq(specStartAll(iChan,intersect(inChan{iChan},JLidx),:,:)));
        tmpLMS=cat(1,tmpLMS,sq(specStartAll(iChan,intersect(inChan{iChan},LMidx),:,:)));
    end
    
    for iF=1:5;
    
     %   bSig=cat(1,tmpLSA(:,1:10),tmpLMA(:,1:10),tmpJLA(:,1:10));
     bSig=repmat(cat(1,sq(mean(tmpLSA(:,freqBand{iF},1:10),2)),sq(mean(tmpJLA(:,freqBand{iF},1:10),2)),sq(mean(tmpLMA(:,freqBand{iF},1:10),2))),1,4);
     %bSig=repmat(cat(1,sq(mean(tmpLSS(:,freqBand{iF},1:10),2)),sq(mean(tmpJLS(:,freqBand{iF},1:10),2)),sq(mean(tmpLMS(:,freqBand{iF},1:10),2))),1,4);

     %   bSig=repmat(cat(1,tmpLSA(:,1:10),tmpLMA(:,1:10),tmpJLA(:,1:10)),1,4);
     aSig=sq(mean(tmpLSA(:,freqBand{iF},1:40),2));
     [zValsRawActLSA{iChan}{iF} pValsRawAct actClustLSA{iChan}{iF}]=timePermCluster(aSig,bSig,nPerm,numTails,zThresh);
     aSig=sq(mean(tmpLMA(:,freqBand{iF},1:40),2));
     [zValsRawActLMA{iChan}{iF} pValsRawAct actClustLMA{iChan}{iF}]=timePermCluster(aSig,bSig,nPerm,numTails,zThresh);
     aSig=sq(mean(tmpJLA(:,freqBand{iF},1:40),2));
     [zValsRawActJLA{iChan}{iF} pValsRawAct actClustJLA{iChan}{iF}]=timePermCluster(aSig,bSig,nPerm,numTails,zThresh);
     aSig=sq(mean(tmpLSP(:,freqBand{iF},1:40),2));
     [zValsRawActLSP{iChan}{iF} pValsRawAct actClustLSP{iChan}{iF}]=timePermCluster(aSig,bSig,nPerm,numTails,zThresh);
     aSig=sq(mean(tmpLMP(:,freqBand{iF},1:40),2));
     [zValsRawActLMP{iChan}{iF} pValsRawAct actClustLMP{iChan}{iF}]=timePermCluster(aSig,bSig,nPerm,numTails,zThresh);
     aSig=sq(mean(tmpJLP(:,freqBand{iF},1:40),2));
     [zValsRawActJLP{iChan}{iF} pValsRawAct actClustJLP{iChan}{iF}]=timePermCluster(aSig,bSig,nPerm,numTails,zThresh);
    end
    toc
     display(iChan);
end    
save([DUKEDIR '/SentenceRep/' Subject(SN).Name '_LocalizerLSLMHL_5Bands_Outlier8_timepointsvsStartbaselineClusterZ_2Tails_Wavelet_AudBaseline.mat'],'AnalParams','actClust*','zValsRaw*','period','freqBand');
clear actClust*
clear zValsRaw*
end