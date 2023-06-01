function y = calcPairedMRS(Trials)
%
%  y = calcPairedMRS(Trials)
%

y = zeros(1,length(Trials));

Trials_ind = find([Trials.TaskCode] == 18);
MRS_trials = Trials(Trials_ind);

Trials_ind2 = find([MRS_trials.Target] == [MRS_trials.EyeTarget]);
MRS_trials_paired_tmp = MRS_trials(Trials_ind2);

M_eyetarg_tmp = [MRS_trials_paired_tmp.EyeTargetLocation];
M_eyetarg = reshape([M_eyetarg_tmp],2,length([MRS_trials_paired_tmp]));
M_eyeones = [ones(size(M_eyetarg))];
M_paired_tmp = (rem(M_eyetarg,M_eyeones) == 0);
M_paired = M_paired_tmp(1,:)+M_paired_tmp(2,:);

Trials_ind3 = find(M_paired == 2);
%MRS_trials_paired = MRS_trials_paired_tmp(M_paired == 2)

y(Trials_ind(Trials_ind2(Trials_ind3))) = 1;

