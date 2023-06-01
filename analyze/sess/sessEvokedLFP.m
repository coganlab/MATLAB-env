function  Data = sessEvokedLFP(Sess,CondParams,AnalParams)
%
%  Data = sessEvokedLFP(Sess,CondParams,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for 
%   					condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%                               To pool Task = {{'Task1','Task2'}};
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


global MONKEYDIR experiment

THRESHOLD_v = 400*1e6;

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

% handles Trials in Sess{1} instead of Day. 
if isstruct(Sess{1})
    All_Trials = Sess{1};
else
    All_Trials = sessTrials(Sess);
end

All_Trials = Params2Trials(All_Trials,CondParams);

if length(All_Trials)==0
  Data.Data = [];
  Data.NumTrials = 0;
  return	
end

if(~iscell(All_Trials))
    Trials{1} = All_Trials;
else
    Trials = All_Trials;
end
FieldSession = extractFieldSession(Sess);

disp([num2str(length(Trials{1})) ' Trials'])

if length(Trials{1}) > 3
    Sys = sessTower(FieldSession);
    Ch = sessElectrode(FieldSession);
    Contact = sessContact(FieldSession);
    Cl = sessCell(FieldSession);

    Mlfp = trialLfp(Trials{1}, Sys, Ch, Contact, Field, ...
        [bn(1)-Smoothing,bn(2)+Smoothing]);
    Evoked = smooth(mean(Mlfp),Smoothing);
    Evoked = Evoked(Smoothing+1:end-Smoothing);
else
    Evoked = zeros(1,diff(bn)+1);
end

t = linspace(bn(1),bn(2), (bn(2)-bn(1)+1));
% removed "length(Rate)" from t... Rate not defined
Data.Data = Evoked;
Data.NumTrials = length(Trials{1});
Data.t = t;



%if(isfield(experiment,'hardware'))
%    gain = experiment.hardware.microdrive(1).electrodes(1).gain;
%    AD_gain = experiment.hardware.acquisition(1).AD_neural_gain;
%    
%else
%    gain = 10;
%    AD_gain = 1e6;
%end
%THRESHOLD_AD = (THRESHOLD_v*gain)/AD_gain;


%num_trials = size(Lfp);
%num_trials = num_trials(1);
%[i,j] = find(abs(Lfp) > THRESHOLD_AD);
%trial_index = unique(i);
%Lfp(trial_index,:) = [];
%
%mlfp = mean(Lfp);
%if(isfield(CondParams,'HighPassFlag'))
%    if(CondParams.HighPassFlag)
%        if(isfield(CondParams,'FilterLength'))
%            filter_length = CondParams.FilterLength;
%        else
%            filter_length = 500;
%        end
%        filter_mlfp = mlfp - smooth(mlfp,filter_length);
%    end
%else
%    filter_mlfp = mlfp;
%end


