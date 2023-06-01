duke;
filedir=['H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data'];
Subject{23}.Name='D23'; Subject{23}.Prefix = '/Sternberg/D23_Sternberg_trialInfo';
Subject{24}.Name='D24'; Subject{24}.Prefix = '/Sternberg/D24_Sternberg_trialInfo';
Subject{26}.Name='D26'; Subject{26}.Prefix = '/Sternberg/D26_Sternberg_trialInfo';
Subject{27}.Name='D27'; Subject{27}.Prefix = '/Neighborhood Sternberg/D27_Sternberg_trialInfo';
Subject{28}.Name='D28'; Subject{28}.Prefix = '/Neighborhood Sternberg/D28_Sternberg_trialInfo';
Subject{29}.Name='D29'; Subject{29}.Prefix = '/NeighborhoodSternberg/D29_Sternberg_trialInfo';
Subject{30}.Name='D30'; Subject{30}.Prefix = '/NeighborhoodSternberg/D30_Sternberg_trialInfo';
Subject{31}.Name='D31'; Subject{31}.Prefix = '/NeighborhoodSternberg/D31_Sternberg_trialInfo';
Subject{33}.Name='D33'; Subject{33}.Prefix = '/NeighborhoodSternberg/D33_Sternberg_trialInfo';
Subject{34}.Name='D34'; Subject{34}.Prefix = '/NeighborhoodSternberg/D34_Sternberg_trialInfo';
Subject{35}.Name='D35'; Subject{35}.Prefix = '/NeighborhoodSternberg/D35_Sternberg_trialInfo';
Subject{36}.Name='D36'; Subject{36}.Prefix = '/NeighborhoodSternberg/D36_Sternberg_trialInfo';
Subject{37}.Name='D37'; Subject{37}.Prefix = '/NeighborhoodSternberg/D37_Sternberg_trialInfo';
Subject{38}.Name='D38'; Subject{38}.Prefix = '/NeighborhoodSternberg/D38_Sternberg_trialInfo';


SNList=[23,26,27,28,29,30,31]; % 


