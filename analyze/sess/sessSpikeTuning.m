function [Tuning,Nmin,Rate] = sessSpikeTuning(Sess,CondParams,AnalParams)
%  Bootstrap analysis to determine target dependence
%
%   [Tuning,Nmin] = sessSpikeTuning(Session,CondParams,AnalParams)
%
%   Inputs:  SESS    =   Cell array.  Session information
%               Can include Trials as 1st cell
%           CONDPARAMS
%           ANALPARAMS
%
%
%           CondParams.Task
%           CondParams.sort
%           CondParams.FieldString    =   String.  Analysis alignment.
%                   'Cue':   Field to 'TargsOn', bn to [0,200]
%                   'Delay':  Field to 'TargsOn', bn to [500,1e3]
%                   'Movement'
%                   'Baseline'
%                   'PreReach'
%           or 
%           CondParams.Field
%           CondParams.bn
%
%           AnalParams.calcVonMises = Binary flag. Default 0. If 0, first trigonometric
%           moment is calculated. If 1, parameters are estimated for Von Mises
%           distribution.
%           AnalParams.nPerm = Scalar.  Number of permutations for testing
%           tuning with permutation test. 
%                       Defaults to 1e4;
%

global MONKEYDIR MONKEYNAME

if isfield(AnalParams,'nPerm')
    nPerm = AnalParams.nPerm;
else
    nPerm = 1e4;
end

if isfield(AnalParams,'calcVonMises')
    calcVonMises = AnalParams.calcVonMises;
else
    calcVonMises = 0; 
end

if isfield(AnalParams,'FieldString')
    FieldString = AnalParams.FieldString;
else
    FieldString = [];
end

if isfield(CondParams,'Field')
    Field = CondParams.Field;
end

if isfield(CondParams,'bn')
    bn = CondParams.bn;
end

if ischar(FieldString)
    switch FieldString
        case 'Baseline'
            Field = 'TargsOn';
            bn = [-600,-300];
        case 'CueTransient'
            Field = 'TargsOn';
            bn = [0 100];
        case 'CuePostTransient'
            Field = 'TargsOn';
            bn = [100 300];
        case 'Cue'
            Field = 'TargsOn';
            bn = [0 300];
        case 'EarlyDelay'
            Field = 'TargsOn';
            bn = [ 300 600 ];
        case 'Delay'
            Field = 'TargsOn';
            bn = [ 400 700 ];
        case 'PreSaccLateDelay'
            Field = 'SaccStart';
            bn = [ -500 -200 ];
        case 'PreSaccTransient'
            Field = 'SaccStart';
            bn = [-100 0];
        case 'PreReach'
            Field = 'ReachStart';
            bn = [-500,-200];
        case 'Movement'
            Field = 'TargAq';
            bn = [-250,50];            
        case 'PostMovement'
            Field = 'TargAq';
            bn = [0,300];
        case 'PostSacc'
            Field = 'SaccStart';
            bn = [0 300];            
    end
elseif isstruct(FieldString)
    Field = FieldString.Field;
    bn = FieldString.bn;
end
Day = sessDay(Sess);
Sys = sessTower(Sess);
Ch = sessElectrode(Sess);
Contact = sessContact(Sess);
Cl = sessCell(Sess);

% if iscell(Cl) % multiunit session?
%   Cl = 1; 
% end

if isstruct(Sess{1})
    Trials = Params2Trials(Sess{1},CondParams);
    if ~isempty(Trials)
      Day = Trials(1).Day;
    end
else
    Trials = sessTrials(Sess);
    Trials = Params2Trials(Trials,CondParams);
    if ~isempty(Trials)
      Day = Trials(1).Day;
    end
end


if isempty(Trials)
      disp('Not enough replications per condition');
    Tuning.P = nan;
    Tuning.R = []; Tuning.Phi = []; Tuning.Sel = [];
    Tuning.Nmin = 0; Tuning.F = []; Tuning.Dir = [];
    return
end

% Filter out choice trials
Trials = Trials([Trials.Choice]==1);

Tuning = [];
Nmin = [];

if isempty(Trials)
      disp('Not enough replications per condition');
    Tuning.P = nan;
    Tuning.R = []; Tuning.Phi = []; Tuning.Sel = [];
    Tuning.Nmin = 0; Tuning.F = []; Tuning.Dir = [];
    return
end

% Trials = Trials(find([Trials.Choice]==1));

T = [Trials.Target];
PT = [1:8];
N = zeros(1,8);
for iRE = 1:length(PT)
    N(iRE) = sum(T==PT(iRE));
end

%N
Tind = find(N>2);
Nmin = min(N);
disp([num2str(Nmin) ' replications per condition']);

if Nmin < 3 
    disp('Not enough replications per condition');
    Tuning.P = nan;
    Tuning.R = []; Tuning.Phi = []; Tuning.Sel = [];
    Tuning.Nmin = 0; Tuning.F = [];
    Tuning.Dir = zeros(1,1);
    return
end


GroupRE = []; Ind = [];
for iRE = 1:length(Tind)
    ind = find(T==Tind(iRE));
%     ind = ind(randperm(length(ind)));
%     Ind = [Ind ind(1:Nmin)];
    Ind = [Ind ind];
    GroupRE = [GroupRE ones(1,length(ind))*Tind(iRE)];
end

Group = GroupRE;
Rate = trialRate(Trials(Ind),Sys{1},Ch,Contact,Cl,Field,bn);

if calcVonMises==0
  [r,phi,sel,f] = calcTuning(Rate,Group,1:8);
  r_null = zeros(1,nPerm);
  for i = 1:nPerm
    r_null(i) = calcTuning(Rate,Group(randperm(length(Group))),1:8);
  end
  p = sum(r_null>r)./nPerm;  
  Tuning.P = p; 
  Tuning.R = r;
  Tuning.Phi = phi;
  Tuning.Sel = sel;
  Tuning.Nmin = Nmin;
  Tuning.F = f;
  Tuning.Dir = Tind;
else
  Target = T(Ind);
  if Trials(1).Saccade
    TargetAngle = calcEyeTargetAngle(Trials(Ind));
  elseif Trials(1).Reach
    TargetAngle = calcHandTargetAngle(Trials(Ind));
  end
  BaseRate = trialRate(Trials(Ind), Sys{1}, Ch, Contact, Cl, 'TargsOn', [-300 0]);
  Data = calcTuningVonMises(Rate,TargetAngle,BaseRate,Target);
  Tuning.phat_alt = Data.phat_alt;
  Tuning.pci_alt = Data.pci_alt;
  Tuning.phat_null = Data.phat_null;
  Tuning.pci_null = Data.pci_null;
  Tuning.p = Data.p;  
end

Sess{1} = Day;
Tuning.Session = Sess;
