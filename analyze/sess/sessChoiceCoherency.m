function [Coh,S1,S2,f,t,NTrials,Data] = sessChoiceCoherency(Sess,Task,Field,bn,conds,tapers,dn,delay)
%
%   [Coh,S1,S2,f,t,NTrials,Data] = sessCoherency(Sess,Task,Field,bn,conds,tapers,dn,delay)
%
%   SESS    =   Cell array.  Session information
%   TASK    =   String/Cell.  Tasks to pool and compare.
%
%           To compare Task = {'Task1';'Task2'};
%	    To pool Task = {{'Task1','Task2'}};
%   FIELD   =   String.  Alignment field
%   BN      =   Vector.
%   CONDS   =   Eye,Hand,Target conds {[],[],[]}
%   TAPERS  =   [N,W].  Defaults to [.5,10]
%   DN
%   DELAY   =  Vector. Select trials according to delay interval (s).
%                    Delay = [DelayStart,DelayStop].


global MONKEYDIR MONKEYNAME

if nargin < 2 || isempty(Task); Task = ''; end
if nargin < 3 || isempty(Field); Field = 'TargsOn'; end
if nargin < 4 || isempty(bn); bn = [-1e3,2e3]; end
if nargin < 5 || isempty(conds); conds = []; end
if nargin < 6 || isempty(tapers); tapers = [0.5,10]; end
if nargin < 7 || isempty(dn); dn = 0.05; end
if nargin < 8 || isempty(delay); delay = [0,5]; end

num = 1;

if ischar(Task) && length(Task)
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

Trials = cell(1,length(Task));
if length(Task)
    for iTaskComp = 1:length(Task)
        for iTaskPool = 1:length(Task{iTaskComp})
            disp(['Now working on ' Task{iTaskComp}{iTaskPool}])
            Trials{iTaskComp} = [Trials{iTaskComp},sessTrials(Sess,Task{iTaskComp}{iTaskPool})];
        end
        if length(conds)
            Trials{iTaskComp} = TrialChoiceConds(Trials{iTaskComp},conds);
%             size(Trials)
%             pause
        end
        NTrials(iTaskComp) = length(Trials{iTaskComp});
    end
    NCoh = min(NTrials);
    for iTaskComp = 1:length(Trials)
        ind = randperm(NTrials(iTaskComp));
        Trials{iTaskComp} = Trials{iTaskComp}(ind(1:NCoh));
    end
else
    Trials{1} = sessTrials(Sess);
end

for iTaskComp = 1:length(Task)
    if ~strcmp(Task{iTaskComp},'DelSaccadethenReach')
        Delay = getDelay(Trials{iTaskComp})./1e3;
        Trials{iTaskComp} = Trials{iTaskComp}(find(Delay>delay(1) & Delay<delay(2)));
    end
end

% if isempty(Trials{1})
%   Coh = []; S1 = []; S2 = [];
%   disp('Not enough Trials');
%  return 
% end

if length(Sess{5}) == 2
    if ~iscell(Sess{5})
        if Sess{5}(1) > 15 || Sess{5}(1)<0
            Type = 'FieldField';
        elseif Sess{5}(2) > 15
            Type = 'SpikeField';
        else
            Type = 'SpikeSpike';
        end
    elseif iscell(Sess{5})
        if Sess{5}{1}(1) > 15 || Sess{5}{1}(1)<0
            Type = 'FieldField';
        elseif Sess{5}{2}(1) > 15
            Type = 'SpikeField';
        else
            Type = 'SpikeSpike';
        end
    end
elseif length(Sess{5}) == 3
    if Sess{5}(1) > 15
        Type = 'FieldFieldField';
    elseif Sess{5}(1) < 15 && Sess{5}(2) > 15 && Sess{5}(3) > 15
        Type = 'SpikeFieldField';
    else
        Type = 'SpikeSpikeSpike';
    end
end
Type
N = tapers(1); 
if length(tapers)==3
  W = tapers(2)./tapers(1);
else
  W = tapers(2);
end

t = [bn(1):dn*1e3:bn(2)];

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
                Lfp1 = trialMlfp(Trials{iTaskComp}, Sys{1}, Ch(1), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Lfp2 = trialMlfp(Trials{iTaskComp}, Sys{2}, Ch(2), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                tic; [Coh{iTaskComp},f,S1{iTaskComp},S2{iTaskComp}] = ...
                    tfcoh(Lfp1, Lfp2,[N,W],1e3,dn,300,2,0.05,11); toc
                Data.Lfp1 = Lfp1;
                Data.Lfp2 = Lfp2;
            case 'SpikeField'
                Sys = Sess{3};
                Ch = Sess{4};
                if ~iscell(Sess{5})
                    Cl = Sess{5}(1);
                elseif iscell(Sess{5})
                    Cl = Sess{5}{1}(1);
                end
                tic
                Spike = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Cl, Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                Lfp = trialMlfp(Trials{iTaskComp}, Sys{2}, Ch(2), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
                [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},f] = ...
                    tfcoh_ptx(Lfp,Spike,[N,W],1e3,dn,300,2,0.05,11); toc
                Data.Spike = Spike;
                Data.Lfp = Lfp;
            case 'SpikeFieldField'
                Sys = Sess{3};
                Ch = Sess{4};
                Cl = Sess{5}(1);
                tic
                Spike = trialSpike(Trials, Sys{1}, Ch(1), Cl, Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                Lfp1 = trialMlfp(Trials, Sys{2}, Ch(2), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Lfp2 = trialMlfp(Trials, Sys{3}, Ch(3), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Lfp = Lfp1-Lfp2; clear Lfp1 Lfp2
                Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
                [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp}] = ...
                    tfcoh_ptx(Lfp,Spike,[N,W],1e3,dn,300,2,0.05,11); toc
            case 'FieldFieldField'
                Sys = Sess{3};
                Ch = Sess{4};
                tic
                Lfp1 = trialMlfp(Trials, Sys{1}, Ch(1), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Lfp2 = trialMlfp(Trials, Sys{2}, Ch(2), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Lfp3 = trialMlfp(Trials, Sys{3}, Ch(3), Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
                Lfp = Lfp2-Lfp3; clear Lfp2 Lfp3
                [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp}] = ...
                    tfcoh(Lfp1,Lfp,[N,W],1e3,dn,300,2,0.05,11); toc
            case 'SpikeSpike'
                Sys = Sess{3};
                Ch = Sess{4};
                Cl = Sess{5};
                tic
                Spike1 = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Cl{1}, Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                Spike2 = trialSpike(Trials{iTaskComp}, Sys{2}, Ch(2), Cl{2}, Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
                Spike1 = sp2ts(Spike1,[0,diff(bn)./1e3+N,1e3]);
                Spike2 = sp2ts(Spike2,[0,diff(bn)./1e3+N,1e3]);
                [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},f] = ...
                    tfcoh_pt(Spike1,Spike2,[N,W],1e3,dn,300,2,0.05,11); toc
        end
    end
else
    Coh = {single(zeros(60,307))};
    S1 = {single(zeros(60,307))};
    S2 = {single(zeros(60,307))};
    f=0;
end

if length(Trials)==1
    Coh = Coh{1}; S1 = S1{1}; S2 = S2{1};
end
