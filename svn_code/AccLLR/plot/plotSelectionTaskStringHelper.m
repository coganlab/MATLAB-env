function TaskString = plotSelectionTaskStringHelper(Params)
%
%  TaskString = plotSelectionTaskStringHelper(Params)
%

switch Params.Type
    case 'Effector'
        if iscell(Params.Event.Task)
            TaskString = [Params.Event.Task{1} ' ' Params.Null.Task{1}];
        else
            TaskString = [Params.Event.Task ' ' Params.Null.Task];
        end
    otherwise
        TaskString = [];
        try Params.Task
        catch
            Params.Task = Params.Event.Task;
        end
        if iscell(Params.Task)
            for iTask = 1:length(Params.Task)
                TaskString = [TaskString ' ' Params.Task{iTask}];
            end
            TaskString = TaskString(2:end);
        else
            TaskString = Params.Task;
        end 
end

