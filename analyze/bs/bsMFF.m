function [MFFSession, NumTrials] = bsMFF(Area1, Area2, Area3, Task)
%
%  [MFFSession, NumTrials] = bsMFF(Area1, Area2, Area3, Task)
%
% Needs contact info

global BSAREALIST MONKEYDIR

if isempty(Area1); Area1 = BSAREALIST; end
if isempty(Area2); Area2 = BSAREALIST; end
if isempty(Area3); Area3 = BSAREALIST; end

if ~iscell(Area1); Area1 = str2cell(Area1);  end
if ~iscell(Area2); Area2 = str2cell(Area2);  end
if ~iscell(Area3); Area3 = str2cell(Area3);  end

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
Session = loadMultiunitFieldField_Database;
MFFSessionNumbers = getSessionNumbers(Session);

MFFSessionIndices1 = [];
for iSess = 1:length(Field1SessionNumbers)
    ind1 = find(MFFSessionNumbers(:,2)==Field1SessionNumbers(iSess))';
    ind2 = find(MFFSessionNumbers(:,3)==Field1SessionNumbers(iSess))';
    MFFSessionIndices1 = [MFFSessionIndices1 ind1 ind2];
end
MFFSessionIndices1 = unique(MFFSessionIndices1);


% Now find indices with Area3
% If no second argument is given, take all sessions with Area2
if nargin < 3
    MFFSessionIndices2 = 1:length(MFFSessionNumbers);
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
    
    MFFSessionIndices2 = [];    allind1 = [];    allind2 = [];
    for iSess = 1:length(Field2SessionNumbers)
        ind1 = find(MFFSessionNumbers(:,2)==Field2SessionNumbers(iSess))';
        ind2 = find(MFFSessionNumbers(:,3)==Field2SessionNumbers(iSess))';
        MFFSessionIndices2 = [MFFSessionIndices2 ind1 ind2];
        allind1 = [allind1 ind1];
        allind2 = [allind2 ind2];
    end
    MFFSessionIndices2 = unique(MFFSessionIndices2);
    
    % Special case: Area2 = Area3
    if length(MFFSessionIndices1) == length(MFFSessionIndices2)
        comparison = MFFSessionIndices1 == MFFSessionIndices2;
        if sum(comparison) == length(comparison)
            MFFSessionIndices2 = intersect(allind1,allind2);
        end
    end
end

%Now find the overlap
MFFSessionIndices = intersect(MFFSessionIndices1,MFFSessionIndices2);
MFFSession = Session(MFFSessionIndices);

if ~isempty(MFFSession)
    %  Now need to find spikes in each of these in area 1
    
    % First, get Fields with the right label
    FieldSession = loadField_Database;
    FieldSessionNumbers1 = [];
    for n = 1:nA1
        FieldSessionNumbers1 = [FieldSessionNumbers1 BSArea.(Area1{n})];
    end
    FSession = FieldSession(FieldSessionNumbers1);
    
    if ~isempty(FSession)
        %  Go through each candidate MFF Session, and see if the spike ch matches
        %  a field that is known to be in area 1
        
        FieldChamber = sessTower(FSession);
        FieldCh = sessElectrode(FSession);
        MultiunitChamber = sessTower(MFFSession);
        MultiunitCh = sessElectrode(MFFSession);
        MultiunitCh = MultiunitCh(:,1);
        
        SessInd = [];
        for iMFFSess = 1:length(MFFSession)
            MultiunitDay = MFFSession{iMFFSess}{1};
            for iFSess = 1:length(FSession)
                FieldDay = FSession{iFSess}{1};
                if strcmp(MultiunitChamber{iMFFSess},FieldChamber{iFSess}) && MultiunitCh(iMFFSess)==FieldCh(iFSess) && ...
                        strcmp(MultiunitDay,FieldDay);
                    SessInd = [SessInd, iMFFSess];
                end
            end
        end
        
        if ~isempty(SessInd)
            SessInd = unique(SessInd);
            MFFSession = MFFSession(SessInd);
        else
            disp('No Multiunit-Field-Field Sessions');
            MFFSession = [];
        end
    else
        disp('No Multiunit-Field-Field Sessions');
        MFFSession = [];
    end
else
    disp('No Multiunit-Field-Field Sessions');
    MFFSession = [];
end

%  Now do the task selection
if nargin > 3
    if isempty(Task); Task = ''; end
    if ischar(Task); Task = {Task}; end

    SessionType = 'MultiunitFieldField';
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;

    NumTrials= zeros(length(MFFSession),length(Task));
    for iMFFSession = 1:length(MFFSession)
        NumTrials(iMFFSession,:) = loadSessionNumTrials(MFFSession{iMFFSession},Task, [], SessionNumTrials, Session);
    end
end