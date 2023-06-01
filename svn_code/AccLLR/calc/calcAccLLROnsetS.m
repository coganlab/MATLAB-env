function [Results, Data , Model] = calcAccLLROnsetS(Session, InputParams)
%
%  [Results, Data, Model] = calcAccLLROnsetS(Session, InputParams);
% Leave one out likelihood computation
%   Inputs:

%  Inputs:
%   Session              =   CellArray.  Spike Session information.   Can
%   include multiple sessions
%  InputParams.Task           = String.  Behavioral Task.
%                             Defaults to 'DelReachSaccade'
%  InputParams.Event.Target
%	       .Field
%	       .bn
%  InputParams.Null.Target
%         .Field
%	      .bn
%
%  InputParams.Hist = 0/1.  Calculate History results? (optional)
%                           Defaults to 1.  Calculate them
%  InputParams.NoHist = 0/1. Calculate No History results? (optional)
%                           Defaults to 1.  Calculate them.
%  InputParams.VarNoHist = 0/1. Calculate Variable Rate No History results? (optional)
%                           Defaults to 1.  Calculate them.
%
%  InputParams.TrialAvgdDetect = 0/1 Calculate the detection times using
%                             resampled trial averaged accumulated  log-lik ratios
%                           Defaults to 0.  Do not calculate trial-averages 
%  InputParams.TrialAvNumTrials = 
%  InputParams.Subject = cell array of subject name strings one for each
%               sessions (if multiple sessions are inputted)
%
%		InputParams.Selection = String.  'Decision','Simple'
%		InputParams.Type = String. 	'Auditory','Visual','Choice','Effector'

global MONKEYDIR MONKEYNAME

if nargin < 2 || isempty(InputParams)
    InputParams.Task = 'DelReachSaccade';
    HistFlag = 0;
    NoHistFlag = 1;
    VarNoHistFlag = 0;
else
    disp('Input Params exists')
    if ~isfield(InputParams,'Task')
        InputParams.Task = 'DelReachSaccade';
    end
    if ~isfield(InputParams,'Hist')
        HistFlag = 0;
    else
        HistFlag = InputParams.Hist;
    end
    if ~isfield(InputParams,'NoHist')
        NoHistFlag = 1;
    else
        NoHistFlag = InputParams.NoHist;
    end
    if ~isfield(InputParams,'VarNoHist')
        VarNoHistFlag = 0;
    else
        VarNoHistFlag = InputParams.VarNoHist;
    end
    if ~isfield(InputParams,'TrialAvgdDetect')
        TrialAvgdFlag = 0;
    else
        TrialAvgdFlag = InputParams.TrialAvgdDetect;
    end
    if ~isfield(InputParams,'Smoothing')
        SpikeParams.Smoothing = 5;
    else
        SpikeParams.Smoothing = InputParams.Smoothing;
    end
end
SpikeParams.Static = InputParams.Null.Static;



if ~iscell(InputParams.Task); InputParams.Task = {InputParams.Task}; end
if ~iscell(InputParams.Event.Task); InputParams.Event.Task = {InputParams.Event.Task}; end
if ~iscell(InputParams.Null.Task); InputParams.Null.Task = {InputParams.Null.Task}; end


if iscell(Session{1})
  
   nSess = length(Session);
    for iSess = 1:nSess
        
        MONKEYNAME = InputParams.Subject{iSess};
        MONKEYDIR = ['/mnt/raid/' InputParams.Subject{iSess}];
        %addpath(genpath(MONKEYDIR))
        
        SysS = Session{iSess}{3}{1};
        ChS = Session{iSess}{4};
        ClS = Session{iSess}{5};
        SelectInputParams = InputParams;
        SelectInputParams.Event.Target = InputParams.Event.Target(iSess);
        if(~isempty(InputParams.Null.Target))
            SelectInputParams.Null.Target = InputParams.Null.Target(iSess);
        end
        
        switch InputParams.Selection
            case 'Decision'
                [EventTrials{iSess}, NullTrials{iSess}] = calcDecisionOnsetTrials(Session{iSess}, SelectInputParams);
            case 'Simple'
               [EventTrials{iSess}, NullTrials{iSess}] = calcSimpleOnsetTrials(Session{iSess}, SelectInputParams);
        end
        
        SpikesNull{iSess} = trialSpike(NullTrials{iSess}, SysS, ChS, ClS, InputParams.Null.Field, InputParams.Null.bn(1:2));
        SpikesEvent{iSess} = trialSpike(EventTrials{iSess}, SysS, ChS, ClS, InputParams.Event.Field, InputParams.Event.bn(1:2));
    end
else
    SysS = Session{3}{1};
    ChS = Session{4};
    ClS = Session{5};
    
    switch InputParams.Selection
        case 'Decision'
            [EventTrials, NullTrials] = calcDecisionOnsetTrials(Session, InputParams);
        case 'Simple'
            [EventTrials, NullTrials] = calcSimpleOnsetTrials(Session, InputParams);            
    end
    
    SpikesNull = trialSpike(NullTrials, SysS, ChS, ClS, InputParams.Null.Field, InputParams.Null.bn(1:2));
    SpikesEvent = trialSpike(EventTrials, SysS, ChS, ClS, InputParams.Event.Field, InputParams.Event.bn(1:2));
end

[Results, Model] = loocalcSpike(SpikesEvent, SpikesNull, InputParams, SpikeParams);


Data.Event = SpikesEvent;
Data.Null = SpikesNull;
Data.Trials.Null = NullTrials;
Data.Trials.Event = EventTrials;
Data.Type = 'Spike';

