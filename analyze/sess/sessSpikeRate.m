function Data = sessSpikeRate(Sess, CondParams, AnalParams)
%
%   Data = sessSpikeRate(Sess, CondParams, AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for 
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
%
%
%   CondParams.sort = 1,N cell.  N sort criteria
%                               For each sort criterion sort is a 1,2 cell
%                                   sort{i}{1} = String. Sort criterion name.
%                                       Names are fields in Trials or
%                                       calcNAME functions.
%                                   sort{i}{2} = [1,1] or [1,2] Scalar.  Sort
%                                                   criterion values
%
%   AnalParams.Smoothing  =   Scalar.  Smoothing parameter in ms 
%                               Defaults to 10ms
%   AnalParams.bn      =   Alignment time.
%   AnalParams.Field   =   String.  Alignment field
%   AnalParams.rate_lim =   Scalar.  Max and Min rates.
%

if(isfield(AnalParams,'Smoothing'))
    Smoothing = AnalParams.Smoothing;
else
    Smoothing = 10;
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

All_Trials = Params2Trials(All_Trials,CondParams);

if(~iscell(All_Trials))
    Trials{1} = All_Trials;
else
    Trials = All_Trials;
end
%SpikeSession = extractSpikeSession(Sess); 
% this doesn't appear relevent if Multiunit_Database is constructed from
% fields - MH 110924

SpikeSession = Sess;
disp([num2str(length(Trials{1})) ' Trials'])

if length(Trials{1}) > 3
    Sys = sessTower(SpikeSession);
%     Sys = Sys{1};
    Ch = sessChannel(SpikeSession);
    Cl = sessCell(SpikeSession);
    Cn = sessContact(SpikeSession);
    Spike = trialSpike(Trials{1}, Sys, Ch, Cn, Cl, Field, ...
        [bn(1)-Smoothing,bn(2)+Smoothing]); 
%     for k=1:length(Spike)
%         fieldlist{k}=sprintf('Spike%d',k);
%     end
%     Spike=cell2struct(Spike,fieldlist,2);
cd('/mnt/raid/analyze/plot/');
    Rate = psth(Spike,bn,Smoothing);
else
    Rate = zeros(1,diff(bn)+1);
end

t = linspace(bn(1),bn(2),length(Rate));

Data.Data = Rate;
Data.NumTrials = length(Trials{1});
Data.t = t;
%Data.xax = t;
% if(isfield(AnalParams,'rate_lim'))
%     rate_lim = AnalParams.rate_lim;
% else
%     rate_lim = [0,max(Rate)];
% end
%Data.yax = rate_lim;
