function Data = sessTestRateRatePhaseCovariations(Sess,CondParams, AnalParams)
%
% REQUIRES A SSF SESSION! 

% v2 - instead of dividing spikes up by phase, will determine the mean
% phase of spikes on a given trial. otherwise, not enough spikes in each
% bin to correlate

%   [p,D,PD] = sessTestRateRatePhaseCovariations(Sess,CondParams1,CondParams2)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAM1 =   Data structure.  Parameter information
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.condstype = 'Choice'  - looks at eye/hand movement
%   not Target
%   CondParams.Delay   =  Vector. Select trials according to delay interval (s).
%                    Delay = [DelayStart,DelayStop].
%   CondParams.Field   =   String.  Alignment field
%   CondParams.bn      =   Alignment time.
%
%
%   Outputs:  P	 = p-Value
%		D = Test statistic
%	        PD = Null-distribution of test statistic


%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   AnalParams.Field   =   String.  Alignment field
%   AnalParams.bn      =   Alignment time in ms.  Defaults to [-1e3,2e3]
%   AnalParams.dn      =   Scalar.  Step size in ms. Defaults to  50ms.
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.sort = 1,N cell.  N sort criteria
%                               For each sort criterion sort is a 1,2 cell
%                                   sort{i}{1} = String. Sort criterion name.
%                                       Names are fields in Trials or
%                                       calcNAME functions.
%                                   sort{i}{2} = [1,1] or [1,2] Scalar.  Sort
%                                                   criterion values
%   CondParams.shuffle  0/1 Shuffle trial ordering
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
%   AnalParams.fk      =   Vector.  Select frequency band to test
%                               Defaults to linspace(W,200,1);
%   AnalParams.tapers = [N,W] for the bandpass filter
%				Defaults = [.2,5]
%   AnalParams.nbins = number of bins to divide spike times by phase from
%   -pi:pi
%   AnalParams.flag = 0/1, 1 calcualtes p values for each freq, defaults to
%   0


Type= getSessionType(Sess);
if strcmp(Type,'SpikeSpikeField')
else
    error('Sessions must be SpikeSpikeField')
end

if(isfield(AnalParams,'tapers'))
    tapers = AnalParams.tapers;
else
    tapers = [0.2,5];
end

if(isfield(AnalParams,'fk'))
    fk = AnalParams.fk;
else
    fk = [tapers(2),100];
end
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
if(isfield(AnalParams,'nbins'))
    nbins = AnalParams.nbins;
else
    nbins = 4;
end
if(isfield(AnalParams,'NPerm'))
   NPERM = AnalParams.Nperm;
else
    NPERM = 1e4;
end

if(isfield(AnalParams,'flag'))
   flag = AnalParams.flag;
else
    flag = 0;
end
if(~isfield(CondParams,'Task'))
    CondParams.Task = 'MemoryReachSaccade';
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
elseif isfield(CondParams,'bn')
    bn = CondParams.bn;
else
    bn = [-1e3,2e3];
end
if(isfield(AnalParams,'Field'))
    Field = AnalParams.Field;
elseif isfield(CondParams,'Field')
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

%disp('Running Params2Trials');
All_Trials = Params2Trials(All_Trials,CondParams);

%whos All_Trials

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
if length(fk)==1,fk = W:fk; end

disp([num2str(length(Trials{1})) ' Trials'])

nTr = length(Trials{1});

binsize = 2*pi/nbins;


