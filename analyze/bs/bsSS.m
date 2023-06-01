function [SSSession, NumTrials] = bsSS(Area1, Area2, Task)
%
%  [SSSession, NumTrials] = bsSS(Area1, Area2, Task)
%


global BSAREALIST MONKEYDIR

if isempty(Area1) Area1 = BSAREALIST; end
if isempty(Area2) Area2 = BSAREALIST; end

if ~iscell(Area1)  Area1 = str2cell(Area1);  end
if ~iscell(Area2)  Area2 = str2cell(Area2);  end

BSArea = BSAreaFields;
FieldSession = loadField_Database;

nA1 = length(Area1);
for n = 1:nA1
    if ~find(strcmp(BSAREALIST, Area1{n}))
        error([Area1{n} ' is not in BSAREALIST']);
    end
end

FieldSessionNumbers1 = [];
for n = 1:nA1
    FieldSessionNumbers1 = [FieldSessionNumbers1 BSArea.(Area1{n})];
end
FSession = FieldSession(FieldSessionNumbers1);

Session = loadSpikeSpike_Database;
SSSessionNumbers = getSessionNumbers(Session);

% Find indices with fields in Area1

FieldChamber = sessTower(FSession);
FieldCh = sessElectrode(FSession);
SSChamber = sessTower(Session);
SpikeChamber1 = SSChamber(:,1);
SpikeChamber2 = SSChamber(:,2);
SSCh = sessElectrode(Session);
SpikeCh1 = SSCh(:,1);
SpikeCh2 = SSCh(:,1);

SSSessionIndices1 = [];
for iSess = 1:length(Session)
    SpikeDay = Session{iSess}{1};
    for iFSess = 1:length(FSession)
        FieldDay = FSession{iFSess}{1};
        if strcmp(SpikeChamber1{iSess},FieldChamber{iFSess}) && SpikeCh1(iSess)==FieldCh(iFSess) && ...
                strcmp(SpikeDay,FieldDay);
            SSSessionIndices1 = [SSSessionIndices1, iSess];
        end
        if strcmp(SpikeChamber2{iSess},FieldChamber{iFSess}) && SpikeCh2(iSess)==FieldCh(iFSess) && ...
                strcmp(SpikeDay,FieldDay);
            SSSessionIndices1 = [SSSessionIndices1, iSess];
        end
    end
end
SSSessionIndices1 = unique(SSSessionIndices1);

% %Limit search in next area to those with at least one spike in Area1
% SSSession = Session(SSSessionIndices1);

if isempty(SSSessionIndices1)
    disp('No Spike-Spike Sessions');
    SSSession = [];
else
    % Now find indices with Area2
    % If no second argument is given, take all sessions with Area1
    if nargin > 1
        
        nA2 = length(Area2);
        for n = 1:nA2
            if ~find(strcmp(BSAREALIST, Area2{n}))
                error([Area2{n} ' is not in BSAREALIST']);
            end
        end
        
        %  Now need to find spikes in each of these in area 2
        % First, get Fields with the right label
        FieldSessionNumbers2 = [];
        for n = 1:nA2
            FieldSessionNumbers2 = [FieldSessionNumbers2 BSArea.(Area2{n})];
        end
        FSession = FieldSession(FieldSessionNumbers2);
        
        if ~isempty(FSession)
            FieldChamber = sessTower(FSession);
            FieldCh = sessElectrode(FSession);
            
            %  Go through each candidate SS Session, and see if the spike ch matches
            %  a field that is known to be in area 2
            SSSessionIndices2 = [];     allind1 = [];    allind2 = [];
            for iSSSess = 1:length(Session)
                SpikeDay = Session{iSSSess}{1};
                for iFSess = 1:length(FSession)
                    FieldDay = FSession{iFSess}{1};
                    if strcmp(SpikeChamber1{iSSSess},FieldChamber{iFSess}) && SpikeCh1(iSSSess)==FieldCh(iFSess) && ...
                            strcmp(SpikeDay,FieldDay);
                        allind1 = [allind1, iSSSess];
                    end
                    if strcmp(SpikeChamber2{iSSSess},FieldChamber{iFSess}) && SpikeCh2(iSSSess)==FieldCh(iFSess) && ...
                            strcmp(SpikeDay,FieldDay);
                        allind2 = [allind2, iSSSess];
                    end
                end
            end
            
            SSSessionIndices2 = [allind1 allind2];
            if ~isempty(SSSessionIndices2)
                SSSessionIndices2 = unique(SSSessionIndices2);
                
                % Special case: Area1 = Area2
                if length(SSSessionIndices1) == length(SSSessionIndices2)
                    comparison = SSSessionIndices1 == SSSessionIndices2;
                    if sum(comparison) == length(comparison)
                        SSSessionIndices2 = intersect(allind1,allind2);
                    end
                end
                
                SSSessionIndices = intersect(SSSessionIndices1,SSSessionIndices2);
                SSSession = Session(SSSessionIndices);
            else
                disp('No Spike-Spike Sessions');
                SSSession = [];
            end
        else
            disp('No Spike-Spike Sessions');
            SSSession = [];
        end
    end
end

%  Now do the task selection
if nargin > 2
    if isempty(Task); Task = ''; end
    if ischar(Task); Task = {Task}; end
    
    SessionType = 'SpikeSpike';
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;
    NumTrials= zeros(length(SSSession),length(Task));
    for iSSSession = 1:length(SSSession)
        NumTrials(iSSSession,:) = loadSessionNumTrials(SSSession{iSSSession},Task, [], SessionNumTrials, Session);
    end
end


