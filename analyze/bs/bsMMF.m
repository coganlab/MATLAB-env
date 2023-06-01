function [MMFSession, NumTrials] = bsMMF(Area1, Area2, Area3, Task)
%
%  [MMFSession, NumTrials] = bsMMF(Area1, Area2, Area3, Task)
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
Session = loadMultiunitMultiunitField_Database;
MMFSessionNumbers = getSessionNumbers(Session);

MMFSessionIndices = [];
for iSess = 1:length(FieldSessionNumbers3)
    ind = find(MMFSessionNumbers(:,3)==FieldSessionNumbers3(iSess))';
    MMFSessionIndices = [MMFSessionIndices ind];
end
MMFSessionIndices = unique(MMFSessionIndices);
Session = Session(MMFSessionIndices);

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
        MMFChamber = sessTower(Session);
        MultiunitChamber1 = MMFChamber(:,1);
        MultiunitChamber2 = MMFChamber(:,2);
        MMFCh = sessElectrode(Session);
        MultiunitCh1 = MMFCh(:,1);
        MultiunitCh2 = MMFCh(:,2);
        
        MMFSessionIndices1 = [];
        for iSess = 1:length(Session)
            MultiunitDay = Session{iSess}{1};
            for iFSess = 1:length(FSession)
                FieldDay = FSession{iFSess}{1};
                if strcmp(MultiunitChamber1{iSess},FieldChamber{iFSess}) && MultiunitCh1(iSess)==FieldCh(iFSess) && ...
                        strcmp(MultiunitDay,FieldDay);
                    MMFSessionIndices1 = [MMFSessionIndices1, iSess];
                end
                if strcmp(MultiunitChamber2{iSess},FieldChamber{iFSess}) && MultiunitCh2(iSess)==FieldCh(iFSess) && ...
                        strcmp(MultiunitDay,FieldDay);
                    MMFSessionIndices1 = [MMFSessionIndices1, iSess];
                end
            end
        end
        MMFSessionIndices1 = unique(MMFSessionIndices1);
        
        % %Limit search in next area to those with at least one multiunit in Area1
        % MMFSession = Session(MMFSessionIndices1);
        
        if isempty(MMFSessionIndices1)
            disp('No Multiunit-Multiunit-Field Sessions');
            MMFSession = [];
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
                    
                    %  Go through each candidate MMF Session, and see if the multiunit ch matches
                    %  a field that is known to be in area 2
                    MMFSessionIndices2 = [];     allind1 = [];    allind2 = [];
                    for iMMFSess = 1:length(Session)
                        MultiunitDay = Session{iMMFSess}{1};
                        for iFSess = 1:length(FSession)
                            FieldDay = FSession{iFSess}{1};
                            if strcmp(MultiunitChamber1{iMMFSess},FieldChamber{iFSess}) && MultiunitCh1(iMMFSess)==FieldCh(iFSess) && ...
                                    strcmp(MultiunitDay,FieldDay);
                                allind1 = [allind1, iMMFSess];
                            end
                            if strcmp(MultiunitChamber2{iMMFSess},FieldChamber{iFSess}) && MultiunitCh2(iMMFSess)==FieldCh(iFSess) && ...
                                    strcmp(MultiunitDay,FieldDay);
                                allind2 = [allind2, iMMFSess];
                            end
                        end
                    end
                    
                    MMFSessionIndices2 = [allind1 allind2];
                    if ~isempty(MMFSessionIndices2)
                        MMFSessionIndices2 = unique(MMFSessionIndices2);
                        
                        % Special case: Area1 = Area2
                        if length(MMFSessionIndices1) == length(MMFSessionIndices2)
                            comparison = MMFSessionIndices1 == MMFSessionIndices2;
                            if sum(comparison) == length(comparison)
                                MMFSessionIndices2 = intersect(allind1,allind2);
                            end
                        end
                        
                        MMFSessionIndices = intersect(MMFSessionIndices1,MMFSessionIndices2);
                        MMFSession = Session(MMFSessionIndices);
                    else
                        disp('No Multiunit-Multiunit-Field Sessions');
                        MMFSession = [];
                    end
                else
                    disp('No Multiunit-Multiunit-Field Sessions');
                    MMFSession = [];
                end
            end
        end
    else
        disp('No Multiunit-Multiunit-Field Sessions');
        MMFSession = [];
    end
else
    disp('No Multiunit-Multiunit-Field Sessions');
    MMFSession = [];
end

%  Now do the task selection
if nargin > 3
    if isempty(Task); Task = ''; end
    if ischar(Task); Task = {Task}; end
    Session = loadMultiunitMultiunitField_Database;
    SessionType = 'MultiunitMultiunitField';
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];
    SessionNumTrials = load(Filename);
    SessionNumTrials = SessionNumTrials.NumTrials;
    NumTrials= zeros(length(MMFSession),length(Task));
    for iMMFSession = 1:length(MMFSession)
        NumTrials(iMMFSession,:) = loadSessionNumTrials(MMFSession{iMMFSession},Task, [], SessionNumTrials, Session);
    end
end


