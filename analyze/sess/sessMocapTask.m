function Task = sessMocapTask(Session);

if iscell(Session{1})
nSess = length(Session)
for iSess = 1:nSess
Task{iSess} = Session{iSess}{3};
end
end
