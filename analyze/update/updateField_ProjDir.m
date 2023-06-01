function updateField_ProjDir(NewProjDir)
%
% updateField_ProjDir(NewProjDir)
%

global MONKEYDIR

PROJDIR_INDEX = 7;
Session = loadField_Database;
for iSess = 1:numel(Session)
  Session{iSess}{PROJDIR_INDEX} = NewProjDir;
end
save([MONKEYDIR '/mat/Field_Session.mat'],'Session');

