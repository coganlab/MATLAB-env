function [Results, Data , Model] = calcAccLLROnsetF(Session, InputParams)
%
%  [Results, Data, Model] = calcAccLLROnsetF(Session, InputParams);
% Leave one out likelihood computation
%   Inputs:

%  Inputs:
%   Session              =   CellArray.  Session information.
%  InputParams.Type = String. 'Decision','Simple' etc
%  InputParams.Selection = String.  'Visual','Choice','Effector' etc.
%  InputParams.Task           = String.  Behavioral Task.
%                             Defaults to 'DelReachSaccade'
%  InputParams.Event.Target
%	       .Field
%	       .bn
%  InputParams.Null.Field
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
%                           Defaults to 1. Calculate them
%  InputParams.TrialAvNumTrials =
%
%  InputParams.Lfp = Data structure of analysis values for LFP Spectral model
%		InputParams.Lfp.Fk = Frequency range to analyze.
%				Defaults to 200 (Hz)
%		InputParams.Lfp.Dn = Time step between spectral estimates
%				Defaults to 0.005 (s)
%		InputParams.Lfp.Tapers = Spectral analysis taper parameters, T and W.
%				Defaults to [.2,10] (s and Hz).
%		InputParams.Lfp.Df = Frequency step for probability calculation
%				Defaults to W (Hz)
%
%  InputParams.Subject if there are multiple sessions



if nargin < 2 || isempty(InputParams)
    InputParams.Task = 'DelReachSaccade';
else
    disp('Input Params exists')
    if ~isfield(InputParams,'Task')
        InputParams.Task = 'DelReachSaccade';
    end
    if ~isfield(InputParams,'Lfp')
        LfpParams = struct([]);
    else
        LfpParams = InputParams.Lfp;
    end
end

if ~iscell(InputParams.Task); InputParams.Task = {InputParams.Task}; end
if ~iscell(InputParams.Event.Task); InputParams.Event.Task = {InputParams.Event.Task}; end
if ~iscell(InputParams.Null.Task); InputParams.Null.Task = {InputParams.Null.Task}; end

if iscell(Session{1})
    
    nSess = length(Session);  
    EventTrials = cell(1,nSess); NullTrials = cell(1,nSess);
    LfpNull = cell(1,nSess); LfpEvent = cell(1,nSess);
    for iSess = 1:nSess
        
        MONKEYNAME = InputParams.Subject{iSess};
        MONKEYDIR = ['/mnt/raid/' InputParams.Subject{iSess}];
        %addpath(genpath(MONKEYDIR))
        
        SysF = Session{iSess}{3}{1};
        ChF = Session{iSess}{4};
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
        
        LfpNull{iSess} = trialMlfp(NullTrials{iSess}, SysF, ChF, InputParams.Null.Field, InputParams.Null.bn);
        LfpEvent{iSess} = trialMlfp(EventTrials{iSess}, SysF, ChF, InputParams.Event.Field, InputParams.Event.bn);
       
        Baseline = mean(LfpNull{iSess}(:));
        LfpNull{iSess} = LfpNull{iSess} - Baseline; LfpEvent{iSess} = LfpEvent{iSess} - Baseline;
    end
else
    SysF = Session{3}{1};
    ChF = Session{4};
    
    switch InputParams.Selection
        case 'Decision'
            [EventTrials, NullTrials] = calcDecisionOnsetTrials(Session, InputParams);
        case 'Simple'
            [EventTrials, NullTrials] = calcSimpleOnsetTrials(Session, InputParams);
    end
    
    LfpNull = trialMlfp(NullTrials, SysF, ChF, InputParams.Null.Field, InputParams.Null.bn);
    LfpEvent = trialMlfp(EventTrials, SysF, ChF, InputParams.Event.Field, InputParams.Event.bn);
 
    %nTrMin = nTrEvent;
    Baseline = mean(LfpNull(:)); LfpNull = LfpNull - Baseline; LfpEvent = LfpEvent - Baseline;
end


[Results, Model] = loocalcField(LfpEvent, LfpNull, InputParams, LfpParams);


Data.Event = LfpEvent;
Data.Null = LfpNull;
Data.Trials.Null = NullTrials;
Data.Trials.Event = EventTrials;
Data.Type = 'Field';
