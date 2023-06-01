function Data = sessPanelField2zScoreSpectrogram(Sess,CondParams, AnalParams)
%
%   Data = sessField2zScoreSpectrogram(Sess,CondParams,AnalParams)
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
%   CondParams.Delay   =  Vector. Select trials according to delay interval (ms).
%                    Delay = [DelayStart,DelayStop].
%   CondParams.IntervalName = 'STRING';
%   CondParams.IntervalDuration = [min,max]
%                       IntervalDuration is either in ms or proportions
%                       if min and max are between 0 and 1 IntervalDuration
%                       is a proportion, otherwise a time duration in ms.
%                       For example
%                         IntervalDuration = [0,500] means time duration
%                         IntervalDuration = [0,0.5] means fastest 50% of
%                           intervals
%
%   AnalParams.Tapers  =   [N,W].  Defaults to [.5,5]
%   AnalParams.fk      =   Vector.  Select frequency band to test
%
%
%   CondParams.Norm.Task    =   String/Cell.  Tasks to pool and compare.
%                               To pool Task = {{'Task1','Task2'}};
%   CondParams.Norm.cond    =   Eye,Hand,Target conds {[],[],[]}
%   AnalParams.Norm.Field   =   String.  Alignment field
%   AnalParams.Norm.bn      =   Alignment time.


if(isfield(AnalParams,'fk'))
    fk = AnalParams.fk;
else
    fk = 200;
end
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
if ischar(Task) && ~isempty(Task)
    NewTask{1} = {Task}; Task = NewTask;
elseif iscell(Task)
    for iTaskComp = 1:length(Task)
        if ~iscell(Task{iTaskComp})
            NewTask(iTaskComp) = {Task(iTaskComp)};
        else
            NewTask(iTaskComp) = Task(iTaskComp);
        end
    end
    Task = NewTask;
end

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

NormTask = '';
NormCond = {[]};
Normbn = [-500,0];
NormField = 'TargsOn';
if(isfield(AnalParams,'Norm'))
    if(isfield(AnalParams.Norm,'bn'))
        Normbn = AnalParams.Norm.bn;
    end
    if(isfield(AnalParams,'Field'))
        NormField = AnalParams.Norm.Field;
    end
    if(isfield(AnalParams.Norm,'Task'))
        NormTask = AnalParams.Norm.Task;
    end
end

NormCondParams.Task = NormTask;
NormCondParams.conds = NormCond;

if(~isfield(CondParams,'Delay'))
    CondParams.Delay = [500,5e3];
end
NormCondParams.Delay = CondParams.Delay;


% This handles Trials in Sess{1} instead of Day.
if isstruct(Sess{1})
    All_Trials = Sess{1};
else
    All_Trials = sessTrials(Sess);
end

Cond_Trials = Params2Trials(All_Trials,CondParams);
NormCond_Trials = Params2Trials(All_Trials,NormCondParams);

if(~iscell(Cond_Trials))
    Trials{1} = Cond_Trials;
else
    Trials = Cond_Trials;
end
if(~iscell(NormCond_Trials))
    NormTrials{1} = NormCond_Trials;
else
    NormTrials = NormCond_Trials;
end

N = tapers(1);
if length(tapers)==3
    W = tapers(2)./tapers(1);
else
    W = tapers(2);
end

FieldSession = extractField2Session(Sess);

disp([num2str(length(Trials{1})) ' Trials'])

if length(Trials{1}) > 3
    Sys = sessTower(FieldSession);
    Ch = sessElectrode(FieldSession);
    Contact = sessContact(FieldSession);
    MonkeyDir = sessMonkeyDir(FieldSession);

    Lfp = trialLfp(Trials{1}, Sys, Ch, Contact, Field, ...
        [bn(1)-N/2*sampling_rate,bn(2)+N/2*sampling_rate], MonkeyDir);
    thresh = 6*std(Lfp(:));
    e = max(abs(Lfp'));
    ind = find(e<thresh);
    Lfp = Lfp(ind,:); numtrials = length(ind);
    [Spec,f] = tfspec(Lfp,[N,W],sampling_rate,dn,fk,pad);

    if diff(Normbn) == N*sampling_rate;
        Spec = sq(sum(log(Spec))./numtrials);
            
        Lfp = trialLfp(NormTrials{1}, Sys, Ch, Contact, NormField, Normbn, MonkeyDir);
        thresh = 6*std(Lfp(:));
        e = max(abs(Lfp'));
        ind = find(e<thresh);
        Lfp = Lfp(ind,:);
        NormSpec = dmtspec(Lfp,[N,W],sampling_rate,fk,pad);
        
        K = length(ind);
        logS_loo = zeros(K,size(NormSpec,2),'single');

        for iJack = 1:K
            jind = setdiff(ind,ind(iJack));
            logS_loo(iJack,:) = sum(1./(K-1)*log(NormSpec(jind,:)));
        end
        numwin = size(Spec,1);

        mean_logjack = 1./K.*sum(logS_loo);
        sd_logjack = sqrt(K-1).*std(logS_loo,1);

        zSpec = (Spec-mean_logjack(ones(1,numwin),:))./sd_logjack(ones(1,numwin),:);
        
    elseif diff(Normbn)==diff(bn)
        NormLfp = trialLfp(NormTrials{1}, Sys, Ch, Contact, NormField,...
            [Normbn(1)-N/2*sampling_rate,Normbn(2)+N/2*sampling_rate], MonkeyDir);
        thresh = 6*std(NormLfp(:)); e = max(abs(NormLfp'));
        ind = find(e<thresh); NormLfp = NormLfp(ind,:);
        K = length(ind);

        NormSpec = tfspec(NormLfp,[N,W],sampling_rate,dn,fk,pad);

        MeanSpec = sq(sum(log(Spec))./numtrials);
        MeanNormSpec = sq(sum(log(NormSpec))./K);

        logTotSpec = log([NormSpec;Spec]);  nTot = size(logTotSpec,1);
        nPerm = 1e3;
        D = zeros(nPerm,size(NormSpec,2),size(NormSpec,3),'single');
        for iJack = 1:nPerm
            Indices = randperm(nTot);
            D(iJack,:,:) = sum(logTotSpec(Indices(1:numtrials),:,:))./numtrials - sum(logTotSpec(Indices(numtrials+1:end),:,:))./K;
        end

        sd_logjack = sq(std(D,0));

        zSpec = (MeanSpec - MeanNormSpec)./sd_logjack;
    else
        error('Normalization time definition is wrong');
    end
else
    disp('Not enough trials');
    t = bn(1):dn*1e3:bn(2);
    f = linspace(0,fk,200); numtrials = 0;
    zSpec = zeros(length(t), 200, 'single');
end

t = bn(1):dn*1e3:bn(2);

Data.Data = zSpec;
Data.NumTrials = numtrials;
Data.f = f;
Data.t = t;

DataSession = Sess;
DataSession{1} = Trials{1}(1).Day;
Data.Session = DataSession;
Data.CondParams = CondParams;
Data.AnalParams = AnalParams;


Data.xax = t;
Data.yax = f;