if nTr > 3
    for iTaskComp = 1:length(Trials)
        TaskString = [];
        for iTaskPool = 1:length(Task{iTaskComp})
            TaskString = [TaskString Task{iTaskComp}{iTaskPool} ' '];
        end
        disp(['Calculating ' Type ' phases with N = ' ...
            num2str(N) ' and W = ' num2str(W) ' for ' ...
            TaskString ' using  ' num2str(length(Trials{iTaskComp})) ' Trials']);
        Sys = sessTower(Sess);
        Ch = sessElectrode(Sess);
        Contact = sessContact(Sess);
        Cl = sessCell(Sess);
        MonkeyDir = sessMonkeyDir(Sess);
        
    Spike1 = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), Cl(1), Field, [bn(1),bn(2)], MonkeyDir);
    Spike2 = trialSpike(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2), Cl(2), Field, [bn(1),bn(2)], MonkeyDir);
    Lfp = trialLfp(Trials{iTaskComp}, Sys{3}, Ch(3), Contact(3), Field, [bn(1),bn(2)], MonkeyDir);
                evLfp = smooth(mean(Lfp),Smoothing);
                mLfp = repmat(evLfp,length(Lfp(:,1)),1);
                Lfp = (Lfp - mLfp);
                phLfp = zeros(nTr,length(fk),size(Lfp,2));
                for iF = 1:length(fk)
                    BandpassLFP = mtfilter(Lfp,tapers,sampling_rate,fk(iF),0,1);
                    phLfp(:,iF,:) = atan2(imag(BandpassLFP),real(BandpassLFP));
                end
                % get spikes of interest
    dN = zeros(1,nTr);
    dM = zeros(1,nTr);
    for itrial = 1:nTr
        dN(itrial) = length(Spike1{itrial});
        dM(itrial) = length(Spike2{itrial});
    end
    nspikes1 = sum(dN);
    nspikes2 = sum(dM);
    
