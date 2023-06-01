function Session = updateFieldField_Database
%
%  Session = updateFieldField_Database
%  To be used for daily updates of new data.
%  Use addFieldField_Database to change specific fields
%  


global MONKEYDIR

Session = cell(0,0); 
FieldSessions = loadField_Database;

NumField = length(FieldSessions);

if isfile([MONKEYDIR '/mat/FieldField_Session.mat']);
    load([MONKEYDIR '/mat/FieldField_Session.mat']);
    for iSess = 1:length(Session)
        NFIELD(iSess) = Session{iSess}{6}(1);
    end
    StartField = max(NFIELD)+1;
else
    StartField = 1;
end

for iField1 = StartField:NumField
  addFieldField_Database(iField1);
end

updateFieldField_NumTrials;
% updateFieldField_NumTrialsConds;
%updateFieldField_Figs;
