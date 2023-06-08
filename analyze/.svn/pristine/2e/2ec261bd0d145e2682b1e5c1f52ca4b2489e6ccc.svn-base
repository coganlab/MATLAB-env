function Session = updateFieldFieldField_Database
%
%  Session = updateFieldFieldField_Database
%  To be used for daily updates of new data.
%  Use addFieldFieldField_Database to change specific fields
%  


global MONKEYDIR

Session = cell(0,0); 
FieldSessions = loadField_Database;

NumField = length(FieldSessions);

if isfile([MONKEYDIR '/mat/FieldFieldField_Session.mat']);
    load([MONKEYDIR '/mat/FieldFieldField_Session.mat']);
    for iSess = 1:length(Session)
        NFIELD(iSess) = Session{iSess}{6}(1);
    end
    StartField = max(NFIELD)+1;
else
    StartField = 1;
end

for iField1 = StartField:NumField
  %addFieldFieldField_Database(iField1);
  Session = addFieldFieldField_Database(iField1,[],[],Session);
end

updateFieldFieldField_NumTrials

