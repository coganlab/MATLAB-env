function [SSession, NumTrials] = bsS(Area, Task, N)
%
%  [SSession, NumTrials] = bsS(Area, Task, N)
%

global BSAREALIST MONKEYDIR

if ~iscell(Area)  Area = str2cell(Area);  end

BSArea = BSAreaFields;
FieldSession = loadField_Database;
SpikeSession = loadSpike_Database;

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

Session = loadSpikeField_Database;
SF_FieldSessionNumbers = getSessionNumbers(Session);

Ind = [];
for iFSess = 1:length(FSession)
    Chamber = FSession{iFSess}{3}(1);
    Ch = FSession{iFSess}{4};
    SF_ind = find(SF_FieldSessionNumbers(:,2)==FieldSessionNumbers(iFSess));
    if ~isempty(SF_ind)
        for iSF_ind = 1:length(SF_ind)
            SpikeSessNum = Session{SF_ind(iSF_ind)}{6}(1);
            SpikeChamber = Session{SF_ind(iSF_ind)}{3}(1);
            SpikeCh = Session{SF_ind(iSF_ind)}{4}(1);
            if strcmp(SpikeChamber,Chamber) && SpikeCh==Ch
                Ind = [Ind, SpikeSessNum];
            end
        end
    end
end

if ~isempty(Ind)
  Ind = unique(Ind);
  SSession = SpikeSession(Ind);
else
  disp('No Spike Sessions');
  SSession = [];
end

if nargin > 1 && ~isempty(SSession)
    if isempty(Task); Task = ''; end
    if ischar(Task); Task = {Task}; end

    %  Preload NumTrials to speed things up
    SessionType = 'Spike';
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;

    NumTrials= zeros(length(SSession),length(Task));
    for iSSession = 1:length(SSession)
        NumTrials(iSSession,:) = loadSessionNumTrials(SSession{iSSession},Task, [], SessionNumTrials);
    end
end