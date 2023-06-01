function saveSpikeSpikeField_Database
%
%  saveSpikeSpikeField_Database
%

global MONKEYDIR 

Session = loadSpikeSpikeField_Database;
for iSess = 1:length(Session)
    if length(Session{iSess})==6
        Session{iSess}{7} = MONKEYDIR;
        Session{iSess}{8} = {'Spike'};
     elseif ~ismember(Session{iSess}{7},'/')
        Session{iSess}{7} = MONKEYDIR;
    end
end

save([MONKEYDIR '/mat/SpikeSpikeField_Session.mat'],'Session');

