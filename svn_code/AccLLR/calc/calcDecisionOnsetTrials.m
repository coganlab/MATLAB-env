function [EventTrials, NullTrials] = calcDecisionOnsetTrials(Session, InputParams)
%
%  [EventTrials, NullTrials] = calcDecisionOnsetTrials(Session, InputParams)
%

SessionTrials = sessTrials(Session);

%  Select Event trials
Movement = []; TotalTrials = [];
for iTask = 1:length(InputParams.Event.Task)
    Trials = TaskTrials(SessionTrials, InputParams.Event.Task{iTask});
    if ~isempty(Trials)
        Trials = Trials([Trials.Choice]==2);
        TotalTrials = [TotalTrials Trials];
        switch InputParams.Event.Task{iTask}
            case 'DelReachSaccade'
                disp(InputParams.Event.Task{iTask})
                Movement = [Movement [Trials.SaccadeChoice]];
            case 'DelSaccadeTouch'
                disp(InputParams.Event.Task{iTask})
                Movement = [Movement [Trials.SaccadeChoice]];
            case 'DelReachFix'
                disp(InputParams.Event.Task{iTask})
                Movement = [Movement [Trials.ReachChoice]];
        end
    end
end
% Movement
Direction_Selected = InputParams.Event.Target;
EventTrials = [];
for iTarget = 1:length(InputParams.Event.Target)
    EventTrials = [EventTrials TotalTrials(Movement == InputParams.Event.Target(iTarget))];
end

%  Select Null trials
Movement = []; TotalTrials = [];
for iTask = 1:length(InputParams.Event.Task)
    Trials = TaskTrials(SessionTrials, InputParams.Null.Task{iTask});
    if ~isempty(Trials)
        Trials = Trials([Trials.Choice]==2);
        TotalTrials = [TotalTrials Trials];
        switch InputParams.Null.Task{iTask}
            case 'DelReachSaccade'
                disp(InputParams.Null.Task{iTask})
                Movement = [Movement [Trials.SaccadeChoice]];
            case 'DelSaccadeTouch'
                disp(InputParams.Null.Task{iTask})
                Movement = [Movement [Trials.SaccadeChoice]];
            case 'DelReachFix'
                disp(InputParams.Null.Task{iTask})
                Movement = [Movement [Trials.ReachChoice]];
        end
    end
end

if isempty(InputParams.Null.Target)
    NullTrials = TotalTrials;
else
    NullTrials = [];
    for iTarget = 1:length(InputParams.Null.Target)
        NullTrials = [NullTrials TotalTrials(Movement == InputParams.Null.Target(iTarget))];
    end
end