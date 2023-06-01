function Data = sessPanelFieldTuningSpectrogram(Sess,CondParams, AnalParams)
%
%   Data = sessPanelFieldTuningSpectrogram(Sess,CondParams,AnalParams)
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
    tapers = [0.5,5];
end

if(~isfield(CondParams,'Task'))
    CondParams.Task = 'DelReachSaccade';
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


N = tapers(1);
if length(tapers)==3
    W = tapers(2)./tapers(1);
else
    W = tapers(2);
end

FieldSession = extractFieldSession(Sess);

disp([num2str(length(Trials{1})) ' Trials'])

if length(Trials{1}) > 3 && isempty(find(isnan([Trials{1}.(Field)]),1))
    numtrials = length(Trials{1});
    Sys = sessTower(FieldSession);
    Ch = sessElectrode(FieldSession);
    Contact = sessContact(FieldSession);
    MonkeyDir = sessMonkeyDir(FieldSession);

    Lfp = trialLfp(Trials{1}, Sys, Ch, Contact, Field, ...
        [bn(1)-N/2*sampling_rate,bn(2)+N/2*sampling_rate], MonkeyDir);
    thresh = 6*std(Lfp(:));
    e = max(abs(Lfp'));
    ind = find(e<thresh);
    Lfp = Lfp(ind,:); Trials{1} = Trials{1}(ind);
    [Spec,f] = tfspec(Lfp,[N,W],sampling_rate,dn,fk,pad);
    Spec = log(Spec);

    Target = [Trials{1}.Target]; nTrials = length(Target);
    SpecTarget = zeros(8,size(Spec,2),size(Spec,3),'single');
    theta = [0:pi./4:2*pi];
    for iTarget = 1:8 
      Ns(iTarget) = length(find(Target==iTarget));
      z(iTarget) = exp(complex(0,1).*theta(iTarget));
      scale(iTarget) = z(iTarget)./Ns(iTarget);
      TargetInd = find(Target==iTarget);
      SpecTarget(iTarget,:,:) = scale(iTarget).*sq(sum(Spec(TargetInd,:,:),1));
    end
    rSpec = sq(sum(SpecTarget,1));
    rSpec = rSpec.*conj(rSpec);
    PermSpecTarget = zeros(8,size(Spec,2),size(Spec,3),'single');
    rPerm = zeros(nPerm,size(Spec,2),size(Spec,3),'single');
    
    for iPerm = 1:nPerm
      PermTarget = Target(randperm(nTrials));
      tempPermSpecTarget = zeros(8,size(Spec,2),size(Spec,3),'single');
      tempPermSpecTarget(1,:,:) = z(1).*sq(sum(Spec(PermTarget==1,:,:),1))./Ns(1);
      tempPermSpecTarget(2,:,:) = z(2).*sq(sum(Spec(PermTarget==2,:,:),1))./Ns(2);
      tempPermSpecTarget(3,:,:) = z(3).*sq(sum(Spec(PermTarget==3,:,:),1))./Ns(3);
      tempPermSpecTarget(4,:,:) = z(4).*sq(sum(Spec(PermTarget==4,:,:),1))./Ns(4);
      tempPermSpecTarget(5,:,:) = z(5).*sq(sum(Spec(PermTarget==5,:,:),1))./Ns(5);
      tempPermSpecTarget(6,:,:) = z(6).*sq(sum(Spec(PermTarget==6,:,:),1))./Ns(6);
      tempPermSpecTarget(7,:,:) = z(7).*sq(sum(Spec(PermTarget==7,:,:),1))./Ns(7);
      tempPermSpecTarget(8,:,:) = z(8).*sq(sum(Spec(PermTarget==8,:,:),1))./Ns(8);      
      PermSpecTarget = tempPermSpecTarget;
      rPerm(iPerm,:,:) = sq(sum(PermSpecTarget,1));
    end
    rPerm = rPerm.*conj(rPerm);
    z = zeros(size(Spec,2),size(Spec,3),'single');
    for iT = 1:size(Spec,2)
      for iF = 1:size(Spec,3)
        z(iT,iF) = length(find(rPerm(:,iT,iF)>rSpec(iT,iF)))./nPerm;
      end
    end
    Spec = norminv(1-z);
else
    disp(['Not enough trials']);
     nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
    nfk = floor(fk./sampling_rate.*nf);
    f = linspace(fk(1),fk(2),diff(nfk)); t = bn(1):dn*1e3:bn(2);
    numtrials= 0;
    Spec = zeros(length(t),diff(nfk),'single');
end

t = [bn(1):dn*1e3:bn(2)];
Data.SuppData.rPerm = rPerm;
Data.SuppData.rSpec = rSpec;
Data.Data = Spec;
Data.f = f;
Data.t = t;
Data.NumTrials = numtrials;

DataSession = Sess;
DataSession{1} = Trials{1}(1).Day;
Data.Session = DataSession;
Data.CondParams = CondParams;
Data.AnalParams = AnalParams;


Data.xax = t;
Data.yax = f;
