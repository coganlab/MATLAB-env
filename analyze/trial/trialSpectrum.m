function [Spec,All_Trials,Lfp,Rate] = trialSpectrum(Sess,All_Trials,CondParams, AnalParams)
%
%   [Spec,All_Trials,Lfp,Rate] = trialSpectrum(Sess,CondParams,AnalParams)
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
%   AnalParams.fk      =   Vector.  Select frequency band to test. Defaults
%                               to 200
%

global MONKEYDIR MONKEYNAME


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
if(isfield(AnalParams,'threshfac'))
    threshfac = AnalParams.threshfac;
else
    threshfac = 6;
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
    CondParams.Delay = [0,5e3];
end


% % This handles Trials in Sess{1} instead of Day.
% if isstruct(Sess{1})
%     All_Trials = Sess{1};
% else
%     All_Trials = sessTrials(Sess);
% end
% 
% disp('Running Params2Trials');
% All_Trials = Params2Trials(All_Trials,CondParams);
% 
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

Type = getSessionType(Sess);

disp(['Calculating ' Type ' spectrum']);

disp([num2str(length(Trials{1})) ' Trials'])

if length(Trials{1}) > 3
    for iTaskComp = 1:length(Trials)
        TaskString = [];
        for iTaskPool = 1:length(Task{iTaskComp})
            TaskString = [TaskString Task{iTaskComp}{iTaskPool} ' '];
        end
        disp(['Calculating ' Type ' spectrum with N = ' ...
            num2str(N) ' and W = ' num2str(W) ' for ' TaskString]);
        switch Type
            case 'Field'
                Sys = sessTower(Sess);
                if iscell(Sys); Sys = Sys{1}; end
                Ch = sessElectrode(Sess);
                tic
                Lfp = trialMlfp(Trials{iTaskComp}, Sys, Ch, Field, ...
                    [bn(1)-N./2*sampling_rate,bn(2)+N./2*sampling_rate]);
                thresh = threshfac*std(Lfp(:));
                %thresh = 20*std(Lfp(:));
                e = max(abs(Lfp'));
                Lfp = Lfp(e<thresh,:);
                All_Trials = All_Trials(e<thresh);

                Spec{iTaskComp} = tfspec(Lfp,[N,W],sampling_rate,dn,fk,pad);
                %     Raw = RawTrial(Trials, Sys, Ch, Field, ...
                %         [bn(1)-N./2*1e3,bn(2)+N./2*1e3], num);
                %     Spec = tfspec(Raw,[N,W],2e4,.05,1e3,2,0.05);
                toc;
            case 'Spike'
                Sys = sessTower(Sess);
                Ch = sessElectrode(Sess);
                if ~iscell(Sess{5})
                    Cl = Sess{5}(1);
                elseif iscell(Sess{5})
                    Cl = Sess{5}{1}(1);
                end
                tic
                Spike = trialSpike(Trials{iTaskComp}, Sys, Ch, Cl, Field, ...
                    [bn(1)-N/2*sampling_rate,bn(2)+N/2*sampling_rate]);
                [Spec{iTaskComp},Rate{iTaskComp}] = tfspec_pt(Spike,[N,W],sampling_rate,dn,fk,pad); toc
            case 'Multiunit'
                Sys = sessTower(Sess);
                Ch = sessElectrode(Sess);
                tic
                Multiunit = trialSpike(Trials{iTaskComp}, Sys, Ch, 1, Field, ...
                    [bn(1)-N/2*sampling_rate,bn(2)+N/2*sampling_rate]);
                [Spec{iTaskComp},Rate{iTaskComp}] = tfspec_pt(Multiunit,[N,W],sampling_rate,dn,fk,pad); toc
            case 'FieldField'
                Sys = sessTower(Sess);
                Ch = sessElectrode(Sess);
                Lfp1 = trialMlfp(Trials{iTaskComp}, Sys, Ch(1), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Lfp2 = trialMlfp(Trials{iTaskComp}, Sys, Ch(2), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Lfp = Lfp2-Lfp1; clear Lfp1 Lfp2
                tic; Spec{iTaskComp} = tfspec(Lfp,[N,W],sampling_rate,dn,fk,pad,0.05,0); toc
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
    Spec = {single(zeros(nwin,diff(nfk)))};
end

%if length(Trials{1})==1
Spec = Spec{1};
if exist('Rate') && ~isempty(Rate) Rate = Rate{1}; end
%end
