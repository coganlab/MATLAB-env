


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

%SNList=[23,26,27,28,29,30,31];
SNList=[29,30,31];

%Subject(30).Name='D30';
%Subject(31).Name='D31';
nPerm=1000;
numTails=2;
zThresh=1.6449;
clear behaviorMat
DUKEDIR = ['H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg'];
for iSN=1:length(SNList);
        behaviorMat=[];
    SN=SNList(iSN);
    
    load([filedir '\' Subject(SN).Name  '\'  Subject(SN).Prefix '.mat'])
    trialLengthIdx = lengthIdx(trialInfo);
    condIdx = catIdx(trialInfo);
    trialCorrectIdx = correctIdx(trialInfo);
    probeValIdx = probeIdx(trialInfo);
    trialRTIdx = rtIdx(trialInfo);
    
    behaviorMat(1,:)=iSN*ones(1,160);
    behaviorMat(2,:)=trialLengthIdx;
    behaviorMat(3,:)=condIdx;
    behaviorMat(4,:)=probeValIdx;
    
    wordIdx=find(condIdx==1 | condIdx==3);
    highIdx=find(condIdx==1 | condIdx==2);
    behaviorMat(5,wordIdx)=1;
    behaviorMat(6,highIdx)=1;
    behaviorMat(7,:)=trialCorrectIdx;
    behaviorMat(8,:)=trialRTIdx;
    behaviorMat(9,:)=(trialRTIdx-nanmean(trialRTIdx))./nanstd(trialRTIdx);
    
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
    
    behaviorMat(10,:)=probePositionVals;
    
    
    
    relPos=zeros(size(behaviorMat,2),size(behaviorMat,3));
    lengthList=[3,5,7,9];
    
    for iTrials=1:160;
        tmp=sq(behaviorMat(:,iTrials));
        if tmp(4)==1 && tmp(10)==1
            relPos(iTrials)=1;
        elseif tmp(4)==1 && tmp(10)==2
            relPos(iTrials)=2;
        elseif tmp(2)>3 && tmp(4)==1 && tmp(10)==3
            relPos(iTrials)=2;
        elseif tmp(2)==3 && tmp(4)==1 && tmp(10)==3
            relPos(iTrials)=3;
        elseif tmp(4)==1 && tmp(10)==4
            relPos(iTrials)=2;
        elseif tmp(2)>5 && tmp(4)==1 && tmp(10)==5
            relPos(iTrials)=2;
        elseif tmp(2)==5 && tmp(4)==1 && tmp(10)==5
            relPos(iTrials)=3;
        elseif tmp(4)==1 && tmp(10)==6
            relPos(iTrials)=2;
        elseif tmp(2)>7 && tmp(4)==1 && tmp(10)==7
            relPos(iTrials)=2;
        elseif tmp(2)==7 && tmp(4)==1 && tmp(10)==7
            relPos(iTrials)=3;
        elseif tmp(4)==1 && tmp(10)==8
            relPos(iTrials)=2;
        elseif tmp(4)==1 && tmp(10)==9
            relPos(iTrials)=3;
        end
    end
    
    
    behaviorMat(11,:)=relPos;
    
    
    if SN==28
        behaviorMat=behaviorMat(:,1:153);
    end
    
    iiW=find(behaviorMat(5,:)==1);
    iiNW=find(behaviorMat(5,:)==0);
    
    
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
    elseif strcmp(Subject(SN).Name,'D30')
        AnalParams.Channel=[1:104];
    elseif strcmp(Subject(SN).Name,'D31')
        AnalParams.Channel=[1:160];
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
    
    AnalParams.Tapers = [1 3];
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
    if srate<2048
        AnalParams.pad=1;
    else
        AnalParams.pad=.5;
    end
    %   ieegS=trialIEEG(Trials,AnalParams.Channel,'ListenCue',[-1000 1500]); % 9 items + 1 second for
    %   ieegA=trialIEEG(Trials,AnalParams.Channel,'FirstStimAuditory',[-1000 10500]); % 9 items + 1 second for
    ieegD=trialIEEG(Trials,AnalParams.Channel,'ProbeCueOnset',[-2500 2500]); % delay is 2 seconds
    %   ieegR=trialIEEG(Trials,AnalParams.Channel,'RespOnset',[-2500 2500]); % max is 2.5 seconds
    
    
    
    %  ieegS=ieegS-mean(ieegS,2);
    %  ieegA=ieegA-mean(ieegA,2);
    ieegD=ieegD-mean(ieegD,2);
    %  ieegR=ieegR-mean(ieegR,2);
    
    % ieegS_DEC=zeros(size(ieegS,2),size(ieegS,1),size(ieegS,3)./4);
    % ieegA_DEC=zeros(size(ieegA,2),size(ieegA,1),size(ieegA,3)./4);
    ieegD_DEC=zeros(size(ieegD,2),size(ieegD,1),size(ieegD,3)./4);
    % ieegR_DEC=zeros(size(ieegR,2),size(ieegR,1),size(ieegR,3)./4);
    
    for iChan=1:size(ieegD,2);
        for iTrials=1:size(ieegD,1);
            %     ieegS_DEC(iChan,iTrials,:)=decimate(double(sq(ieegS(iTrials,iChan,:))),4);
            %     ieegA_DEC(iChan,iTrials,:)=decimate(double(sq(ieegA(iTrials,iChan,:))),4);
            ieegD_DEC(iChan,iTrials,:)=decimate(double(sq(ieegD(iTrials,iChan,:))),4);
            %     ieegR_DEC(iChan,iTrials,:)=decimate(double(sq(ieegR(iTrials,iChan,:))),4);
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
    
    % if srate<2048
    % specA=zeros(size(ieegA_DEC,1),size(ieegA_DEC,2),210,102);
    % specD=zeros(size(ieegD_DEC,1),size(ieegD_DEC,2),80,102);
    % specR=zeros(size(ieegR_DEC,1),size(ieegR_DEC,2),80,102);
    % else
    % specA=zeros(size(ieegA_DEC,1),size(ieegA_DEC,2),215,200);
    % specD=zeros(size(ieegD_DEC,1),size(ieegD_DEC,2),81,200);
    % specR=zeros(size(ieegR_DEC,1),size(ieegR_DEC,2),81,200);
    % end
    
    
    % srate=2048;
    
    %specSW=zeros(size(ieegS_DEC,1),size(ieegS_DEC,2),34,30);
    %specAW=zeros(size(ieegA_DEC,1),size(ieegA_DEC,2),34,210);
    specDW=zeros(size(ieegD_DEC,1),size(ieegD_DEC,2),34,40);
    %specRW=zeros(size(ieegR_DEC,1),size(ieegR_DEC,2),34,40);
    
    clear ieegOut*
    for iChan=1:size(ieegD_DEC,1);
        
        %tmpS=sq(ieegS_DEC(iChan,:,:));
        %tmpA=sq(ieegA_DEC(iChan,:,:));
        tmpD=sq(ieegD_DEC(iChan,:,:));
        %tmpR=sq(ieegR_DEC(iChan,:,:));
        %[waveS,period,scale,coi]=basewave6(tmpS,srate2,2,200,5,0.5,.05);
        %[waveA,period,scale,coi]=basewave6(tmpA,srate2,2,200,5,0.5,.05);
        [waveD,period,scale,coi]=basewave6(tmpD,srate2,2,200,5,0.5,.05);
        %[waveR,period,scale,coi]=basewave6(tmpR,srate2,2,200,5,0.5,.05);
        
        % waveS=waveS(:,:,idxS);
        % waveA=waveA(:,:,idxA);
        % waveD=waveD(:,:,idxD);
        % waveR=waveR(:,:,idxR);
        
        %specSW(iChan,:,:,:)=waveS(:,:,6:35);
        %specAW(iChan,:,:,:)=waveA(:,:,6:215);
        specDW(iChan,:,:,:)=waveD(:,:,11:50);
        %specRW(iChan,:,:,:)=waveR(:,:,11:50);
        
        % [SPECA, F] = tfspec(tmpA, AnalParams.Tapers, experiment.recording.sample_rate/4, AnalParams.dn, AnalParams.fk,AnalParams.pad, [], AnalParams.TrialPooling, [], []);
        % specA(iChan,:,:,:)=SPECA;
        % % [SPECAL, FL] = tfspec(tmpAL, [1 5], experiment.recording.sample_rate/4, AnalParams.dn, AnalParams.fk,0.5, [], AnalParams.TrialPooling, [], []);
        % % specAL(iChan,:,:,:)=SPECAL;
        % % [SPECDL, FL] = tfspec(tmpDL, [1 5], experiment.recording.sample_rate/4, AnalParams.dn, AnalParams.fk,.5, [], AnalParams.TrialPooling, [], []);
        % % specDL(iChan,:,:,:)=SPECDL;
        % [SPECD, F] = tfspec(tmpD, AnalParams.Tapers, experiment.recording.sample_rate/4, AnalParams.dn, AnalParams.fk,AnalParams.pad, [], AnalParams.TrialPooling, [], []);
        % specD(iChan,:,:,:)=SPECD;
        % [SPECR, F] = tfspec(tmpR, AnalParams.Tapers, experiment.recording.sample_rate/4, AnalParams.dn, AnalParams.fk,AnalParams.pad, [], AnalParams.TrialPooling, [], []);
        % specR(iChan,:,:,:)=SPECR;
        % [SPECRL, FL] = tfspec(tmpRL, [1 5], experiment.recording.sample_rate/4, AnalParams.dn, AnalParams.fk,.5, [], AnalParams.TrialPooling, [], []);
        % specRL(iChan,:,:,:)=SPECRL;
        
        %
        %ieegOutS(iChan,:)=mean(log(abs(tmpS)),2);
        %ieegOutA(iChan,:)=mean(log(abs(tmpA)),2);
        ieegOutD(iChan,:)=mean(log(abs(tmpD)),2);
        %ieegOutR(iChan,:)=mean(log(abs(tmpR)),2);
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
    
    freqBand{1}=5:11; % theta
    freqBand{2}=12:15; % alpha
    freqBand{3}=16:19; % beta
    freqBand{4}=20:25; % gamma
    freqBand{5}=26:31; % HG
    for iChan=1:size(ieegD_DEC,1);
        tic
        %     aSigD=sq(specD(iChan,:,1:40,:));
        %     aSigA=sq(specA(iChan,:,:,:));
        %     bSig=repmat(aSigA(:,1:10,:),1,4);
        aSigD=sq(abs(specDW(iChan,:,:,:)));
        %aSigA=sq(abs(specAW(iChan,:,:,:)));
        %aSigS=sq(abs(specSW(iChan,:,:,:)));
        %aSigR=sq(abs(specRW(iChan,:,:,:)));
        %bSig=repmat(aSigS(:,:,1:10),1,1,21);
        
        aSigDW=aSigD(iiW,:,:);
        aSigDNW=aSigD(iiNW,:,:);
        
        
        aSigDW2=zeros(size(aSigDW,1),size(aSigDW,3),size(aSigDW,2));
        aSigDNW2=zeros(size(aSigDNW,1),size(aSigDNW,3),size(aSigDNW,2));
        
        %  aSigR2=zeros(size(aSigR,1),size(aSigR,3),size(aSigR,2));
        %  aSigA2=zeros(size(aSigA,1),size(aSigA,3),size(aSigA,2));
        %  aSigS2=zeros(size(aSigS,1),size(aSigS,3),size(aSigS,2));
        %  bSig2=zeros(size(bSig,1),size(bSig,3),size(bSig,2));
        
        for iTrials=1:size(aSigDW,1);
            % tIdx=shuffle(1:size(bSig,3));
            % tIdx=1:size(bSig,3);
            %aSigR2(iTrials,:,:)=sq(aSigR(iTrials,:,:))';
            aSigDW2(iTrials,:,:)=sq(aSigDW(iTrials,:,:))';
        end
        for iTrials=1:size(aSigDNW,1)
            aSigDNW2(iTrials,:,:)=sq(aSigDNW(iTrials,:,:))';
            %aSigS2(iTrials,:,:)=sq(aSigS(iTrials,:,:))';
            %aSigA2(iTrials,:,:)=sq(aSigA(iTrials,:,:))';
            %bSig2(iTrials,:,:)=sq(bSig(iTrials,:,tIdx))';
        end
        
        for iF=1:length(freqBand)
            
            %  bSig=repmat(cat(1,mean(tmpLSA(:,1:10,1:200),2),mean(tmpLMA(:,1:10,1:200),2),mean(tmpJLA(:,1:10,1:200),2)),1,40);
            %  [zValsRawActD{iChan} pValsRawAct actClustD{iChan}]=timePermClusterSpec(aSigD2,bSig2,nPerm,numTails,zThresh);
            %  [zValsRawActR{iChan}{iF} pValsRawR{iChan}{iF} actClustR{iChan}{iF}]=timePermCluster(sq(mean(aSigR2(:,:,freqBand{iF}),3)),sq(mean(bSig2(:,1:size(aSigR2,2),freqBand{iF}),3)),nPerm,numTails,zThresh);
            [zValsRawActD{iChan}{iF} pValsRawD{iChan}{iF} actClustD{iChan}{iF}]=timePermCluster(sq(mean(aSigDW2(:,:,freqBand{iF}),3)),sq(mean(aSigDNW2(:,1:size(aSigDW2,2),freqBand{iF}),3)),nPerm,numTails,zThresh);
            %  [zValsRawActS{iChan}{iF} pValsRawS{iChan}{iF} actClustS{iChan}{iF}]=timePermCluster(sq(mean(aSigS2(:,:,freqBand{iF}),3)),sq(mean(bSig2(:,1:size(aSigS2,2),freqBand{iF}),3)),nPerm,numTails,zThresh);
            %  [zValsRawActA{iChan}{iF} pValsRawA{iChan}{iF} actClustA{iChan}{iF}]=timePermCluster(sq(mean(aSigA2(:,:,freqBand{iF}),3)),sq(mean(bSig2(:,1:size(aSigA2,2),freqBand{iF}),3)),nPerm,numTails,zThresh);
            
        end
        display(iChan)
        toc
    end
    save([DUKEDIR '/Output/' Subject(SN).Name '_NeighborhoodSternberg_ClusterTime_5FreqBands_2Tails_bw6_DelayWvsNW.mat'],'zValsRaw*','pValsRaw*','actClust*','freqBand','AnalParams','behaviorMat','period');
    clear zValsRaw*
    clear pValsRaw*
    clear actClust*
end
