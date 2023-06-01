function saveBehavior_Database
%
%  saveBehavior_Database
%

global MONKEYDIR

Session = Behavior_Database;
save([MONKEYDIR '/mat/Behavior_Session.mat'],'Session');
