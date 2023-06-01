function y = calcContDissMRS(Trials)
%
%  y = calcContDissMRS(Trials)
%

y = zeros(1,length(Trials));

Trials_ind = find([Trials.TaskCode] == 18);
MRS_trials = Trials(Trials_ind);
%get all of the non-integer values

M_eyetarg_tmp = [MRS_trials.EyeTargetLocation];
M_eyetarg = reshape([M_eyetarg_tmp],2,length([MRS_trials]));
M_eyeones = [ones(size(M_eyetarg))];
M_continuous_tmp = (rem(M_eyetarg,M_eyeones) == 0);
M_continuous = M_continuous_tmp(1,:)+M_continuous_tmp(2,:);
%%%%%% Variable Name
%MRS_continuous = MRS_trials(M_continuous ~= 2)

Trials_ind2 = find(M_continuous ~= 2);

y(Trials_ind(Trials_ind2)) = 1;

