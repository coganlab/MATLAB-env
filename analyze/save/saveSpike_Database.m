function saveSpike_Database
%
%  saveSpike_Database
%

global MONKEYDIR 

Session = loadSpike_Database;
for iSess = 1:length(Session)
    if length(Session{iSess})==8
        Session{iSess}{7} = MONKEYDIR;
        Session{iSess}{8} = {'Spike'};
        Session{iSess}{6} = iSess;
     elseif ~ismember(Session{iSess}{7},'/')
        Session{iSess}{7} = MONKEYDIR;
    end
end

save([MONKEYDIR '/mat/Spike_Session.mat'],'Session');

