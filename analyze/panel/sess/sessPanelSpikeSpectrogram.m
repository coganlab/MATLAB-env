function Data = sessPanelSpikeSpectrogram(Sess, CondParams, AnalParams)
%
%   Data = sessPanelSpikeSpectrogram(Sess,CondParams,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for 
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%
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

SpikeSession = extractSpikeSession(Sess);

disp([num2str(length(Trials{1})) ' Trials'])

if length(Trials{1}) > 3
    Sys = sessTower(SpikeSession);
    Ch = sessElectrode(SpikeSession);
    Contact = sessContact(SpikeSession);
    if ~iscell(SpikeSession{5})
        Cl = SpikeSession{5}(1);
    elseif iscell(SpikeSession{5})
        Cl = SpikeSession{5}{1}(1);
    end
    MonkeyDir = sessMonkeyDir(Sess);
    Spike = trialSpike(Trials{1}, Sys, Ch, Contact, Cl, Field, ...
        [bn(1)-N/2*sampling_rate,bn(2)+N/2*sampling_rate], MonkeyDir);
    [Spec,Rate,f] = tfspec_pt(Spike,[N,W],sampling_rate,dn,fk,pad); toc
end

t = [bn(1):dn*1e3:bn(2)];

Data.Data = Spec;
Data.NumTrials = length(Trials{1});
Data.f = f;
Data.t = t;

DataSession = Sess;
DataSession{1} = Trials{1}(1).Day;
Data.Sess = DataSession;
Data.CondParams = CondParams;
Data.AnalParams = AnalParams;


Data.xax = t;
Data.yax = f;