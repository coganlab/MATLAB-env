function y = calcDiscMRS(Trials)
%
%  y = calcDiscMRS(Trials)
%

y = zeros(1,length(Trials));

Trials_ind = find([Trials.TaskCode] == 18);
MRS_trials = Trials(Trials_ind);
%get all of the non-integer values

M_eyetarg_tmp = [MRS_trials.EyeTargetLocation];
M_eyetarg = reshape([M_eyetarg_tmp],2,length([MRS_trials]));
M_eyeones = [ones(size(M_eyetarg))];
M_eye_discrete_tmp = (rem(M_eyetarg,M_eyeones) == 0);

M_handtarg_tmp = [MRS_trials.HandTargetLocation];
M_handtarg = reshape([M_handtarg_tmp],2,length([MRS_trials]));
M_handones = [ones(size(M_handtarg))];
M_hand_discrete_tmp = (rem(M_handtarg,M_handones) == 0);

M_discrete = M_eye_discrete_tmp(1,:) + M_eye_discrete_tmp(2,:) + ...
    M_hand_discrete_tmp(1,:) + M_hand_discrete_tmp(2,:);

%%%%%% Variable Name
%MRS_continuous = MRS_trials(M_continuous ~= 2)

Trials_ind2 = find(M_discrete == 4);

y(Trials_ind(Trials_ind2)) = 1;

