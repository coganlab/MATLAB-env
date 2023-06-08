function [Spec,Rate] = sessRawSpectrum(Sess,CondParams, AnalParams)
%
%   [Spec, Rate] = sessRawSpectrum(Sess,CondParams,AnalParams)
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
%   AnalParams.Tapers  =   [N,W].  Defaults to [.1,10]
%   AnalParams.fk      =   Vector.  Select frequency band to test
%

global MONKEYDIR MONKEYNAME


if(isfield(AnalParams,'fk'))
    fk = AnalParams.fk;
else
    fk = 1e4;
end
if(isfield(AnalParams,'sampling_rate'))
    sampling_rate = AnalParams.sampling_rate;
else
    sampling_rate = 2e4;
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
    tapers = [0.1,10];
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
                Ch = sessElectrode(Sess);
		Contact = sessContact(Sess);
                tic
                Raw = trialRaw(Trials{iTaskComp}, Sys, Ch, Contact, Field, ...
                    [bn(1)-N./2*1e3, bn(2)+N./2*1e3]);
                Lfp = trialLfp(Trials{iTaskComp}, Sys, Ch, Contact, Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                thresh = 6*std(Lfp(:));
                %thresh = 20*std(Lfp(:));
                e = max(abs(Lfp'));
                Raw = Raw(e<thresh,:);

                Spec{iTaskComp} = tfspec(Raw,[N,W],sampling_rate,dn,fk,pad);
                %     Raw = RawTrial(Trials, Sys, Ch, Field, ...
                %         [bn(1)-N./2*1e3,bn(2)+N./2*1e3], num);
                %     Spec = tfspec(Raw,[N,W],2e4,.05,1e3,2,0.05);
                toc;
            
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
