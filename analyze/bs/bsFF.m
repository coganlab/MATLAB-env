function [FFSession, NumTrials] = bsFF(Area1, Area2, Task)
%
%  [FFSession, NumTrials] = bsFF(Area1, Area2, Task)
%

global BSAREALIST MONKEYDIR

if ~iscell(Area1);  Area1 = str2cell(Area1);  end

BSArea = BSAreaFields;
FieldSession = loadField_Database;

nA1 = length(Area1);
for n = 1:nA1
    if ~find(strcmp(BSAREALIST, Area1{n}))
        error([Area1{n} ' is not in BSAREALIST']);
    end
end

FieldSessionNumbers = [];
for n = 1:nA1
    FieldSessionNumbers = [FieldSessionNumbers BSArea.(Area1{n})];
end

Session = loadFieldField_Database;
FFSessionNumbers = getSessionNumbers(Session);

% Find indices with Area1
FFSessionIndices1 = [];
for iSess = 1:length(FieldSessionNumbers)
    ind1 = find(FFSessionNumbers(:,1)==FieldSessionNumbers(iSess))';
    ind2 = find(FFSessionNumbers(:,2)==FieldSessionNumbers(iSess))';
    FFSessionIndices1 = [FFSessionIndices1 ind1 ind2];
end
FFSessionIndices1 = unique(FFSessionIndices1);

% Now find indices with Area2
% If no second argument is given, take all sessions with Area1 
if nargin == 1
    FFSessionIndices2 = 1:length(FFSessionNumbers);
else %We have to go through as we did with Area1
    if ~iscell(Area2);  Area2 = str2cell(Area2);  end
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

    FFSessionIndices2 = [];    allind1 = [];    allind2 = [];
    for iSess = 1:length(FieldSessionNumbers2)
        ind1 = find(FFSessionNumbers(:,1)==FieldSessionNumbers2(iSess))';
        ind2 = find(FFSessionNumbers(:,2)==FieldSessionNumbers2(iSess))';
        FFSessionIndices2 = [FFSessionIndices2 ind1 ind2];
        allind1 = [allind1 ind1];
        allind2 = [allind2 ind2];
    end
    FFSessionIndices2 = unique(FFSessionIndices2);
    
    % Special case: Area1 = Area2
    if length(FFSessionIndices1) == length(FFSessionIndices2)
        comparison = FFSessionIndices1 == FFSessionIndices2;
        if sum(comparison) == length(comparison)
            FFSessionIndices2 = intersect(allind1,allind2);
        end
    end
end

%Now find the overlap
FFSessionIndices = intersect(FFSessionIndices1,FFSessionIndices2);
FFSession = Session(FFSessionIndices);

%  Now do the task selection
if nargin > 2
    if isempty(Task); Task = ''; end

    if ischar(Task); Task = {Task}; end

    SessionType = 'FieldField';
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;

    NumTrials= zeros(length(FFSession),length(Task));
    for iFFSession = 1:length(FFSession)
        NumTrials(iFFSession,:) = loadSessionNumTrials(FFSession{iFFSession},Task, [], SessionNumTrials, Session);
    end
end



