function [Trials, ia, ib] = intersectTrials(Trials1, Trials2);
%
%  [Trials, ia, ib] = intersectTrials(Trials1, Trials2)
%

Recs1 = cell(1,length(Trials1));
for iTrial = 1:length(Trials1)
  Recs1{iTrial} = Trials1(iTrial).Rec;
end
Tr1 = [Trials1.Trial];

Recs2 = cell(1,length(Trials2));
for iTrial = 1:length(Trials2)
  Recs2{iTrial} = Trials2(iTrial).Rec;
end
Tr2 = [Trials2.Trial];

ia = []; ib = [];
for iTr = 1:length(Trials1)
  ind = find(Tr2 == Tr1(iTr));
  if ~isempty(ind)
    for iIndTr = 1:length(ind)
      if Recs2{ind(iIndTr)}==Recs1{iTr}
        ia = [ia iTr];
        ib = [ib ind(iIndTr)];
      end
    end
  end
end

Trials = Trials1(ia);
