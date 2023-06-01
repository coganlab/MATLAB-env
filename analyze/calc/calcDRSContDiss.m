function y = calcDRSContDiss(Trials)
%
%  y = calcDRSContDiss(Trials)
%

y = zeros(1,length(Trials));

Trials_ind = find([Trials.TaskCode] == 13);
DRS_trials = Trials(Trials_ind);
%get all of the non-integer values
eyetarg_tmp = [DRS_trials.EyeTargetLocation];
eyetarg = reshape([eyetarg_tmp],2,length([DRS_trials]));
eyeones = [ones(size(eyetarg))];
continuous_tmp = (rem(eyetarg,eyeones) == 0);
continuous = continuous_tmp(1,:)+continuous_tmp(2,:);
%%%%%% Variable Name
Trials_ind2 = find(continuous ~= 2);
%DRS_continuous = DRS_trials(Trials_ind2);

y(Trials_ind(Trials_ind2)) = 1;
