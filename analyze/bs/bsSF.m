function [SFSession, NumTrials] = bsSF(Area1, Area2, Task)
%
%  [SFSession, NumTrials] = bsSF(Area1, Area2, Task)
%
% Needs contact info

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

% Find Fields in Area 2
FieldSessionNumbers = [];
for n = 1:nA2
    FieldSessionNumbers = [FieldSessionNumbers BSArea.(Area2{n})];
end

% Find spike-field indices with fields in Area2
Session = loadSpikeField_Database;
SFSessionNumbers = getSessionNumbers(Session);

SFSessionIndices = [];
for iSess = 1:length(FieldSessionNumbers)
    ind = find(SFSessionNumbers(:,2)==FieldSessionNumbers(iSess))';
    SFSessionIndices = [SFSessionIndices ind];
end
SFSessionIndices = unique(SFSessionIndices);
SFSession = Session(SFSessionIndices);

%  Now need to find spikes in each of these in area 1

if ~isempty(SFSession)
    % First, get Fields with the right label
    FieldSession = loadField_Database;
    FieldSessionNumbers1 = [];
    for n = 1:nA1
        FieldSessionNumbers1 = [FieldSessionNumbers1 BSArea.(Area1{n})];
    end
    FSession = FieldSession(FieldSessionNumbers1);
    
    if ~isempty(FSession)
        %  Go through each candidate SF Session, and see if the spike ch matches
        %  a field that is known to be in area 1
        
        FieldChamber = sessTower(FSession);
        FieldCh = sessElectrode(FSession);
        SFChamber = sessTower(SFSession);
        SpikeChamber = SFChamber(:,1);
        SpikeCh = sessElectrode(SFSession);
        SpikeCh = SpikeCh(:,1);
        
        SFInd = [];
        for iSFSess = 1:length(SFSession)
            SpikeDay = SFSession{iSFSess}{1};
            for iFSess = 1:length(FSession)
                FieldDay = FSession{iFSess}{1};
                if strcmp(SpikeChamber{iSFSess},FieldChamber{iFSess}) && SpikeCh(iSFSess)==FieldCh(iFSess) && ...
                        strcmp(SpikeDay,FieldDay);
                    SFInd = [SFInd, iSFSess];
                end
            end
        end
        
        if ~isempty(SFInd)
            SFInd = unique(SFInd);
            SFSession = SFSession(SFInd);
        else
            disp('No Spike-Field Sessions');
            SFSession = [];
        end
    else
        disp('No Spike-Field Sessions');
        SFSession = [];
    end
else
    disp('No Spike-Field Sessions');
    SFSession = [];
end


%  Now do the task selection
if nargin > 2
    if isempty(Task); Task = ''; end
    
    if ischar(Task); Task = {Task}; end
    
    SessionType = 'SpikeField';
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;
    
    NumTrials= zeros(length(SFSession),length(Task));
    for iSFSession = 1:length(SFSession)
        NumTrials(iSFSession,:) = loadSessionNumTrials(SFSession{iSFSession},Task, [], SessionNumTrials, Session);
    end
end