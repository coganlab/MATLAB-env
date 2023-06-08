function SelectedIntervals = CondSelIndices(Intervals, IntervalDuration);
%
%  SelectedIntervals = CondSelIndices(Intervals, IntervalDuration)
%


if IntervalDuration(1) >= 0 & IntervalDuration(1) <= 1 & ...
        IntervalDuration(2) >= 0 & IntervalDuration(2) <= 1
    [SortedIntervals,Indices] = sort(Intervals, 'ascend');
    %  IntervalDuration is a proportion
    LowerInd = max([1,round(IntervalDuration(1)*length(Intervals))]);
    UpperInd = min([length(Intervals),round(IntervalDuration(2)*length(Intervals))]);
    SelectedIntervals = Indices(LowerInd:UpperInd);
else
    %  IntervalDuration is a time in ms
    Ind = find(Intervals <= IntervalDuration(2) & Intervals >= IntervalDuration(1));
    SelectedIntervals = Ind;
end
