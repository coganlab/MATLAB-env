% Partial Coh task panel
% Before calling, you need to load Directions, set task 

clear CondParams AnalParams CondDiff AnalDiff;
SessType = sessType(Sess);
%SN = getSessionNumbers(Sess);
%SN_str = getSessionNumberString(Sess);

% sSess = splitSession(Sess);
% Type{1} = getSessionType(sSess{1});
% Type{2} = getSessionType(sSess{2});
% Type{3} = getSessionType(sSess{3});

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

%CondParams(1,1).Name = [task SessType 'PartialCoherogram' Type{order(1)}(1) Type{order(2)}(1) Type{order(3)}(1) '_' num2str(SN(order(1))) '_' num2str(SN(order(2))) '_' num2str(SN(order(3)))]; 
CondParams(1,1).Name = [task SessType 'PartialCoherogram']; 

CondParams(1,1).shuffle = 0;
CondParams(1,1).merge = 1;
CondParams(1,1).Task = {{Task}};
CondParams(1,1).conds = {[Dir.Pref]};
%CondParams(1,1).order = order;
CondParams(2,1) = CondParams(1,1);
CondParams(2,1).conds = {[Dir.Null]};


AnalParams(1,1).Type = 'PartialCoherogram';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = bn;
AnalParams(1,1).tapers = tapers;
 
AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'Go';






