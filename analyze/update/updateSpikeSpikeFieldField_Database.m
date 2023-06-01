function Session = updateSpikeSpikeFieldField_Database
%
%   Session = UpdateSpikeSpikeFieldField_Database
%  To be used for daily updates of new data.
%  Use addSpikeSpikeField_Database to change specific fields
%

global MONKEYDIR

Session = cell(0,0); 
SpikeSessions = loadSpike_Database;
FieldSessions = loadField_Database;

NumSpike = length(SpikeSessions);
NumField = length(FieldSessions);

%  First go from spike to field
if isfile([MONKEYDIR '/mat/SpikeSpikeFieldField_Session.mat']);
    Session = loadSpikeSpikeFieldField_Database;
    NSPIKE = zeros(1,length(Session));
    for iSess = 1:length(Session)
        NSPIKE(iSess) = Session{iSess}{6}(1);
    end
    StartSpike = max(NSPIKE)+1;
else
    StartSpike = 1;
end

for iSpike = StartSpike:NumSpike
    %addSpikeSpikeField_Database(iSpike, [], []);
    Session = addSpikeSpikeFieldField_Database(iSpike, [], [], Session);
end


%  Now repeat for field to spike
if isfile([MONKEYDIR '/mat/SpikeSpikeFieldField_Session.mat']);
    Session = loadSpikeSpikeFieldField_Database;
    NFIELD = zeros(1,length(Session));
    for iSess = 1:length(Session)
        NFIELD(iSess) = Session{iSess}{6}(3);
    end
    StartField = max(NFIELD)+1;
else
    StartField = 1;
end

for iField = StartField:NumField
    %addSpikeSpikeFieldField_Database([],[],iField);
    Session = addSpikeSpikeFieldField_Database([],[],iField,Session);
end



% updateSpikeSpikeFieldField_NumTrials;



