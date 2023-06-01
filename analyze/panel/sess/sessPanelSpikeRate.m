function Data = sessPanelSpikeRate(Sess, CondParams, AnalParams)
%
%   Data = sessPanelSpikeRate(Sess, CondParams, AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for 
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
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
%   AnalParams.Smoothing  =   Scalar.  Smoothing parameter in ms
%   AnalParams.bn      =   Alignment time.
%   AnalParams.Field   =   String.  Alignment field
%   AnalParams.rate_lim =   Scalar.  Max and Min rates.
%
%   CondParams.Diff.Task    =   String/Cell.  Tasks to pool and compare.
%                               To pool Task = {{'Task1','Task2'}};
%   CondParams.Diff.Cond    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.Diff.IntervalName = ;
%   CondParams.Diff.IntervalDuration = ;
%   AnalParams.Diff.Field   =   String.  Alignment field
%   AnalParams.Diff.bn      =   Alignment time.


if(isfield(AnalParams,'Smoothing'))
    Smoothing = AnalParams.Smoothing;
else
    Smoothing = 10;
end
if(isfield(AnalParams,'sampling_rate'))
    sampling_rate = AnalParams.sampling_rate;
else
    sampling_rate = 1e3;
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
    CondParams.Delay = [0, 5e3];
end

DiffTask = '';
DiffCond = {[]};
Diffbn = bn;
DiffField = 'TargsOn';
DiffDelay = [500,5e3];

if(isfield(AnalParams,'Diff'))
    if(isfield(AnalParams.Diff,'bn'))
        Diffbn = AnalParams.Diff.bn;
    end
    if(isfield(AnalParams,'Field'))
        DiffField = AnalParams.Diff.Field;
    end
end
if(isfield(CondParams,'Diff'))
    if(isfield(CondParams.Diff,'Task'))
        DiffTask = CondParams.Diff.Task;
    end
    if(isfield(CondParams.Diff,'Cond'))
        DiffCond = CondParams.Diff.Cond;
    end
    if(isfield(CondParams.Diff,'Delay'))
        DiffDelay = CondParams.Diff.Delay;
    end
    if(isfield(CondParams.Diff,'IntervalName'))
        DiffIntervalName = CondParams.Diff.IntervalName;
        DiffCondParams.IntervalName = DiffIntervalName;
    end
    if(isfield(CondParams.Diff,'IntervalDuration'))
        DiffIntervalDuration = CondParams.Diff.IntervalDuration;
        DiffCondParams.IntervalDuration = DiffIntervalDuration;
    end
    if(isfield(CondParams.Diff,'sort'))
        DiffSort = CondParams.Diff.sort;
        DiffCondParams.sort = DiffSort;
    end
end
DiffCondParams.Task = DiffTask;
DiffCondParams.conds = DiffCond;
DiffCondParams.Delay = DiffDelay;


% This handles Trials in Sess{1} instead of Day. 
if isstruct(Sess{1})
    All_Trials = Sess{1};
else
    All_Trials = sessTrials(Sess);
end


%All_Trials = Params2Trials(All_Trials,CondParams);
Cond_Trials = Params2Trials(All_Trials,CondParams);
DiffCond_Trials = Params2Trials(All_Trials,DiffCondParams);

if(~iscell(Cond_Trials))
    Trials{1} = Cond_Trials;
else
    Trials = Cond_Trials;
end
if(~iscell(DiffCond_Trials))
    DiffTrials{1} = DiffCond_Trials;
else
    DiffTrials = DiffCond_Trials;
end



SpikeSession = extractSpikeSession(Sess);

disp([num2str(length(Trials{1})) ' Trials'])

if length(Trials{1}) > 3
    Sys = sessTower(SpikeSession);
    Ch = sessElectrode(SpikeSession);
    Contact = sessContact(SpikeSession);
    MonkeyDir = sessMonkeyDir(SpikeSession);
    if ~iscell(SpikeSession{5})
        Cl = SpikeSession{5}(1);
    elseif iscell(SpikeSession{5})
        Cl = SpikeSession{5}{1}(1);
    end
    if isempty(find(isnan([Trials{1}.(Field)]), 1))
        Spike = trialSpike(Trials{1}, Sys, Ch, Contact, Cl, Field, ...
            [bn(1)-Smoothing,bn(2)+Smoothing], MonkeyDir);
        Rate = psth(Spike,bn,Smoothing);
    else
        Rate = zeros(1,diff(bn)+1);
    end
    if isfield(AnalParams,'Diff') && length(DiffTrials{1}) > 3
        if isempty(find(isnan([DiffTrials{1}.(Field)]), 1))
            DiffSpike = trialSpike(DiffTrials{1}, Sys, Ch, Contact, Cl, Field, ...
                [bn(1)-Smoothing,bn(2)+Smoothing], MonkeyDir);
            DiffRate = psth(DiffSpike,bn,Smoothing);
            Rate = Rate - DiffRate;
        end
    else
        disp('Not enough diff trials');
    end
else
    Rate = zeros(1,diff(bn)+1);
end

t = linspace(bn(1),bn(2),length(Rate));

Data.Data = Rate;
Data.NumTrials = length(Trials{1});
Data.t = t;
Data.xax = t;
if(isfield(AnalParams,'rate_lim'))
    rate_lim = AnalParams.rate_lim;
else
    rate_lim = [0,max(Rate)];
end
Data.yax = rate_lim;

DataSession = Sess;
DataSession{1} = Trials{1}(1).Day;
Data.Sess = DataSession;
Data.CondParams = CondParams;
Data.AnalParams = AnalParams;

