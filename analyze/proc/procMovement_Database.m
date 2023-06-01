function procMovement_Database(day)
%
%  procMovement_Database(day)
%
%  Assumes recording is done with SCNN drive.

global MONKEYDIR
disp('In procMovement_Database')
Session = loadMovement_Database;
SessNum = length(Session);

recs = dayrecs(day);
load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);

for iTower = 1:length(experiment.hardware.microdrive)
    SessNum = SessNum+1;
    tower = experiment.hardware.microdrive(iTower).name;
    nCh = length(experiment.hardware.microdrive(iTower).electrodes);
    Session{SessNum} = {day,[],{tower},[1:nCh],[],SessNum};
end

save([MONKEYDIR '/mat/Movement_Session.mat'],'Session');
