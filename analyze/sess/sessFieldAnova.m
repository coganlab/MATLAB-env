function [Anova,Nmin] = sessFieldAnova(Sess,Task,FieldString)
%  Anova analysis to determine tuning of activity
%
%   [Anova,Nmin] = sessFieldAnova(Session,Task,FieldString)
%
%   Inputs:  SESS    =   Cell array.  Session information
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

Sys = sessTower(Sess);
Ch = sessElectrode(Sess);
Contact = sessContact(Sess);

if ischar(Task) Task = {Task}; end

N = [];
for iTask = 1:length(Task)
  if isstruct(Sess{1})
    Trials{iTask} = TaskTrials(Sess{1},Task{iTask});
  else
    Trials{iTask} = sessTrials(Sess,Task{iTask});
  end

    if length(Trials{iTask})
        Ta = getTarget(Trials{iTask});
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
        Anova.Frequencies = [];
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
  Anova.Frequencies = [];
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
    Tr = Trials{iTask};
    I = Ind{iTask};  
    Lfp = trialLfp(Tr(I(iDir,:)),Sys,Ch,Contact,Field,bn);
    Spec(iTask,iDir,:,:) = dmtspec(Lfp,[diff(bn)./1e3,10],1e3,400);
  end
end

ff = [1:10:400];
for iF = 1:length(ff)
  Tmp = permute(sq(Spec(:,:,:,ff(iF))),[3,1,2]);
  Tmp = reshape(Tmp,[Nmin.*length(Task),length(Tind)]);
  if length(Task) == 1
    [p(iF),t(iF,:,:),stats(iF)] = anova1(Tmp,[],'off');
  elseif length(Task) > 1
    [p(iF),t(iF,:,:),stats(iF)] = anova2(Tmp,Nmin,'off');
  end
end

Anova.P = p; 
Anova.T = t;
Anova.Stats = stats;
Anova.Nmin = Nmin;
Anova.Task = Task;
Anova.Dir = Tind;
Anova.Frequencies = ff;
