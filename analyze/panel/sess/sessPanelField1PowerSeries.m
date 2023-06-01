function Data = sessPanelField1PowerSeries(Sess,CondParams, AnalParams)
%
%   Data = sessPanelField1PowerSeries(Sess,CondParams,AnalParams)
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
%   AnalParams.fk      =   Vector.  Select frequency band to average for series
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

FieldSession = extractFieldSession1(Sess);

disp([num2str(length(Trials{1})) ' Trials'])

if length(Trials{1}) > 3
                Sys = sessTower(FieldSession);
                Ch = sessElectrode(FieldSession);
		Contact = sessContact(FieldSession);
            	MonkeyDir = sessMonkeyDir(FieldSession);

                tic
                Lfp = trialLfp(Trials{1}, Sys, Ch, Contact, Field, ...
                    [bn(1)-N/2*sampling_rate,bn(2)+N/2*sampling_rate], MonkeyDir);
Spec = sq(mean(tfspec(Lfp,[N,W],sampling_rate,dn,fk,pad))); toc
Spec = sq(mean(Spec,2));
end

Data.Data = Spec;
Data.NumTrials = length(Trials{1});

DataSession = Sess;
DataSession{1} = Trials{1}(1).Day;
Data.Session = DataSession;
Data.CondParams = CondParams;
Data.AnalParams = AnalParams;

