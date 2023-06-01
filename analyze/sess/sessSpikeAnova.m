function [Anova,Nmin] = sessSpikeAnova(Sess,Task,FieldString)
%  Anova analysis to determine tuning of activity
%
%   [Anova,Nmin] = sessSpikeAnova(Session,Task,FieldString)
%
%   Inputs:  SESS    =   Cell array.  Session information
%               Can include Trials as 1st cell
%	     TASK
%            FIELDSTRING    =   String.  Analysis alignment.
%                   'Cue':   Field to 'TargsOn', bn to [0,200]
%                   'Delay':  Field to 'ReachAq', bn to [-250,50]
%                   'Movement'
%                   'Baseline'
%                   'PreReach'
%

global MONKEYDIR MONKEYNAME

if nargin < 2 Task = {'DelReachSaccade'}; end
if nargin < 3 FieldString = 'Delay'; end
if isstr(FieldString)
    switch FieldString
        case 'PreSacc'
            Field = 'LRSaccStart';
            bn = [-400,-100];
        case 'PreReach'
            Field = 'ReachStart';
            bn = [-500,-200];
        case 'Delay'
            Field = 'TargsOn';
            bn = [500,1e3];
        case 'Cue'
            Field = 'TargsOn';
            bn = [0,500];
        case 'Movement'
            Field = 'TargAq';
            bn = [-250,50];
        case 'PostMovement'
            Field = 'TargAq';
            bn = [0,300];
        case 'Baseline'
            Field = 'TargsOn';
            bn = [-600,-300];
    end
elseif isstruct(FieldString)
    Field = FieldString.Field;
    bn = FieldString.bn;
end

Sys = sessTower(Sess);
Ch = sessElectrode(Sess);
Contact = sessContact(Sess);
Cl = sessCell(Sess);

if isstruct(Sess{1})
    Trials = Sess{1};
else
    Trials = sessTrials(Sess);
end

if ischar(Task) Task = {Task}; end

N = [];
for iTask = 1:length(Task)
    myTrials{iTask} = TaskTrials(Trials, Task{iTask});
    if length(myTrials{iTask})
        Ta = getTarget(myTrials{iTask});
        N(iTask,:) = hist(Ta,[1:9]);
        T{iTask} = Ta;
    else
        N(iTask,:) = zeros(1,9);
        T{iTask} = 0;
        Anova.P = [];
        Anova.T = [];
        Anova.Stats = [];
        Anova.Nmin = 0;
        Anova.Task = Task{iTask};
        Anova.Dir = [];
        return
    end
end
N = N(:,1:end-1);

Tind = find(N>2);
Nmin = min(N);
disp([num2str(Nmin) ' replications per condition']);

if Nmin < 3
    Anova.P = [];
  Anova.T = [];
  Anova.Stats = [];
  Anova.Nmin = 0;
  Anova.Task = Task{iTask};
  Anova.Dir = [];
  return
end


for iTask = 1:length(Task)
  A = [];
  for iT = 1:length(Tind)
     ind = find(T{iTask} == Tind(iT));
     A = [A;ind(1:Nmin)];
  end
  Ind{iTask} = A;
end

for iTask = 1:length(Task)
  for iDir = 1:length(Tind)
    Tr = myTrials{iTask};
    I = Ind{iTask};  
    Rate(iTask,iDir,:) = trialRate(Tr(I(iDir,:)),Sys,Ch,Contact,Cl,Field,bn);
  end
end
Rate = permute(Rate,[3,1,2]);

Rate = reshape(Rate,[Nmin.*length(Task),length(Tind)]);
if length(Task) == 1
  [p,t,stats] = anova1(Rate,[],'off');
elseif length(Task) > 1
  [p,t,stats] = anova2(Rate,Nmin,'off');
end


Anova.P = p; 
Anova.T = t;
Anova.Stats = stats;
Anova.Nmin = Nmin;
Anova.Task = Task;
Anova.Dir = Tind;
