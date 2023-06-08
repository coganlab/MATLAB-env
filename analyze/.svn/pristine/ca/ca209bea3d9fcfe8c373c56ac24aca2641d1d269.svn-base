function Rank = calcSaccadeRTRank(Trials)
%
%  Rank = Fastest SaccadeRT = 0
%         Slowest SaccadeRT = 1

Time = [Trials.SaccStart] - [Trials.Go];
[dum,ind] = sort(Time);
Ntrials = length(Time);
Rank = zeros(1,Ntrials);
Rank(ind) = linspace(0,1,Ntrials);
