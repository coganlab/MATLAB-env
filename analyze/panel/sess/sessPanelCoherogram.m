function Data = sessPanelCoherogram(Sess, CondParams, AnalParams)
%
%   Data = sessPanelCoherogram(Sess,CondParams,AnalParams)
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
%   AnalParams.fk      =   Vector.  Select frequency band to test
%

if(isfield(AnalParams,'fk'))
    fk = AnalParams.fk;
else
    fk = 200;
end
if length(fk)==1; fk = [0,fk]; end

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
    CondParams.Task = {'DelReachSaccade'};
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
if(isfield(AnalParams,'nPerm'))
    nPerm = AnalParams.nPerm;
else
    nPerm = 1e3;
end
% This handles Trials in Sess{1} instead of Day.
if isstruct(Sess{1})
    All_Trials = Sess{1};
else
    disp('Loading data');
    All_Trials = sessTrials(Sess);
end

All_Trials = Params2Trials(All_Trials,CondParams);

if(~iscell(All_Trials))
    Trials{1} = All_Trials;
else
    Trials = All_Trials;
end

Type = sessType(Sess);

N = tapers(1);
if length(tapers)==3
    W = tapers(2)./tapers(1);
else
    W = tapers(2);
end

disp([num2str(length(Trials{1})) ' Trials'])
if length(Trials{1}) > 3 && isempty(find(isnan([Trials{1}.(Field)]),1))
    numtrials = length(Trials{1});
    switch Type
        case 'FieldField'
            Sys = sessTower(Sess);
            Sys1 = Sys{1};
            if iscell(Sys1); Sys1 = Sys1{1}; end
            Sys2 = Sys{2};
            if iscell(Sys2); Sys2 = Sys2{1}; end
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);
            MonkeyDir = sessMonkeyDir(Sess);
            
            Lfp1 = trialLfp(Trials{1}, Sys1, Ch(1), Contact(1), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            Lfp2 = trialLfp(Trials{1}, Sys2, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            if sum(sum(isnan([Lfp1,Lfp2])))
                ind = find(~isnan(Lfp1(:,1)) & ~isnan(Lfp2(:,1)));
                Lfp1 = Lfp1(ind,:);  Lfp2 = Lfp2(ind,:);
            end
            thresh1 = 6*std(Lfp1(:)); e1 = max(abs(Lfp1'));
            thresh2 = 6*std(Lfp2(:)); e2 = max(abs(Lfp2'));
            ind = find(e1<thresh1 & e2<thresh2);
            numtrials = length(ind);
            Lfp1 = Lfp1(ind,:);  Lfp2 = Lfp2(ind,:);
            
            Lfp1k = tfsp_proj(Lfp1, tapers, sampling_rate, dn, fk, pad);
            Lfp2k = tfsp_proj(Lfp2, tapers, sampling_rate, dn, fk, pad);
            nwin = size(Lfp1k,2);  nfk = size(Lfp1k,4);  K = size(Lfp1k,3);
            Lfp1k = permute(Lfp1k, [1,3,2,4]);
            Lfp1k = reshape(Lfp1k, [numtrials*K, nwin, nfk]);
            Lfp2k = permute(Lfp2k, [1,3,2,4]);
            Lfp2k = reshape(Lfp2k, [numtrials*K, nwin, nfk]);
            
            SLfp1 = sq(sum(Lfp1k.*conj(Lfp1k)));
            SLfp2 = sq(sum(Lfp2k.*conj(Lfp2k)));
            CrossSpec = sq(sum(Lfp1k.*conj(Lfp2k)));
            if nwin == 1
                SLfp1 = SLfp1.'; SLfp2 = SLfp2.'; CrossSpec = CrossSpec.';
            end
            Coh = CrossSpec./sqrt(SLfp1.*SLfp2);
            
            D = Coh.*conj(Coh);
            
            fNum = size(D,2);
            DPerm = zeros(nPerm,fNum);
            pCoh = zeros(nwin,fNum);
            for iWin = 1:nwin
                Lfp1kWin = sq(Lfp1k(:,iWin,:));
                Lfp2kWin = sq(Lfp2k(:,iWin,:));
                SLfp1Win = sq(SLfp1(iWin,:));
                SLfp2Win = sq(SLfp2(iWin,:));
                den = sqrt(SLfp1Win.*SLfp2Win);
                Y1k = Lfp1kWin;
                for iPerm = 1:nPerm
                    Indices1 = randperm(numtrials*K);
                    X1k = Lfp2kWin(Indices1,:);
                    Coh1 = sq(sum(X1k.*conj(Y1k)))./den;
                    DPerm(iPerm,:) = Coh1.*conj(Coh1);
                end
                for iF = 1:size(D,2)
                    pCoh(iWin,iF) = length(find(DPerm(:,iF)>D(iWin,iF)))./nPerm;
                end
            end
            pCoh(pCoh==0) = 1./nPerm;  pCoh(pCoh==1) = (nPerm-1)./nPerm;
            
        case {'SpikeField','MultiunitField'}
            Sys = sessTower(Sess);
            Sys1 = Sys{1};
            if iscell(Sys1); Sys1 = Sys1{1}; end
            Sys2 = Sys{2};
            if iscell(Sys2); Sys2 = Sys2{1}; end
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);
            Cl = sessCell(Sess);
            if iscell(Cl{1}) Cl(1) = Cl{1}; end
            MonkeyDir = sessMonkeyDir(Sess);
            
            Spike = trialSpike(Trials{1}, Sys1, Ch(1), Contact(1), Cl(1), Field, ...
                [bn(1)-N/2*sampling_rate,bn(2)+N/2*sampling_rate], MonkeyDir);
            Lfp = trialLfp(Trials{1}, Sys2, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*sampling_rate,bn(2)+N./2*sampling_rate], MonkeyDir);
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
            
            D = atanh(abs(Coh));
            
            fNum = size(D,2);
            DPerm = zeros(nPerm,fNum);
            pCoh = zeros(nwin,fNum);
            for iWin = 1:nwin
                LfpkWin = sq(Lfpk(:,iWin,:));
                SpikekWin = sq(Spikek(:,iWin,:));
                SLfpWin = sq(SLfp(iWin,:));
                SSpikeWin = sq(SSpike(iWin,:));
                num = sqrt(SLfpWin.*SSpikeWin);
                Y1k = SpikekWin;
                for iPerm = 1:nPerm
                    Indices1 = randperm(numtrials*K);
                    X1k = LfpkWin(Indices1,:);
                    Coh1 = sq(sum(X1k.*conj(Y1k)))./num;
                    DPerm(iPerm,:) = atanh(abs(Coh1));
                end
                for iF = 1:size(D,2)
                    pCoh(iWin,iF) = length(find(DPerm(:,iF)>D(iWin,iF)))./nPerm;
                end
            end
            pCoh(pCoh==0) = 1./nPerm;  pCoh(pCoh==1) = (nPerm-1)./nPerm;
        case {'SpikeSpike'}
            Sys = sessTower(Sess);
            Sys1 = Sys{1};
            if iscell(Sys1); Sys1 = Sys1{1}; end
            Sys2 = Sys{2};
            if iscell(Sys2); Sys2 = Sys2{1}; end
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);
            Cl = sessCell(Sess);
            if iscell(Cl{1}) Cl(1) = Cl{1}; end
            MonkeyDir = sessMonkeyDir(Sess);

            Spike1 = trialSpike(Trials{1}, Sys1, Ch(1), Contact(1), Cl(1), Field, ...
                [bn(1)-N/2*sampling_rate,bn(2)+N/2*sampling_rate], MonkeyDir);
            Spike2 = trialSpike(Trials{1}, Sys2, Ch(2), Contact(2), Cl(2), Field, ...
                [bn(1)-N./2*sampling_rate,bn(2)+N./2*sampling_rate], MonkeyDir);
            Spike1 = sp2ts(Spike1,[0,diff(bn)./1e3+N,1e3]);
            Spike2 = sp2ts(Spike2,[0,diff(bn)./1e3+N,1e3]);
            
            
            Spike1k = tfspproj_pt(Spike1, tapers, sampling_rate, dn, fk, pad);
            Spike2k = tfspproj_pt(Spike2, tapers, sampling_rate, dn, fk, pad);
            
            nwin = size(Spike1k,2);  nfk = size(Spike1k,4);  K = size(Spike1k,3);
            
            Spike1k = permute(Spike1k, [1,3,2,4]);
            Spike1k = reshape(Spike1k, [numtrials*K, nwin, nfk]);
            SSpike1 = sq(sum(Spike1k.*conj(Spike1k)));
            Spike2k = permute(Spike2k, [1,3,2,4]);
            Spike2k = reshape(Spike2k, [numtrials*K, nwin, nfk]);
            SSpike2 = sq(sum(Spike2k.*conj(Spike2k)));
            CrossSpec = sq(sum(Spike1k.*conj(Spike2k)));
            if nwin == 1
                SSpike = SSpike.'; CrossSpec = CrossSpec.';
            end
            Coh = CrossSpec./sqrt(SSpike1.*SSpike2);
            
            
            D = atanh(abs(Coh));
            
            fNum = size(D,2);
            DPerm = zeros(nPerm,fNum);
            pCoh = zeros(nwin,fNum);
            for iWin = 1:nwin
                Spike1kWin = sq(Spike1k(:,iWin,:));
                Spike2kWin = sq(Spike2k(:,iWin,:));
                SSpike1Win = sq(SSpike1(iWin,:));
                SSpike2Win = sq(SSpike2(iWin,:));
                den = sqrt(SSpike1Win.*SSpike2Win);
                Y1k = Spike1kWin;
                for iPerm = 1:nPerm
                    Indices1 = randperm(numtrials*K);
                    X1k = Spike2kWin(Indices1,:);
                    Coh1 = sq(sum(X1k.*conj(Y1k)))./den;
                    DPerm(iPerm,:) = atanh(abs(Coh1));
                end
                for iF = 1:size(D,2)
                    pCoh(iWin,iF) = length(find(DPerm(:,iF)>D(iWin,iF)))./nPerm;
                end
            end
            pCoh(pCoh==0) = 1./nPerm;  pCoh(pCoh==1) = (nPerm-1)./nPerm;
    end
else
    disp('Not enough trials')
    nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
    nfk = floor(fk./sampling_rate.*nf);
    f = linspace(fk(1),fk(2),diff(nfk));
    t = bn(1):dn*1e3:bn(2);
    numtrials = 0;
    Coh = zeros(length(t),diff(nfk),'single');
    pCoh = Coh;
end
nf = max(256,pad*2^nextpow2(N*sampling_rate+1));
nfk = floor(fk./sampling_rate.*nf);
f = linspace(fk(1),fk(2),diff(nfk));
t = bn(1):dn*1e3:bn(2);
Data.t = t;
Data.f = f;
Data.xax = t;
Data.yax = f;
Data.NumTrials = numtrials;
Data.Data = Coh;
Data.SuppData.pCoh = pCoh;

DataSession = Sess;
DataSession{1} = Trials{1}(1).Day;
Data.Sess = DataSession;
Data.CondParams = CondParams;
Data.AnalParams = AnalParams;
