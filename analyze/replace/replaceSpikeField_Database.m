function replaceSpikeField_Database(SessNum1,SessNum2)
%
% replaceSpikeField_Database(SessNum1,SessNum2)
%

global MONKEYDIR 

Session = loadSpikeField_Database;
FieldSessions = loadField_Database;
SpikeSessions = loadSpike_Database;

SessNums = getSessionNumbers(Session);

if nargin == 2
    ind = find(SessNums(:,1)==SessNum1 & SessNums(:,2)==SessNum2);
elseif isempty(SessNum1) 
    ind = find(SessNums(:,2)==SessNum2);
elseif nargin < 2 || isempty(SessNum2) 
    ind = find(SessNums(:,1)==SessNum1);
end


for iInd = 1:length(ind)
    SN1 = Session{ind(iInd)}{6}(1);
    SN2 = Session{ind(iInd)}{6}(2);

    SpikeSess = SpikeSessions{SN1};
    FieldSess = FieldSessions{SN2};
    if isSpikeField(SpikeSess,FieldSess)
        tmpSession(1) = intersect(SpikeSess(1),FieldSess(1));
        tmpSession{2} = intersect(SpikeSess{2},FieldSess{2});
        tmpSession{3} = [SpikeSess{3},FieldSess{3}(1)];
        tmpSession{4} = [SpikeSess{4},FieldSess{4}];
        if iscell(SpikeSess{5}) && iscell(FieldSess{5})
            tmpSession{5} = {SpikeSess{5}{1},FieldSess{5}{1}};
        elseif iscell(SpikeSess{5}) && ~iscell(FieldSess{5})
            tmpSession{5} = {SpikeSess{5}{1},FieldSess{5}};
        elseif ~iscell(SpikeSess{5}) && iscell(FieldSess{5})
            tmpSession{5} = {SpikeSess{5},FieldSess{5}{1}};
        elseif ~iscell(SpikeSess{5}) && ~iscell(FieldSess{5})
            tmpSession{5} = {SpikeSess{5},FieldSess{5}};
        end
        tmpSession{6} = [SN1,SN2];
        
        Session{ind(iInd)} = tmpSession;
        save([MONKEYDIR '/mat/SpikeField_Session.mat'],'Session');
        updateSpikeField_NumTrials(ind(iInd));
    end
end
