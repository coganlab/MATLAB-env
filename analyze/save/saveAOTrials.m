function saveAOTrials(day)
%
%   saveAOTrials(day)
%   Saves AO trials

global MONKEYDIR

olddir = pwd;
if(~isdir([MONKEYDIR '/' day '/mat']))
   mkdir([MONKEYDIR '/' day '/mat']);
end
if isfile([MONKEYDIR '/' day '/mat/AOTrials.mat'])
    delete([MONKEYDIR '/' day '/mat/AOTrials.mat']);
end

experiment = loadExperiment(day);

AOTrials = dbAOdatabase(day);

cd([MONKEYDIR '/' day '/mat']);
disp(['Saving AOTrials matrix: ' num2str(length(AOTrials)) 'aotrials']);
save AOTrials.mat AOTrials

cd(olddir);
