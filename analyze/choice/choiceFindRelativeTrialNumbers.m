

function relative_trial_num = choiceFindRelativeTrialNumbers(number_trials, switch_index)

trials = [1:number_trials];
switch_index = [0;switch_index;number_trials+1];
x = trials(ones(1,length(switch_index)),:);
xx = switch_index(:,ones(1,number_trials));
d = x - xx;
dd = d;
dd(find(d<0)) = 1e4;
relative_trial_num = min(dd);
plot(relative_trial_num)

return