for iSN=1:length(SNList);
    SN=SNList(iSN);
    %   load([filedir '\' Subject{SN}.Name '\Spec\' Subject{SN}.Name '_eegSpecDelay.mat']);
    load([filedir '\' Subject{SN}.Name  '\'  Subject{SN}.Prefix '.mat'])
        trialLengthIdx = lengthIdx(trialInfo);
    condIdx = catIdx(trialInfo);
    trialCorrectIdx = correctIdx(trialInfo);
    probeValIdx = probeIdx(trialInfo);
    trialRTIdx = rtIdx(trialInfo);
    
    behaviorMat(1,iSN,:)=iSN*ones(1,160);
    behaviorMat(2,iSN,:)=trialLengthIdx;
    behaviorMat(3,iSN,:)=condIdx;
    behaviorMat(4,iSN,:)=probeValIdx;
    
    wordIdx=find(condIdx==1 | condIdx==3);
    highIdx=find(condIdx==1 | condIdx==2);
    behaviorMat(5,iSN,wordIdx)=1;
    behaviorMat(6,iSN,highIdx)=1;
    behaviorMat(7,iSN,:)=trialCorrectIdx;
    behaviorMat(8,iSN,:)=trialRTIdx;
    behaviorMat(9,iSN,:)=(trialRTIdx-nanmean(trialRTIdx))./nanstd(trialRTIdx);
    
    probePositionVals=zeros(160,1);
    idxP=find(probeValIdx==1);
    for iP=1:length(idxP);
        pString=trialInfo{idxP(iP)}.probeSound_name;
        for iS=1:length(trialInfo{idxP(iP)}.stimulusSounds_name)
            if strcmp(pString,trialInfo{idxP(iP)}.stimulusSounds_name(iS))
                probePositionVals(idxP(iP))=iS;
            end
        end
    end
            
    behaviorMat(10,iSN,:)=probePositionVals;
    
end

relPos=zeros(size(behaviorMat,2),size(behaviorMat,3));
lengthList=[3,5,7,9];
for iSN=1:size(behaviorMat,2)
    for iTrials=1:160;
        tmp=sq(behaviorMat(:,iSN,iTrials));
        if tmp(4)==1 && tmp(10)==1
            relPos(iSN,iTrials)=1;
        elseif tmp(4)==1 && tmp(10)==2
            relPos(iSN,iTrials)=2;
        elseif tmp(2)>3 && tmp(4)==1 && tmp(10)==3
            relPos(iSN,iTrials)=2;
        elseif tmp(2)==3 && tmp(4)==1 && tmp(10)==3
            relPos(iSN,iTrials)=3;
        elseif tmp(4)==1 && tmp(10)==4
            relPos(iSN,iTrials)=2;
        elseif tmp(2)>5 && tmp(4)==1 && tmp(10)==5
            relPos(iSN,iTrials)=2;
        elseif tmp(2)==5 && tmp(4)==1 && tmp(10)==5
            relPos(iSN,iTrials)=3;
        elseif tmp(4)==1 && tmp(10)==6
            relPos(iSN,iTrials)=2;
        elseif tmp(2)>7 && tmp(4)==1 && tmp(10)==7
            relPos(iSN,iTrials)=2;
        elseif tmp(2)==7 && tmp(4)==1 && tmp(10)==7
            relPos(iSN,iTrials)=3;
        elseif tmp(4)==1 && tmp(10)==8
            relPos(iSN,iTrials)=2;
        elseif tmp(4)==1 && tmp(10)==9
            relPos(iSN,iTrials)=3;
        end
    end
end

behaviorMat(11,:,:)=relPos;






Subject=[];
Subject(23).Name = 'D23'; Subject(23).Day = '180718';
%Subject(24).Name = 'D24'; Subject(24).Day = '181028';
Subject(26).Name = 'D26'; Subject(26).Day = '190129';
Subject(27).Name = 'D27'; Subject(27).Day = '190304';
Subject(28).Name = 'D28'; Subject(28).Day = '190302';
Subject(29).Name = 'D29'; Subject(29).Day = '190315';
Subject(30).Name = 'D30'; Subject(30).Day = '190413';
Subject(31).Name = 'D31'; Subject(31).Day = '190423';
Subject(32).Name = 'D32'; Subject(32).Day = '190';
Subject(33).Name = 'D33'; Subject(33).Day = '190315';

DUKEDIR = ['H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg'];
for iSN=1:length(SNList);
    SN=SNList(iSN);
    
Subject(SN).Experiment = loadExperiment(Subject(SN).Name);
%Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');
load([DUKEDIR '\' Subject(SN).Name '\' Subject(SN).Day '\mat\Trials.mat']);
Subject(SN).Trials=Trials;
%Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_CovertOvert'); % Test line
Subject(SN).Trials = recodeStartCodeTrials(Subject(SN).Trials);
Trials = Subject(SN).Trials;
experiment = Subject(SN).Experiment;

CondParams.Conds=1:18



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
    AnalParams.Channel=[1:140];
    AnalParams.badChannels=[8,56,133,136,137,140];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);
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
%AnalParams.Tapers = [.25 16];
AnalParams.fk = 200;
%AnalParams.RefChans=subjRefChans(Subject(SN).Name);
AnalParams.Reference = 'Grand average'; % 'IndRef'; %'Grand average', 'Grand average induced'% induced' 'Single-ended','IndRef';%AnalParams.RefChans=subjRefChansInd(Subject(SN).Name);
AnalParams.ArtifactThreshold = 8; %8 %12;
%NumTrials=repmat(270,1,66);
%SelectedChannels = AnalParams.Channel(find(NumTrials > (0.8*length(Trials)))); %STRICT?
% SelectedChannels = AnalParams.Channel(find(NumTrials > (0.65*length(Trials)))); %LESS STRICT?
SelectedChannels=AnalParams.Channel; % really loose: accounts for practice trial confound
%AnalParams.ReferenceChannels = SelectedChannels;
AnalParams.Channel = SelectedChannels;
AnalParams.TrialPooling = 0; %1;  %1; % used to be 1
srate=experiment.recording.sample_rate;
srate2=srate/4;

    ieegA=trialIEEG(Trials,AnalParams.Channel,'FirstStimAuditory',[-500 10000]); % 9 items + 1 second for 
    ieegD=trialIEEG(Trials,AnalParams.Channel,'ProbeCueOnset',[-2000 2000]); % delay is 2 seconds
    ieegR=trialIEEG(Trials,AnalParams.Channel,'RespOnset',[-2000 2000]); % max is 2.5 seconds
    
    ieegA=ieegA-mean(ieegA,2);
    ieegD=ieegD-mean(ieegD,2);
    ieegR=ieegR-mean(ieegR,2);
    
    ieegA_DEC=zeros(size(ieegA,2),size(ieegA,1),size(ieegA,3)./4);
    ieegD_DEC=zeros(size(ieegD,2),size(ieegD,1),size(ieegD,3)./4);
    ieegR_DEC=zeros(size(ieegR,2),size(ieegR,1),size(ieegR,3)./4);

    for iChan=1:size(ieegA,2);
        for iTrials=1:size(ieegA,1);
            ieegA_DEC(iChan,iTrials,:)=decimate(double(sq(ieegA(iTrials,iChan,:))),4);
            ieegD_DEC(iChan,iTrials,:)=decimate(double(sq(ieegD(iTrials,iChan,:))),4);
            ieegR_DEC(iChan,iTrials,:)=decimate(double(sq(ieegR(iTrials,iChan,:))),4);
        end
        display(iChan);
    end
           
 
    
% FREQPAR_D=[];
% FREQPAR_D.foi=[2:1:200];
% %FREQPAR_D.stepsize=.02;
% FREQPAR_D.win_centers=[750:25:(size(ieegD_DEC,3)-750)];
% 
% FREQPAR_R=[];
% %FREQPAR_B.foi=2.^[1:1/8:6];
% FREQPAR_R.foi=[2:1:200];
% 
% %FREQPAR_B.stepsize=.02;
% FREQPAR_R.win_centers=[750:25:(size(ieegR_DEC,3)-750)];
% 
% FREQPAR_A=[];
% %FREQPAR_A.foi=2.^[1:1/8:6];
% FREQPAR_A.foi=[2:1:200];
% FREQPAR_A.foi=2.^(1:.25:8);
% FREQPAR_A.foi=[[1.9,2.2,2.6,2.9,3.4,3.9,4.4,5.1,5.9,6.7,7.7,8.9,10.2,11.7,13.5,15.5,17.8,20.4,23.5,26.9,30.9,35.5,40.8,46.9,53.9,61.9,71.1,81.7,93.8,107.8,123.8,142.2,163.3,187.6,215.5,247.6]'
% %FREQPAR_A.stepsize=.02;
% FREQPAR_A.win_centers=[750:25:(size(ieegA_DEC,3)-750)];
% % FREQPAR_B.stepsize=.01;
% % FREQPAR_B.win_centers=[3750:125:(size(eegB,2)-3750)];
% % %eegSpec=zeros(124,34,3750);
% % %eegSpec=zeros(124,40,163);
    
    
specA=zeros(size(ieegA_DEC,1),size(ieegA_DEC,2),194,200);
specD=zeros(size(ieegD_DEC,1),size(ieegD_DEC,2),61,200);
specR=zeros(size(ieegR_DEC,1),size(ieegR_DEC,2),71,200);
specAL=zeros(size(ieegA_DEC,1),size(ieegA_DEC,2),194,200);
specDL=zeros(size(ieegD_DEC,1),size(ieegD_DEC,2),61,200);
specRL=zeros(size(ieegR_DEC,1),size(ieegR_DEC,2),71,200);

% specWA=zeros(size(ieegA_DEC,1),size(ieegA_DEC,2),36,5000);
% specWD=zeros(size(ieegD_DEC,1),size(ieegD_DEC,2),36,1750);
% specWR=zeros(size(ieegR_DEC,1),size(ieegR_DEC,2),36,1500);

for iChan=1:size(ieegA_DEC,1);
tmpA=sq(ieegA_DEC(iChan,:,srate2*0.75+1:size(ieegA_DEC,3)-srate2*0.75));
tmpD=sq(ieegD_DEC(iChan,:,srate2*0.75+1:size(ieegD_DEC,3)-srate2*0.75));
tmpR=sq(ieegR_DEC(iChan,:,srate2*0.75+1:size(ieegR_DEC,3)-srate2*0.75));

tmpAL=sq(ieegA_DEC(iChan,:,srate2*0.5+1:size(ieegA_DEC,3)-srate2*0.5));
tmpDL=sq(ieegD_DEC(iChan,:,srate2*0.5+1:size(ieegD_DEC,3)-srate2*0.5));
tmpRL=sq(ieegR_DEC(iChan,:,srate2*0.5+1:size(ieegR_DEC,3)-srate2*0.5));

[SPECA, F] = tfspec(tmpA, AnalParams.Tapers, experiment.recording.sample_rate/4, AnalParams.dn, AnalParams.fk,1, [], AnalParams.TrialPooling, [], []);
specA(iChan,:,:,:)=SPECA;
[SPECAL, FL] = tfspec(tmpAL, [1 5], experiment.recording.sample_rate/4, AnalParams.dn, AnalParams.fk,0.5, [], AnalParams.TrialPooling, [], []);
specAL(iChan,:,:,:)=SPECAL;
[SPECDL, FL] = tfspec(tmpDL, [1 5], experiment.recording.sample_rate/4, AnalParams.dn, AnalParams.fk,.5, [], AnalParams.TrialPooling, [], []);
specDL(iChan,:,:,:)=SPECDL;
[SPECD, F] = tfspec(tmpD, AnalParams.Tapers, experiment.recording.sample_rate/4, AnalParams.dn, AnalParams.fk,1, [], AnalParams.TrialPooling, [], []);
specD(iChan,:,:,:)=SPECD;
[SPECR, F] = tfspec(tmpR, AnalParams.Tapers, experiment.recording.sample_rate/4, AnalParams.dn, AnalParams.fk,1, [], AnalParams.TrialPooling, [], []);
specR(iChan,:,:,:)=SPECR;
[SPECRL, FL] = tfspec(tmpRL, [1 5], experiment.recording.sample_rate/4, AnalParams.dn, AnalParams.fk,.5, [], AnalParams.TrialPooling, [], []);
specRL(iChan,:,:,:)=SPECRL;

%
ieegOutA(iChan,:)=mean(log(abs(tmpA)),2);
ieegOutD(iChan,:)=mean(log(abs(tmpD)),2);
ieegOutR(iChan,:)=mean(log(abs(tmpR)),2);
%
% % [WAVEPAR_A, specWA] = tfwavelet(tmpA(:,:),experiment.recording.sample_rate/4,FREQPAR_A, []);
% % [WAVEPAR_D, specWD] = tfwavelet(tmpD(:,:),experiment.recording.sample_rate/4,FREQPAR_D, []);
% % [WAVEPAR_R, specWR] = tfwavelet(tmpR(:,:),experiment.recording.sample_rate/4,FREQPAR_R, []);

%      [waveA,period,scale,coi]=basewave5(tmpAM,experiment.recording.sample_rate/4,2,200,7,0);
%     [waveD,period,scale,coi]=basewave5(tmpDM,experiment.recording.sample_rate/4,2,200,7,0);
%     [waveR,period,scale,coi]=basewave5(tmpRM,experiment.recording.sample_rate/4,2,200,7,0);
%
%     specWA(iChan,:,:,:)=waveA;
%     specWD(iChan,:,:,:)=waveD;
%     specWR(iChan,:,:,:)=waveR;

display(iChan)
end

pvalsDelay=zeros(size(ieegA_DEC,1),200);
% compute stats tests for average of delay in each frequency?
nPerm=1000;
for iChan=1:size(ieegA_DEC,1);
    for iF=1:200;
        aSig=sq(mean(abs(specDL(iChan,:,1:40,iF)),3));
        bSig=sq(mean(abs(specAL(iChan,:,1:10,iF)),3));
        cSig=cat(2,aSig,bSig);
        actDiff=mean(aSig)-mean(bSig);
        
        for iPerm=1:nPerm;
            sIdx=randperm(size(cSig,2));
            idx1=sIdx(1:size(aSig,2));
            idx2=sIdx(size(aSig,2)+1:size(cSig,2));
            permval(iPerm)=mean(cSig(idx1))-mean(cSig(idx2));
        end
        pvalsDelay(iChan,iF)=length(find(actDiff<permval))./nPerm;
    end
    display(iChan);
end

for iChan=1:size(ieegA_DEC,1);
    [pmask pfdr]=fdr(pvalsDelay(iChan,:),.05);
    pvalsDelayFDR(iChan,:)=pfdr;
end

groups=reshape(behaviorMat([1:6,11,10],iSN,:),8,size(behaviorMat,3))';
x_rt=reshape(sq(behaviorMat(8,iSN,:)),size(behaviorMat,3),1);
x_rtN=reshape(sq(behaviorMat(9,iSN,:)),size(behaviorMat,3),1);
x_correct=reshape(sq(behaviorMat(7,iSN,:)),size(behaviorMat,3),1);
TimeOutIdx=isnan(x_rt);
iiT=find(TimeOutIdx==1);
iiR=find(x_rtN>3);
ii=cat(1,iiT,iiR);
iiG=setdiff(1:size(groups,1),ii);
x_rt2=x_rt;
groups2=groups;
x_correct2=x_correct;
x_rt2(ii)=[];
groups2(ii,:)=[];
x_correct2(ii)=[];
x_rtN(ii)=[];

fRange{1}=2:4;
fRange{2}=3:8;
fRange{3}=9:15;
fRange{4}=16:25;
fRange{5}=26:51;
fRange{6}=71:101;
for iChan=1:size(ieegA_DEC,1);
    for iF=1:6;
       aSig=(sq(mean(mean(abs(specDL(iChan,iiG,1:40,fRange{iF})),3),4))-sq(mean(mean(abs(specAL(iChan,iG,1:10,fRange{iF})),3),4)));
   %   aSig=(sq(mean(mean(abs(specDL(iChan,iiG,1:40,fRange{iF})),3),4)));

       aSig=(aSig-mean(aSig));
        iiOut=find(aSig>(3*std(aSig)+mean(aSig)));
        iiIn=setdiff(1:length(iiG),iiOut);
        aSig=aSig(iiIn);
        groups3=groups2(iiIn,:);
        t= table(aSig',x_rt2(iiIn),x_correct2(iiIn),groups3(:,1), groups3(:,2), groups3(:,4), groups3(:,5), groups3(:,6), groups3(:,8), ...
            'VariableNames',{'Neuro','RT','Correct','Subject','Length','Probe','Lex','Phono','ProbePos'});
        %
        t.Correct=categorical(t.Correct);
        t.Subject=categorical(t.Subject);
        t.Probe=categorical(t.Probe);
        t.Lex=categorical(t.Lex);
        t.Phono=categorical(t.Phono);
        mdl_NEURO=fitglm(t,'Neuro~Length*Lex','Distribution','normal');
        mdlCF2{iChan}{iF}=mdl_NEURO;
        %  nestedVals=zeros(4,4);
        % nestedVals(4,3)=1;
        % %[p,tbl,stats,terms] = anovan(x_correct2,groups2(:,[2,5,4,7]),'model','interaction','varnames',{'Length','Lex','Probe','RelPos'},'nested',nestedVals);
        % %[p,tbl,stats,terms] = anovan(x_rtN,groups2(:,[2,5,4,7]),'model','interaction','varnames',{'Length','Lex','Probe','RelPos'},'nested',nestedVals);
        % [p,tbl,stats,terms] = anovan(aSig,groups2(:,[2,5]),'model','interaction','varnames',{'Length','Lex'},'display','off');
        %
        % pM(iChan,iF,:)=p;
        % cM(iChan,iF,:)=stats.coeffs([2:5,7,9,11,13,15]);
    end
    display(iChan)
end


for iChan=1:size(ieegA_DEC,1)
    for iF=1:6 %100;
      %  rvals(iChan,iF) = mdlCF{iChan}{iF}.Rsquared.Adjusted;
        cvals(iChan,iF,:)=mdlCF2{iChan}{iF}.Coefficients.Estimate;
        pvals(iChan,iF,:)=mdlCF2{iChan}{iF}.Coefficients.pValue;
    end
    display(iChan)
end

for iChan=1:size(ieegA_DEC,1);
    for iCond=1:3;
    [pmask pfdr]=fdr(sq(pvals(iChan,:,iCond+1)),.05);
    pvalsFDR(iChan,:,iCond)=pfdr;
    end
end
   
pvalsM=zeros(size(ieegA_DEC,1),6,size(pvals,3));
ii=find(pvals<0.05);
pvalsM(ii)=1;
        
        





groups3=groups2;
ii=find(groups3(:,4)==0);
groups3(ii,:)=[];
x_rt3=x_rt2;
x_correct3=x_correct2;
x_rt3(ii)=[];
x_correct3(ii)=[];
% [P_RT T_RT STATS_RT TERMS_RT]=anovan(x_rt2N,groups2(:,[2,4,5,6]),'model','full','display','off');
%  [P_CORRECT T_CORRECT STATS_CORRECT TERMS_CORRECT]=anovan(x_correct2,groups2(:,[2,5,6]),'model','full','display','off');
% %  


mdl_CORR=fitglm(t,'Correct~Length*Lex*Probe','Distribution','binomial');
mdl_RT=fitlme(t,'RT~Length*Lex*Probe+(1|Subject)');

% % FULL NO PROBE
% mdl_CORR=fitglm(t,'Correct~Length*Lex*Phono','Distribution','binomial');
% mdl_RT=fitlme(t,'RT~Length*Lex*Phono+(1|Subject)');
% TWO WAY
mdl_CORR=fitglm(t,'Correct~Length+Lex+Probe+Length:Lex+Length:Probe+Lex:Probe','Distribution','binomial');
mdl_RT=fitlme(t,'RT~Length+Lex+Probe+Length:Lex+Length:Probe+Lex:Probe+(1|Subject)');beta=fixedEffects(mdl_RT);
% [~,~,STATS] = randomEffects(lme_RT);
% STATS.Level = nominal(STATS.Level);

% anova?
nestedVals=zeros(4,4);
nestedVals(4,3)=1;
[p,tbl,stats,terms] = anovan(x_correct2,groups2(:,[2,5,4,7]),'model','interaction','varnames',{'Length','Lex','Probe','RelPos'},'nested',nestedVals);
[p,tbl,stats,terms] = anovan(x_rtN,groups2(:,[2,5,4,7]),'model','interaction','varnames',{'Length','Lex','Probe','RelPos'},'nested',nestedVals);

