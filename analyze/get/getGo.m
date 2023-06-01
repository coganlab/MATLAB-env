function Go = getGo(Trials);
%
% Go = getGo(Trials)
%

[Go{1:length(Trials)}] = deal(Trials.Go);
Go = cell2num(Go);
