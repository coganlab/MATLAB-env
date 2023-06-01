function [MMSession, NumTrials] = bsMM(Area1, Area2, Task)
%
%  [MMSession, NumTrials] = bsMM(Area1, Area2, Task)
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

if ~isempty(FSession)
    Session = loadMultiunitMultiunit_Database;
    MMSessionNumbers = getSessionNumbers(Session);
    
    % Find indices with fields in Area1
    
    FieldChamber = sessTower(FSession);
    FieldCh = sessElectrode(FSession);
    MMChamber = sessTower(Session);
    MultiunitChamber1 = MMChamber(:,1);
    MultiunitChamber2 = MMChamber(:,2);
    MMCh = sessElectrode(Session);
    MultiunitCh1 = MMCh(:,1);
    MultiunitCh2 = MMCh(:,1);
    
    MMSessionIndices1 = [];
    for iSess = 1:length(Session)
        MultiunitDay = Session{iSess}{1};
        for iFSess = 1:length(FSession)
            FieldDay = FSession{iFSess}{1};
            if strcmp(MultiunitChamber1{iSess},FieldChamber{iFSess}) && MultiunitCh1(iSess)==FieldCh(iFSess) && ...
                    strcmp(MultiunitDay,FieldDay);
                MMSessionIndices1 = [MMSessionIndices1, iSess];
            end
            if strcmp(MultiunitChamber2{iSess},FieldChamber{iFSess}) && MultiunitCh2(iSess)==FieldCh(iFSess) && ...
                    strcmp(MultiunitDay,FieldDay);
                MMSessionIndices1 = [MMSessionIndices1, iSess];
            end
        end
    end
    MMSessionIndices1 = unique(MMSessionIndices1);
    
    % %Limit search in next area to those with at least one spike in Area1
    % MMSession = Session(MMSessionIndices1);
    
    if isempty(MMSessionIndices1)
        disp('No Multiunit-Multiunit Sessions');
        MMSession = [];
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
                MMSessionIndices2 = [];     allind1 = [];    allind2 = [];
                for iMMSess = 1:length(Session)
                    MultiunitDay = Session{iMMSess}{1};
                    for iFSess = 1:length(FSession)
                        FieldDay = FSession{iFSess}{1};
                        if strcmp(MultiunitChamber1{iMMSess},FieldChamber{iFSess}) && MultiunitCh1(iMMSess)==FieldCh(iFSess) && ...
                                strcmp(MultiunitDay,FieldDay);
                            allind1 = [allind1, iMMSess];
                        end
                        if strcmp(MultiunitChamber2{iMMSess},FieldChamber{iFSess}) && MultiunitCh2(iMMSess)==FieldCh(iFSess) && ...
                                strcmp(MultiunitDay,FieldDay);
                            allind2 = [allind2, iMMSess];
                        end
                    end
                end
                
                MMSessionIndices2 = [allind1 allind2];
                if ~isempty(MMSessionIndices2)
                    MMSessionIndices2 = unique(MMSessionIndices2);
                    
                    % Special case: Area1 = Area2
                    if length(MMSessionIndices1) == length(MMSessionIndices2)
                        comparison = MMSessionIndices1 == MMSessionIndices2;
                        if sum(comparison) == length(comparison)
                            MMSessionIndices2 = intersect(allind1,allind2);
                        end
                    end
                    
                    MMSessionIndices = intersect(MMSessionIndices1,MMSessionIndices2);
                    MMSession = Session(MMSessionIndices);
                else
                    disp('No Multiunit-Multiunit Sessions');
                    MMSession = [];
                end
            else
                disp('No Multiunit-Multiunit Sessions');
                MMSession = [];
            end
        end
    end
else
    disp('No Multiunit-Multiunit Sessions');
    MMSession = [];
end


%  Now do the task selection
if nargin > 2
    if isempty(Task); Task = ''; end
    if ischar(Task); Task = {Task}; end
    
    SessionType = 'MultiunitMultiunit';
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;
    NumTrials= zeros(length(MMSession),length(Task));
    for iMMSession = 1:length(MMSession)
        NumTrials(iMMSession,:) = loadSessionNumTrials(MMSession{iMMSession},Task, [], SessionNumTrials, Session);
    end
end


