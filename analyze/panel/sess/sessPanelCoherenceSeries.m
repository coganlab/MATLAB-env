function Data = sessPanelCoherenceSeries(Sess, CondParams, AnalParams)
%
%   Data = sessPanelCoherenceSeries(Sess,CondParams,AnalParams)
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
%   AnalParams.fk      =   Vector.  Select frequency band to average
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
disp('Loading data');
    All_Trials = sessTrials(Sess);
end

disp('Running Params2Trials');
All_Trials = Params2Trials(All_Trials,CondParams);

if(~iscell(All_Trials))
    Trials{1} = All_Trials;
else
    Trials = All_Trials;
end

if length(Sess{5}) == 2
    if ~iscell(Sess{5})
        if Sess{5}(1) > 15 || Sess{5}(1)<0
            Type = 'FieldField';
        elseif Sess{5}(2) > 15
            Type = 'SpikeField';
        else
            Type = 'SpikeSpike';
        end
    elseif iscell(Sess{5})
        if Sess{5}{1}(1) > 15 || Sess{5}{1}(1)<0
            Type = 'FieldField';
        elseif Sess{5}{2}(1) > 15
            Type = 'SpikeField';
        else
            Type = 'SpikeSpike';
        end
    end
elseif length(Sess{5}) == 3
    if Sess{5}(1) > 15
        Type = 'FieldFieldField';
    elseif Sess{5}(1) < 15 && Sess{5}(2) > 15 && Sess{5}(3) > 15
        Type = 'SpikeFieldField';
    else
        Type = 'SpikeSpikeSpike';
    end
end

N = tapers(1); 
if length(tapers)==3
  W = tapers(2)./tapers(1);
else
  W = tapers(2);
end

t = [bn(1):dn*1e3:bn(2)];

disp([num2str(length(Trials{1})) ' Trials'])

if length(Trials{1}) > 3
        switch Type
            case 'FieldField'
                Sys = Sess{3};
                Ch = Sess{4};
                Lfp1 = trialMlfp(Trials{1}, Sys{1}, Ch(1), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Lfp2 = trialMlfp(Trials{1}, Sys{2}, Ch(2), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                tic; [Coh,f,S1,S2] = ...
                    tfcoh(Lfp1, Lfp2,tapers,sampling_rate,dn,fk,pad,0.05,11); toc
		Data.Data = mean(abs(Coh),2);
            case 'SpikeField'
                Sys = Sess{3};
                Ch = Sess{4};
                if ~iscell(Sess{5})
                    Cl = Sess{5}(1);
                elseif iscell(Sess{5})
                    Cl = Sess{5}{1}(1);
                end
                tic
                Spike = trialSpike(Trials{1}, Sys{1}, Ch(1), Cl, Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                Lfp = trialMlfp(Trials{1}, Sys{2}, Ch(2), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
                [Coh,S1,S2,f] = ...
                    tfcoh_ptx(Lfp,Spike,tapers,sampling_rate,dn,fk,pad,0.05,11); toc
		Data.Data = mean(abs(Coh),2);
        end
    end
end

