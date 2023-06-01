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

SNList=[3,5,7,8,9,12,13,14,15,16,17,18,20,22,23,24,26,27,28,29];  % add 3 back in

make_ibtb;  

%nt=ones(lsec*srate/decifactor,1);
%I=find(nt==1);
%nt(I)=ntrials;
%S=[1:lsec*srate/decifactor];
opts.method='dr'
opts.bias='qe'
bins=4;
opts.btsp=20;


for iSN=1:length(SNList)

SN = SNList(iSN);
Subject(SN).Experiment = loadExperiment(Subject(SN).Name);
Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');
%Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_CovertOvert'); % Test line
Trials = Subject(SN).Trials;
experiment = Subject(SN).Experiment;
fs=experiment.processing.ieeg.sample_rate;
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
      CondParams.Conds=[5,6,7,12,13,14];

    ieeg=trialIEEG(Trials,AnalParams.Channel,'Auditory',[0 1800]);
    ieegCAR=ieeg-mean(ieeg,2);
    
    clear condVals
    for iTrials=1:length(Trials);
      condVals(iTrials)=Trials(iTrials).StartCode;
    end
    
    for iCond=1:length(CondParams.Conds)
        trialNum(iCond)=length(find(condVals==CondParams.Conds(iCond)));
    end
    
    iPhase=zeros(size(ieegCAR,2),length(CondParams.Conds),39,21);
    iPower=zeros(size(ieegCAR,2),length(CondParams.Conds),39,21);
    pPhase=zeros(size(ieegCAR,2),length(CondParams.Conds),39,21);
    for iChan=1:size(ieegCAR,2)
        for iCond=1:length(CondParams.Conds);
            tic
            ieegTmp=sq(ieegCAR(condVals==CondParams.Conds(iCond),iChan,:));
            ieegTmpDS=zeros(size(ieegTmp,1),size(ieegTmp,2)./4);
            for iTrials=1:size(ieegTmp,1)
                ieegTmpDS(iTrials,:)=decimate(double(ieegTmp(iTrials,:)),4);
            end
            lsec=1.8;
            ntrials=size(ieegTmpDS,1);
            nt=ntrials*(ones(size(ieegTmpDS,2),1));
            opts.nt=nt;
            [wave,period,scale,coi]=basewave5(ieegTmpDS,fs/4,1,200,5,0);
            for iF=1:size(wave,2)
                fPhase=reshape(angle(sq(wave(:,iF,:))),1,size(wave,1),size(wave,3));
                %  plv = abs(sum(exp(1i*(fPhase))))/length(fPhase);
                %  plv=(cos(fPhase).^2+sin(fPhase).^2)./length(fPhase);
                plv=sum((sum(cos(sq(fPhase)),1)./size(sq(fPhase),2)).^2+(sum(sin(sq(fPhase)),1)./size(sq(fPhase),2)).^2);
                
                rPhase=binr(fPhase,nt,bins,'eqspace');
                [iPHT] = information(rPhase, opts, 'Ish');
                iPhase(iChan,iCond,iF,:)=iPHT;
                pPhase(iChan,iCond,iF,:)=plv;
                
                powerF=reshape(abs(sq(wave(:,iF,:))).^2,1,size(wave,1),size(wave,3));
                rPower=binr(powerF,nt,bins,'eqpop');
                [iPOT] = information(rPower, opts, 'Ish');
                iPower(iChan,iCond,iF,:)=iPOT;
            end
            for iF1=1:size(wave,2)
                for iF2=1:size(wave,2)
                    fPhase1=reshape(angle(sq(wave(:,iF1,:))),1,size(wave,1),size(wave,3));
                    fPhase2=reshape(angle(sq(wave(:,iF2,:))),1,size(wave,1),size(wave,3));
                    rPhase1=binr(fPhase1,nt,bins,'eqspace');
                    rPhase2=binr(fPhase2,nt,bins,'eqspace');
                    
                    powerF1=reshape(abs(sq(wave(:,iF1,:))).^2,1,size(wave,1),size(wave,3));
                    powerF2=reshape(abs(sq(wave(:,iF2,:))).^2,1,size(wave,1),size(wave,3));
                    rPower1=binr(powerF1,nt,bins,'eqpop');
                    rPower2=binr(powerF2,nt,bins,'eqpop');
                    
                    rPhasePhase=cat(1,rPhase1,rPhase2);
                    rPowerPower=cat(1,rPower1,rPower2);
                    rPhasePower=cat(1,rPhase1,rPower2);
                    
                    [ISH ILIN ICI ICDSH] = information(rPhasePhase, opts, 'Ish','ILIN','ICI','ICDsh');
                    ishPhasePhase(iChan,iCond,iF1,iF2,:)=ISH;
                    ilinPhasePhase(iChan,iCond,iF1,iF2,:)=ILIN;
                    iciPhasePhase(iChan,iCond,iF1,iF2,:)=ICI;
                    icdshPhasePhase(iChan,iCond,iF1,iF2,:)=ICDSH;

                    [ISH ILIN ICI ICDSH] = information(rPowerPower, opts, 'Ish','ILIN','ICI','ICDsh');
                    ishPowerPower(iChan,iCond,iF1,iF2,:)=ISH;
                    ilinPowerPower(iChan,iCond,iF1,iF2,:)=ILIN;
                    iciPowerPower(iChan,iCond,iF1,iF2,:)=ICI;
                    icdshPowerPower(iChan,iCond,iF1,iF2,:)=ICDSH;
                    [ISH ILIN ICI ICDSH] = information(rPhasePower, opts, 'Ish','ILIN','ICI','ICDsh');
                    ishPhasePower(iChan,iCond,iF1,iF2,:)=ISH;
                    ilinPhasePower(iChan,iCond,iF1,iF2,:)=ILIN;
                    iciPhasePower(iChan,iCond,iF1,iF2,:)=ICI;
                    icdshPhasePower(iChan,iCond,iF1,iF2,:)=ICDSH;
                end
            end
            toc
        end
        display(iChan)
    end
    


