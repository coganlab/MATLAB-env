function Session = updateSpikeSpike_Database
%
%  Session = updateSpikeSpike_Database
%  To be used for daily updates of new data.
%  


global MONKEYDIR

Session = cell(0,0); 
SpikeSessions = loadSpike_Database;

NumSpike = length(SpikeSessions);

if isfile([MONKEYDIR '/mat/SpikeSpike_Session.mat']);
    load([MONKEYDIR '/mat/SpikeSpike_Session.mat']);
    for iSess = 1:length(Session)
        NSPIKE(iSess) = Session{iSess}{6}(1);
    end
    StartSpike = max(NSPIKE)+1;
else
    StartSpike = 1;
end

for iSpike1 = StartSpike:NumSpike
  addSpikeSpike_Database(iSpike1);
end

updateSpikeSpike_NumTrials;
% updateSpikeSpike_NumTrialsConds;
% updateSpikeSpike_Figs;
