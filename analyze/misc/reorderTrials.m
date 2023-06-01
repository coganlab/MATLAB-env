function Trials = reorderTrials(trials)
%
%  Trials = reorderTrials(Trials)
%
if iscell(trials) && length(trials)==1
    trials = trials{1};
end
Trials = trials;
recTrials = zeros(50,1);
tmp_rec_num = zeros(length(trials),1);
for iTrials = 1:length(trials)
    recTrials(str2num(trials(iTrials).Rec)) = recTrials(str2num(trials(iTrials).Rec)) +1;
    tmp_rec_num(iTrials) = str2num(trials(iTrials).Rec);
end

recStart = 1;
for iRec = 1:length(recTrials)
    if(recTrials(iRec) > 0)
        subTrials = trials(tmp_rec_num == iRec);
        [dum,ind] = sort([subTrials.Trial]);
        subTrials = subTrials(ind);
        Trials(recStart:recStart+recTrials(iRec)-1) = subTrials;
        recStart = recStart+recTrials(iRec);
    end
end
