
function InitLabview(handles)
global MONKEYDIR

%  Initialize Labview task controllers
TaskControllers = dir([MONKEYDIR '/Labview']);
TaskControllers = TaskControllers(3:end);

nTask = length(TaskControllers);
TaskControllerCell = cell(1,nTask);
for iTask = 1:nTask
    TaskControllerCell{iTask} = TaskControllers(iTask).name;
end
set(handles.popTaskController,'String',TaskControllerCell);
