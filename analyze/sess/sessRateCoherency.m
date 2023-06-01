function [Coh,S1,S2,f,t,Data] = sessRateCoherency(Sess,CondParams, AnalParams)
%
%   [Coh,S1,S2,f,t,Data] = sessRateCoherency(Sess,CondParams, AnalParams)
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
%	CondParams.Rate.Field
%	CondParams.Rate.Bn
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

CondRateBn = [500,1e3];
CondRateField = 'TargsOn';
if(isfield(CondParams,'Rate'))
  if isfield(CondParams.Rate,'Bn');
    CondRateBn = CondParams.Rate.bn;
  end
  if isfield(CondParams.Rate,'Field')
    CondRateField = CondParams.Rate.Field;
  end
end

CondPowerBn = [500,1e3];
CondPowerField = 'TargsOn';
CondPowerFreq = 20;
if(isfield(CondParams,'Power'))
  if isfield(CondParams.Power,'Bn');
    CondPowerBn = CondParams.Power.bn;
  end
  if isfield(CondParams.Power,'Field')
    CondPowerField = CondParams.Power.Field;
  end
  if isfield(CondParams.Power,'Freq')
    CondPowerFreq = CondParams.Power.Freq;
  end
end

% This handles Trials in Sess{1} instead of Day.
if isstruct(Sess{1})
    All_Trials = Sess{1};
else
    All_Trials = sessTrials(Sess);
end

