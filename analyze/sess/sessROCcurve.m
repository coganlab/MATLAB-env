function Data = sessROCcurve(Sess, CondParams, AnalParams)

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
%
%   %%%%%%%%ANALPARAMS SPECIFIC TO ROC%%%%%%%%%%%%%
%   (No AP.Diff for the following)
%   AnalParams.win =   ROC analysis window (ms) and stepsize (ms). Defaults
%                       to [100,10]
%   AnalParmas.nperm = Number of ROC permunations for pval. Defaults to 5e3;
%   AnalParams.flag = flag = 0/1 order data
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

if(isfield(AnalParams,'win'))
    window = AnalParams.bn(1);
    stepsize = AnalParams.bn(2);
else
    window = 100;
    stepsize = 10;
end
if(isfield(AnalParams,'nperm'))
    nperm = AnalParams.nperm;
else
    nperm = 5e3;
end
if(isfield(AnalParams,'flag'))
    flag = AnalParams.flag;
else
    flag = 0;
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

SpikeSession = Sess;
disp([num2str(length(Trials)) ' Trials'])

nSteps = abs(bn(1)-bn(2))/stepsize;

Data.p = zeros(1,nSteps);
Data.se = zeros(1,nSteps);
Data.pval = zeros(1,nSteps);

if length(Cond_Trials) > 3
    Sys = sessTower(SpikeSession);
    %     Sys = Sys{1};
    Ch = sessChannel(SpikeSession);
    Cl = sessCell(SpikeSession);
    Cn = sessContact(SpikeSession);
    
    for iStep = 1:nSteps
        clear Cond_Spike Diff_Spike Cond_FR Diff_FR
        start = bn(1) + (iStep-1);
        stop = window + start;
        Cond_Spike = trialSpike(Cond_Trials, Sys, Ch, Cn, Cl, Field, ...
            [start,stop]);
        for itr = 1:length(Cond_Spike)
            Cond_FR(itr) = length(Cond_Spike{itr});
        end
        Diff_Spike = trialSpike(DiffCond_Trials, Sys, Ch, Cn, Cl, Field, ...
            [start,stop]);
        for itr = 1:length(Diff_Spike)
            Diff_FR(itr) = length(Diff_Spike{itr});
        end
        
        [p, se, pval] = myroc(Cond_FR,Diff_FR,flag);
        Data.p(iStep) = p;
        Data.se(iStep) = se;
        Data.pval(iStep) = pval;
    end
else
    error('not enough trials');
end

end