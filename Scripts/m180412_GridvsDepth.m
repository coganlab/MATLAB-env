duke;
Subject = struct([]);
Subject(1).Name = 'D1'; Subject(1).Day = '260216'; % grid
Subject(3).Name = 'D3'; Subject(3).Day = '100916'; % grid
Subject(7).Name = 'D7'; Subject(7).Day = '030117'; % grid
Subject(8).Name = 'D8'; Subject(8).Day = '030317'; % depth
Subject(12).Name = 'D12'; Subject(12).Day = '090917'; % depth
Subject(13).Name = 'D13'; Subject(13).Day = '071017'; % depth
Subject(14).Name = 'D14'; Subject(14).Day = '101117'; % depth
Subject(15).Name= 'D15'; Subject(15).Day = '171217'; % depth
Subject(16).Name = 'D16'; Subject(16).Day = '200118'; % grid
Subject(101).Name = 'S1'; Subject(101).Day = '080318';
Subject(17).Name = 'D17'; Subject(17).Day = '180309'; % depth

% GRID? 1,3,7,16
% SEEG 8,12:15,17

for SN=[12:17] %[1,3,7:8,12:17];
    


Subject(SN).Experiment = loadExperiment(Subject(SN).Name);
Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');
%Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_CovertOvert'); % Test line
Trials = Subject(SN).Trials;
experiment = Subject(SN).Experiment;
global experiment
CondParams.Conds = [1:4];



%CondParams.bn = [-2500,3500];
%AnalParams.Tapers = [0.5,10];
AnalParams.Tapers = [.5,10];
%AnalParams.Tapers = [.25 16];
AnalParams.fk = 500;
AnalParams.Reference = 'Grand average'; % other is 'Single-ended';
AnalParams.ArtifactThreshold = 10;

if strcmp(Subject(SN).Name,'D1')
    AnalParams.Channel = [1:66];
    
elseif  strcmp(Subject(SN).Name,'D7')
    AnalParams.Channel = [1:102];
 %   AnalParams.Channel = [17:80]; % just grid
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
else
    AnalParams.Channel = [1:64];
end
CondParams.bn=[-500 2000];
NumTrials = SelectChannels(Subject(SN).Trials, CondParams, AnalParams);
%NumTrials=repmat(270,1,66);
%SelectedChannels = AnalParams.Channel(find(NumTrials > (0.8*length(Trials)))); %STRICT?
% SelectedChannels = AnalParams.Channel(find(NumTrials > (0.65*length(Trials)))); %LESS STRICT?
SelectedChannels=AnalParams.Channel; % really loose: accounts for practice trial confound
AnalParams.ReferenceChannels = SelectedChannels;
AnalParams.Channel = SelectedChannels;
AnalParams.TrialPooling = 1; %1;  %1; % used to be 1


trialStart=Trials(1).Start;
trialEnd=Trials(end).Go;

%Trials=[];
Trials=Trials(1);
CondParams.Conds=[1:4];
CondParams.Field = 'Start';
CondParams.bn = [1 floor((trialEnd-trialStart)./30)];
Subject(SN).Trials=Trials;
ieeg=trialIEEG(Trials,AnalParams.Channel,'Start',CondParams.bn);

Subject(SN).ieeg=ieeg;
Subject(SN).srate=Subject(SN).Experiment.recording.sample_rate;
%clear experiment; clear Subject(SN).experiment
end


% GRID? 1,3,7,16
% SEEG 8,12:15,17


counter=0;
for SN=[1,3,7:8,12:17];
    tVals(counter+1)=size(Subject(SN).ieeg,2);
    counter=counter+1;
    for iChan=1:size(Subject(SN).ieeg,1)
    [Spec, F] = tfspec(Subject(SN).ieeg(iChan,1:min(tVals)), [10 2], Subject(SN).srate, 5, [0 1000], 1, [], 0, [], []); 
    Subject(SN).Spec(iChan,:)=
end

Grid_Data=[];
for SN=[1,3,7,16];
    Grid_Data=cat(1,Grid_Data,Subject(SN).ieeg(:,1:min(tVals)));
end

Depth_Data=[];
for SN=[8,12:15,17];
    Depth_Data=cat(1,Depth_Data,Subject(SN).ieeg(:,1:min(tVals)));
end



