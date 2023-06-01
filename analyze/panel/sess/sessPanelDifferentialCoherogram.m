function Data = sessPanelDifferentialCoherogram(Sess, CondParams, AnalParams)
%
%   Data = sessPanelDifferentialCoherogram(Sess,CondParams,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%                               To pool Task = {{'Task1','Task2'}};
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
%   AnalParams.Field   =   String.  Alignment field
%   AnalParams.bn      =   Alignment time.
%


global MONKEYDIR MONKEYNAME

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
    tapers = [0.5,10];
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

if(~isfield(CondParams,'Task'))
    CondParams.Task = 'DelReachSaccade';
    CondParams.Diff.Task = 'DelReachSaccade';
end
PrefTask = CondParams.Task;
NullTask = CondParams.Diff.Task;
if(~isfield(CondParams,'conds'))
    CondParams.conds = {[]};
    CondParams.Diff.conds = {[]};
end
if(~isfield(CondParams,'Delay'))
    CondParams.Delay = [0,5e3];
end

% This handles Trials in Sess{1} instead of Day.
if isstruct(Sess{1})
    All_Trials = Sess{1};
else
    disp('Loading data');
    All_Trials = sessTrials(Sess);
end

All_PrefTrials = Params2Trials(All_Trials,CondParams);
All_NullTrials = Params2Trials(All_Trials,CondParams.Diff);

if(~iscell(All_PrefTrials))
    PrefTrials{1} = All_PrefTrials;
else
    PrefTrials = All_PrefTrials;
end
if(~iscell(All_NullTrials))
    NullTrials{1} = All_NullTrials;
else
    NullTrials = All_NullTrials;
end

Type = getSessionType(Sess);

N = tapers(1);
if length(tapers)==3
    W = tapers(2)./tapers(1);
else
    W = tapers(2);
end

disp([num2str(length(PrefTrials{1})) ' Pref Trials'])
disp([num2str(length(NullTrials{1})) ' Null Trials'])
if length(PrefTrials{1}) > 3 && length(NullTrials{1}) > 3
    switch Type
        case 'FieldField'
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
	    Contact = sessContact(Sess);
            PrefLfp1 = trialLfp(PrefTrials{1}, Sys{1}, Ch(1), Contact(1), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            PrefLfp2 = trialLfp(PrefTrials{1}, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            NullLfp1 = trialLfp(NullTrials{1}, Sys{1}, Ch(1), Contact(1), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            NullLfp2 = trialLfp(NullTrials{1}, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);

            [PrefCoh,f,S1,S2] = ...
                tfcoh(PrefLfp1, PrefLfp2,tapers,sampling_rate,dn,fk,pad,0.05,11);
            [NullCoh] = ...
                tfcoh(NullLfp1, NullLfp2,tapers,sampling_rate,dn,fk,pad,0.05,11);
        case 'SpikeField'
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
	    Contact = sessContact(Sess);
            if ~iscell(Sess{5})
                Cl = Sess{5}(1);
            elseif iscell(Sess{5})
                Cl = Sess{5}{1}(1);
            end

            PrefSpike = trialSpike(PrefTrials{1}, Sys{1}, Ch(1), Contact(1), Cl, Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
            PrefLfp = trialLfp(PrefTrials{1}, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            PrefSpike = sp2ts(PrefSpike,[0,diff(bn)./1e3+N,1e3]);
            [PrefCoh,S1,S2,rate,f] = ...
                tfcoh_ptx(PrefLfp,PrefSpike,tapers,sampling_rate,dn,fk,pad,0.05,11);

            NullSpike = trialSpike(NullTrials{1}, Sys{1}, Ch(1), Contact(1), Cl, Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
            NullLfp = trialMlfp(NullTrials{1}, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            NullSpike = sp2ts(NullSpike,[0,diff(bn)./1e3+N,1e3]);
            [NullCoh,S1,S2,rate,f] = ...
                tfcoh_ptx(NullLfp,NullSpike,tapers,sampling_rate,dn,fk,pad,0.05,11);
            
            case 'MultiunitField'
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);

            PrefSpike = trialSpike(PrefTrials{1}, Sys{1}, Ch(1), Contact(1), 1, Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
            PrefLfp = trialLfp(PrefTrials{1}, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            PrefSpike = sp2ts(PrefSpike,[0,diff(bn)./1e3+N,1e3]);
            [PrefCoh,S1,S2,rate,f] = ...
                tfcoh_ptx(PrefLfp,PrefSpike,tapers,sampling_rate,dn,fk,pad,0.05,11);

            NullSpike = trialSpike(NullTrials{1}, Sys{1}, Ch(1), Contact(1), 1, Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
            NullLfp = trialLfp(NullTrials{1}, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            NullSpike = sp2ts(NullSpike,[0,diff(bn)./1e3+N,1e3]);
            [NullCoh,S1,S2,rate,f] = ...
                tfcoh_ptx(NullLfp,NullSpike,tapers,sampling_rate,dn,fk,pad,0.05,11);
    end
end

t = bn(1):dn*1e3:bn(2);
Data.t = t;
Data.NumTrials = [length(PrefTrials{1}) length(NullTrials{1})];
Data.Data = tanh(atanh(abs(PrefCoh)) - atanh(abs(NullCoh)));
Data.f = f;

Data.xax = t;
Data.yax = f;
