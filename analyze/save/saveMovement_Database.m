function saveMovement_Database
%
%  saveMovement_Database
%

global MONKEYDIR

Session = Movement_Database;
save([MONKEYDIR '/mat/Movement_Session.mat'],'Session');
