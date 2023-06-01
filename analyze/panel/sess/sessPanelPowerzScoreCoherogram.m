function Data = sessPanelPowerzScoreCoherogram(Sess, CondParams, AnalParams)
%
%   Data = sessPanelPowerzScoreCoherogram(Sess,CondParams,AnalParams)
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
%   AnalParams.nPerm   =   Number of permutations.  Defaults to 1e4;
%   AnalParams.Time = Time at which we should sort Lfp power in seconds
%   AnalParams.Frequency = Frequency at which we should sort Lfp power in Hz
%


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
if(~isfield(CondParams,'Delay'))
    CondParams.Delay = [500,5e3];
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
if(isfield(AnalParams,'nPerm'))
    nPerm = AnalParams.nPerm;
else
    nPerm = 1e3;
end
if(isfield(AnalParams,'Frequency'))
    Frequency = AnalParams.Frequency;
else
    Frequency = 20;
end
if(isfield(AnalParams,'Time'))
    Time = AnalParams.Time;
else
    Time = 0.750;
end
Time = Time.*sampling_rate;

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

N = tapers(1);
if length(tapers)==3
    W = tapers(2)./tapers(1);
else
    W = tapers(2);
end

nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
nfk = floor(fk./sampling_rate.*nf);
f = linspace(fk(1),fk(2),diff(nfk));
t = bn(1):dn*sampling_rate:bn(2);
Freq_ind = find(f>Frequency,1,'first');
Time_ind = find(t>Time,1,'first');


