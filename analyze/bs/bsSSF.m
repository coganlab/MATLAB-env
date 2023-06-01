function [SSFSession, NumTrials] = bsSSF(Area1, Area2, Area3, Task)
%
%  [SSFSession, NumTrials] = bsSSF(Area1, Area2, Area3, Task)
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
FieldSession = loadField_Database;

nA1 = length(Area1);
for n = 1:nA1
    if ~find(strcmp(BSAREALIST, Area1{n}))
        error([Area1{n} ' is not in BSAREALIST']);
    end
end

nA3 = length(Area3);
for n = 1:nA3
    if ~find(strcmp(BSAREALIST, Area3{n}))
        error([Area3{n} ' is not in BSAREALIST']);
    end
end


% Find Fields in Area 3
FieldSessionNumbers3 = [];
for n = 1:nA3
    FieldSessionNumbers3 = [FieldSessionNumbers3 BSArea.(Area3{n})];
end

% Find multiunit-multiunit-field indices with fields in Area3
Session = loadSpikeSpikeField_Database;
SSFSessionNumbers = getSessionNumbers(Session);

SSFSessionIndices = [];
for iSess = 1:length(FieldSessionNumbers3)
    ind = find(SSFSessionNumbers(:,3)==FieldSessionNumbers3(iSess))';
    SSFSessionIndices = [SSFSessionIndices ind];
end
SSFSessionIndices = unique(SSFSessionIndices);
Session = Session(SSFSessionIndices);

if ~isempty(Session)
    
    %  Now need to find multiunits in each of these in Area1 and Area2
    
    % First, get Fields with the right label
    FieldSessionNumbers1 = [];
    for n = 1:nA1
        FieldSessionNumbers1 = [FieldSessionNumbers1 BSArea.(Area1{n})];
    end
    FSession = FieldSession(FieldSessionNumbers1);
    
    if ~isempty(FSession)
        % Find indices with fields in Area1
        
        FieldChamber = sessTower(FSession);
        FieldCh = sessElectrode(FSession);
        SSFChamber = sessTower(Session);
        SpikeChamber1 = SSFChamber(:,1);
        SpikeChamber2 = SSFChamber(:,2);
        SSFCh = sessElectrode(Session);
        SpikeCh1 = SSFCh(:,1);
        SpikeCh2 = SSFCh(:,2);
        
        SSFSessionIndices1 = [];
        for iSess = 1:length(Session)
            SpikeDay = Session{iSess}{1};
            for iFSess = 1:length(FSession)
                FieldDay = FSession{iFSess}{1};
                if strcmp(SpikeChamber1{iSess},FieldChamber{iFSess}) && SpikeCh1(iSess)==FieldCh(iFSess) && ...
                        strcmp(SpikeDay,FieldDay);
                    SSFSessionIndices1 = [SSFSessionIndices1, iSess];
                end
                if strcmp(SpikeChamber2{iSess},FieldChamber{iFSess}) && SpikeCh2(iSess)==FieldCh(iFSess) && ...
                        strcmp(SpikeDay,FieldDay);
                    SSFSessionIndices1 = [SSFSessionIndices1, iSess];
                end
            end
        end
        SSFSessionIndices1 = unique(SSFSessionIndices1);
        
        % %Limit search in next area to those with at least one multiunit in Area1
        % SSFSession = Session(SSFSessionIndices1);
        
        if isempty(SSFSessionIndices1)
            disp('No Spike-Spike-Field Sessions');
            SSFSession = [];
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
                
                %  Now need to find multiunits in each of these in area 2
                % First, get Fields with the right label
                FieldSessionNumbers2 = [];
                for n = 1:nA2
                    FieldSessionNumbers2 = [FieldSessionNumbers2 BSArea.(Area2{n})];
                end
                FSession = FieldSession(FieldSessionNumbers2);
                
                if ~isempty(FSession)
                    FieldChamber = sessTower(FSession);
                    FieldCh = sessElectrode(FSession);
                    
                    %  Go through each candidate SSF Session, and see if the multiunit ch matches
                    %  a field that is known to be in area 2
                    SSFSessionIndices2 = [];     allind1 = [];    allind2 = [];
                    for iSSFSess = 1:length(Session)
                        SpikeDay = Session{iSSFSess}{1};
                        for iFSess = 1:length(FSession)
                            FieldDay = FSession{iFSess}{1};
                            if strcmp(SpikeChamber1{iSSFSess},FieldChamber{iFSess}) && SpikeCh1(iSSFSess)==FieldCh(iFSess) && ...
                                    strcmp(SpikeDay,FieldDay);
                                allind1 = [allind1, iSSFSess];
                            end
                            if strcmp(SpikeChamber2{iSSFSess},FieldChamber{iFSess}) && SpikeCh2(iSSFSess)==FieldCh(iFSess) && ...
                                    strcmp(SpikeDay,FieldDay);
                                allind2 = [allind2, iSSFSess];
                            end
                        end
                    end
                    
                    SSFSessionIndices2 = [allind1 allind2];
                    if ~isempty(SSFSessionIndices2)
                        SSFSessionIndices2 = unique(SSFSessionIndices2);
                        
                        % Special case: Area1 = Area2
                        if length(SSFSessionIndices1) == length(SSFSessionIndices2)
                            comparison = SSFSessionIndices1 == SSFSessionIndices2;
                            if sum(comparison) == length(comparison)
                                SSFSessionIndices2 = intersect(allind1,allind2);
                            end
                        end
                        
                        SSFSessionIndices = intersect(SSFSessionIndices1,SSFSessionIndices2);
                        SSFSession = Session(SSFSessionIndices);
                    else
                        disp('No Spike-Spike-Field Sessions');
                        SSFSession = [];
                    end
                else
                    disp('No Spike-Spike-Field Sessions');
                    SSFSession = [];
                end
            end
        end
    else
        disp('No Spike-Spike-Field Sessions');
        SSFSession = [];
    end
else
    disp('No Spike-Spike-Field Sessions');
    SSFSession = [];
end

%  Now do the task selection
if nargin > 3
    if isempty(Task); Task = ''; end
    if ischar(Task); Task = {Task}; end
    Session = loadSpikeSpikeField_Database;
    SessionType = 'SpikeSpikeField';
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;
    NumTrials= zeros(length(SSFSession),length(Task));
    for iSSFSession = 1:length(SSFSession)
        NumTrials(iSSFSession,:) = loadSessionNumTrials(SSFSession{iSSFSession},Task, [], SessionNumTrials, Session);
    end
end


