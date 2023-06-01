function saveMocapTrials(day)
%
%   saveMocapTrials(day)
%

global MONKEYDIR

olddir = pwd;
if(~isdir([MONKEYDIR '/' day '/mat']))
   mkdir([MONKEYDIR '/' day '/mat']);
end
if isfile([MONKEYDIR '/' day '/mat/MocapTrials.mat'])
    delete([MONKEYDIR '/' day '/mat/MocapTrials.mat']);
end

MocapTrials = dbMocapDatabase(day);

cd([MONKEYDIR '/' day '/mat']);
disp(['Saving MocapTrials matrix: ' num2str(length(MocapTrials)) ' trials']);
save MocapTrials.mat MocapTrials

cd(olddir);
