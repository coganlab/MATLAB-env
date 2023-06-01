function [SFFSession, NumTrials] = bsSFF(Area1, Area2, Area3, Task)
%
%  [SFFSession, NumTrials] = bsSFF(Area1, Area2, Area3, Task)
%
% Needs contact info

global BSAREALIST MONKEYDIR

if isempty(Area1) Area1 = BSAREALIST; end
if isempty(Area2) Area2 = BSAREALIST; end
if isempty(Area3) Area3 = BSAREALIST; end

if ~iscell(Area1)  Area1 = str2cell(Area1);  end
if ~iscell(Area2)  Area2 = str2cell(Area2);  end
if ~iscell(Area3)  Area3 = str2cell(Area3);  end

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
Field1SessionNumbers = [];
for n = 1:nA2
    Field1SessionNumbers = [Field1SessionNumbers BSArea.(Area2{n})];
end

% Find spike-field-field indices with fields in Area2
Session = loadSpikeFieldField_Database;
SFFSessionNumbers = getSessionNumbers(Session);

SFFSessionIndices1 = [];
for iSess = 1:length(Field1SessionNumbers)
    ind1 = find(SFFSessionNumbers(:,2)==Field1SessionNumbers(iSess))';
    ind2 = find(SFFSessionNumbers(:,3)==Field1SessionNumbers(iSess))';
    SFFSessionIndices1 = [SFFSessionIndices1 ind1 ind2];
end
SFFSessionIndices1 = unique(SFFSessionIndices1);


% Now find indices with Area3
% If no second argument is given, take all sessions with Area2
if nargin < 3
    SFFSessionIndices2 = 1:length(SFFSessionNumbers);
else %We have to go through as we did with Area2
    nA3 = length(Area3);
    for n = 1:nA3
        if ~find(strcmp(BSAREALIST, Area3{n}))
            error([Area3{n} ' is not in BSAREALIST']);
        end
    end
    
    Field2SessionNumbers = [];
    for n = 1:nA3
        Field2SessionNumbers = [Field2SessionNumbers BSArea.(Area3{n})];
    end
    
    SFFSessionIndices2 = [];    allind1 = [];    allind2 = [];
    for iSess = 1:length(Field2SessionNumbers)
        ind1 = find(SFFSessionNumbers(:,2)==Field2SessionNumbers(iSess))';
        ind2 = find(SFFSessionNumbers(:,3)==Field2SessionNumbers(iSess))';
        SFFSessionIndices2 = [SFFSessionIndices2 ind1 ind2];
        allind1 = [allind1 ind1];
        allind2 = [allind2 ind2];
    end
    SFFSessionIndices2 = unique(SFFSessionIndices2);
    
    % Special case: Area2 = Area3
    if length(SFFSessionIndices1) == length(SFFSessionIndices2)
        comparison = SFFSessionIndices1 == SFFSessionIndices2;
        if sum(comparison) == length(comparison)
            SFFSessionIndices2 = intersect(allind1,allind2);
        end
    end
end

%Now find the overlap
SFFSessionIndices = intersect(SFFSessionIndices1,SFFSessionIndices2);
SFFSession = Session(SFFSessionIndices);

if ~isempty(SFFSession)
    %  Now need to find spikes in each of these in area 1
    
    % First, get Fields with the right label
    FieldSession = loadField_Database;
    FieldSessionNumbers1 = [];
    for n = 1:nA1
        FieldSessionNumbers1 = [FieldSessionNumbers1 BSArea.(Area1{n})];
    end
    FSession = FieldSession(FieldSessionNumbers1);
    
    if ~isempty(FSession)
        %  Go through each candidate SFF Session, and see if the spike ch matches
        %  a field that is known to be in area 1
        
        FieldChamber = sessTower(FSession);
        FieldCh = sessElectrode(FSession);
        SpikeChamber = sessTower(SFFSession);
        SpikeCh = sessElectrode(SFFSession);
        SpikeCh = SpikeCh(:,1);
        
        SessInd = [];
        for iSFFSess = 1:length(SFFSession)
            SpikeDay = SFFSession{iSFFSess}{1};
            for iFSess = 1:length(FSession)
                FieldDay = FSession{iFSess}{1};
                if strcmp(SpikeChamber{iSFFSess},FieldChamber{iFSess}) && SpikeCh(iSFFSess)==FieldCh(iFSess) && ...
                        strcmp(SpikeDay,FieldDay);
                    SessInd = [SessInd, iSFFSess];
                end
            end
        end
        
        if ~isempty(SessInd)
            SessInd = unique(SessInd);
            SFFSession = SFFSession(SessInd);
        else
            disp('No Spike-Field-Field Sessions');
            SFFSession = [];
        end
    else
        disp('No Spike-Field-Field Sessions');
        SFFSession = [];
    end
else
    disp('No Spike-Field-Field Sessions');
    SFFSession = [];
end

%  Now do the task selection
if nargin > 3
    if isempty(Task); Task = ''; end
    if ischar(Task); Task = {Task}; end

    SessionType = 'SpikeFieldField';
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;

    NumTrials= zeros(length(SFFSession),length(Task));
    for iSFFSession = 1:length(SFFSession)
        NumTrials(iSFFSession,:) = loadSessionNumTrials(SFFSession{iSFFSession},Task, [], SessionNumTrials, Session);
    end
end