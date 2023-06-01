function Data = sessPanelFieldzScoreSpectrogram(Sess,CondParams, AnalParams)
%
%   Data = sessFieldzScoreSpectrogram(Sess,CondParams,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   AnalParams.Field   =   String.  Alignment field
%   AnalParams.bn      =   Alignment time.
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.sort{}{}
%
%   AnalParams.Tapers  =   [N,W].  Defaults to [.5,10]
%   AnalParams.fk      =   Vector.  Select frequency band to test
%   AnalParams.nPerm   =   Scalar.  Number of permutations for stats.
%                               Defaults to 100.
%
%
%   CondParams.Diff.Task    =   String/Cell.  Tasks to pool and compare.
%                               To pool Task = {{'Task1','Task2'}};
%   CondParams.Diff.Cond    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.Diff.sort{}{}
%   AnalParams.Diff.Field   =   String.  Alignment field
%   AnalParams.Diff.bn      =   Alignment time.


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
    nPerm = 100;
end

DiffTask = '';
DiffCond = {[]};
DiffSort = [];
Diffbn = [-tapers(1).*sampling_rate,0];
DiffField = 'TargsOn';

if(isfield(AnalParams,'Diff'))
    if(isfield(AnalParams.Diff,'bn'))
        Diffbn = AnalParams.Diff.bn;
    end
    if(isfield(AnalParams,'Field'))
        DiffField = AnalParams.Diff.Field;
    end
end
if(isfield(CondParams,'Diff'))
    DiffCondParams = CondParams.Diff;
    if(isfield(CondParams.Diff,'Task'))
        DiffTask = CondParams.Diff.Task;
        DiffCondParams.Task = DiffTask;
    end
    if(isfield(CondParams.Diff,'Cond'))
        DiffCond = CondParams.Diff.Cond;
        DiffCondParams.conds = DiffCond;
    end
    if(isfield(CondParams.Diff,'sort'))
        DiffSort = CondParams.Diff.sort;
        DiffCondParams.sort = DiffSort;
    end
end

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

N = tapers(1);
if length(tapers)==3
    W = tapers(2)./tapers(1);
else
    W = tapers(2);
end

FieldSession = extractFieldSession(Sess);

disp([num2str(length(Trials{1})) ' Trials; Diff Trials ' num2str(length(DiffTrials{1}))])

if length(Trials{1}) > 3
    Sys = sessTower(FieldSession);
    Ch = sessElectrode(FieldSession);
    Contact = sessContact(FieldSession);
    MonkeyDir = sessMonkeyDir(Sess);

    if isempty(find(isnan([Trials{1}.(Field)]),1))
        Lfp = trialLfp(Trials{1}, Sys, Ch, Contact, Field, ...
            [bn(1)-N/2*sampling_rate,bn(2)+N/2*sampling_rate], MonkeyDir);
        thresh = 4*std(Lfp(:));
        e = max(abs(Lfp'));
        ind = find(e<thresh); numtrials = length(ind);
        Lfp = Lfp(ind,:);
        [Spec,f] = tfspec(Lfp,[N,W],sampling_rate,dn,fk,pad);
        
        nWin = size(Spec,2);
        TestSpec = sq(sum(log(Spec))./numtrials);
        
        zSpec = zeros(nWin,size(Spec,3));
        if diff(Diffbn) == N*sampling_rate;            
            if length(DiffTrials{1}) > 3
                DiffLfp = trialLfp(DiffTrials{1}, Sys, Ch, Contact, DiffField, Diffbn, MonkeyDir);
                thresh = 4*std(DiffLfp(:));
                e = max(abs(DiffLfp'));
                ind = find(e<thresh);
                DiffLfp = DiffLfp(ind,:);
                DiffSpec = dmtspec(DiffLfp,[N,W],sampling_rate,fk,pad);
                Diff_NumTr = length(ind);
                AvDiffSpec =  sum(log(DiffSpec))./Diff_NumTr;
                
                D = TestSpec - AvDiffSpec(ones(1,nWin),:);
                
                Tot_NumTr = numtrials + Diff_NumTr;
                for iWin = 1:nWin
                    TotSpec = [sq(Spec(:,iWin,:));DiffSpec];
                    Dperm = zeros(nPerm,size(DiffSpec,2));
                    for iPerm = 1:nPerm
                        Perm_ind = randperm(Tot_NumTr);
                        Spec1 = sum(log(TotSpec(Perm_ind(1:numtrials),:)))./numtrials;
                        Spec2 = sum(log(TotSpec(Perm_ind(numtrials+1:end),:)))./Diff_NumTr;
                        Dperm(iPerm,:) = Spec1-Spec2;
                        
                    end
                    zSpec(iWin,:) = D(iWin,:)./std(Dperm,1);
                end
                
            else
                nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
                nfk = floor(fk./sampling_rate.*nf);
                disp('Not enough trials');
                f = linspace(fk(1),fk(2),diff(nfk));
                t = bn(1):dn*1e3:bn(2); numtrials = 0;
                zSpec = zeros(length(t)-1,diff(nfk),'single');
            end
        elseif diff(Diffbn)==diff(bn)
            if length(DiffTrials{1})>3
                DiffLfp = trialLfp(DiffTrials{1}, Sys, Ch, Contact, DiffField,...
                    [Diffbn(1)-N/2*sampling_rate,Diffbn(2)+N/2*sampling_rate]);
                thresh = 4*std(DiffLfp(:)); e = max(abs(DiffLfp'));
                ind = find(e<thresh);
                DiffLfp = DiffLfp(ind,:);
                
                DiffSpec = tfspec(DiffLfp,[N,W],sampling_rate,dn,fk,pad);
                Diff_NumTr = length(ind);
                AvDiffSpec =  sq(sum(log(DiffSpec)))./Diff_NumTr;
                D = TestSpec - AvDiffSpec;
                
                Tot_NumTr = numtrials + Diff_NumTr;
                
                for iWin = 1:nWin
                    TotSpec = [sq(Spec(:,iWin,:));sq(DiffSpec(:,iWin,:))];
                    Dperm = zeros(nPerm,size(DiffSpec,3));
                    for iPerm = 1:nPerm
                        Perm_ind = randperm(Tot_NumTr);
                        Spec1 = sum(log(TotSpec(Perm_ind(1:numtrials),:)))./numtrials;
                        Spec2 = sum(log(TotSpec(Perm_ind(numtrials+1:end),:)))./Diff_NumTr;
                        Dperm(iPerm,:) = Spec1-Spec2;
                    end
                    
                    zSpec(iWin,:) = D(iWin,:)./std(Dperm,1);
                end
                
            else
                nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
                nfk = floor(fk./sampling_rate.*nf);
                disp('Not enough trials');
                f = linspace(fk(1),fk(2),diff(nfk));
                t = bn(1):dn*1e3:bn(2); numtrials = 0;
                zSpec = zeros(length(t)-1,diff(nfk),'single');
            end
        else
            error('Normalization time definition is wrong');
        end
    else
        nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
        nfk = floor(fk./sampling_rate.*nf);
        f = linspace(fk(1),fk(2),diff(nfk));
        t = bn(1):dn*1e3:bn(2); numtrials = 0;
        zSpec = zeros(length(t)-1,diff(nfk),'single');
    end
else
    disp('Not enough trials');
    nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
    nfk = floor(fk./sampling_rate.*nf);
    f = linspace(fk(1),fk(2),diff(nfk));
    t = bn(1):dn*1e3:bn(2); numtrials = 0;
    zSpec = zeros(length(t)-1,diff(nfk),'single');
end
t = bn(1):dn*1e3:bn(2);
Data.Data = zSpec;
Data.f = f;
Data.t = t;
Data.NumTrials = numtrials;

DataSession = Sess;
DataSession{1} = Trials{1}(1).Day;
Data.Session = DataSession;
Data.CondParams = CondParams;
Data.AnalParams = AnalParams;


Data.xax = t;
Data.yax = f;
