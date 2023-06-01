function saveLRS_Behavior_Database
%
%  saveLRS_Behavior_Database
%

global MONKEYDIR

Session = LRS_Behavior_Database;
save([MONKEYDIR '/mat/LRS_Behavior_Session.mat'],'Session');
