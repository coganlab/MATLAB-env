function [Coh,S1,S2,f,t,Data] = sessCoherency(Sess, CondParams, AnalParams, Data)
%
%   [Coh,S1,S2,f,t,Data] = sessCoherency(Sess, CondParams, AnalParams, Data)
%
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
%   AnalParams.tapers  =   [N,W].  N  is the time duration in seconds. W is the bandwidth in Hz,
%                               Defaults to [.5,5]
%   AnalParams.fk      =   Vector.  Select frequency band to test.
%                               Defaults to 200 Hz.
%
%   Data               = Cell. Data to analyze (if previously loaded).
%                        For now, using this option permits analysis of one
%                        task condition only.

if nargin<4
    Data = [];
end

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
                Ch = sessElectrode(Sess);
                Contact = sessContact(Sess);
                MonkeyDir = sessMonkeyDir(Sess);
                if ~isempty(Data)
                    Lfp1 = Data.Lfp1;
                    Lfp2 = Data.Lfp2;
                else
                    Lfp1 = trialLfp(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1),Field, ...
                        [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
                    Lfp2 = trialLfp(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2),Field, ...
                        [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
                end
                tic; [Coh{iTaskComp},f,S1{iTaskComp},S2{iTaskComp}] = ...
                    tfcoh(Lfp1, Lfp2,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
                Data.Lfp1 = Lfp1;
                Data.Lfp2 = Lfp2;
            case 'SpikeField'
                Sys = sessTower(Sess);
                Ch = sessElectrode(Sess);
                Contact = sessContact(Sess);
                Cl = sessCell(SFtoS(Sess));
                MonkeyDir = sessMonkeyDir(Sess);
                %tic
                if ~isempty(Data)
                    Spike = Data.Spike;
                    Lfp = Data.Lfp;
                else
                    Spike = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), Cl, Field, ...
                        [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
                    Lfp = trialLfp(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2), Field, ...
                        [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
                end
                Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
                [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},rate,f] = ...
                    tfcoh_ptx(Lfp,Spike,[N,W],sampling_rate,dn,fk,pad,0.05,11); %toc
                Data.Spike = Spike;
                Data.Lfp = Lfp;
            case 'MultiunitField'
                Sys = sessTower(Sess);
                Ch = sessElectrode(Sess);
                Contact = sessContact(Sess);
                MonkeyDir = sessMonkeyDir(Sess);
                if ~isempty(Data)
                    Multiunit = Data.Multiunit;
                    Lfp = Data.Lfp;
                else
                    Multiunit = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact{1}, 1, Field, ...
                        [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
                    Lfp = trialLfp(Trials{iTaskComp}, Sys{2}, Ch(2), Contact{2}, Field, ...
                        [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
                end
                Multiunit = sp2ts(Multiunit,[0,diff(bn)./1e3+N,1e3]);
                [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},rate,f] = ...
                    tfcoh_ptx(Lfp,Multiunit,[N,W],sampling_rate,dn,fk,pad,0.05,11);
                Data.Multiunit = Multiunit;
                Data.Lfp = Lfp;
            case 'SpikeFieldField'
                Sys = Sess{3};
                Ch = Sess{4};
                Cl = Sess{5}(1);
                tic
                if ~isempty(Data)
                    Spike = Data.Spike;
                    Lfp1 = Data.Lfp1;
                    Lfp2 = Data.Lfp2;
                else
                    Spike = trialSpike(Trials, Sys{1}, Ch(1), Cl, Field, ...
                        [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                    Lfp1 = trialLfp(Trials, Sys{2}, Ch(2), Field, ...
                        [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                    Lfp2 = trialLfp(Trials, Sys{3}, Ch(3), Field, ...
                        [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                end
                Lfp = Lfp1-Lfp2; clear Lfp1 Lfp2
                Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
                [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},rate,f] = ...
                    tfcoh_ptx(Lfp,Spike,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
            case 'FieldFieldField'
                Sys = Sess{3};
                Ch = Sess{4};
                tic
                if ~isempty(Data)
                    Lfp1 = Data.Lfp1;
                    Lfp2 = Data.Lfp2;
                    Lfp3 = Data.Lfp3;
                else
                    Lfp1 = trialLfp(Trials, Sys{1}, Ch(1), Field, ...
                        [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                    Lfp2 = trialLfp(Trials, Sys{2}, Ch(2), Field, ...
                        [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                    Lfp3 = trialLfp(Trials, Sys{3}, Ch(3), Field, ...
                        [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                end
                Lfp = Lfp2-Lfp3; clear Lfp2 Lfp3
                [Coh{iTaskComp},f,S1{iTaskComp},S2{iTaskComp}] = ...
                    tfcoh(Lfp1,Lfp,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
            case 'SpikeSpike'
                Sys = Sess{3};
                Ch = Sess{4};
                Cl = Sess{5};
                MonkeyDir = sessMonkeyDir(Sess);
                tic
                if ~isempty(Data)
                    Spike1 = Data.Spike1;
                    Spike2 = Data.Spike2;
                else
                    Spike1 = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Cl{1}, Field, ...
                        [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
                    Spike2 = trialSpike(Trials{iTaskComp}, Sys{2}, Ch(2), Cl{2}, Field, ...
                        [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
                end
                Spike1 = sp2ts(Spike1,[0,diff(bn)./1e3+N,1e3]);
                Spike2 = sp2ts(Spike2,[0,diff(bn)./1e3+N,1e3]);
                [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},rate1,rate2,f] = ...
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
    S1 = {single(zeros(nwin,diff(nfk)))};
    S2 = {single(zeros(nwin,diff(nfk)))};
    Coh = {single(zeros(nwin,diff(nfk)))};
    f=0;
end

if length(Trials)==1
    Coh = Coh{1}; S1 = S1{1}; S2 = S2{1};
end
