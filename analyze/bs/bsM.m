function [MSession, NumTrials] = bsM(Area, Task, N)
%
%  [MSession, NumTrials] = bsM(Area, Task, N)
%

global BSAREALIST MONKEYDIR

if ~iscell(Area);  Area = str2cell(Area);  end

BSArea = BSAreaFields;
FieldSession = loadField_Database;
MultiunitSession = loadMultiunit_Database;

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

MF_Session = loadMultiunitField_Database;
MF_SessionNumbers = getSessionNumbers(MF_Session);

Ind = []; Ind2 = [];
for iFSess = 1:length(FSession)
    Chamber = FSession{iFSess}{3}{1};
    Ch = FSession{iFSess}{4};
    MF_ind = find(MF_SessionNumbers(:,2) == FieldSessionNumbers(iFSess));
    if ~isempty(MF_ind)
        for iMF_ind = 1:length(MF_ind)
            MultiunitSessNum = MF_Session{MF_ind(iMF_ind)}{6}(1);
            FieldSessNum = MF_Session{MF_ind(iMF_ind)}{6}(2);
            MultiunitChamber = MF_Session{MF_ind(iMF_ind)}{3}{1};
            MultiunitCh = MF_Session{MF_ind(iMF_ind)}{4}(1);
            if strcmp(MultiunitChamber,Chamber) && MultiunitCh==Ch
                Ind = [Ind, MultiunitSessNum];
                Ind2 = [Ind2, FieldSessNum];
            end
        end
    end
end

if ~isempty(Ind)
  Ind = unique(Ind);
  MSession = MultiunitSession(Ind);
else
  disp('No Multiunit Sessions');
  MSession = [];
end

if nargin > 1 && ~isempty(MSession)
    if isempty(Task); Task = ''; end
    if ischar(Task); Task = {Task}; end

    %  Preload NumTrials to speed things up
    SessionType = 'Multiunit';
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;

    NumTrials= zeros(length(MSession),length(Task));
    for iMSession = 1:length(MSession)
        NumTrials(iMSession,:) = loadSessionNumTrials(MSession{iMSession},Task, [], SessionNumTrials);
    end
end