% Coherogram task panel
% Before calling, you need to load Directions and set task

clear CondParams AnalParams CondDiff AnalDiff;
SessType = sessType(Sess);

bn = [-500,1000];
tapers = [.5,10];
switch task
    case 'MST'
        Task = 'MemorySaccadeTouch';
    case 'MRS'
        Task = 'MemoryReachSaccade';
    case ''
        Task = {'MemoryReachSaccade','MemorySaccadeTouch'};
end


CondParams(1,1).Name = [task SessType 'Coherogram']; 

CondParams(1,1).shuffle = 0;
CondParams(1,1).merge = 1;
CondParams(1,1).Task = {{Task}};
CondParams(1,1).conds = {[Dir.Pref]};
CondParams(2,1) = CondParams(1,1);
CondParams(2,1).conds = {[Dir.Null]};

AnalParams(1,1).Type = 'Coherogram';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = bn;
AnalParams(1,1).tapers = tapers;
 
AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'Go';






