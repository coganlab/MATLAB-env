function TaskController = sessTaskController(Session)
%
%  TaskController = sessTaskController(Session)
%

MonkeyDir = sessMonkeyDir(Session);
Recs = sessRec(Session);
Day = sessDay(Session);

Rec = loadRec(Day, Recs{1}, MonkeyDir);
if ~isempty(Rec)
    TaskController = Rec.Task;
else
    experiment = loadExperiment(Day, Recs{1}, MonkeyDir);
    %  Get Task Controller info from experiment.
end