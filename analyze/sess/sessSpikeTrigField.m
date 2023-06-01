function [STA,shSTA,t,Data] = sessSpikeTrigField(Sess,CondParams, AnalParams)
%
%   [STA,shSTA,t,Data] = sessSpikeTrigField(Sess,CondParams, AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.sort{i}{1} = 'STRING';
%   CondParams.sort{i}{2} = [min,max]
%
%   AnalParams.N      =   Vector.  Select time interval to test in ms.
%				Defaults to [-100,100];
%   AnalParams.Field   =   String.  Alignment field
%   AnalParams.bn      =   Alignment time.
%   AnalParams.sampling_rate = Scalar.  Sampling rate of Lfp signal.
%                               Defaults to 1e3.
%

if(isfield(AnalParams,'N'))
    N = AnalParams.N;
    if length(N)==1; N = N*[-1,1]; end
else
    N = [-100,100];
end
if(isfield(AnalParams,'sampling_rate'))
    sampling_rate = AnalParams.sampling_rate;
else
    sampling_rate = 1e3;
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

t = [N(1):N(2)];

MonkeyDir = sessMonkeyDir(Sess);

disp([num2str(length(Trials{1})) ' Trials'])

if length(Trials{1}) > 3
    for iTaskComp = 1:length(Trials)
        TaskString = [];
        for iTaskPool = 1:length(Task{iTaskComp})
            TaskString = [TaskString Task{iTaskComp}{iTaskPool} ' '];
        end
        disp(['Calculating ' Type ' TrigField with N = ' ...
            num2str(N) ' for ' ...
            TaskString ' using  ' num2str(length(Trials{iTaskComp})) ' Trials']);
        switch Type
	    case {'SpikeField','MultiunitField'}
                Sys = sessTower(Sess);
                Ch = sessElectrode(Sess);
		Contact = sessContact(Sess);
                if ~iscell(Sess{5})
                    Cl = Sess{5}(1);
                elseif iscell(Sess{5})
                    Cl = Sess{5}{1}(1);
                end
                tic
                Spike = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), Cl, Field, ...
                    bn, MonkeyDir);
		Spike = sp2ts(Spike,[N(1),diff(bn)-N(1),1]);
                Lfp = trialLfp(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2), Field, ...
                    bn+N, MonkeyDir);
		 nTr = size(Lfp,1);
		    mLfp = mean(Lfp);
		    Lfp = Lfp - mLfp(ones(1,nTr),:);
                STA{iTaskComp} = responseextract(Spike,Lfp,N);
		shLfp = Lfp(randperm(size(Lfp,1)),:);
		tmp = Spike(:,-N(1)*sampling_rate./1e3:end-N(2)*sampling_rate./1e3);
		shtmp = tmp(:,randperm(size(tmp,2)));
                shSpike = zeros(size(Spike));
		shSpike(:,-N(1)*sampling_rate./1e3:end-N(2)*sampling_rate./1e3) = tmp;
                shSTA{iTaskComp} = responseextract(shSpike,shLfp,N);
                Data.Lfp = Lfp; Data.shLfp = shLfp;
                Data.Spike = Spike; Data.shSpike = shSpike;
            case 'SpikeSpike'
                Sys = sessTower(Sess);
                Ch = sessElectrode(Sess);
		Contact = sessContact(Sess);
                Cl = sessCell(Sess);
                tic
                Spike1 = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), Cl{1}, Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
                Spike2 = trialSpike(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2), Cl{2}, Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
                Spike1 = sp2ts(Spike1,[0,diff(bn)./1e3+N,1e3]);
                Spike2 = sp2ts(Spike2,[0,diff(bn)./1e3+N,1e3]);
                
        end
    end
else
    STA = {single(zeros(1,diff(N)+1))};
    shSTA = {single(zeros(1,diff(N)+1))};
    t=[N(1):N(2)];
end

if length(Trials)==1
    STA = STA{1}; shSTA= shSTA{1}; %S1 = S1{1}; S2 = S2{1};
end
