function Time = calcJointRT(Trials)
%
%  Time =  (SaccStart - Go) + (ReachStart - Go);

Time = [Trials.SaccStart] - [Trials.Go] + [Trials.ReachStart] - [Trials.Go];
