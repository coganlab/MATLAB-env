function Data = sessPanelPhaseLockingValue(Sess, CondParams, AnalParams)
%
%   Data = sessPanelPhaseLockingValue(Sess,CondParams,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%                               To pool Task = {{'Task1','Task2'}};
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
    tapers = [0.5,10];
end

if(~isfield(CondParams,'Task'))
    CondParams.Task = {'DelReachSaccade'};
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

if(~isfield(CondParams,'Delay'))
    CondParams.Delay = [0,5e3];
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
    disp('Loading data');
    All_Trials = sessTrials(Sess);
end

All_Trials = Params2Trials(All_Trials,CondParams);

if(~iscell(All_Trials))
    Trials{1} = All_Trials;
else
    Trials = All_Trials;
end

Type = sessType(Sess);

N = tapers(1);
if length(tapers)==3
    W = tapers(2)./tapers(1);
else
    W = tapers(2);
end

disp([num2str(length(Trials{1})) ' Trials'])
if length(Trials{1}) > 3 && isempty(find(isnan([Trials{1}.(Field)]),1))
    numtrials = length(Trials{1});
    switch Type
        case 'FieldField'
            Sys = sessTower(Sess);
            Sys1 = Sys{1};
            if iscell(Sys1); Sys1 = Sys1{1}; end
            Sys2 = Sys{2};
            if iscell(Sys2); Sys2 = Sys2{1}; end
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);
            MonkeyDir = sessMonkeyDir(Sess);
            
            Lfp1 = trialLfp(Trials{1}, Sys1, Ch(1), Contact(1), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            Lfp2 = trialLfp(Trials{1}, Sys2, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            if sum(sum(isnan([Lfp1,Lfp2])))
                ind = find(~isnan(Lfp1(:,1)) & ~isnan(Lfp2(:,1)));
                Lfp1 = Lfp1(ind,:);  Lfp2 = Lfp2(ind,:);
            end
            thresh1 = 6*std(Lfp1(:)); e1 = max(abs(Lfp1'));
            thresh2 = 6*std(Lfp2(:)); e2 = max(abs(Lfp2'));
            ind = find(e1<thresh1 & e2<thresh2);
            numtrials = length(ind);
            Lfp1 = Lfp1(ind,:);  Lfp2 = Lfp2(ind,:);
            LfpHilbert1 = hilbert(Lfp1);
            LfpHilbert2 = hilbert(Lfp2);
            Phase1 = angle(LfpHilbert1);
            Phase2 = angle(LfpHilbert2);
            plv =  abs(sum(exp(1i*(Phase1-Phase2)),1))/size(Phase1,1);
%             plv2 = abs(exp(1i*angle(LfpHilbert1)).'*exp(-1i*angle(LfpHilbert1)))./size(Phase1,1);
            tfspecgram1 = tfspec(Lfp1);
            tfspecgram2 = tfspec(Lfp2);
            Phase1 = angle(tfspecgram1);
            Phase2 = angle(tfspecgram2);
            plv3 =  abs(sum(exp(1i*(Phase1-Phase2)),1))/size(Phase1,1);
%             plv4 = abs(exp(1i*Phase1).'*exp(-1i*Phase2))./size(Phase1,1);
    end
            
else
    disp('Not enough trials')
    nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
    nfk = floor(fk./sampling_rate.*nf);
    f = linspace(fk(1),fk(2),diff(nfk));
    t = bn(1):dn*1e3:bn(2);
    numtrials = 0;
    Coh = zeros(length(t),diff(nfk),'single');
    pCoh = Coh;
end
nf = max(256,pad*2^nextpow2(N*sampling_rate+1));
nfk = floor(fk./sampling_rate.*nf);
f = linspace(fk(1),fk(2),diff(nfk));
t = bn(1):dn*1e3:bn(2);
Data.t = t;
Data.f = f;
Data.xax = t;
Data.yax = f;
Data.NumTrials = numtrials;
Data.Data{1} = plv;
Data.Data{2} = plv3;
% Data.Data{3} = plv3;
% Data.Data{4} = plv4;

DataSession = Sess;
DataSession{1} = Trials{1}(1).Day;
Data.Sess = DataSession;
Data.CondParams = CondParams;
Data.AnalParams = AnalParams;
