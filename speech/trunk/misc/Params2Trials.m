function Trials = Params2Trials(Trials,Params)
%
%  Trials = Params2Trials(Trials,Params)
%
%  Params.Conds
%  Params.IntervalName
%  Params.IntervalDuration
%
%

% Task = Params.Task;

% 
% if ischar(Task) && ~isempty(Task)
%     NewTask{1} = {Task}; Task = NewTask;
% elseif iscell(Task)
%     for iTaskComp = 1:length(Task)
%       if ~iscell(Task{iTaskComp})
%         NewTask(iTaskComp) = {Task(iTaskComp)};
%       else
%         NewTask(iTaskComp) = Task(iTaskComp);
%       end
%     end
%     Task = NewTask;
% end

% Trials = cell(1,length(Task));
% if ~isempty(Task)
%     for iTaskComp = 1:length(Task)
%         for iTaskPool = 1:length(Task{iTaskComp})
%             disp(['Now working on ' Task{iTaskComp}{iTaskPool}])
%             Trials{iTaskComp} = [Trials{iTaskComp},TaskTrials(Session,Task{iTaskComp}{iTaskPool})];
%         end
%         if ~isempty(conds)
%             Trials{iTaskComp} = TrialConds(Trials{iTaskComp},conds);
%         end
%         NTrials(iTaskComp) = length(Trials{iTaskComp});
%     end
%     NCoh = min(NTrials);
%     for iTaskComp = 1:length(Trials)
%         ind = randperm(NTrials(iTaskComp));
%         Trials{iTaskComp} = Trials{iTaskComp}(ind(1:NCoh));
%     end
%     Trials{1} = Trials;
% end

% for iTaskComp = 1:length(Task)

% if isfield(Params,'Conds2') && ~isempty(Params.Conds2)
%     Trials = Trials(ismember([Trials.StartCode],Params.Conds2));

if isfield(Params,'Conds') && ~isempty(Params.Conds)
    Trials = Trials(ismember([Trials.StartCode],Params.Conds));
end

if isfield(Params,'PropertyName')
    for iProperty = 1:length(Params.PropertyName)
        disp(['Selecting by ' Params.PropertyName{iProperty}]);
      Name = Params.PropertyName{iProperty};
      Value = Params.PropertyValue{iProperty};
      Trials = Trials(ismember([Trials.(Name)],Value));
    end
end

if isfield(Params,'IntervalName')
    eval(['Interval = calc' Params.IntervalName '(Trials);']);
    if Params.IntervalDuration(1) >= 0 & Params.IntervalDuration(1) <= 1 & ...
            Params.IntervalDuration(2) >= 0 & Params.IntervalDuration(2) <= 1
        %  IntervalDuration is a proportion
        [SortedIntervals,Indices] = sort(Interval,'ascend');
        LowerInd = max([1,round(Params.IntervalDuration(1)*length(Interval))]);
        UpperInd = min([length(Interval),round(Params.IntervalDuration(2)*length(Interval))]);
        Ind = Indices(LowerInd:UpperInd);
    else
        %  IntervalDuration is a time in ms
        Ind = find(Interval <= Params.IntervalDuration(2) & ...
            Interval >= Params.IntervalDuration(1));
    end
    Trials = Trials(Ind);
end

