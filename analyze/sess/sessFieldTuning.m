function [Tuning,Nmin] = sessFieldTuning(Sess,Task,FieldString)
%  Bootstrap analysis to determine target dependence
%
%   [Tuning,Nmin] = sessFieldTuning(Session,Task,FieldString)
%
%   Inputs:  SESS    =   Cell array.  Session information
%            FIELDSTRING    =   String.  Analysis alignment.
%                   'Cue':   Field to 'TargsOn', bn to [0,200]
%                   'Delay':  Field to 'ReachAq', bn to [-250,50]
%                   'Movement'
%                   'Baseline'
%                   'PreReach'
%

global MONKEYDIR MONKEYNAME

if nargin < 2 Task = 'DelReachSaccade'; end
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
Cl = sessCellDepthInfo(Sess);
Contact = sessContact(Sess);

if isstruct(Sess{1})
  Trials = TaskTrials(Sess{1},Task);
else
  Trials = sessTrials(Sess,Task);
end


if isempty(Trials)
      disp('Not enough replications per condition');
    Tuning.P = [];
    Tuning.R = []; Tuning.Phi = []; Tuning.Sel = [];
    Tuning.Nmin = 0; Tuning.F = []; Tuning.Dir = [];
    return
end

T = [Trials.Target];
PT = [1:8];
N = zeros(1,8);
for iRE = 1:length(PT)
    N(iRE) = sum(T==PT(iRE));
end

N
Tind = find(N>2);
Nmin = min(N);
disp([num2str(Nmin) ' replications per condition']);

if Nmin < 3 
    disp('Not enough replications per condition');
    Tuning.P = zeros(1,1);
    Tuning.R = []; Tuning.Phi = []; Tuning.Sel = [];
    Tuning.Nmin = 0; Tuning.F = [];
    Tuning.Dir = zeros(1,1);
    return
end


GroupRE = []; Ind = [];
for iRE = 1:length(Tind)
    ind = find(T==Tind(iRE));
    ind = ind(randperm(length(ind)));
    Ind = [Ind ind(1:Nmin)];
    GroupRE = [GroupRE ones(1,Nmin)*Tind(iRE)];
end

Group = GroupRE;
Lfp = trialLfp(Trials(Ind),Sys,Ch,Contact,Field,bn);
N = diff(bn)./1e3;
Spec = dmtspec(Lfp,[N,10],1e3,400);
ff = [1:10:200];
for iF = 1:length(ff)
  [r(iF),phi(iF),sel(iF),f(iF,:)] = calcTuning(Spec(:,ff(iF)),Group,1:8);
  for i = 1:4000
    r_null(i) = calcTuning(Spec(:,ff(iF)),Group(randperm(length(Group))),1:8);
  end
  p(iF) = length(find(r_null>r(iF)))./4000;
end

Tuning.P = p; 
Tuning.R = r;
Tuning.Phi = phi;
Tuning.Sel = sel;
Tuning.Nmin = Nmin;
Tuning.F = f;
Tuning.Frequencies = ff;
Tuning.Dir = Tind;

