%duke;
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
Subject(13).Name = 'D16'; Subject(13).Day = '200118';
Subject(14).Name = 'S1'; Subject(14).Day = '080318';
Subject(15).Name = 'D17'; Subject(15).Day = '180309'; % 180309 = lexical between, 180310 = lexical long no delay
Subject(16).Name = 'S6'; Subject(16).Day = '180727';
Subject(17).Name = 'D20'; Subject(17).Day = '180518';
Subject(18).Name = 'D22'; Subject(18).Day = '270618';
Subject(19).Name = 'D23'; Subject(19).Day = '130818';
Subject(20).Name = 'S6'; Subject(20).Day = '180727';
Subject(21).Name = 'D19'; Subject(21).Day = '180414';

SN = 21;
Subject(SN).Experiment = loadExperiment(Subject(SN).Name);
Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');
%Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_CovertOvert'); % Test line
Trials = Subject(SN).Trials;
experiment = Subject(SN).Experiment;

CondParams.Conds = [1:4];



%CondParams.bn = [-2500,3500];
%AnalParams.Tapers = [0.5,10];


if strcmp(Subject(SN).Name,'D1')
    AnalParams.Channel = [1:66];
    
elseif  strcmp(Subject(SN).Name,'D7')
 %   AnalParams.Channel = [1:102];
    AnalParams.Chcaannel = [17:80]; % just grid
elseif  strcmp(Subject(SN).Name,'D3')
    AnalParams.Channel = [1:52];
    badChans=[12];
    AnalParams.Channel=setdiff(AnalParams.Channel,badChans);
elseif strcmp(Subject(SN).Name,'D8')
    AnalParams.Channel = [1:110];
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
elseif strcmp(Subject(SN).Name,'S6');
   AnalParams.Channel=setdiff(1:256,[12,32,53,66,96,128,130,160,192,204,224,245]);
elseif strcmp(Subject(SN).Name,'D20');
    AnalParams.Channel=[10:129];
elseif strcmp(Subject(SN).Name,'D22');
    AnalParams.Channel=[1:100];
elseif strcmp(Subject(SN).Name,'D23');
        AnalParams.Channel=[1:121];
elseif strcmp(Subject(SN).Name,'D19');
    AnalParams.Channel=[1:76];
else
    AnalParams.Channel = [1:64];
end
CondParams.Conds=1:18;
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
AnalParams.ArtifactThreshold = 8; %8 %12;

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

CondParams.Conds=[1:18];
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

CondParams.Conds=[1:18];
CondParams.Field = 'Go';
CondParams.bn = [-500,1500];
for iCode = 1:length(Auditory_Spec)
    if isfield(CondParams,'Conds2')
        CondParams.Conds = CondParams.Conds2(iCode);
    else
        CondParams.Conds = iCode;
    end
    tic
    [Motor_Spec{iCode}, Motor_Data, Motor_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
    toc
    display(['Cond = ' num2str(iCode)])
end
% %
% 
% CondParams.Conds=[1:18];
% CondParams.Field = 'Del';
% CondParams.bn = [-500,5000];
% for iCode = 1:length(Auditory_Spec)
%     if isfield(CondParams,'Conds2')
%         CondParams.Conds = CondParams.Conds2(iCode);
%     else
%         CondParams.Conds = iCode;
%     end
%     tic
%     [Del_Spec{iCode}, Del_Data, Del_Trials{iCode}] = subjSpectrum(Subject(SN), CondParams, AnalParams);
%     toc
%     display(['Cond = ' num2str(iCode)])
% end


%Clear Auditory_nSpec Motor_nSpec
base=0;
%base = zeros(1,size(Auditory_Spec{iCode}{iCh},2));
for iCh = 1:length(Auditory_Spec{iCode})
    base=0;
    for iCode = 1:length(Auditory_Spec)
        %base = base + sq(Auditory_Spec{iCode}{iCh}(5,:)); % standard
        base= base+mean(sq(Auditory_Spec{iCode}{iCh}(1:10,:)),1); % used to be 1:9
        
        %base2(iCode,:)=std(sq(Auditory_Spec{iCode}{iCh}(1:6,:)),1); % std across time bins?       
        
    end
    base = base./length(Auditory_Spec);
    for iCode = 1:length(Auditory_Spec)
        Auditory_nSpec(iCode,iCh,:,:) = Auditory_Spec{iCode}{iCh}(:,:)./base(ones(1,size(Auditory_Spec{iCode}{iCh},1)),:);
        Motor_nSpec(iCode,iCh,:,:) = Motor_Spec{iCode}{iCh}(:,:)./base(ones(1,size(Motor_Spec{iCode}{iCh},1)),:);
      %  Start_nSpec(iCode,iCh,:,:) = Start_Spec{iCode}{iCh}(:,:)./base(ones(1,size(Start_Spec{iCode}{iCh},1)),:);
       % Del_nSpec(iCode,iCh,:,:) = Del_Spec{iCode}{iCh}(:,:)./base(ones(1,size(Del_Spec{iCode}{iCh},1)),:);
        %Auditory_nSpec(iCode,iCh,:,:)=(sq(Auditory_Spec{iCode}{iCh}(:,:))-base2)./(repmat(base,80,1)); % SD LINE
        
    end
    
end


% if no trialpooling and individual trial baselines; make sure motor and
% auditory specs have the same number of trials (set a large outlier value,
% e.g. 16
