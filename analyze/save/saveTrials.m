function saveTrials(day)
%
%   saveTrials(day)
%

global MONKEYDIR

olddir = pwd;
if(~isdir([MONKEYDIR '/' day '/mat']))
   mkdir([MONKEYDIR '/' day '/mat']);
end
if isfile([MONKEYDIR '/' day '/mat/Trials.mat'])
    delete([MONKEYDIR '/' day '/mat/Trials.mat']);
end

experiment = loadExperiment(day);
if isMocapExperiment(experiment)
   disp('Mocap experiment');
   Trials = dbMocapDatabase(day);
elseif isPlexonExperiment(experiment)
    disp('Plexon experiment');
    Trials = dbPlexondatabase(day);
elseif isLaserAwakeExperiment(experiment)
    disp('Laser Awake Experiment')
    Trials = dbLaserAwakeDatabase(day);
else
    disp('Taskcontroller experiment')
    Trials = dbdatabase(day);
end

cd([MONKEYDIR '/' day '/mat']);
disp(['Saving Trials matrix: ' num2str(length(Trials)) ' trials']);
save Trials.mat Trials

cd(olddir);
