function y = calcDRSDiscAxisDiss(Trials)
%
%  y = calcDRSDiscAxisDiss(Trials)
%

y = zeros(1,length(Trials));

DRS_trials_axis_diss_one_five = find([DRS_trials.Target]'==1 & [DRS_trials.EyeTarget]'==5);
DRS_trials_axis_diss_five_one = find([DRS_trials.Target]'==5 & [DRS_trials.EyeTarget]'==1);
DRS_trials_axis_diss_seven_three = find([DRS_trials.Target]'==7 & [DRS_trials.EyeTarget]'==3);
DRS_trials_axis_diss_three_seven = find([DRS_trials.Target]'==3 & [DRS_trials.EyeTarget]'==7);
DRS_trials_axis_diss_six_two = find([DRS_trials.Target]'==6 & [DRS_trials.EyeTarget]'==2);
DRS_trials_axis_diss_two_six = find([DRS_trials.Target]'==2 & [DRS_trials.EyeTarget]'==6);
DRS_trials_axis_diss_four_eight = find([DRS_trials.Target]'==4 & [DRS_trials.EyeTarget]'==8);
DRS_trials_axis_diss_eight_four = find([DRS_trials.Target]'==8 & [DRS_trials.EyeTarget]'==4);

y(DRS_trials_axis_diss_one_five) = 1;
y(DRS_trials_axis_diss_five_one) = 1;
y(DRS_trials_axis_diss_seven_three) = 1;
y(DRS_trials_axis_diss_three_seven) = 1;
y(DRS_trials_axis_diss_six_two) = 1;
y(DRS_trials_axis_diss_two_six) = 1;
y(DRS_trials_axis_diss_four_eight) = 1;
y(DRS_trials_axis_diss_eight_four) = 1;
