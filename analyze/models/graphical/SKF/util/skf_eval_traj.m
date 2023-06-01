function [CC] = skf_eval_traj(traj,pred)
%SKF_EVAL_TRAJ Compute correlation coefficients

CC = [];
for i=1:size(traj,1)
    C = corrcoef(traj(i,:),pred(i,:));
    CC(i) = C(1,2);
end
