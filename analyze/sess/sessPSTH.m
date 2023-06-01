function PSTH = sessPSTH(Sess,CondParams,AnalParams)
%
%   PSTH = sessPSTH(Sess,CondParams,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   Sess:   EITHER:  Session cell array (the usual.  Loads Trials using
%   sessTrial);
%               OR:     Session cell array with the first cell being the
%               Trials data structure. (doesn't load the Trials data
%               structure)
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams.Field   =   String.  Alignment field
%   CondParams.bn      =   Alignment time.
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.condstype = 'Movement'  - looks at eye/hand movement
%   CondParams.Choice = scalar 0/1. 1 = subset choice trials.
%   CondParams.Center = scalar 0/1 - subset Sacc2Center Trials
%
%   CondParams.sort = 1,N cell.  N sort criteria
%                               For each sort criterion sort is a 1,2 cell
%                                   sort{i}{1} = String. Sort criterion name.
%                                       Names are fields in Trials or
%                                       calcNAME functions.
%                                   sort{i}{2} = [1,1] or [1,2] Scalar.  Sort
%                                                   criterion values
% CondParams.shuffle  0/1 Shuffle trial ordering
%
%   AnalParams.sm = Smoothing parameter.  Defaults to 20.
%

global MONKEYDIR MONKEYNAME



Trials = Params2Trials(Sess,CondParams);


if length(Trials) == 0
    error('No Trials');
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
if isfield(AnalParams,'sm')
    sm = AnalParams.sm;
else
    sm = 20;
end
disp([num2str(length(Trials)) ' Trials'])

Sys = sessTower(Sess);
Ch = sessElectrode(Sess);
Contact = sessContact(Sess);
Info = sessCellDepthInfo(Sess);

Spike = trialSpike(Trials, Sys, Ch, Contact, Info, Field, bn);

PSTH = psth(Spike,bn,sm); 
