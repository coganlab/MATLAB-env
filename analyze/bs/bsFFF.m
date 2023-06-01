function [FFFSession, NumTrials] = bsFFF(Area1, Area2, Area3, Task)
%
%  [FFFSession, NumTrials] = bsFFF(Area1, Area2, Area3, Task)
%

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

% Find Fields in Area 1
Field1SessionNumbers = [];
for n = 1:nA1
    Field1SessionNumbers = [Field1SessionNumbers BSArea.(Area1{n})];
end

% Find field-field-field indices with fields in Area1
Session = loadFieldFieldField_Database;
FFFSessionNumbers = getSessionNumbers(Session);

FFFSessionIndices1 = [];
for iSess = 1:length(Field1SessionNumbers)
    ind1 = find(FFFSessionNumbers(:,1)==Field1SessionNumbers(iSess))';
    ind2 = find(FFFSessionNumbers(:,2)==Field1SessionNumbers(iSess))';
    ind3 = find(FFFSessionNumbers(:,3)==Field1SessionNumbers(iSess))';
    FFFSessionIndices1 = [FFFSessionIndices1 ind1 ind2 ind3];
end
FFFSessionIndices1 = unique(FFFSessionIndices1);


% Now find indices with Area2
% If no second argument is given, take all sessions with Area1 
if nargin < 2
    FFFSessionIndices2 = 1:length(FFFSessionNumbers);
else %We have to go through as we did with Area1
    nA2 = length(Area2);
    for n = 1:nA2
        if ~find(strcmp(BSAREALIST, Area2{n}))
            error([Area2{n} ' is not in BSAREALIST']);
        end
    end
    
    FieldSessionNumbers2 = [];
    for n = 1:nA2
        FieldSessionNumbers2 = [FieldSessionNumbers2 BSArea.(Area2{n})];
    end

    FFFSessionIndices2 = []; allind1 = []; allind2 = []; allind3 = [];
    for iSess = 1:length(FieldSessionNumbers2)
        ind1 = find(FFFSessionNumbers(:,1)==FieldSessionNumbers2(iSess))';
        ind2 = find(FFFSessionNumbers(:,2)==FieldSessionNumbers2(iSess))';
        ind3 = find(FFFSessionNumbers(:,3)==FieldSessionNumbers2(iSess))';
        FFFSessionIndices2 = [FFFSessionIndices2 ind1 ind2 ind3];
        allind1 = [allind1 ind1];
        allind2 = [allind2 ind2];
        allind3 = [allind3 ind3];
    end
    FFFSessionIndices2 = unique(FFFSessionIndices2);
    
    % Special case: Area1 = Area2
    if length(FFFSessionIndices1) == length(FFFSessionIndices2)
        comparison = FFFSessionIndices1 == FFFSessionIndices2;
        if sum(comparison) == length(comparison)
            FFFSessionIndices2 = unique([intersect(allind1,allind2) intersect(allind2,allind3) intersect(allind1,allind3)]);
        end
    end
end

% Now find indices with Area3
% If no third argument is given, take all sessions with Area1 & Area2 
if nargin < 3
    FFFSessionIndices3 = 1:length(FFFSessionNumbers);
else %We have to go through as we did with Area1
    nA3 = length(Area3);
    for n = 1:nA3
        if ~find(strcmp(BSAREALIST, Area3{n}))
            error([Area3{n} ' is not in BSAREALIST']);
        end
    end
    
    FieldSessionNumbers3 = [];
    for n = 1:nA3
        FieldSessionNumbers3 = [FieldSessionNumbers3 BSArea.(Area3{n})];
    end

    FFFSessionIndices3 = []; allind1 = []; allind2 = []; allind3 = [];
    for iSess = 1:length(FieldSessionNumbers3)
        ind1 = find(FFFSessionNumbers(:,1)==FieldSessionNumbers3(iSess))';
        ind2 = find(FFFSessionNumbers(:,2)==FieldSessionNumbers3(iSess))';
        ind3 = find(FFFSessionNumbers(:,3)==FieldSessionNumbers3(iSess))';
        FFFSessionIndices3 = [FFFSessionIndices3 ind1 ind2 ind3];
        allind1 = [allind1 ind1];
        allind2 = [allind2 ind2];
        allind3 = [allind3 ind3];
    end
    FFFSessionIndices3 = unique(FFFSessionIndices3);
    
    % Special case: Area3 = Area1
    if length(FFFSessionIndices3) == length(FFFSessionIndices1)
        comparison1 = FFFSessionIndices3 == FFFSessionIndices1;
        if sum(comparison1) == length(comparison1)
            FFFSessionIndices3 = unique([intersect(allind1,allind2) intersect(allind2,allind3) intersect(allind1,allind3)]);
            FFFSessionIndices1 = unique([intersect(allind1,allind2) intersect(allind2,allind3) intersect(allind1,allind3)]);
        end
    end
    % Special case: Area3 = Area2
    if length(FFFSessionIndices3) == length(FFFSessionIndices2)
        comparison2 = FFFSessionIndices3 == FFFSessionIndices2;
        if sum(comparison2) == length(comparison2)
            FFFSessionIndices3 = unique([intersect(allind1,allind2) intersect(allind2,allind3) intersect(allind1,allind3)]);
        end
    end
    % Special case: Area3 = Area1 = Area2
    if length(FFFSessionIndices3) == length(FFFSessionIndices1) && length(FFFSessionIndices3) == length(FFFSessionIndices2)
        comparison1 = FFFSessionIndices3 == FFFSessionIndices1;
        comparison2 = FFFSessionIndices3 == FFFSessionIndices2;
        if sum(comparison1) == length(comparison1) && sum(comparison2) == length(comparison2)
            FFFSessionIndices3 = intersect(intersect(allind1,allind2),allind3);
        end
    end
end

%Now find the overlap
FFFSessionIndices = intersect(intersect(FFFSessionIndices1,FFFSessionIndices2),FFFSessionIndices3);
%FFFSession = Session(FFFSessionIndices);


if ~isempty(FFFSessionIndices)
    FFFSessionIndices = unique(FFFSessionIndices);
    FFFSession = Session(FFFSessionIndices);
else
  disp('No Field-Field-Field Sessions');
  FFFSession = [];
end


%  Now do the task selection
if nargin > 3
    if isempty(Task); Task = ''; end
    if ischar(Task); Task = {Task}; end
    SessionType = 'FieldFieldField';
    %Session = loadFieldFieldField_Database;
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;

    NumTrials= zeros(length(FFFSession),length(Task));
    for iFFFSession = 1:length(FFFSession)
        NumTrials(iFFFSession,:) = loadSessionNumTrials(FFFSession{iFFFSession},Task, [], SessionNumTrials, Session);
    end
end