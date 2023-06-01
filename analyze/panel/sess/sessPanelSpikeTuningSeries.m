function Tuning = sessPanelSpikeTuningSeries(Sess,CondParams,AnalParams,calcVonMises)
%
%   Tuning = sessPanelSpikeTuningSeries(Sess,CondParams,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Tuning structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Tuning structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   AnalParams.Field   =   String.  Alignment field
%   AnalParams.bn      =   Alignment time.
%   CondParams.cond    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.sort = 'STRING';

if nargin<4
  calcVonMises = 0;
  doBaselineComparison = 0;
elseif calcVonMises
  doBaselineComparison = 1;
  if isfield(AnalParams,'doBaselineComparison')
    doBaselineComparison = AnalParams.doBaselineComparison;
  end
end

if(isfield(AnalParams,'sampling_rate'))
    sampling_rate = AnalParams.sampling_rate;
else
    sampling_rate = 1e3;
end
if(isfield(AnalParams,'wlen'))
    wlen = AnalParams.wlen;
else
    wlen = 0.3;
end
if(isfield(AnalParams,'dn'))
    dn = AnalParams.dn;
else
    dn = 0.05;
end

if(~isfield(CondParams,'Task'))
    CondParams.Task = 'DelSaccade';
end
Task = CondParams.Task;

if(~isfield(CondParams,'conds'))
    CondParams.conds = {[]};
end

if(isfield(AnalParams,'bn'))
    bn = AnalParams.bn;
else
    bn = [-1e3,2e3];
end
if(isfield(AnalParams,'Field'))
    Field = AnalParams.Field;
else
    Field = 'TargsOn';
end
if(isfield(AnalParams,'nPerm'))
  nPerm = AnalParams.nPerm;
else
  nPerm = 1e3;
end

Tuning = [];

wlen = floor(wlen.*sampling_rate);
dn = floor(dn.*sampling_rate);
nwin = single(floor(diff(bn)/dn)+1);  % calculate the number of windows

RateTuningP = zeros(1,nwin);
if calcVonMises==0
  RateTuningR = zeros(1,nwin);
  RateTuningPhi = zeros(1,nwin);
  RateTuningSel = zeros(1,nwin);
  RateTuningF = zeros(8,nwin);
elseif calcVonMises==1
  phat_alt = zeros(4,nwin);
  pci_alt = zeros(2,4,nwin);
  phat_null = zeros(1,nwin);
  pci_null = zeros(2,1,nwin);
  p = zeros(1,nwin);
end

% This handles Trials in Sess{1} instead of Day.
if isstruct(Sess{1})
    All_Trials = Sess{1};
else
    All_Trials = sessTrials(Sess);
end

All_Trials = Params2Trials(All_Trials,CondParams);

if(~iscell(All_Trials))
    Trials{1} = All_Trials;
else
    Trials = All_Trials;
end

% Filter out choice trials
Trials{1} = Trials{1}([Trials{1}.Choice]==1);

nTrials = numel(Trials);

SpikeSession = Sess;

disp([num2str(length(Trials{1})) ' Trials'])

if length(Trials{1}) > 3 && isempty(find(isnan([Trials{1}.(Field)]),1))
    numtrials = length(Trials{1});
    Day = SpikeSession{1}(1).Day;
    Sys = sessTower(SpikeSession);
    Ch = sessElectrode(SpikeSession);
    Contact = sessContact(SpikeSession);
    Cl = sessCell(SpikeSession);
    Target = [Trials{1}.Target]; nTrials = length(Target);
    sp = trialSpike(Trials{1}, Sys{1}, Ch, Contact, Cl, Field,[bn(1)-wlen/2,bn(2)+wlen/2]);
    
    if calcVonMises & doBaselineComparison
      baseSp = trialSpike(Trials{1}, Sys{1}, Ch, Contact, Cl, 'TargsOn', [-150-wlen/2,-150+wlen/2]);
    end
                
    Nmin = zeros(1,8);
        
    for win = 1:nwin
      wRange = [ dn*(win-1)-wlen/2 dn*win+wlen/2 ];
      for iTarget = 1:8 
        TargetInd = find(Target==iTarget);
        Nmin(iTarget) = numel(TargetInd);
      end
      if calcVonMises==0      
        Ind = [];
        Group = [];
        spTot = zeros(numel(Target),1);
        iSpTot = 1;
        for iTarget = 1:8 
          TargetInd = find(Target==iTarget);
          for k=1:numel(TargetInd)
            spTot(iSpTot) = numel(find(sp{TargetInd(k)}>=wRange(1)&sp{TargetInd(k)}<=wRange(2))); 
            iSpTot = iSpTot + 1;
          end
          Ind = [Ind TargetInd];
          Group = [Group ones(1,length(TargetInd))*iTarget];
        end
        [r,phi,sel,F] = calcTuning(spTot,Group,1:8);
        r_null = zeros(1,nPerm);
        parfor i = 1:nPerm
          r_null(i) = calcTuning(spTot,Group(randperm(length(Group))),1:8);
        end
        p = sum(r_null>r)./nPerm;
        RateTuningP(win) = p;
        RateTuningR(win) = r;
        RateTuningPhi(win) = phi;
        RateTuningSel(win) = sel;
        RateTuningF(:,win) = F;
      elseif calcVonMises==1
        Rate = zeros(1,numel(Trials));
        for k=1:nTrials
          Rate(k) = numel(find(sp{k}>=wRange(1)&sp{k}<=wRange(2)));
        end
        Rate = Rate + eps; % vonMises code can crash if all rates are zero
        
        if Trials{1}(1).Saccade
          TargetAngle = calcEyeTargetAngle(Trials{1});
        elseif Trials{1}(1).Reach
          TargetAngle = calcHandTargetAngle(Trials{1});
        end
        
        % If no eye/hand target specified, use Target field instead.
        nanInd = find(isnan(TargetAngle));
        if numel(nanInd)>0
          Theta = [0 1 2 3 4 -3 -2 -1 ].*pi/4;
          TargetAngle(nanInd) = Theta([Trials{1}(nanInd).Target]);
        end
        
        if doBaselineComparison
          BaseRate = zeros(1,numel(Trials{1}));
          for k=1:nTrials
            BaseRate(k) = numel(baseSp{k}); % find(baseSp{k}>=wRange(1)&baseSp{k}<=wRange(2))); 
          end     
          Data = calcTuningVonMises(Rate,TargetAngle,BaseRate,Target);
        else
          Data = calcTuningVonMises(Rate,TargetAngle);
        end

        phat_alt(:,win) = Data.phat_alt;
        pci_alt(:,:,win) = Data.pci_alt;
        phat_null(:,win) = Data.phat_null;
        pci_null(:,:,win) = Data.pci_null;
        p(win) = Data.p;        
      end
    end
    
  if calcVonMises==0
    Tuning.P = RateTuningP;      
    Tuning.R = RateTuningR;
    Tuning.Phi = RateTuningPhi;
    Tuning.Sel = RateTuningSel;
    Tuning.F = RateTuningF;
    Tuning.Dir = [1:8];
  elseif calcVonMises==1
    Tuning.P = p;      
    Tuning.phat_alt = phat_alt;
    Tuning.pci_alt = pci_alt;
    Tuning.phat_null = phat_null;
    Tuning.pci_null = pci_null;
  end
  Tuning.Nmin = Nmin;
  Tuning.t = [bn(1):dn:bn(2)];
  Sess{1} = Day;
  Tuning.Session = Sess;
end
