function Tuning = sessPanelFieldTuningSeries(Sess,CondParams, AnalParams,calcVonMises)
%
%   Tuning = sessPanelFieldTuningSeries(Sess,CondParams,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   AnalParams.Field   =   String.  Alignment field
%   AnalParams.bn      =   Alignment time.
%   CondParams.cond    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.sort = 'STRING';
%
%   AnalParams.Tapers  =   [N,W].  Defaults to [.5,10]
%   AnalParams.fk      =   Vector.  Select frequency band to test
%

if nargin<4
  calcVonMises = 0;
end

if(isfield(AnalParams,'fk'))
    fk = AnalParams.fk;
else
    fk = 200;
end
if length(fk)==1; fk = [0,fk]; end

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
if(isfield(AnalParams,'pad'))
    pad = AnalParams.pad;
else
    pad = 2;
end
if(isfield(AnalParams,'tapers'))
    tapers = AnalParams.tapers;
else
    tapers = [0.3,10];
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
    bn = [-2e3,2e3];
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
if(isfield(AnalParams,'scaleFactor'))
  nPerm = AnalParams.scaleFactor;
else
  scaleFactor = 1e3;
end

Day = sessDay(Sess);
Sys = sessTower(Sess);
Ch = sessElectrode(Sess);
Contact = sessContact(Sess);
MonkeyDir = sessMonkeyDir(Sess);

% This handles Trials in Sess{1} instead of Day.
if isstruct(Sess{1})
    All_Trials = Sess{1};
else
    All_Trials = sessTrials(Sess);
    Sess{1} = All_Trials;
end

All_Trials = Params2Trials(All_Trials,CondParams);

if(~iscell(All_Trials))
    Trials{1} = All_Trials;
else
    Trials = All_Trials;
end

N = tapers(1);
if length(tapers)==3
    W = tapers(2)./tapers(1);
else
    W = tapers(2);
end

Tuning = [];

bn_buffer = bn + (wlen+dn)*sampling_rate/2*[-1 1];

if length(Trials{1}) > 3 && isempty(find(isnan([Trials{1}.(Field)]),1))

  Lfp =  trialLfp(Trials{1},Sys{1},Ch,Contact,Field,bn_buffer,MonkeyDir);
        
  % remove trials with large deviations
  thresh = 6*std(Lfp(:));
  e = max(abs(Lfp'));
  ind = find(e<thresh);
  Lfp = Lfp(ind,:); Trials{1} = Trials{1}(ind);
    
  Target = [Trials{1}.Target];

  % Calculate LFP spectrum tuning
  [Spec,f] = tfspec(Lfp,tapers,sampling_rate,dn,fk,pad);
        
  T = Target;
  PT = [1:8];
  N = zeros(1,8);
  for iRE = 1:length(PT)
    N(iRE) = sum(T==PT(iRE));
  end

  SpecTarget = zeros(8,size(Spec,2),numel(f)); % need to initialize time here, too

  Tind = find(N>2);
  Nmin = min(N);
  GroupRE = []; Ind = [];
  for iRE = 1:length(Tind)
    ind = find(T==Tind(iRE));
    ind = ind(randperm(length(ind)));
    temp = Spec(ind,:);
    nanInd = find(isnan(sum(temp,2)));
    ind(nanInd) = [];
    Ind = [Ind ind(1:min(Nmin,numel(ind)))];    
    SpecTarget(Tind(iRE),:,:) = mean(Spec(ind(1:min(Nmin,numel(ind))),:,:),1); % do this for each time point, too
    GroupRE = [GroupRE ones(1,min(Nmin,numel(ind)))*Tind(iRE)];
  end
  Spec = Spec(Ind,:,:);
  Group = GroupRE;
  permInd = ceil(numel(Group)*rand(numel(Group),nPerm));
  
  p_t = zeros(size(Spec,2),numel(f));
  if calcVonMises==0
    r_t = p_t;
    phi_t = p_t;
    sel_t = p_t;
  elseif calcVonMises==1
    thetahat_t = p_t;
    kappa_t = p_t;
  end
          
  for t=1:size(Spec,2) % check that this is time dimension
    
    Spec_t = sq(Spec(:,t,:));
      
    if calcVonMises==0

      r_null = zeros(numel(f),nPerm);
      parfor iPerm = 1:nPerm
        r_null(:,iPerm) = calcTuning(Spec_t(permInd(:,iPerm),:),Group,1:8);
      end

      p = zeros(1,numel(f),'single');
      phi = p;
      sel = p;
      r = p;
      for iF = 1:numel(f)
        [r(iF),phi(iF),sel(iF),fSpec] = calcTuning(Spec_t(:,iF),Group,1:8);
        p(iF) = length(find(r_null(iF,:)>r(iF)))./nPerm;
      end
    
      p_t(t,:) = p;
      r_t(t,:) = r;
      phi_t(t,:) = phi;
      sel_t(t,:) = sel;
      
    elseif calcVonMises==1
        
      centers =(Group'-1)*pi/4;
      [kappa,thetahat,p] = calcTuningVonMises(Spec_t,centers);
      
      % Generate parameters for iter random distributions
      uCenters = unique(centers);  
      nullData = zeros(nPerm,numel(f));
      parfor iPerm = 1:nPerm
        shufSpec = Spec_t(permInd(:,iPerm),:);
        [kappa_rand,thetahat_rand,p_rand] = calcTuningVonMises(shufSpec,centers);
        nullData(iPerm,:) = p_rand>p;        
      end
      nullSum = sum(nullData,1);
      p = nullSum./nPerm;

      p_t(t,:) = p;
      thetahat_t(t,:) = thetahat;
      kappa_t(t,:) = kappa;
      
    end % if calcVonMises==0

  end % for t=1:size(Spec,1)

  
  Tuning.P = uint16(p_t*scaleFactor);
  if calcVonMises==0
    Tuning.R = int32(r_t*scaleFactor);
    Tuning.Phi = int16(phi_t*scaleFactor);
    Tuning.Sel = uint16(sel_t*scaleFactor);
      SpecTarget = log10(SpecTarget);
    Tuning.PSD = uint16(SpecTarget*scaleFactor);
    Tuning.Dir = [1:8];
  elseif calcVonMises==1
    Tuning.ThetaHat = int16(thetahat_t*scaleFactor);
    Tuning.Kappa = uint16(kappa_t*scaleFactor);
  end
  Tuning.Nmin = uint8(Nmin);
  Tuning.f = single(f);
  Tuning.t = single([bn(1):dn*1e3:bn(2)]);
  Tuning.scaleFactor = scaleFactor;

end
