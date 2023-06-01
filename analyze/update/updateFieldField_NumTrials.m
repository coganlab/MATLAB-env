function updateFieldField_NumTrials(SessNum1,SessNum2)
%
%   updateFieldField_NumTrials(SessNum1,SessNum2)
%
%   Adds NumTrials data structure to FieldField_NumTrials file
%
%   Modified to accept sessnum list

global MONKEYDIR

if nargin < 1; SessNum1 = []; end
if nargin < 2; SessNum2 = []; end

if isempty(SessNum1) && ~isempty(SessNum2)
    SessNum1 = SessNum2;
    SessNum2 = [];
end

if isempty(SessNum1) && isempty(SessNum2)
    updateType_NumTrials('FieldField');
else
    disp('Loading FieldField_Session.mat');
    if isfile([MONKEYDIR '/mat/FieldField_Session.mat'])
        Session = loadFieldField_Database;
    else
        Session = [];
    end
    FSess = loadField_Database;
    if ~isempty(SessNum1) && ~isempty(SessNum2)
        FieldSess1 = FSess{SessNum1};
        FieldSess2 = FSess{SessNum2};
        [flag,SessNum] = isInFieldField(FieldSess1,FieldSess2,Session);
        if flag
            updateType_NumTrials('FieldField',SessNum);
        end
    elseif ~isempty(SessNum1) && isempty(SessNum2)
        FieldSess1 = FSess{SessNum1};
        FSessions = FtoF(FieldSess1);
        for iSess = 1:length(FSessions)
            FieldSess2 = FSessions{iSess};
            [flag,SessNum] = isInFieldField(FieldSess1,FieldSess2,Session);
            if flag
                updateType_NumTrials('FieldField',SessNum);
            end
        end
    end
end


