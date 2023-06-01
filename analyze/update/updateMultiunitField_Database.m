function Session = updateMultiunitField_Database
%
%   Session = UpdateMultiunitField_Database
%  To be used for daily updates of new data.
%  Use addMultiunitField_Database to change specific fields
%

global MONKEYDIR

Session = cell(0,0); 
MultiunitSessions = loadMultiunit_Database;
FieldSessions = loadField_Database;

NumMultiunit = length(MultiunitSessions);
NumField = length(FieldSessions);

%  First go from mutiunit to field
if isfile([MONKEYDIR '/mat/MultiunitField_Session.mat']);
    Session = loadMultiunitField_Database;
    NSPIKE = zeros(1,length(Session));
    for iSess = 1:length(Session)
        NSPIKE(iSess) = Session{iSess}{6}(1);
    end
    StartMultiunit = max(NSPIKE)+1;
else
    StartMultiunit = 1;
end

for iMultiunit = StartMultiunit:NumMultiunit
    Session = addMultiunitField_Database(iMultiunit,[],Session);
end


%  Now repeat for field to multiunit
if isfile([MONKEYDIR '/mat/MultiunitField_Session.mat']);
    Session = loadMultiunitField_Database;
    NFIELD = zeros(1,length(Session));
    for iSess = 1:length(Session)
        NFIELD(iSess) = Session{iSess}{6}(2);
    end
    StartField = max(NFIELD)+1;
else
    StartField = 1;
end

for iField = StartField:NumField
    Session = addMultiunitField_Database([],iField,Session);
end


% updateMultiunitField_NumTrials;
% updateMultiunitField_NumTrialsConds;
%updateMultiunitField_Figs;

