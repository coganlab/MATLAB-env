function SOA = calcSOA(Trials)
%
%  SOA = ReachGo - SaccadeGo
%

SOA = [Trials.ReachGo] - [Trials.SaccadeGo];

