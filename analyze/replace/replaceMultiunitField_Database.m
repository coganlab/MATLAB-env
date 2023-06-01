function replaceMultiunitField_Database(SessNum1,SessNum2)
%
% replaceMultiunitField_Database(SessNum1,SessNum2)
%

global MONKEYDIR 

Session = loadMultiunitField_Database;
FieldSessions = loadField_Database;
MultiunitSessions = loadMultiunit_Database;

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

    MultiunitSess = MultiunitSessions{SN1};
    FieldSess = FieldSessions{SN2};
    if isMultiunitField(MultiunitSess,FieldSess)
        tmpSession(1) = intersect(MultiunitSess(1),FieldSess(1));
        tmpSession{2} = intersect(MultiunitSess{2},FieldSess{2});
        tmpSession{3} = [MultiunitSess{3},FieldSess{3}(1)];
        tmpSession{4} = [MultiunitSess{4},FieldSess{4}];
        if iscell(MultiunitSess{5}) && iscell(FieldSess{5})
            tmpSession{5} = {MultiunitSess{5}{1},FieldSess{5}{1}};
        elseif iscell(MultiunitSess{5}) && ~iscell(FieldSess{5})
            tmpSession{5} = {MultiunitSess{5}{1},FieldSess{5}};
        elseif ~iscell(MultiunitSess{5}) && iscell(FieldSess{5})
            tmpSession{5} = {MultiunitSess{5},FieldSess{5}{1}};
        elseif ~iscell(MultiunitSess{5}) && ~iscell(FieldSess{5})
            tmpSession{5} = {MultiunitSess{5},FieldSess{5}};
        end
        tmpSession{6} = [SN1,SN2];
        
        Session{ind(iInd)} = tmpSession;
        save([MONKEYDIR '/mat/MultiunitField_Session.mat'],'Session');
        updateMultiunitField_NumTrials(ind(iInd));
    end
end
