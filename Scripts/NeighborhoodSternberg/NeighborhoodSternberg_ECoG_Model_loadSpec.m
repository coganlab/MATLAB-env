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

SNList=[23,26,27,28,29,30,31];
%SNList=[29,30,31];

%Subject(30).Name='D30'; 
%Subject(31).Name='D31';
nPerm=1000;
numTails=1;
zThresh=1.6449;
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


load([DUKEDIR '/Output/Spec/' Subject(SN).Name '_NeighborhoodSternberg_Spec_bw6.mat']);

behaviorMat = genBehaviorMat(Subject(SN).Name,Subject(SN).Prefix,filedir); 

freqBand{1}=5:11; % theta
freqBand{2}=12:15; % alpha
freqBand{3}=16:19; % beta
freqBand{4}=20:25; % gamma
freqBand{5}=26:31; % HG








groups=reshape(behaviorMat([1:6,11,10],:),8,size(behaviorMat,2))';
if SN==28
    groups=groups(1:153,:);
end
x_rt=behaviorMat(8,:);
x_rtN=behaviorMat(9,:);
x_correct=behaviorMat(7,:);
TimeOutIdx=isnan(x_rt);
iiT=find(TimeOutIdx==1);
iiR=find(x_rtN>3);
if length(iiT) > 0 && length(iiR) > 0
ii=unique(cat(1,iiT,iiR));
elseif length(iiT) > 0
    ii=iiT;
else
    ii=iiR;
end

%ii=cat(2,ii,find(x_correct==0));


iiG=setdiff(1:size(groups,1),ii);
x_rt2=x_rt;
groups2=groups;
x_correct2=x_correct;
x_rt2(ii)=[];
groups2(ii,:)=[];
x_correct2(ii)=[];
x_rtN(ii)=[];


    
for iChan=1:size(specAW,1)
    for iF=1:5;
        aSigD=sq(mean(abs(specDW(iChan,:,freqBand{iF},:)),3));   %   aSig=(sq(mean(mean(abs(specDL(iChan,iiG,1:40,fRange{iF})),3),4)));
        aSigD=mean(aSigD(:,:),2);
        aSigD=(aSigD-mean(aSigD))./std(aSigD);
        iiOut=find(aSigD>3);
        iiIn=setdiff(1:length(iiG),iiOut);
        aSigD=aSigD(iiIn);
        groups3=groups2(iiIn,:);
     
        t= table(aSigD,x_rt2(iiIn)',x_correct2(iiIn)',groups3(:,1), groups3(:,2), groups3(:,4), groups3(:,5), groups3(:,6), groups3(:,8), ...
            'VariableNames',{'Neuro','RT','Correct','Subject','Length','Probe','Lex','Phono','ProbePos'});
        %
        t.Correct=categorical(t.Correct);
        t.Subject=categorical(t.Subject);
        t.Probe=categorical(t.Probe);
        t.Lex=categorical(t.Lex);
        t.Phono=categorical(t.Phono);
       
%         clear t2
%         Length=groups3(:,2);
%         Lex=groups3(:,5);
%         Neuro=aSigD;
%            t2= table(Neuro,Length,Lex);
%                 t2.Lex=categorical(t2.Lex);

        %mdl_NEURO=fitglm(t,'Neuro~Length*Lex','Distribution','normal');
        mdl_NEURO=fitglm(t,'Neuro~Correct','Distribution','normal');

    %   mdl_NEURO =  stepwiseglm(t2,'Neuro~Length*Lex','Distribution','normal');
        mdlCF{iChan}{iF}=mdl_NEURO;
        %  nestedVals=zeros(4,4);
        % nestedVals(4,3)=1;
      % %  [p,tbl,stats,terms] = anovan(x_correct2,groups2(:,[2,5,4,7]),'model','interaction','varnames',{'Length','Lex','Probe','RelPos'},'nested',nestedVals);
      % % [p,tbl,stats,terms] = anovan(x_rtN,groups2(:,[2,5,4,7]),'model','interaction','varnames',{'Length','Lex','Probe','RelPos'},'nested',nestedVals);
%       groupsA{1}=groups3(:,2);
%       groupsA{2}=groups3(:,5);
%       [p,tbl,stats,terms] = anovan(aSigD,groupsA,'model','interaction','varnames',{'Length','Lex'},'display','off');
%         %
        % pM(iChan,iF,:)=p;
        % cM(iChan,iF,:)=stats.coeffs([2:5,7,9,11,13,15]);
    end
    display(iChan)
end

for iChan=1:size(specAW,1)
    for iF=1:5;
        cvalsS(iChan,iF)=size(mdlCF{iChan}{iF}.Coefficients,1);
    end
end


for iChan=1:size(specAW,1)
    for iF=1:5 %100;
      %  rvals(iChan,iF) = mdlCF{iChan}{iF}.Rsquared.Adjusted;
        cvals(iChan,iF,:)=mdlCF{iChan}{iF}.Coefficients.Estimate;
        pvals(iChan,iF,:)=mdlCF{iChan}{iF}.Coefficients.pValue;
%         avals(iChan,iF,:)=mdlCF{iChan}{iF}.anova.F;
%         apvals(iChan,iF,:)=mdlCF{iChan}{iF}.anova.pValue;
    end
    display(iChan)
end


save([DUKEDIR '/Output/' Subject(SN).Name '_NeighborhoodSternberg_Model_CorrectPred.mat'],'cvals','pvals','mdlCF','freqBand','behaviorMat','period');
clear cvals pvals mdlCF
end
