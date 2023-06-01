function updateSpike_ProjDir(NewProjDir)
%
% updateSpike_ProjDir(NewProjDir)
%

global MONKEYDIR

PROJDIR_INDEX = 7;
Session = loadSpike_Database;
for iSess = 1:numel(Session)
  Session{iSess}{PROJDIR_INDEX} = NewProjDir;
end
save([MONKEYDIR '/mat/Spike_Session.mat'],'Session');

