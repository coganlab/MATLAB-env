function [MFSession, NumTrials] = bsMF(Area1, Area2, Task)
%
%  [MFSession, NumTrials] = bsMF(Area1, Area2, Task)
%
% Needs contact info

global BSAREALIST MONKEYDIR

if isempty(Area1); Area1 = BSAREALIST; end
if isempty(Area2); Area2 = BSAREALIST; end

if ~iscell(Area1); Area1 = str2cell(Area1);  end
if ~iscell(Area2); Area2 = str2cell(Area2);  end

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

% Find multiunit-field indices with fields in Area2
Session = loadMultiunitField_Database;
MFSessionNumbers = getSessionNumbers(Session);

MFSessionIndices = [];
for iSess = 1:length(FieldSessionNumbers)
    ind = find(MFSessionNumbers(:,2)==FieldSessionNumbers(iSess))';
    MFSessionIndices = [MFSessionIndices ind];
end
MFSessionIndices = unique(MFSessionIndices);
MFSession = Session(MFSessionIndices);

%  Now need to find spikes in each of these in area 1

if ~isempty(MFSession)
    
    % First, get Fields with the right label
    FieldSession = loadField_Database;
    FieldSessionNumbers1 = [];
    for n = 1:nA1
        FieldSessionNumbers1 = [FieldSessionNumbers1 BSArea.(Area1{n})];
    end
    FSession = FieldSession(FieldSessionNumbers1);
    
    if ~isempty(FSession)
        %  Go through each candidate MF Session, and see if the spike ch matches
        %  a field that is known to be in area 1
        
        FieldChamber = sessTower(FSession);
        FieldCh = sessElectrode(FSession);
        MFChamber = sessTower(MFSession);
        MultiunitChamber = MFChamber(:,1);
        MultiunitCh = sessElectrode(MFSession);
        MultiunitCh = MultiunitCh(:,1);
        
        MFInd = [];
        for iMFSess = 1:length(MFSession)
            MultiunitDay = MFSession{iMFSess}{1};
            for iFSess = 1:length(FSession)
                FieldDay = FSession{iFSess}{1};
                if strcmp(MultiunitChamber{iMFSess},FieldChamber{iFSess}) && MultiunitCh(iMFSess)==FieldCh(iFSess) && ...
                        strcmp(MultiunitDay,FieldDay);
                    MFInd = [MFInd, iMFSess];
                end
            end
        end
        
        if ~isempty(MFInd)
            MFInd = unique(MFInd);
            MFSession = MFSession(MFInd);
        else
            disp('No Multiunit-Field Sessions');
            MFSession = [];
        end
    else
        disp('No Multiunit-Field Sessions');
        MFSession = [];
    end
else
    disp('No Multiunit-Field Sessions');
    MFSession = [];
end

%  Now do the task selection
if nargin > 2
    if isempty(Task); Task = ''; end

    if ischar(Task); Task = {Task}; end

    SessionType = 'MultiunitField';
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;

    NumTrials= zeros(length(MFSession),length(Task));
    for iMFSession = 1:length(MFSession)
        NumTrials(iMFSession,:) = loadSessionNumTrials(MFSession{iMFSession},Task, [], SessionNumTrials, Session);
    end
end


