function y = calcMRSAxisDiss(Trials)
%
%  y = calcMRSAxisDiss(Trials)
%

y = zeros(1,length(Trials));

Trials_ind = find([Trials.TaskCode] == 18);
MRS_trials = Trials(Trials_ind);

MRS_trials_axis_diss_one_five = find([MRS_trials.Target]'==1 & [MRS_trials.EyeTarget]'==5);
MRS_trials_axis_diss_five_one = find([MRS_trials.Target]'==5 & [MRS_trials.EyeTarget]'==1);
MRS_trials_axis_diss_seven_three = find([MRS_trials.Target]'==7 & [MRS_trials.EyeTarget]'==3);
MRS_trials_axis_diss_three_seven = find([MRS_trials.Target]'==3 & [MRS_trials.EyeTarget]'==7);
MRS_trials_axis_diss_six_two = find([MRS_trials.Target]'==6 & [MRS_trials.EyeTarget]'==2);
MRS_trials_axis_diss_two_six = find([MRS_trials.Target]'==2 & [MRS_trials.EyeTarget]'==6);
MRS_trials_axis_diss_four_eight = find([MRS_trials.Target]'==4 & [MRS_trials.EyeTarget]'==8);
MRS_trials_axis_diss_eight_four = find([MRS_trials.Target]'==8 & [MRS_trials.EyeTarget]'==4);

y(Trials_ind(MRS_trials_axis_diss_one_five))=1;
y(Trials_ind(MRS_trials_axis_diss_five_one))=1;
y(Trials_ind(MRS_trials_axis_diss_seven_three))=1;
y(Trials_ind(MRS_trials_axis_diss_three_seven))=1;
y(Trials_ind(MRS_trials_axis_diss_six_two))=1;
y(Trials_ind(MRS_trials_axis_diss_two_six))=1;
y(Trials_ind(MRS_trials_axis_diss_four_eight))=1;
y(Trials_ind(MRS_trials_axis_diss_eight_four))=1;