%     
%     PhaseSpike1 = cell(length(fk));
%     PhaseSpike2 = cell(length(fk));
%     for ifreq = 1:length(fk)
%         PhaseSpike1{ifreq} = cell(1,nbins);
%         PhaseSpike2{ifreq} = cell(1,nbins);
%         for ibn = 1:nbins
%         PhaseSpike1{ifreq}{ibn} = cell(1,nTr);
%         PhaseSpike2{ifreq}{ibn} = cell(1,nTr);
%         end
%     end
%             
%     PhaseRate1 = zeros(length(fk),nbins,diff(bn)+1);
%     PhaseRate2 = zeros(length(fk),nbins,diff(bn)+1);
%     
%     if nspikes1 > 3
%         phases1 = zeros(length(fk), nspikes1);
%         for iFreq = 1:length(fk)
%             tmpPhases = [];
%             for iTr = 1:nTr
%                 spiketimes = round(Spike1{iTr}');
%                 spiketimes(spiketimes==0) = 1;
%                 if ~isempty(spiketimes)
%                     trialphases = sq(phLfp(iTr,iFreq,spiketimes))';
%                     tmpPhases   = [tmpPhases, trialphases];
%                     for ibn = 1:nbins
%                         start = -pi+(binsize*(ibn-1));
%                         stop = start+binsize;
%                         PhaseSpike1{iFreq}{ibn}{iTr} = Spike1{iTr}(trialphases >= start & trialphases <= stop);
%                     end
%                 end
%             end
%             phases1(iFreq,:) = tmpPhases;
%             for ibn = 1:nbins
%                 PhaseRate1(iFreq,ibn,:) = psth(PhaseSpike1{iFreq}{ibn},bn,Smoothing);
%             end
%         end
%     else
%         phases1 = [];
%     end
% 
%     if nspikes2 > 3
%         phases2 = zeros(length(fk), nspikes2);
%         for iFreq = 1:length(fk)
%             tmp2 = [];
%             for iTr = 1:nTr
%                 spiketimes = round(Spike2{iTr}');
%                 spiketimes(spiketimes==0) = 1;
%                 if ~isempty(spiketimes)
%                     trialphases = sq(phLfp(iTr,iFreq,spiketimes))';
%                     tmp2   = [tmp2, trialphases];
%                     for ibn = 1:nbins
%                         start = -pi+(binsize*(ibn-1));
%                         stop = start+binsize;
%                         PhaseSpike2{iFreq}{ibn}{iTr} = Spike2{iTr}(trialphases >= start & trialphases <= stop);
%                     end
%                 end
%             end
%             phases2(iFreq,:) = tmp2;
%             for ibn = 1:nbins
%                 PhaseRate2(iFreq,ibn,:) = psth(PhaseSpike2{iFreq}{ibn},bn,Smoothing);
%             end
%         end
%     else
%         phases2 = [];
%     end
%     
%     Data.phase1 = phases1;
%     Data.phase2 = phases2;
%     Data.PhaseSpike1 = PhaseSpike1;
%     Data.PhaseSpike2 = PhaseSpike2;
%     Data.PhaseRate1 = PhaseRate1;
%     Data.PhaseRate2 = PhaseRate2;

PhaseSpike1 = zeros(length(fk),nTr);
PhaseSpike2 = zeros(length(fk),nTr);

for iFreq = 1:length(fk)
    for iTr = 1:nTr
        spiketimes = round(Spike1{iTr}');
        spiketimes(spiketimes==0) = 1;
        if ~isempty(spiketimes)
            trialphases = sq(phLfp(iTr,iFreq,spiketimes));
            PhaseSpike1(iFreq,iTr)   =  circ_mean(trialphases);
        else
            PhaseSpike1(iFreq,iTr)   = nan(1);
        end
    end
end

for iFreq = 1:length(fk)
    for iTr = 1:nTr
        spiketimes = round(Spike2{iTr}');
        spiketimes(spiketimes==0) = 1;
        if ~isempty(spiketimes)
            trialphases = sq(phLfp(iTr,iFreq,spiketimes));
            PhaseSpike2(iFreq,iTr)   = circ_mean(trialphases);
        else
            PhaseSpike2(iFreq,iTr)   = nan(1);
        end
    end
end

Data.PhaseSpike1 = PhaseSpike1;
Data.PhaseSpike2 = PhaseSpike2;


% rate rate covariations..
GdN = [dN,dM];
var1 = std(dN).*std(dM);
tmp = cov([dN',dM']);
D = tmp(2,1)/var1;
PD = nan(1,NPERM);
if flag
    parfor iPerm = 1:NPERM
        NP = randperm(size(GdN,2));
        N1 = GdN(NP(1:size(dN,2)));
        N2 = GdN(NP(size(dN,2)+1:end));
        tmp = cov([N1',N2']);
        var1 = std(N1).*std(N2);
        PD(iPerm) = tmp(2,1)/var1;
    end
    Data.p = length(find(abs(PD)>abs(D)))./NPERM;
    Data.PD = PD;
end
Data.D = D;
    
    % phase dependent rate rate covariations...
    
    PD = nan(1,NPERM);
    
    for iFreq = 1:length(fk)
        for ibn = 1:nbins
            start = -pi+(binsize*(ibn-1));
            stop = start+binsize;
            ind1 = find(PhaseSpike1(iFreq,:)>start & PhaseSpike1(iFreq,:)<=stop);
            if length(ind1)>3
                dNi = dN(ind1);
                dMi = dM(ind1);
                GdN = [dNi,dMi];
                var1 = std(dNi).*std(dMi);
                tmp = cov([dNi',dMi']);
                D = tmp(2,1)/var1;
            else D = nan(1);
            end
            
            if flag && ~isnan(D)
                tic
                Data.PhasePD = zeros(iFreq,nbins,NPERM);
                parfor iPerm = 1:NPERM
                    NP = randperm(size(GdN,2));
                    %NP = shuffle(1:size(GdN,2));
                    N1 = GdN(NP(1:size(dNi,2)));
                    N2 = GdN(NP(size(dNi,2)+1:end));
                    tmp = cov([N1',N2']);
                    var1 = std(N1).*std(N2);
                    PD(iPerm) = tmp(2,1)/var1;
                end
            Data.PhaseP(iFreq,ibn) = length(find(abs(PD)>abs(D)))./NPERM;
            Data.PhasePD(iFreq,ibn,:) = PD;
            toc
            end
            Data.PhaseD(iFreq,ibn) = D;
        end
    end
    end
    
else
    Data.p = nan(1);
    Data.D = nan(1);
    Data.PhaseD = nan(1,nbins);
    Data.PhaseP = nan(length(fk),nbins);
end