disp([num2str(length(Trials{1})) ' Trials'])
if length(Trials{1}) > 3 && ...
        isempty(find(isnan([Trials{1}.(Field)]),1)) 
    switch Type
        case 'FieldField'
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
	    Contact = sessContact(Sess);
	    MonkeyDir = sessMonkeyDir(Sess)l

            Lfp1 = trialLfp(Trials{1}, Sys{1}, Ch(1), Contact(1), Field, ...
                [bn(1)-N./2*sampling_rate,bn(2)+N./2*sampling_rate], MonkeyDir);
            Lfp2 = trialLfp(Trials{1}, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*sampling_rate,bn(2)+N./2*sampling_rate], MonkeyDir);
            thresh1 = 6*std(Lfp1(:)); e1 = max(abs(Lfp1'));
            thresh2 = 6*std(Lfp2(:)); e2 = max(abs(Lfp2'));
            ind = find(e1<thresh1 & e2<thresh2);
            numtrials = length(ind);
            Lfp1 = Lfp1(ind,:);  Lfp2 = Lfp2(ind,:);
            
            Lfpk1 = tfsp_proj(Lfp1, tapers, sampling_rate, dn, fk, pad);
            Lfpk2 = tfsp_proj(Lfp2, tapers, sampling_rate, dn, fk, pad);
            nwin = size(Lfpk1,2);  nfk = size(Lfpk1,4);  K = size(Lfpk1,3);
            Lfpk1 = permute(Lfpk1, [1,3,2,4]);
            Lfpk1 = reshape(Lfpk1, [numtrials*K, nwin, nfk]);
            Lfpk2 = permute(Lfpk2, [1,3,2,4]);
            Lfpk2 = reshape(Lfpk2, [numtrials*K, nwin, nfk]);
            Coh = sq(sum(Lfpk1.*conj(Lfpk2)))./sqrt(sq(sum(Lfpk1.*conj(Lfpk1)).*sum(Lfpk2.*conj(Lfpk2))));
            
        case {'SpikeField','MultiunitField'}
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);
            MonkeyDir = sessMonkeyDir(Sess)l
            Cl = sessCell(Sess);
            if iscell(Cl{1}) Cl(1) = Cl{1}; end
            
            Lfp = trialLfp(Trials{1}, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            Spike = trialSpike(Trials{1}, Sys{1}, Ch(1), Contact(1), Cl(1), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            thresh = 6*std(Lfp(:)); e = max(abs(Lfp'));
            ind = find(e<thresh); numtrials = length(ind);
            Lfp = Lfp(ind,:);  Spike = Spike(ind);
            Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
            
            Lfpk = tfsp_proj(Lfp, tapers, sampling_rate, dn, fk, pad);
            Spikek = tfspproj_pt(Spike, tapers, sampling_rate, dn, fk, pad);
            nwin = size(Lfpk,2);  nfk = size(Lfpk,4);  K = size(Lfpk,3);
            Lfpk = permute(Lfpk, [1,3,2,4]);
            Spikek = permute(Spikek, [1,3,2,4]);

            Power = sq(sum(Lfpk.*conj(Lfpk),2)./K);
            Power = sq(Power(:, Time_ind, Freq_ind));
            [dum, Power_ind] = sort(Power,'ascend');
            Power_lo = Power_ind(1:floor(numtrials/2)); Power_hi = Power_ind(floor(numtrials/2)+1:end);
            numtrials_lo = length(Power_lo);  numtrials_hi = length(Power_hi);
            Lfpk_lo = reshape(Lfpk(Power_lo,:,:,:), [numtrials_lo*K, nwin, nfk]);
            Lfpk_hi = reshape(Lfpk(Power_hi,:,:,:), [numtrials_hi*K, nwin, nfk]);
            Spikek_lo = reshape(Spikek(Power_lo,:,:,:), [numtrials_lo*K, nwin, nfk]);
            Spikek_hi = reshape(Spikek(Power_hi,:,:,:), [numtrials_hi*K, nwin, nfk]);
            Coh_hi = sq(sum(Lfpk_hi.*conj(Spikek_hi)))./sqrt(sq(sum(Lfpk_hi.*conj(Lfpk_hi)).*sum(Spikek_hi.*conj(Spikek_hi))));
            Coh_lo = sq(sum(Lfpk_lo.*conj(Spikek_lo)))./sqrt(sq(sum(Lfpk_lo.*conj(Lfpk_lo)).*sum(Spikek_lo.*conj(Spikek_lo))));
            D = atanh(abs(Coh_hi)) - atanh(abs(Coh_lo));

	    Lfpk = reshape(Lfpk, [numtrials*K, nwin, nfk]);
	    Spikek = reshape(Spikek, [numtrials*K, nwin, nfk]);

            pCoh = zeros(size(Coh_hi,1),size(Coh_hi,2));
            for iWin = 1:size(Coh_hi,1)
                DPerm = zeros(nPerm,size(Coh_hi,2));
                SpikekTot = sq(Spikek(:,iWin,:));
                LfpkTot = sq(Lfpk(:,iWin,:));
                nLfpTot = size(LfpkTot,1);
                for iPerm = 1:nPerm
                    Indices1 = randperm(nLfpTot);
                    Indices2 = randperm(nLfpTot);
                    X1k = LfpkTot(Indices1(1:numtrials_lo*K),:);
                    X2k = LfpkTot(Indices1(numtrials_lo*K+1:end),:);
                    Y1k = SpikekTot(Indices2(1:numtrials_lo*K),:);
                    Y2k = SpikekTot(Indices2(numtrials_lo*K+1:end),:);
                    Coh1 = sq(sum(X1k.*conj(Y1k)))./sqrt(sq(sum(X1k.*conj(X1k)).*sum(Y1k.*conj(Y1k))));
                    Coh2 = sq(sum(X2k.*conj(Y2k)))./sqrt(sq(sum(X2k.*conj(X2k)).*sum(Y2k.*conj(Y2k))));
                    DPerm(iPerm,:) = atanh(abs(Coh1)) - atanh(abs(Coh2));
                end
                for iF = 1:size(D,2)
                    pCoh(iWin,iF) = length(find(D(iWin,iF)>DPerm(:,iF)))./nPerm;
                end
            end
            pCoh(pCoh==0) = 1./nPerm;  pCoh(pCoh==1) = (nPerm-1)./nPerm;
            zCoh = log(pCoh./(1-pCoh));
    end
else
    disp('Not enough trials');
    nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
    nfk = floor(fk./sampling_rate.*nf);
    f = linspace(fk(1),fk(2),diff(nfk));
    t = bn(1):dn*sampling_rate:bn(2);
    numtrials = 0;
    zCoh = zeros(length(t)-1,diff(nfk),'single');
    Coh_hi = zeros(length(t)-1,diff(nfk),'single');
    Coh_lo = zeros(length(t)-1,diff(nfk),'single');
end
nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
nfk = floor(fk./sampling_rate.*nf);
f = linspace(fk(1),fk(2),diff(nfk));
t = bn(1):dn*sampling_rate:bn(2);
Data.t = t;
Data.NumTrials = numtrials;
Data.Data = zCoh;
Data.f = f;

Data.Supp.Coh_hi = Coh_hi;
Data.Supp.Coh_lo = Coh_lo;

DataSession = Sess;
DataSession{1} = Trials{1}(1).Day;
Data.Sess = DataSession;
Data.CondParams = CondParams;
Data.AnalParams = AnalParams;


Data.xax = t;
Data.yax = f;
