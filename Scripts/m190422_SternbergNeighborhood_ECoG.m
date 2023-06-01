duke;
global experiment
Subject = struct([]);
DUKEDIR=[DUKEDIR '\Neighborhood_Sternberg'];
global DUKEDIR
Subject(23).Name = 'D23'; Subject(23).Day = '180718';
Subject(26).Name = 'D26'; Subject(26).Day = '190128';
Subject(27).Name = 'D27'; Subject(27).Day = '190304';
Subject(28).Name = 'D28'; Subject(28).Day = '190302';
Subject(29).Name = 'D29'; Subject(29).Day = '090315';
%SNList=[2,3,4,5,6,7,8,9,11,12,13,15,16,17,18,20,21,22,23,24];
%SNList=[9,11,12,13,15,16,17,18,20,21,22,23,24];

SNList=[23,26:29];

for iSN=1:length(SNList);
SN=SNList(iSN);

clear Auditory_Spec Motor_Spec
clear Auditory_nSpec Motor_nSpec
Subject(SN).Experiment = loadExperiment(Subject(SN).Name);
Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');
%Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_CovertOvert'); % Test line
Trials = Subject(SN).Trials;
experiment = Subject(SN).Experiment;

CondParams.Conds = [1:18];



%CondParams.bn = [-2500,3500];
%AnalParams.Tapers = [0.5,10];

if strcmp(Subject(SN).Name,'D23')
        AnalParams.Channel=[1:121];
        AnalParams.goodChannel=AnalParams.Channel;
elseif strcmp(Subject(SN).Name,'D26')
        AnalParams.Channel=[1:60];
        AnalParams.goodChannel=AnalParams.Channel;        
elseif strcmp(Subject(SN).Name,'D27');
        AnalParams.Channel=[1:114];
        AnalParams.goodChannel=AnalParams.Channel;       
elseif strcmp(Subject(SN).Name,'D28');
        AnalParams.Channel=[1:108];
        AnalParams.badChannel=[10,20,27,33,77,8];
        AnalParams.goodChannel=setdiff(AnalParams.Channel,AnalParams.badChannel);
   %     AnalParams.Channel=setdiff(AnalParams.Channel,badChans);
elseif strcmp(Subject(SN).Name,'D29');
        AnalParams.Channel=[1:140]; 
        AnalParams.goodChannel=AnalParams.Channel;        
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

AnalParams.Tapers = [.5,10];
%AnalParams.Tapers = [.25 16];
AnalParams.fk = 500;
%AnalParams.RefChans=subjRefChans(Subject(SN).Name);
AnalParams.Reference = 'Grand average';% 'IndRef'; %'Grand average', 'Grand average induced'% induced' 'Single-ended','IndRef';%AnalParams.RefChans=subjRefChansInd(Subject(SN).Name);
AnalParams.ArtifactThreshold = 12; %8 %12;

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


ieegD=trialIEEG(Trials,AnalParams.Channel,'ProbeCueOnset',[-3500 2500]);
ieegB=trialIEEG(Trials,AnalParams.Channel,'FirstStimAuditory',[-3000 500]);
ieegA=trialIEEG(Trials,AnalParams.Channel,'FirstStimAuditory',[-3000 11500]);


ieegA2=zeros(size(ieegA,1),size(ieegA,2),size(ieegA,3)./4);
ieegB2=zeros(size(ieegB,1),size(ieegB,2),size(ieegB,3)./4);
ieegD2=zeros(size(ieegD,1),size(ieegD,2),size(ieegD,3)./4);

for iChan=1:size(ieegA,2)
    for iTrials=1:size(ieegA,1);
        ieegA2(iTrials,iChan,:)=decimate(double(sq(ieegA(iTrials,iChan,:))),4);
        ieegB2(iTrials,iChan,:)=decimate(double(sq(ieegB(iTrials,iChan,:))),4);
        ieegD2(iTrials,iChan,:)=decimate(double(sq(ieegD(iTrials,iChan,:))),4);
    end
end

