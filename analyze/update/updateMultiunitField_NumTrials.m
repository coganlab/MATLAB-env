function updateMultiunitField_NumTrials(MultiunitSessNum,FieldSessNum)
%
%   updateMultiunitField_NumTrials(MultiunitSessNum,FieldSessNum)
%
%   Adds NumTrials data structure to MultiunitField_NumTrials file
%
%   Modified to accept sessnum list

global MONKEYDIR

if nargin < 1; MultiunitSessNum = []; end
if nargin < 2; FieldSessNum = []; end

if isempty(MultiunitSessNum) && isempty(FieldSessNum)
    updateType_NumTrials('MultiunitField');
else
    disp('Loading MultiunitField_Session.mat');
    if isfile([MONKEYDIR '/mat/MultiunitField_Session.mat'])
        Session = loadMultiunitField_Database;
    else
        Session = [];
    end
    FSess = loadField_Database;
    MSess = loadMultiunit_Database;
    if ~isempty(MultiunitSessNum) && ~isempty(FieldSessNum)
        FieldSess = FSess{FieldSessNum};
        MultiunitSess = MSess{MultiunitSessNum};
        [flag,SessNum] = isInMultiunitField(MultiunitSess,FieldSess,Session);
        if flag
            updateType_NumTrials('MultiunitField',SessNum);
        end
    elseif isempty(MultiunitSessNum) && ~isempty(FieldSessNum)
        FieldSess = FSess{FieldSessNum};
        MSessions = FtoM(FieldSess);
        for iSess = 1:length(MSessions)
            MultiunitSess = MSessions{iSess};
            [flag,SessNum] = isInMultiunitField(MultiunitSess,FieldSess,Session);
            if flag
                updateType_NumTrials('MultiunitField',SessNum);
            end
        end
    elseif ~isempty(MultiunitSessNum) && isempty(FieldSessNum)
        MultiunitSess = MSess{MultiunitSessNum};
        FSessions = MtoF(MultiunitSess);
        for iSess = 1:length(FSessions)
            FieldSess = FSessions{iSess};
            [flag,SessNum] = isInMultiunitField(MultiunitSess,FieldSess,Session);
            if flag
                updateType_NumTrials('MultiunitField',SessNum);
            end
        end
    end
end


