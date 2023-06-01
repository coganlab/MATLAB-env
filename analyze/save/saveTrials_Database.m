function saveTrials_Database
%
%  saveTrials_Database;
%

global MONKEYDIR

Session = loadMultiunit_Database;

Days = sessDay(Session);
uDays = unique(Days);
nDay = length(unique(Days));
Trials = dbSelectTrials(uDays{1});
for iDay = 2:nDay
  Trials = [Trials dbSelectTrials(uDays{iDay})];
end

save([MONKEYDIR '/mat/Trials_Database.mat'],'Trials','-v7.3');
