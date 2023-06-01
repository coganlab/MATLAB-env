function Data = sessPanelDecimateCoherogram(Sess, CondParams, AnalParams)
%
%   Data = sessPanelDecimateCoherogram(Sess,CondParams,AnalParams)
%
%   Calculates the coherence after decimating the firing rate with probability AnalParams.p
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%                               To pool Task = {{'Task1','Task2'}};
%   CondParams.cond    =   Eye,Hand,Target conds {[],[],[]}
%
%   AnalParams.Tapers  =   [N,W].  Defaults to [.5,10]
%   AnalParams.fk      =   Vector.  Select frequency band to test
%   AnalParams.Field   =   String.  Alignment field
%   AnalParams.bn      =   Alignment time.
%   AnalParams.p       =   probability of spike deletion. 
%                          Default = 0 (same as sessPanelNullzScoreCoherogram.m)
%
%
%  OUTPUTS:	DATA = Data structure with the following fields
%				Data.Data = Coh - Coherogram
%				Data.SuppData.SLfp = SLfp - Field spectrogram
%				Data.SuppData.SSpike = SSpike - Spike spectrogram
%


% global MONKEYDIR MONKEYNAME

%MONKEYDIR = sessMonkeyDir(Sess);

if(isfield(AnalParams,'p'))
    p_delete = AnalParams.p;
else
    p_delete = 0;
end
if(isfield(AnalParams,'fk'))
    fk = AnalParams.fk;
else
    fk = 200;
end
if length(fk)==1; fk = [0, fk]; end

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
end

if(isfield(CondParams,'merge'))
    MergeTrials = CondParams.merge;
else
    MergeTrials = 0;
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
%if(~isfield(CondParams,'Delay'))
%    CondParams.Delay = [500,5e3];
%end

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
% This handles Trials in Sess{1} instead of Day.
if isstruct(Sess{1})
    All_Trials = Sess{1};
else
    disp('Loading data');
    All_Trials = sessTrials(Sess);
end

Cond_Trials = Params2Trials(All_Trials,CondParams);

if(~iscell(Cond_Trials))
    Trials{1} = Cond_Trials;
else
    Trials = Cond_Trials;
end

Type = getSessionType(Sess);

%We want to merge Trials if multiple tasks are given rather than use just
%the first.
if MergeTrials
    if length(Trials) > 1
        tmpTrials = [];
        for iTask = 1:length(Trials)
            tmpTrials = [tmpTrials Trials{iTask}];
        end
        clear Trials
        Trials{1} = tmpTrials;
    end
end

N = tapers(1);
if length(tapers)==3
    W = tapers(2)./tapers(1);
else
    W = tapers(2);
end

