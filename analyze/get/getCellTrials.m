function Trials = getCellTrials(Trials,sys,ch,cl)
%   Returns trials that have sys, ch and cl isolated
%
%   Trials = getCellTrials(Trials,sys,ch,cl)
%

SysNum = findSys(Trials,sys);

ind = zeros(1,length(Trials));
for iTr = 1:length(Trials)
    if ~isempty(Trials(iTr).Iso)
        if ~isempty(Trials(iTr).Iso{SysNum(iTr),ch})
            ind(iTr) = Trials(iTr).Iso{SysNum(iTr),ch}(cl);
        end
    end
end
Trials = Trials(find(ind));
