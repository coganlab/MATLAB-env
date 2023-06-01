function [FSession, NumTrials] = bsF(Area, Task, N)
%
%  [FSession, NumTrials] = bsF(Area, Task, N)
%
%  Task and N are optional selection parameter for Sessions

global BSAREALIST MONKEYDIR

if ~iscell(Area);  Area = str2cell(Area);  end

BSArea = BSAreaFields;
FieldSession = loadField_Database;

nA = length(Area);
for n = 1:nA
    if ~find(strcmp(BSAREALIST, Area{n}))
        error([Area{n} ' is not in BSAREALIST']);
    end
end

FieldSessionNumbers = [];
for n = 1:nA
    FieldSessionNumbers = [FieldSessionNumbers BSArea.(Area{n})];
end

FSession = FieldSession(FieldSessionNumbers);

if nargin > 1
    if isempty(Task); Task = ''; end
    if ischar(Task); Task = {Task}; end

    %  Preload NumTrials to speed things up
    SessionType = 'Field';
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;

    NumTrials= zeros(length(FSession),length(Task));
    for iFSession = 1:length(FSession)
        tr = sessTrials(FSession{iFSession}, Task);
        NumTrials(iFSession,:) = length(tr);
    end
%     for iFSession = 1:length(FSession)
%         NumTrials(iFSession,:) = loadSessionNumTrials(FSession{iFSession},Task, [], SessionNumTrials);
%     end
end



