function [err,spct] = skf_eval_state(truth, pred)
%SKF_EVAL_STATE Evaluate performance compared to true state sequence

p = (pred(1,:) < 0.5) +1;
err = sum(p ~= truth)/length(truth);

spct = sum(p-1)/length(truth);




