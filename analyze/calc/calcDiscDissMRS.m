function y = calcDiscDissMRS(Trials)
%
%  y = calcDiscDissMRS(Trials)
%

y = zeros(1,length(Trials));

Trials_ind = find([Trials.TaskCode] == 18);
MRS_trials = Trials(Trials_ind);

Trials_ind2 = find([MRS_trials.Target]' ~= [MRS_trials.EyeTarget]');
MRS_trials_disc_diss_tmp = MRS_trials(Trials_ind2);
M_overlap = ismember([MRS_trials_disc_diss_tmp.Trial],[MRS_trials_axis_diss.Trial]);
%%%%%% Variable Name
Trials_ind3 = find(M_overlap == 0);
%MRS_trials_disc_diss = MRS_trials_disc_diss_tmp(M_overlap == 0)

y(Trials_ind(Trials_ind2(Trials_ind3))) = 1;

