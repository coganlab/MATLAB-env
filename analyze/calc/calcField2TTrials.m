function ChoiceNumTrials = calcField2TTrials
% Return the number of 2T Reward Mag trials in Field Database
global MONKEYDIR
session = Field_Database;

for i = 1:length(session)
    trials = sessTrials(session{i});
    if(length(trials) > 0) 
        trials = trials(find([trials.Choice] == 2));
    end
    ChoiceNumTrials(i) = length(trials);
end

save([MONKEYDIR '/mat/Choice/2TRewMagNumTrials.mat'],'ChoiceNumTrials')
end