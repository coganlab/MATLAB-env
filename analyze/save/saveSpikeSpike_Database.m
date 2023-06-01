function saveSpikeSpike_Database
%
%  saveSpike_Database
%

global MONKEYDIR 

Session = loadSpikeSpike_Database;
for iSess = 1:length(Session)
    if length(Session{iSess})==6
        Session{iSess}{7} = MONKEYDIR;
        Session{iSess}{8} = {'Spike'};
     elseif ~ismember(Session{iSess}{7},'/')
        Session{iSess}{7} = MONKEYDIR;
    end
end

save([MONKEYDIR '/mat/SpikeSpike_Session.mat'],'Session');

