function Rank = calcJointRTRank(Trials)
%
%  Rank = Fastest JointRT = 0
%         Slowest JointRT = 1

Time = calcJointRT(Trials);
[dum,ind] = sort(Time);
Ntrials = length(Time);
Rank = zeros(1,Ntrials);
Rank(ind) = linspace(0,1,Ntrials);
