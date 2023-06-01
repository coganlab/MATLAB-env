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

SN = 11;
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
AnalParams.Reference = 'Single-ended'; %'Grand average'; % other is 'Single-ended';
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
CondParams.bn = [-500,1500];
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

comps=5;
designMat=[1 1 0 0 1 1 0 0;1 1 1 1 0 0 0 0;1 0 1 0 1 0 1 0];
fVals=[70:150];
for iChan=1:120;
    for iCond=1:8
        trialNums(iCond)=size(Auditory_Spec{iCond}{iChan},1);
    end
    minTrial=min(trialNums);
    data=[];
    for iCond=1:8
        idx=shuffle(1:size(Auditory_Spec{iCond}{iChan},1));
        data=cat(1,data,Auditory_Spec{iCond}{iChan}(idx(1:minTrial),:,fVals));
        data=data./repmat(mean(data(:,1:20,:),2),1,size(data,2),1);
    end
    nTrial=size(data,1);
    for iTemp=1:size(data,2);
        data2=sq(data(:,iTemp,:));
                 modelLex=cat(1,ones(minTrial,1),ones(minTrial,1),0*ones(minTrial,1),0*ones(minTrial,1),ones(minTrial,1),ones(minTrial,1),0*ones(minTrial,1),0*ones(minTrial,1));
                 modelTask=cat(1,ones(minTrial,1),ones(minTrial,1),ones(minTrial,1),ones(minTrial,1),0*ones(minTrial,1),0*ones(minTrial,1),0*ones(minTrial,1),0*ones(minTrial,1));
                 modelPhono=cat(1,ones(minTrial,1),0*ones(minTrial,1),ones(minTrial,1),0*ones(minTrial,1),ones(minTrial,1),0*ones(minTrial,1),ones(minTrial,1),0*ones(minTrial,1));
        modelAll=cat(1,1*ones(minTrial,1),2*ones(minTrial,1),3*ones(minTrial,1),4*ones(minTrial,1),5*ones(minTrial,1),6*ones(minTrial,1),7*ones(minTrial,1),8*ones(minTrial,1));
        modelChoice=modelLex;
        
        for iTrial = 1:nTrial
            xLooTrial = data2(setdiff(1:nTrial,iTrial),:);
            xLooTrial2 = xLooTrial*xLooTrial';
            [u1,s1,v1] = svd(xLooTrial2);
            vTrial1 = xLooTrial'*v1(:,1:comps);
            xTrial1 = sq(data2(iTrial,:));
            TestTrial = xTrial1(:)'*vTrial1;
            TrainTrial = xLooTrial*vTrial1;
            train = setdiff(1:nTrial,iTrial);
            classAll(iTrial) = classify(TestTrial(1,1:comps),TrainTrial(:,1:comps),modelChoice(train));
            %             classLex(iTrial) = classify(TestTrial(1,1:comps),TrainTrial(:,1:comps),modelLex(train));
            %             classTask(iTrial) = classify(TestTrial(1,1:comps),TrainTrial(:,1:comps),modelPhono(train));
            %             classPhono(iTrial) = classify(TestTrial(1,1:comps),TrainTrial(:,1:comps),modelTask(train));
            
        end
        
%         Pmatrix=zeros(8,8);
%         counter2=0;
%         for ii=1:8
%             val1=classAll(counter2+1:counter2+minTrial);
%             for ii2=1:8
%                 val2=find(val1==ii2);
%                 Pmatrix(ii,ii2)=length(val2)./minTrial;
%             end
%             counter2=counter2+minTrial;
%         end
        
        Pmatrix=zeros(2,2);
        iiPos=find(modelChoice==1);
        iiNeg=find(modelChoice==0);
        Pmatrix(1,1)=sum(classAll(iiPos))./length(iiPos);
        Pmatrix(1,2)=1-Pmatrix(1,1);
        Pmatrix(2,2)=sum(classAll(iiNeg))./length(iiNeg);
        Pmatrix(2,1)=1-Pmatrix(2,2);
        
%         counter2=0;
%         for ii=1:2
%             val1=classAll(counter2+1:counter2+minTrial);
%             for ii2=1:2
%                 val2=find(val1==1);
%                 Pmatrix(ii,ii2)=length(val2)./minTrial;
%             end
%             counter2=counter2+minTrial;
%         end
        
        
        PmatrixFULL(iChan,iTemp,:,:)=Pmatrix;
    end
    display(iChan)
end

PmatrixLex=[1,1,0,0,1,1,0,0;1,1,0,0,1,1,0,0;0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0;1,1,0,0,1,1,0,0;1,1,0,0,1,1,0,0;0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0];        
PmatrixTask=[1,1,1,1,0,0,0,0;1,1,1,1,0,0,0,0;1,1,1,1,0,0,0,0;1,1,1,1,0,0,0,0;0,0,0,0,1,1,1,1;0,0,0,0,1,1,1,1;0,0,0,0,1,1,1,1;0,0,0,0,1,1,1,1];
PmatrixPhono=[1,0,1,0,1,0,1,0;0,1,0,1,0,1,0,1;1,0,1,0,1,0,1,0;0,1,0,1,0,1,0,1;1,0,1,0,1,0,1,0;0,1,0,1,0,1,0,1;1,0,1,0,1,0,1,0;0,1,0,1,0,1,0,1];
%   fit1=glmnet(double(TrainTrial1(:,1:numcomps)),groups2,'multinomial');
%      % response=glmnetPredict(fit,'response',AUDCAT_LSJL1_test);
%       response1=glmnetPredict(fit1,'response',Test1Trial(1:numcomps));
%       % take end of respnise function?
%       response1B=sq(response1(:,:,end));
%       class1(iTrial,:)=response1B;   
% 

