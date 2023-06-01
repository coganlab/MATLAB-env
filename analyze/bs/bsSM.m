function [SMSession, NumTrials] = bsSM(Area1, Area2, Task)
%
%  [SMSession, NumTrials] = bsSM(Area1, Area2, Task)
%


global BSAREALIST MONKEYDIR

if isempty(Area1) Area1 = BSAREALIST; end
if isempty(Area2) Area2 = BSAREALIST; end

if ~iscell(Area1)  Area1 = str2cell(Area1);  end
if ~iscell(Area2)  Area2 = str2cell(Area2);  end
    
BSArea = BSAreaFields;

nA1 = length(Area1);
for n = 1:nA1
    if ~find(strcmp(BSAREALIST, Area1{n}))
        error([Area1{n} ' is not in BSAREALIST']);
    end
end

nA2 = length(Area2);
for n = 1:nA2
    if ~find(strcmp(BSAREALIST, Area2{n}))
        error([Area2{n} ' is not in BSAREALIST']);
    end
end


% Find spike-spike indices with fields in Area1
Session = loadSpikeMultiunit_Database;

FieldSession = loadField_Database;
FieldSessionNumbers1 = [];
for n = 1:nA1
   FieldSessionNumbers1 = [FieldSessionNumbers1 BSArea.(Area1{n})];
end
FSession = FieldSession(FieldSessionNumbers1);

SMSessionIndices = [];
for iSess = 1:length(Session)
    SpikeDay = Session{iSess}{1};
    SpikeChamber = sessTower(Session{iSess});
    SpikeChamber = SpikeChamber{1};
    %if iscell(SpikeChamber); SpikeChamber = SpikeChamber{1}; end
    SpikeCh = sessElectrode(Session{iSess});
    SpikeCh = SpikeCh(1);
    for iFSess = 1:length(FSession)
        FieldDay = FSession{iFSess}{1};
        FieldChamber = FSession{iFSess}{3}{1};
        FieldCh = FSession{iFSess}{4}(1);
        if strcmp(SpikeChamber,FieldChamber) && SpikeCh==FieldCh && ...
                strcmp(SpikeDay,FieldDay);
            SMSessionIndices= [SMSessionIndices, iSess];
        end
    end
end
SMSessionIndices = unique(SMSessionIndices);
SMSession = Session(SMSessionIndices);


%  Now need to find spikes in each of these in area 2
% First, get Fields with the right label
FieldSessionNumbers2 = [];
for n = 1:nA2
   FieldSessionNumbers2 = [FieldSessionNumbers2 BSArea.(Area2{n})];
end
FSession = FieldSession(FieldSessionNumbers2);

%  Go through each candidate SM Session, and see if the multiunit ch matches
%  a field that is known to be in area 2
SMInd = [];
for iSMSess = 1:length(SMSession)
    MultiunitDay = SMSession{iSMSess}{1};
    Chambers = sessTower(Session{iSMSess});
    MultiunitChamber = Chambers{2};
    Channels = sessElectrode(SMSession{iSMSess});
    MultiunitCh = Channels(2);
    for iFSess = 1:length(FSession)
        FieldDay = FSession{iFSess}{1};
        FieldChamber = sessTower(FSession{iFSess});
        FieldChamber = FieldChamber{1};
        FieldCh = sessElectrode(FSession{iFSess});
        if strcmp(MultiunitChamber,FieldChamber) && MultiunitCh==FieldCh && ...
                strcmp(MultiunitDay,FieldDay);
            SMInd = [SMInd, iSMSess];
        end
    end
end

if ~isempty(SMInd)
    SMInd = unique(SMInd);
    SMSession = SMSession(SMInd);
else
  disp('No Spike-Multiunit Sessions');
  SMSession = [];
end


%  Now do the task selection
if nargin > 2
    if isempty(Task); Task = ''; end

    if ischar(Task); Task = {Task}; end

    SessionType = 'SpikeMultiunit';
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;

    NumTrials= zeros(length(SMSession),length(Task));
    for iSMSession = 1:length(SMSession)
        NumTrials(iSMSession,:) = loadSessionNumTrials(SMSession{iSMSession},Task, [], SessionNumTrials, Session);
    end
end



