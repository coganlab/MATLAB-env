function updateMultiunitMultiunit_NumTrials(SessNum1,SessNum2)
%
%   updateMultiunitMultiunit_NumTrials(SessNum1,SessNum2)
%
%   Adds NumTrials data structure to MultiunitMultiunit_NumTrials file
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
    updateType_NumTrials('MultiunitMultiunit');
else
    disp('Loading MultiunitMultiunit_Session.mat');
    if isfile([MONKEYDIR '/mat/MultiunitMultiunit_Session.mat'])
        Session = loadMultiunitMultiunit_Database;
    else
        Session = [];
    end
    MSess = loadMultiunit_Database;
    if ~isempty(SessNum1) && ~isempty(SessNum2)
        MultiunitSess1 = MSess{SessNum1};
        MultiunitSess2 = MSess{SessNum2};
        [flag,SessNum] = isInMultiunitMultiunit(MultiunitSess1,MultiunitSess2,Session);
        if flag
            updateType_NumTrials('MultiunitMultiunit',SessNum);
        end
    elseif ~isempty(SessNum1) && isempty(SessNum2)
        MultiunitSess1 = MSess{SessNum1};
        MSessions = MtoM(MultiunitSess1);
        for iSess = 1:length(MSessions)
            MultiunitSess2 = MSessions{iSess};
            [flag,SessNum] = isInMultiunitMultiunit(MultiunitSess1,MultiunitSess2,Session);
            if flag
                updateType_NumTrials('MultiunitMultiunit',SessNum);
            end
        end
    end
end



