function [EventTrials, NullTrials] = calcReachOnsetTrials(Session, InputParams)
%
%  [EventTrials, NullTrials] = calcReachOnsetTrials(Session, InputParams)
%

SessionTrials = sessTrials(Session);

%  Select Event trials
TotalTrials = [];
for iTask = 1:length(InputParams.Event.Task)
    Trials = TaskTrials(SessionTrials, InputParams.Event.Task{iTask});
    if ~isempty(Trials)
        TotalTrials = [TotalTrials Trials];
    end
end

Target = [TotalTrials.Target];
EventTrials = [];
for iTarget = 1:length(InputParams.Event.Target)
    EventTrials = [EventTrials TotalTrials(Target == InputParams.Event.Target(iTarget))];
end

%  Select Null trials
TotalTrials = [];
for iTask = 1:length(InputParams.Null.Task)
    Trials = TaskTrials(SessionTrials, InputParams.Null.Task{iTask});
    if ~isempty(Trials)
        TotalTrials = [TotalTrials Trials];
    end
end

Target = [TotalTrials.Target];
NullTrials = [];
for iTarget = 1:length(InputParams.Null.Target)
    NullTrials = [NullTrials TotalTrials(Target == InputParams.Null.Target(iTarget))];
end