disp([num2str(length(Trials{1})) ' Trials'])
if length(Trials{1}) > 3 && isempty(find(isnan([Trials{1}.(Field)]),1))
    switch Type
        case 'FieldField'
		error('Wrong session type - Decimation not supported for Fields');
        case 'SpikeField'
            
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
	    Contact = sessContact(Sess);
            if ~iscell(Sess{5})
                Cl = Sess{5}(1);
            elseif iscell(Sess{5})
                Cl = Sess{5}{1}(1);
            end
	    MonkeyDir = sessMonkeyDir(Sess);
            Spike = trialSpike(Trials{1}, Sys{1}, Ch(1), Contact(1), Cl, Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
            
            % Decimate spikes
            for iTr = 1:length(Spike)
                cutProb = rand(size(Spike{iTr}));
                newSpikeind = cutProb > p_delete;
                Spike{iTr} = Spike{iTr}(newSpikeind);
            end
            Data.Spike = Spike;

            Lfp = trialLfp(Trials{1}, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
            thresh = 6*std(Lfp(:)); e = max(abs(Lfp'));
            ind = find(e<thresh);
            numtrials = length(ind);
            Lfp = Lfp(ind,:);  Spike = Spike(ind,:);

            Lfpk = tfsp_proj(Lfp, tapers, sampling_rate, dn, fk, pad);
            Spikek = tfspproj_pt(Spike, tapers, sampling_rate, dn, fk, pad);
            nwin = size(Lfpk,2);  nfk = size(Lfpk,4);  K = size(Lfpk,3);
            Lfpk = permute(Lfpk, [1,3,2,4]);
            Lfpk = reshape(Lfpk, [numtrials*K, nwin, nfk]);
            Spikek = permute(Spikek, [1,3,2,4]);
            Spikek = reshape(Spikek, [numtrials*K, nwin, nfk]);
            SLfp = sq(sum(Lfpk.*conj(Lfpk)));
            SSpike = sq(sum(Spikek.*conj(Spikek)));
            CrossSpec = sq(sum(Lfpk.*conj(Spikek)));
            if nwin == 1
              SLfp = SLfp.'; SSpike = SSpike.'; CrossSpec = CrossSpec.';
            end
            Coh = CrossSpec./sqrt(SLfp.*SSpike);
            
        case 'MultiunitField'
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);
	    MonkeyDir = sessMonkeyDir(Sess);

            Spike = trialSpike(Trials{1}, Sys{1}, Ch(1), Contact(1), 1, Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
            
            % Decimate spikes
            for iTr = 1:length(Spike)
                cutProb = rand(size(Spike{iTr}));
                newSpikeind = cutProb > p_delete;
                Spike{iTr} = Spike{iTr}(newSpikeind);
            end
            Data.Spike = Spike;
            
            Lfp = trialLfp(Trials{1}, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);

            Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
            thresh = 6*std(Lfp(:)); e = max(abs(Lfp'));
            ind = find(e<thresh);
            numtrials = length(ind);
            Lfp = Lfp(ind,:);  Spike = Spike(ind,:);

            Lfpk = tfsp_proj(Lfp, tapers, sampling_rate, dn, fk, pad);
            Spikek = tfspproj_pt(Spike, tapers, sampling_rate, dn, fk, pad);
            nwin = size(Lfpk,2);  nfk = size(Lfpk,4);  K = size(Lfpk,3);
            Lfpk = permute(Lfpk, [1,3,2,4]);
            Lfpk = reshape(Lfpk, [numtrials*K, nwin, nfk]);
            Spikek = permute(Spikek, [1,3,2,4]);
            Spikek = reshape(Spikek, [numtrials*K, nwin, nfk]);
            SLfp = sq(sum(Lfpk.*conj(Lfpk)));
            SSpike = sq(sum(Spikek.*conj(Spikek)));
            CrossSpec = sq(sum(Lfpk.*conj(Spikek)));
	    if nwin == 1
              SLfp = SLfp'; SSpike = SSpike'; CrossSpec = CrossSpec.';
	    end
	    Coh = CrossSpec./sqrt(SLfp.*SSpike);

    end
else
    disp('Not enough trials');
    nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
    nfk = floor(fk./sampling_rate.*nf);
    t = bn(1):dn*1e3:bn(2);
    f = linspace(fk(1),fk(2),diff(nfk));
    numtrials = 0;
    Coh = zeros(length(t)-1,diff(nfk),'single');
    SLfp = zeros(length(t)-1,diff(nfk),'single');
    SSpike = zeros(length(t)-1,diff(nfk),'single');

end

nf = max(256,pad*2^nextpow2(N*sampling_rate+1));
nfk = floor(fk./sampling_rate.*nf);
f = linspace(fk(1),fk(2),diff(nfk));
t = bn(1):dn*1e3:bn(2);
Data.t = t;
Data.NumTrials = numtrials;
Data.Data = Coh;
%Data.SuppData.pCoh = pCoh;
%Data.SuppData.Coh = Coh;
Data.SuppData.SLfp = SLfp;
Data.SuppData.SSpike = SSpike;
Data.f = f;

DataSession = Sess;
DataSession{1}= Trials{1}(1).Day;
Data.Session = DataSession;
Data.CondParams = CondParams;
Data.AnalParams = AnalParams;

Data.xax = t;
Data.yax = f;
