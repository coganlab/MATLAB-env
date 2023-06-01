function Session = updateSpikeMultiunit_Database
%
%  Session = updateSpikeMultiunit_Database
%  To be used for daily updates of new data.
%  


global MONKEYDIR

Session = cell(0,0); 
SpikeSessions = loadSpike_Database;
MultiunitSessions = loadMultiunit_Database;

NumSpike = length(SpikeSessions);
NumMultiunit= length(MultiunitSessions);

%  First go from spike to multiunit
if isfile([MONKEYDIR '/mat/SpikeMultiunit_Session.mat']);
    Session = loadSpikeMultiunit_Database;
    NSPIKE = zeros(1,length(Session));
    for iSess = 1:length(Session)
        NSPIKE(iSess) = Session{iSess}{6}(1);
    end
    StartSpike = max(NSPIKE)+1;
else
    StartSpike = 1;
end

for iSpike = StartSpike:NumSpike
    addSpikeMultiunit_Database(iSpike,[],Session);
end


%  Now repeat for multiunit to spike

if isfile([MONKEYDIR '/mat/SpikeMultiunit_Session.mat']);
    Session = loadSpikeMultiunit_Database;
    NMULTIUNIT = zeros(1,length(Session));
    for iSess = 1:length(Session)
        NMULTIUNIT(iSess) = Session{iSess}{6}(2);
    end
    StartMultiunit = max(NMULTIUNIT)+1;
else
    StartMultiunit = 1;
end

for iMultiunit = StartMultiunit:NumMultiunit
    addSpikeMultiunit_Database([],iMultiunit,Session);
end


updateSpikeMultiunit_NumTrials;
% updateSpikeMultiunit_NumTrialsConds;
% updateSpikeMultiunit_Figs;
