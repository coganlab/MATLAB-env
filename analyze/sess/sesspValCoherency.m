function [Coh,pVal,S1,S2,Rate,f,t,Data] = sesspValCoherency(Sess,CondParams, AnalParams)
%
%   [Coh,pVal,S1,S2,Rate,f,t,Data] = sesspValCoherency(Sess,CondParams, AnalParams)
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
        disp(['Calculating ' Type ' coherency with N = ' ...
            num2str(N) ' and W = ' num2str(W) ' for ' ...
            TaskString ' using  ' num2str(length(Trials{iTaskComp})) ' Trials']);
        switch Type
            case 'FieldField'
                Sys = sessTower(Sess);
                Ch = sessChannel(Sess);
		Contact = sessContact(Sess);
                Lfp1 = trialLfp(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Lfp2 = trialLfp(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                if matlabpool('size')
                    [Coh{iTaskComp},pVal{iTaskComp},S1{iTaskComp},S2{iTaskComp},f] = ...
                        ptfcohpval(Lfp1,Lfp2,[N,W],sampling_rate,dn,fk,pad);
                else
                    [Coh{iTaskComp},pVal{iTaskComp},S1{iTaskComp},S2{iTaskComp},f] = ...
                        tfcohpval(Lfp1,Lfp2,[N,W],sampling_rate,dn,fk,pad); 
                end
                Data.Lfp1 = Lfp1;
                Data.Lfp2 = Lfp2;
            case 'SpikeField'
                Sys = sessTower(Sess);
                Ch = sessChannel(Sess);
		Contact = sessContact(Sess);
                Cl = sessCell(Sess);
                tic
                Spike = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), Cl{1}, Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                Lfp = trialLfp(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2),Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
                if matlabpool('size')
                    [Coh{iTaskComp}, pVal{iTaskComp}, S1{iTaskComp}, S2{iTaskComp}, Rate{iTaskComp}, f] = ...
                        ptfcohpval_ptx(Lfp,Spike,[N,W],sampling_rate,dn,fk,pad);
                else
                    [Coh{iTaskComp}, pVal{iTaskComp}, S1{iTaskComp}, S2{iTaskComp}, Rate{iTaskComp}, f] = ...
                        tfcohpval_ptx(Lfp,Spike,[N,W],sampling_rate,dn,fk,pad); 
                end
                Data.Spike = Spike;
                Data.Lfp = Lfp;
            case 'MultiunitField'
                Sys = sessTower(Sess);
                Ch = sessElectrode(Sess);
		Contact = sessContact(Sess);
                Multiunit = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), 1, Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                Lfp = trialLfp(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Multiunit = sp2ts(Multiunit,[0,diff(bn)./1e3+N,1e3]);
                if matlabpool('size')
                    [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},Rate{iTaskComp},f] = ...
                        ptfcohpval_ptx(Lfp,Multiunit,[N,W],sampling_rate,dn,fk,pad);
                else
                    [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},Rate{iTaskCpmp},f] = ...
                        tfcohpval_ptx(Lfp,Multiunit,[N,W],sampling_rate,dn,fk,pad);
                end
                Data.Multiunit = Multiunit;
                Data.Lfp = Lfp;
            case 'SpikeSpike'
                Sys = sessTower(Sess);
                Ch = sessElectrode(Sess);
		Contact = sessContact(Sess);
                Cl = sessCell(Sess);
                tic
                Spike1 = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), Cl{1}, Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                Spike2 = trialSpike(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2), Cl{2}, Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                Spike1 = sp2ts(Spike1,[0,diff(bn)./1e3+N,1e3]);
                Spike2 = sp2ts(Spike2,[0,diff(bn)./1e3+N,1e3]);
                [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},f] = ...
                    tfcoh_pt(Spike1,Spike2,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
        end
    end
else
    nt = N*sampling_rate + diff(bn);
    Dn = dn*sampling_rate;
    Nn = N*sampling_rate;
    if length(fk) == 1; fk = [0,fk]; end
    nf = max(256, pad*2^nextpow2(Nn+1));
    nfk = floor(fk./sampling_rate.*nf);

    nwin = floor((nt-Nn)./Dn);           % calculate the number of windows
    S1 = {single(zeros(nwin,1,diff(nfk)))};
    S2 = {single(zeros(nwin,1,diff(nfk)))};
    pVal = {single(zeros(nwin,1,diff(nfk)))};
    Coh = {single(zeros(nwin,diff(nfk)))};
    f=0;
end

if length(Trials)==1
    Coh = Coh{1}; pVal = pVal{1}; S1 = S1{1}; S2 = S2{1};
end
