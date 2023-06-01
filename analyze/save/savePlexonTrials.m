function savePlexonTrials(day)
%
%   savePlexonTrials(da,rec)
%

global MONKEYDIR

olddir = pwd;
if(~isdir([MONKEYDIR '/' day '/mat']))
   mkdir([MONKEYDIR '/' day '/mat']);
end
if isfile([MONKEYDIR '/' day '/mat/Trials.mat'])
    delete([MONKEYDIR '/' day '/mat/Trials.mat']);
end

Trials = dbPlexondatabase(day);


cd([MONKEYDIR '/' day '/mat']);
disp(['Saving Trials matrix: ' num2str(length(Trials)) ' trials']);
save('Trials.mat', 'Trials')

cd(olddir);
