function Session = updateMultiunitFieldField_Database
%
%   Session = UpdateMultiunitFieldField_Database
%  To be used for daily updates of new data.
%  Use addMultiunitFieldField_Database to change specific fields
%

global MONKEYDIR

Session = cell(0,0); 
MultiunitSessions = loadMultiunit_Database;
FieldSessions = loadField_Database;

NumMultiunit = length(MultiunitSessions);
NumField = length(FieldSessions);

%  First go from spike to field
if isfile([MONKEYDIR '/mat/MultiunitFieldField_Session.mat']);
    Session = loadMultiunitFieldField_Database;
    NSPIKE = zeros(1,length(Session));
    for iSess = 1:length(Session)
        NSPIKE(iSess) = Session{iSess}{6}(1);
    end
    StartMultiunit = max(NSPIKE)+1;
else
    StartMultiunit = 1;
end

for iMultiunit = StartMultiunit:NumMultiunit
    Session = addMultiunitFieldField_Database(iMultiunit, [], [], Session);
end


%  Now repeat for field to spike
if isfile([MONKEYDIR '/mat/MultiunitFieldField_Session.mat']);
    Session = loadMultiunitFieldField_Database;
    NFIELD = zeros(1,length(Session));
    for iSess = 1:length(Session)
        NFIELD(iSess) = Session{iSess}{6}(2);
    end
    StartField = max(NFIELD)+1;
else
    StartField = 1;
end

for iField = StartField:NumField
    Session = addMultiunitFieldField_Database([],iField,[],Session);
end



updateMultiunitFieldField_NumTrials;



