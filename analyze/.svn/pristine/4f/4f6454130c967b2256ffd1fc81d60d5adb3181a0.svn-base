function [Results, Data , Model] = loocalcDecisionOnsetF(Session, InputParams)
%
%  [Results, Data, Model] = loocalcDecisionOnsetF(Session, InputParams);
% Leave one out likelihood computation
%   Inputs:

%  Inputs:
%   Session              =   CellArray.  Spike-Field Session information.
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

SysF = Session{3}{1};
ChF = Session{4};

if ~iscell(InputParams.Task); InputParams.Task = {InputParams.Task}; end
if ~iscell(InputParams.Event.Task); InputParams.Event.Task = {InputParams.Event.Task}; end
if ~iscell(InputParams.Null.Task); InputParams.Null.Task = {InputParams.Null.Task}; end

[EventTrials, NullTrials] = calcDecisionOnsetTrials(Session, InputParams);

LfpNull = trialMlfp(NullTrials, SysF, ChF, InputParams.Null.Field, InputParams.Null.bn);
LfpEvent = trialMlfp(EventTrials, SysF, ChF, InputParams.Event.Field, InputParams.Event.bn);

%Baseline Correction
Baseline = mean(LfpNull(:)); LfpNull = LfpNull - Baseline; LfpEvent = LfpEvent - Baseline;

[Results, Model] = loocalcField(LfpEvent, LfpNull, InputParams, LfpParams)


Data.Event = LfpEvent;
Data.Null = LfpNull;
Data.Trials.Null = NullTrials;
Data.Trials.Event = EventTrials;
Data.Type = 'Field';
