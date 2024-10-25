function [RPCorr,RTCorr,SRT,RRT,S,Rate,f,t,Data,Trials] = sessRatePowerRTCorrelation(Sess,CondParams, AnalParams)
%
%   [RPCorr,RTCorr,SRT,RRT,S,Rate,f,t,Data] = sessRatePowerRTCorrelation(Sess,CondParams, AnalParams)
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
%
%   AnalParams.tapers  =   [N,W].  Defaults to [.5,10]
%   AnalParams.fk      =   Vector.  Select frequency band to test
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

N = tapers(1);
if length(tapers)==3
    W = tapers(2)./tapers(1);
else
    W = tapers(2);
end

t = [bn(1):dn*sampling_rate:bn(2)];

disp([num2str(length(Trials{1})) ' Trials'])

if length(Trials{1}) > 3
    for iTaskComp = 1:length(Trials)
        TaskString = [];
        for iTaskPool = 1:length(Task{iTaskComp})
            TaskString = [TaskString Task{iTaskComp}{iTaskPool} ' '];
        end
        disp(['Calculating ' Type ' rate-power correlation with N = ' ...
            num2str(N) ' and W = ' num2str(W) ' for ' ...
            TaskString ' using  ' num2str(length(Trials{iTaskComp})) ' Trials']);
        Sys = sessTower(Sess);
        Ch = sessChannel(Sess);
        Cl = sessCell(Sess);
        Lfp = trialMlfp(Trials{iTaskComp}, Sys, Ch(2), Field, ...
            [bn(1)-N./2*1e3, bn(2)+N./2*1e3]);
        Spike = trialSpike(Trials{iTaskComp}, Sys, Ch(1), Cl{1}, Field, ...
            [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
        RRT_tmp = calcReachRT(Trials{iTaskComp});
        SRT_tmp = calcSaccadeRT(Trials{iTaskComp});
        
        thresh = 16*std(Lfp(:)); e = max(abs(Lfp'));
        ind = find(e<thresh & SRT_tmp > 100 & RRT_tmp > 120 & SRT_tmp < 400 & RRT_tmp < 500);
        Trials{iTaskComp} = Trials{iTaskComp}(ind);
        numtrials = length(ind)
        Lfp = Lfp(ind,:);  Spike = Spike(ind);
    	SRT_tmp = SRT_tmp(ind); RRT_tmp = RRT_tmp(ind);
        S_tmp = tfspec(Lfp, [N,W], sampling_rate, dn, fk, pad);
        nwin = size(S_tmp,2);
        Rate_tmp = zeros(length(Spike),nwin);
        for iTr = 1:length(Spike)
            for iT = 1:nwin
                Rate_tmp(iTr,iT) = length(find(Spike{iTr}>iT*dn*1e3 & Spike{iTr}<iT*dn*1e3 + N*1e3));
            end
        end
        Rate_tmp = Rate_tmp*diff(bn)./1e3;
        
        C = zeros(size(S_tmp,2),size(S_tmp,3));
        for iT = 1:size(S_tmp,2)
            for iF = 1:size(S_tmp,3)
                RPC(iT,iF) = mycorr(log(S_tmp(:,iT,iF)),sqrt(Rate_tmp(:,iT)));
            end
        end
        RTCorr{iTaskComp} = mycorr(SRT_tmp,RRT_tmp);
        RPCorr{iTaskComp} = RPC;
        SRT{iTaskComp} = SRT_tmp;
        RRT{iTaskComp} = RRT_tmp;
        S{iTaskComp} = S_tmp;
        Rate{iTaskComp} = Rate_tmp;
        Data.Lfp = Lfp;
        f=0;
    end
else
    nt = N*sampling_rate + diff(bn);
    Dn = dn*sampling_rate;
    Nn = N*sampling_rate;
    if length(fk) == 1; fk = [0,fk]; end
    nf = max(256, pad*2^nextpow2(Nn+1));
    nfk = floor(fk./sampling_rate.*nf);
    
    nwin = floor((nt-Nn)./Dn);           % calculate the number of windows
    S = {zeros(1,diff(nfk),'single')};
    RPCorr = {zeros(nwin,diff(nfk),'single')};
    Rate = {zeros(1,nwin,'single')};
    f=0;
end

if length(Trials)==1
    SRT = SRT{1}; RRT = RRT{1}; RTCorr = RTCorr{1}; 
    RPCorr = RPCorr{1}; S = S{1}; Rate = Rate{1};
end