ieegD2=ieegD2-mean(ieegD2(:,AnalParams.goodChannel,:),2);
ieegB2=ieegB2-mean(ieegB2(:,AnalParams.goodChannel,:),2);
ieegA2=ieegA2-mean(ieegA2(:,AnalParams.goodChannel,:),2);



% [eegD]=bva_epoch(eeg3,triggers3,[152],-5500,2500,srate2); % delay period? % in TFWAVLET, should align to delay start to probe audio start
% [eegB]=bva_epoch(eeg3,triggers3,[501],-3000,500,srate2); % baseline period? % in TFWAVLET, should align to -0.5 to 0 baseline 
% [eegA]=bva_epoch(eeg3,triggers3,[501],-3000,11500,srate2);

%load([filedir '\' Subject{SN}.Name  '\Behavioral_Data(PTB)\' Subject{SN}.Behavior '\' Subject{SN}.Name '_Block_1_TrialData.mat'])


trialLengthIdx = lengthIdx(trialInfo);
condIdx = catIdx(trialInfo);
trialCorrectIdx = correctIdx(trialInfo);
probeValIdx = probeIdx(trialInfo);
trialRTIdx = rtIdx(trialInfo);

srate=round(experiment.recording.sample_rate);
srate2=srate/4;

ii3=find(trialLengthIdx==3);
ii5=find(trialLengthIdx==5);
ii7=find(trialLengthIdx==7);
ii9=find(trialLengthIdx==9);

TAPERS=[0.5 10];
SAMPLING=srate;
DN=0.05;
FK1=[0 1200];
FK2=[0 200];
PAD=1;
cutoff=3;
FREQPAR_D=[];
FREQPAR_D.foi=[2:2:200];
%FREQPAR_D.stepsize=.02;
FREQPAR_D.win_centers=round([1.5*srate2:16:(size(ieegD2,3)-1.5*srate2)]);

FREQPAR_B=[];
%FREQPAR_B.foi=2.^[1:1/8:6];
FREQPAR_B.foi=[2:2:200];

%FREQPAR_B.stepsize=.02;
FREQPAR_B.win_centers=round([1.5*srate2:16:(size(ieegB2,3)-1.5*srate2)]);

FREQPAR_A=[];
%FREQPAR_A.foi=2.^[1:1/8:6];
FREQPAR_A.foi=[2:2:200];
%FREQPAR_A.stepsize=.02;
FREQPAR_A.win_centers=round([1.5*srate2:16:(size(ieegA2,3)-1.5*srate2)]);
% FREQPAR_B.stepsize=.01;
% FREQPAR_B.win_centers=[3750:125:(size(eegB,2)-3750)];
% %eegSpec=zeros(124,34,3750);
% %eegSpec=zeros(124,40,163);
if SN==23;
ieegSpecD=zeros(size(ieegD2,2),size(ieegD2,1),94,100); % for Delay
ieegSpecB=zeros(size(ieegB2,2),size(ieegB2,1),16,100); % for Baseline
ieegSpecA=zeros(size(ieegA2,2),size(ieegA2,1),360,100); % for Auditory


ieegSpecMD=zeros(size(ieegD2,2),size(ieegD2,1),110,204);
ieegSpecMA=zeros(size(ieegA2,2),size(ieegA2,1),280,204);
ieegSpecMB=zeros(size(ieegB2,2),size(ieegB2,1),60,204);

PAD=2;
else

ieegSpecD=zeros(size(ieegD2,2),size(ieegD2,1),97,100); % for Delay
ieegSpecB=zeros(size(ieegB2,2),size(ieegB2,1),17,100); % for Baseline
ieegSpecA=zeros(size(ieegA2,2),size(ieegA2,1),369,100); % for Auditory


ieegSpecMD=zeros(size(ieegD2,2),size(ieegD2,1),112,200);
ieegSpecMA=zeros(size(ieegA2,2),size(ieegA2,1),286,200);
ieegSpecMB=zeros(size(ieegB2,2),size(ieegB2,1),61,200);

PAD=1;

end
for iChan=1:size(ieegD,2);
    ieegTmpD=sq(ieegD2(:,iChan,:,:));
    ieegTmpB=sq(ieegB2(:,iChan,:,:));
    ieegTmpA=sq(ieegA2(:,iChan,:,:));
%     eegTmpA=eegTmpA-mean(eegTmpB(501:625,:)); % detrend
%     eegTmpD=eegTmpD-mean(eegTmpB(501:625,:)); % detrend
%     eegTmpB=eegTmpB-mean(eegTmpB(501:625,:)); % detrend

    ieegOutA(iChan,:)=mean(abs(ieegTmpA),2);
    ieegOutB(iChan,:)=mean(abs(ieegTmpB),2);
    ieegOutD(iChan,:)=mean(abs(ieegTmpD),2);
   
%     [m s]=normfit(log(eegTmpD(:).^2));
%     [ii1 jj1]=find(log(eegTmp.^2)>cutoff*s+m);
% %[SPEC, F] = tfspec(eegTmp(:,:)', TAPERS, SAMPLING, DN, FK1, PAD, [], 0, [], []);
% %tmpSpec=reshape(sq(mean(SPEC(:,:,165:end),3)),size(SPEC,1)*size(SPEC,2),1);
% %
% 
%    % trialBad{iChan}=unique(cat(1,jj1,jj2));
%     trialBad{iChan}=unique(jj1);
% 
%     goodTrials{iChan}=setdiff(1:size(eegTmp,2),trialBad{iChan});
%[SPEC, F] = tfspec(eegTmp(:,goodTrials{iChan})', TAPERS, SAMPLING, DN, FK2, PAD, [], 1, [], []);

%[wave,period,scale,coi]=basewave5(eegTmp',SAMPLING,1,100,5,0);
%[WAVEPAR, spec] = tfwavelet(eegTmp(:,goodTrials{iChan})',2500,FREQPAR, []);
 [WAVEPAR_D, specD] = tfwavelet(ieegTmpD(:,:),srate2,FREQPAR_D, []);
 [WAVEPAR_B, specB] = tfwavelet(ieegTmpB(:,:),srate2,FREQPAR_B, []);
 [WAVEPAR_A, specA] = tfwavelet(ieegTmpA(:,:),srate2,FREQPAR_A, []);

[SPECD] = tfspec(ieegTmpD(:,:), [0.5 10], srate2, 0.05, [0 200], PAD, [], 0, [],[]); 
[SPECA] = tfspec(ieegTmpA(:,:), [0.5 10], srate2, 0.05, [0 200], PAD, [], 0, [],[]); 
[SPECB] = tfspec(ieegTmpB(:,:), [0.5 10], srate2, 0.05, [0 200], PAD, [], 0, [],[]); 

 ieegSpecD(iChan,:,:,:)=specD;
 ieegSpecB(iChan,:,:,:)=specB;
 ieegSpecA(iChan,:,:,:)=specA;

ieegSpecMD(iChan,:,:,:)=SPECD;
ieegSpecMB(iChan,:,:,:)=SPECB;
ieegSpecMA(iChan,:,:,:)=SPECA;
display(iChan)
end
% 
% fileSaveDir=[filedir '\' Subject{SN}.Name '\Spec\'];
% if ~exist(fileSaveDir)
%     mkdir(fileSaveDir)
% end
% save([fileSaveDir Subject{SN}.Name '_eegSpecDelay_A.mat'],'eegSpecA','WAVEPAR_A','eegOutA','-v7.3');
% save([fileSaveDir Subject{SN}.Name '_eegSpecDelay_B.mat'],'eegSpecB','WAVEPAR_B','eegOutB','-v7.3');
% save([fileSaveDir Subject{SN}.Name '_eegSpecDelay_D.mat'],'eegSpecD','WAVEPAR_D','eegOutD','-v7.3');
% 
% clear eegSpec* eegOut* WAVEPAR* eeg*
end
