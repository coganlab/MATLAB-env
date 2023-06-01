function y = calcDRSPaired(Trials)
%
%  y = calcDRSPaired(Trials)
%

y = zeros(1,length(Trials));

Trials_ind = find([Trials.TaskCode] == 13);
DRS_trials = Trials(Trials_ind);

Trials_ind2 = find([DRS_trials.Target] == [DRS_trials.EyeTarget]);
DRS_trials_paired_tmp = DRS_trials(Trials_ind2);

%however, this also includes all continuous trials by default
eyetarg_tmp = [DRS_trials_paired_tmp.EyeTargetLocation]
eyetarg = reshape([eyetarg_tmp],2,length([DRS_trials_paired_tmp]))
eyeones = [ones(size(eyetarg))]
paired_tmp = (rem(eyetarg,eyeones) == 0)
paired = paired_tmp(1,:)+paired_tmp(2,:)
%%%%%% Variable Name
Trials_ind3 = find(paired == 2);
%DRS_trials_paired = DRS_trials_paired_tmp(paired == 2)

y(Trials_ind(Trials_ind2(Trials_ind3))) = 1;
