function Session = updateSpikeMultiunitField_Database
%
%   Session = UpdateSpikeMultiunitField_Database
%  To be used for daily updates of new data.
%  Use addSpikeMultiunitField_Database to change specific fields
%

global MONKEYDIR

Session = cell(0,0); 
SpikeSessions = loadSpike_Database;
MultiunitSessions = loadMultiunit_Database;
FieldSessions = loadField_Database;


NumSpike = length(SpikeSessions);
NumMultiunit = length(MultiunitSessions);
NumField = length(FieldSessions);

%  First go from spike to SMF
if isfile([MONKEYDIR '/mat/SpikeMultiunitField_Session.mat']);
    Session = loadSpikeMultiunitField_Database;
    NSPIKE = zeros(1,length(Session));
    for iSess = 1:length(Session)
        NSPIKE(iSess) = Session{iSess}{6}(1);
    end
    StartSpike = max(NSPIKE)+1;
else
    StartSpike = 1;
end

for iSpike = StartSpike:NumSpike
    Session = addSpikeMultiunitField_Database(iSpike, [], [], Session);
    %addSpikeMultiunitField_Database(iSpike, [], []);
end


%  Now repeat for multiunit to SMF
if isfile([MONKEYDIR '/mat/SpikeMultiunitField_Session.mat']);
    Session = loadSpikeMultiunitField_Database;
    NSPIKE = zeros(1,length(Session));
    for iSess = 1:length(Session)
        NSPIKE(iSess) = Session{iSess}{6}(2);
    end
    StartMultiunit = max(NSPIKE)+1;
else
    StartMultiunit = 1;
end

for iMultiunit = StartMultiunit:NumMultiunit
    Session = addSpikeMultiunitField_Database([], iMultiunit, [], Session);
    %addSpikeMultiunitField_Database([], iMultiunit, []);
end


%  Now repeat for field to SMF
if isfile([MONKEYDIR '/mat/SpikeMultiunitField_Session.mat']);
    Session = loadSpikeMultiunitField_Database;
    NFIELD = zeros(1,length(Session));
    for iSess = 1:length(Session)
        NFIELD(iSess) = Session{iSess}{6}(3);
    end
    StartField = max(NFIELD)+1;
else
    StartField = 1;
end

for iField = StartField:NumField
    Session = addSpikeMultiunitField_Database([],[],iField, Session);
    %addSpikeMultiunitField_Database([],[],iField);
end



updateSpikeMultiunitField_NumTrials;



