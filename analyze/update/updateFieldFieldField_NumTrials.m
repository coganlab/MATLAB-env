function updateFieldFieldField_NumTrials(SessNum1,SessNum2,SessNum3)
%
%   updateFieldFieldField_NumTrials(SessNum1,SessNum2,SessNum3)
%
%   Adds NumTrials data structure to FieldFieldField_NumTrials file
%
%   Modified to accept sessnum list

global MONKEYDIR

if nargin < 1; SessNum1 = []; end
if nargin < 2; SessNum2 = []; end
if nargin < 3; SessNum3 = []; end

if isempty(SessNum1) && ~isempty(SessNum2)
    SessNum1 = SessNum2;
    SessNum2 = [];
end
if isempty(SessNum1) && ~isempty(SessNum3)
    SessNum1 = SessNum3;
    SessNum3 = [];
end
if isempty(SessNum2) && ~isempty(SessNum3)
    SessNum2 = SessNum3;
    SessNum3 = [];
end

if isempty(SessNum1) && isempty(SessNum2) && isempty(SessNum1)
    updateType_NumTrials('FieldFieldField');
else
    disp('Loading FieldField_Session.mat');
    if isfile([MONKEYDIR '/mat/FieldFieldField_Session.mat'])
        Session = loadFieldFieldField_Database;
    else
        Session = [];
    end
    FSess = loadField_Database;
    if ~isempty(SessNum1) && ~isempty(SessNum2) && ~isempty(SessNum3)
        FieldSess1 = FSess{SessNum1};
        FieldSess2 = FSess{SessNum2};
        FieldSess3 = FSess{SessNum3};
        [flag,SessNum] = isInFieldFieldField(FieldSess1,FieldSess2,FieldSess3,Session);
        if ~flag
            updateType_NumTrials('FieldFieldField',SessNum);
        end
        
    elseif ~isempty(SessNum1) && ~isempty(SessNum2) && isempty(SessNum3)
        FieldSess1 = FSess{SessNum1};
        FieldSess2 = FSess{SessNum2};
        FSessions = FtoF(FieldSess1);
        for iSess = 1:length(FSessions)
            FieldSess3 = FSessions{iSess};
            [flag,SessNum] = isInFieldFieldField(FieldSess1,FieldSess2,FieldSess3,Session);
            if flag
                updateType_NumTrials('FieldFieldField',SessNum);
            end
        end
        
    elseif ~isempty(SessNum1) && isempty(SessNum2) && isempty(SessNum3)
        FieldSess1 = FSess{SessNum1};
        FSessions = FtoF(FieldSess1);
        for iInd1 = 1:length(FSessions)
            FieldSess2 = FSessions{iInd1};
            for iInd2 = iInd1+1:length(FSessions)
                FieldSess3 = FSessions{iInd2};
                [flag,SessNum] = isInFieldFieldField(FieldSess1,FieldSess2,FieldSess3,Session);
                if flag
                    updateType_NumTrials('FieldFieldField',SessNum);
                end
            end
        end
    end
end


