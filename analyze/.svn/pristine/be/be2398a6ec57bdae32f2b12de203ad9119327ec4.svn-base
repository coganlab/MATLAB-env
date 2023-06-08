function saveErrorTrials(day)
%
%   saveErrorTrials(day)
%

global MONKEYDIR

olddir = pwd;

if isfile([MONKEYDIR '/' day '/mat'])
    if isfile([MONKEYDIR '/' day '/mat/ErrorTrials.mat'])
        delete([MONKEYDIR '/' day '/mat/ErrorTrials.mat']);
    end
else
    cmd = ['mkdir ' Directory '/mat'];
    unix(cmd);
    disp([Directory ' made']);
end

ErrorTrials = dbErrorDatabase(day);

cd([MONKEYDIR '/' day '/mat']);
disp(['Saving ErrorTrials matrix: ' num2str(length(ErrorTrials)) ' trials']);
save ErrorTrials.mat ErrorTrials

cd(olddir);