%disp('Running Params2Trials');
All_Trials = Params2Trials(All_Trials, CondParams);

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
                Sys = Sess{3};
                Ch = Sess{4};
                Contact  sessContact(Sess);
                Lfp1 = trialLfp(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Lfp2 = trialLfp(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                tic; [Coh{iTaskComp},f,S1{iTaskComp},S2{iTaskComp}] = ...
                    tfcoh(Lfp1, Lfp2,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
                Data.Lfp1 = Lfp1;
                Data.Lfp2 = Lfp2;
            case 'SpikeField'
                Sys = Sess{3};
                Ch = Sess{4};
                Contact  sessContact(Sess);
		Cl = sessCell(Sess);
                %if ~iscell(Sess{5})
                %    Cl = Sess{5}(1);
                %elseif iscell(Sess{5})
                %    Cl = Sess{5}{1}(1);
                %end
                tic
                Rate = zeros(1,length(Trials{iTaskComp}));
                SpikeCond = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), Cl, CondRateField, ...
                    CondRateBn);
                for iTr = 1:length(SpikeCond); Rate(iTr) = length(SpikeCond{iTr}); end
                [a, indices] = sort(Rate,'ascend');
                RateLow = indices(1:floor(length(indices)./2));
                RateHigh = indices(ceil(length(indices)./2):end);
                
                LfpCond = trialLfp(Trials{iTaskComp},Sys{2}, Ch(2), Contact(2), CondPowerField, CondPowerBn);
                [LfpSpec,Lfpf] = dmtspec(LfpCond,[N,W],sampling_rate,fk,pad);
                ind = find(Lfpf>CondPowerFreq - 0.5,1,'first');
                Power= LfpSpec(:,ind);
                [a, indices] = sort(Power,'ascend');
                PowerLow = indices(1:floor(length(indices)./2));
                PowerHigh = indices(ceil(length(indices)./2):end);
                
                %whos Low High
                Spike = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), Cl, Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                Lfp = trialLfp(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
                
                if matlabpool('size')
                    [Coh.RateLow{iTaskComp},S1.RateLow{iTaskComp},S2.RateLow{iTaskComp},f] = ...
                        ptfcoh_ptx(Lfp(RateLow,:),Spike(RateLow,:),[N,W],sampling_rate,dn,fk,pad,0.05,11);
                    [Coh.RateHigh{iTaskComp},S1.RateHigh{iTaskComp},S2.RateHigh{iTaskComp},f] = ...
                        ptfcoh_ptx(Lfp(RateHigh,:),Spike(RateHigh,:),[N,W],sampling_rate,dn,fk,pad,0.05,11);
                    
                    [Coh.PowerLow{iTaskComp},S1.PowerLow{iTaskComp},S2.PowerLow{iTaskComp},f] = ...
                        ptfcoh_ptx(Lfp(PowerLow,:),Spike(PowerLow,:),[N,W],sampling_rate,dn,fk,pad,0.05,11);
                    [Coh.PowerHigh{iTaskComp},S1.PowerHigh{iTaskComp},S2.PowerHigh{iTaskComp},f] = ...
                        ptfcoh_ptx(Lfp(PowerHigh,:),Spike(PowerHigh,:),[N,W],sampling_rate,dn,fk,pad,0.05,11);
                else
                    [Coh.RateLow{iTaskComp},S1.RateLow{iTaskComp},S2.RateLow{iTaskComp},f] = ...
                        tfcoh_ptx(Lfp(RateLow,:),Spike(RateLow,:),[N,W],sampling_rate,dn,fk,pad,0.05,11);
                    [Coh.RateHigh{iTaskComp},S1.RateHigh{iTaskComp},S2.RateHigh{iTaskComp},f] = ...
                        tfcoh_ptx(Lfp(RateHigh,:),Spike(RateHigh,:),[N,W],sampling_rate,dn,fk,pad,0.05,11);
                    
                    [Coh.PowerLow{iTaskComp},S1.PowerLow{iTaskComp},S2.PowerLow{iTaskComp},f] = ...
                        tfcoh_ptx(Lfp(PowerLow,:),Spike(PowerLow,:),[N,W],sampling_rate,dn,fk,pad,0.05,11);
                    [Coh.PowerHigh{iTaskComp},S1.PowerHigh{iTaskComp},S2.PowerHigh{iTaskComp},f] = ...
                        tfcoh_ptx(Lfp(PowerHigh,:),Spike(PowerHigh,:),[N,W],sampling_rate,dn,fk,pad,0.05,11);
                end
                Data.Spike = Spike;
                Data.Lfp = Lfp;
                Data.Spec = LfpSpec;
                Data.Rate = Rate;
            case 'MultiunitField'
                Sys = Sess{3};
                Ch = Sess{4};
                Contact = sessContact(Sess);
                Multiunit = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), 1, Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                Lfp = trialLfp(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Multiunit = sp2ts(Multiunit,[0,diff(bn)./1e3+N,1e3]);
                [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},f] = ...
                    tfcoh_ptx(Lfp,Multiunit,[N,W],sampling_rate,dn,fk,pad,0.05,11); 
                Data.Multiunit = Multiunit;
                Data.Lfp = Lfp;
            case 'SpikeFieldField'
                %Sys = Sess{3};
                %Ch = Sess{4};
                %Cl = Sess{5}(1);
                %tic
                %Spike = trialSpike(Trials, Sys{1}, Ch(1), Cl, Field, ...
                %    [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                %Lfp1 = trialMlfp(Trials, Sys{2}, Ch(2), Field, ...
                %    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                %Lfp2 = trialMlfp(Trials, Sys{3}, Ch(3), Field, ...
                %    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                %Lfp = Lfp1-Lfp2; clear Lfp1 Lfp2
                %Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
                %[Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp}] = ...
                %    tfcoh_ptx(Lfp,Spike,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
            case 'FieldFieldField'
                %Sys = Sess{3};
                %Ch = Sess{4};
                %tic
                %Lfp1 = trialMlfp(Trials, Sys{1}, Ch(1), Field, ...
                %    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                %Lfp2 = trialMlfp(Trials, Sys{2}, Ch(2), Field, ...
                %    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                %Lfp3 = trialMlfp(Trials, Sys{3}, Ch(3), Field, ...
                %    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                %Lfp = Lfp2-Lfp3; clear Lfp2 Lfp3
                %[Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp}] = ...
                %    tfcoh(Lfp1,Lfp,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
            case 'SpikeSpike'
                %Sys = Sess{3};
                %Ch = Sess{4};
                %Cl = Sess{5};
                %tic
                %Spike1 = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Cl{1}, Field, ...
                %    [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                %Spike2 = trialSpike(Trials{iTaskComp}, Sys{2}, Ch(2), Cl{2}, Field, ...
                %    [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                %Spike1 = sp2ts(Spike1,[0,diff(bn)./1e3+N,1e3]);
                %Spike2 = sp2ts(Spike2,[0,diff(bn)./1e3+N,1e3]);
                %[Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},f] = ...
                %    tfcoh_pt(Spike1,Spike2,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
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
    S1.LowRate = {single(zeros(nwin,diff(nfk)))};
    S2.LowRate = {single(zeros(nwin,diff(nfk)))};
    Coh.LowRate = {single(zeros(nwin,diff(nfk)))};
    S1.HighRate = {single(zeros(nwin,diff(nfk)))};
    S2.HighRate = {single(zeros(nwin,diff(nfk)))};
    Coh.HighRate = {single(zeros(nwin,diff(nfk)))};
    S1.LowPower = {single(zeros(nwin,diff(nfk)))};
    S2.LowPower = {single(zeros(nwin,diff(nfk)))};
    Coh.LowPower = {single(zeros(nwin,diff(nfk)))};
    S1.HighPower = {single(zeros(nwin,diff(nfk)))};
    S2.HighPower = {single(zeros(nwin,diff(nfk)))};
    Coh.HighPower = {single(zeros(nwin,diff(nfk)))};
    f=0;
end

if length(Trials)==1
    Coh.RateLow = Coh.RateLow{1}; 
    S1.RateLow = S1.RateLow{1}; S2.RateLow = S2.RateLow{1};
    Coh.RateHigh = Coh.RateHigh{1}; 
    S1.RateHigh = S1.RateHigh{1}; S2.RateHigh = S2.RateHigh{1};
    
    Coh.PowerLow = Coh.PowerLow{1};
    S1.PowerLow = S1.PowerLow{1}; S2.PowerLow = S2.PowerLow{1};
    Coh.PowerHigh = Coh.PowerHigh{1}; 
    S1.PowerHigh = S1.PowerHigh{1}; S2.PowerHigh = S2.PowerHigh{1};
    
end
