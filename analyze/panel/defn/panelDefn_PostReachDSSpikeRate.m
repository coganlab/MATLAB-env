%  PostReachDS Spike Rate Tasks panel
clear CondParams AnalParams;
CondParams(1,1).Name = 'PostReachDS';
%SessType = getSessionType(Session);

CondParams(1,1).Task = {{'MemoryReachSaccade'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,2).Task = CondParams(1,1).Task;
CondParams(1,2).conds = {[Dirs(2)]};

CondParams(2,1).Task = {{'MemorySaccadeTouch'}};
CondParams(2,1).conds = {[Dirs(1)]};
CondParams(2,2).Task = CondParams(2,1).Task;
CondParams(2,2).conds = {[Dirs(2)]};

AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).Smoothing = 30;
AnalParams(1,1).Type = [SessType 'Rate'];

AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'SaccStart';
AnalParams(1,2).bn = [-1e3,1e3];

