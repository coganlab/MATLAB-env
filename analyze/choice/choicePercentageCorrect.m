function [reward_values, percent_correct, number_trials] = choicePercentageCorrect(correct, rewardDist)

reward1 = rewardDist(:,1);
reward2 = rewardDist(:,2);

reward_values = unique(reward1)';
percent_correct = zeros(1,length(reward_values));
number_trials = zeros(1,length(reward_values));
for i = 1:length(reward_values)
   
    percent_correct(i) = mean(correct(find(reward1 == reward_values(i)))); 
   
   number_trials(i) = length(find(reward1 == reward_values(i)));
end

return;
