function [SMFSession, NumTrials] = bsSMF(Area1, Area2, Area3, Task)
%
%  [SMFSession, NumTrials] = bsSMF(Area1, Area2, Area3, Task)
%


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

if ~isempty(FieldSessionNumbers3)
    % Find spike-spike-field indices with fields in Area3
    Session = loadSpikeMultiunitField_Database;
    SMFSessionNumbers = getSessionNumbers(Session);
    
    SMFSessionIndices = [];
    for iSess = 1:length(FieldSessionNumbers3)
        ind = find(SMFSessionNumbers(:,3)==FieldSessionNumbers3(iSess))';
        SMFSessionIndices = [SMFSessionIndices ind];
    end
    SMFSessionIndices = unique(SMFSessionIndices);
    Session = Session(SMFSessionIndices);
    
    
    %  Now need to find spikes in each of these in Area1 and Area2
    
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
        SMFChamber = sessTower(Session);
        SpikeChamber = SMFChamber(:,1);
        SMFCh = sessElectrode(Session);
        SpikeCh = SMFCh(:,1);
        
        SMFSessionIndices1 = [];
        for iSess = 1:length(Session)
            SpikeDay = Session{iSess}{1};
            for iFSess = 1:length(FSession)
                FieldDay = FSession{iFSess}{1};
                if strcmp(SpikeChamber{iSess},FieldChamber{iFSess}) && SpikeCh(iSess)==FieldCh(iFSess) && ...
                        strcmp(SpikeDay,FieldDay);
                    SMFSessionIndices1 = [SMFSessionIndices1, iSess];
                end
            end
        end
        SMFSessionIndices1 = unique(SMFSessionIndices1);
        
        %Limit search in next area to those with at least one spike in Area1
        SMFSession = Session(SMFSessionIndices1);
        
        if isempty(SMFSessionIndices1)
            disp('No Spike-Multiunit-Field Sessions');
            SMFSession = [];
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
                    MultiunitChamber = SMFChamber(:,1);
                    MultiunitCh = SMFCh(:,1);
                    %  Go through each candidate SMF Session, and see if the spike ch matches
                    %  a field that is known to be in area 2
                    SMFSessionIndices2 = [];
                    for iSMFSess = 1:length(SMFSession)
                        MultiunitDay = SMFSession{iSMFSess}{1};
                        for iFSess = 1:length(FSession)
                            FieldDay = FSession{iFSess}{1};
                            if strcmp(MultiunitChamber{iSess},FieldChamber{iFSess}) && MultiunitCh(iSess)==FieldCh(iFSess) && ...
                                    strcmp(MultiunitDay,FieldDay);
                                SMFSessionIndices2 = [SMFSessionIndices2, iSMFSess];
                            end
                        end
                    end
                    
                    if ~isempty(SMFSessionIndices2)
                        SMFSessionIndices2 = unique(SMFSessionIndices2);
                        SMFSession = SMFSession(SMFSessionIndices2);
                    else
                        disp('No Spike-Multiunit-Field Sessions');
                        SMFSession = [];
                    end
                else
                    disp('No Spike-Multiunit-Field Sessions');
                    SMFSession = [];
                end
            end
        end
    else
        disp('No Spike-Multiunit-Field Sessions');
        SMFSession = [];
    end
else
    disp('No Spike-Multiunit-Field Sessions');
    SMFSession = [];
end

%  Now do the task selection
if nargin > 3
    if isempty(Task); Task = ''; end
    if ischar(Task); Task = {Task}; end
    Session = loadSpikeMultiunitField_Database;
    SessionType = 'SpikeMultiunitField';
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;
    NumTrials= zeros(length(SMFSession),length(Task));
    for iSMFSession = 1:length(SMFSession)
        NumTrials(iSMFSession,:) = loadSessionNumTrials(SMFSession{iSMFSession},Task, [], SessionNumTrials, Session);
    end
end


