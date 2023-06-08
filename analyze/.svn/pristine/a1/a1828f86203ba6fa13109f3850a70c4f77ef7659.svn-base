function [Corr,Rate,RT,Trials] = sessRateRTCorrelation(Sess,CondParams, AnalParams)
%
%   [Corr,Rate,RT,Trials] = sessRateRTCorrelation(Sess,CondParams, AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams.Field   =   String.  Alignment field
%   CondParams.bn      =   Alignment time.
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
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
%   AnalParams.tapers  =   [N,W].  Defaults to [.5,10]
%   AnalParams.fk      =   Vector.  Select frequency band to test
%

global MONKEYDIR MONKEYNAME

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

if(~isfield(CondParams,'Task'))
    CondParams.Task = 'DelReachSaccade';
end

N = 0.5;

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
if(isfield(CondParams,'bn'))
    bn = CondParams.bn;
else
    bn = [-1e3,2e3];
end
if(isfield(CondParams,'Field'))
    Field = CondParams.Field;
else
    Field = 'TargsOn';
end

if(~isfield(CondParams,'Delay'))
    CondParams.Delay = [500,5e3];
end


% This handles Trials in Sess{1} instead of Day.
if isstruct(Sess{1})
    All_Trials = Sess{1};
else
    All_Trials = sessTrials(Sess);
end

disp('Running Params2Trials');
All_Trials = Params2Trials(All_Trials,CondParams);

if(~iscell(All_Trials))
    Trials{1} = All_Trials;
else
    Trials = All_Trials;
end

Type= getSessionType(Sess);

t = [bn(1):dn*sampling_rate:bn(2)];

disp([num2str(length(Trials{1})) ' Trials'])

if length(Trials{1}) > 3
    for iTaskComp = 1:length(Trials)
        TaskString = [];
        for iTaskPool = 1:length(Task{iTaskComp})
            TaskString = [TaskString Task{iTaskComp}{iTaskPool} ' '];
        end
        disp(['Calculating ' Type ' rate-RT correlation for ' ...
            TaskString ' using  ' num2str(length(Trials{iTaskComp})) ' Trials']);
        Sys = sessTower(Sess);
        Ch = sessChannel(Sess);
        Cl = sessCell(Sess);
        Spike = trialSpike(Trials{iTaskComp}, Sys, Ch, Cl, Field, ...
            [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
        RRT_tmp = calcReachRT(Trials{iTaskComp});
        SRT_tmp = calcSaccadeRT(Trials{iTaskComp});

        %ind = find(SRT_tmp > 100 & RRT_tmp > 120 & SRT_tmp < 400 & RRT_tmp < 500);
        ind = find(SRT_tmp > 100 & SRT_tmp < 400);
        Trials{iTaskComp} = Trials{iTaskComp}(ind);
        numtrials = length(ind);
        Spike = Spike(ind);
    	SRT_tmp = SRT_tmp(ind); RRT_tmp = RRT_tmp(ind);
        
        nwin = length(t)-1;
        Rate_tmp = zeros(length(Spike),nwin);
        for iTr = 1:length(Spike)
            for iT = 1:nwin
                Rate_tmp(iTr,iT) = length(find(Spike{iTr}>iT*dn*1e3 & Spike{iTr}<iT*dn*1e3 + N*1e3));
            end
        end
        Rate_tmp = Rate_tmp*diff(bn)./1e3;
        
        
        RTs = {'SRT','RRT'};
        for iRT = 1:length(RTs)
            eval(['RT = ' RTs{iRT} '_tmp;'])
            for iwin = 1:size(Rate_tmp,2)
                if mean(sqrt(Rate_tmp(:,iwin))) > 0
                    C(iRT,iwin) = mycorr(RT,sqrt(Rate_tmp(:,iwin)));
                else
                    C(iRT,iwin) = 0;
                end
            end
        end
        
        clear Corr RT Rate
        Corr{iTaskComp} = C;
        RT{iTaskComp} = [SRT_tmp; RRT_tmp];
        Rate{iTaskComp} = Rate_tmp;
    end
else

    
end

if length(Trials)==1
    Corr = Corr{1}; RT = RT{1}; Rate = Rate{1};
end

