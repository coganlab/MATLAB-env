function y = DRSDiscDiss(Trials)
%
%  y = DRSDiscDiss(Trials)
%

y = zeros(1,length(Trials));

Trials_ind = find([Trials.TaskCode] == 13);
DRS_trials = Trials(Trials_ind);

Trials_ind2 = find([DRS_trials.Target]' ~= [DRS_trials.EyeTarget]');
DRS_trials_disc_diss_tmp = DRS_trials(Trials_ind2);
overlap = ismember([DRS_trials_disc_diss_tmp.Trial],[DRS_trials_axis_diss.Trial]);

%%%%%% Variable Name
Trials_ind3 = find(overlap == 0);
%DRS_trials_disc_diss = DRS_trials_disc_diss_tmp(Trials_ind3)
%y = DRS_trials_disc_diss;

y(Trials_ind(Trials_ind2(Trials_ind3))) = 1;
